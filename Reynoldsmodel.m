classdef Reynoldsmodel < Model

    methods
        function obj = Reynoldsmodel()
            obj.comsolmodel = "models/reynoldsopt.mph";
            obj.nvars = 8;
            obj.A = [];
            obj.b = [];
            obj.Aeq = [1,0,0,0,0,0,0,0; 0,0,0,1,0,0,0,0];
            obj.beq = [1;1];
            obj.lb = [1; 0.01; 0.01; 1; 1; 1; 1; 1];
            obj.ub = [1; 0.99; 0.99; 1; 5; 5; 5; 5];
        end

        function f = fit(~, x, model)
            model.param.set('r1' , x(1));
            model.param.set('r2', x(2));
            model.param.set('r3' , x(3));
            model.param.set('r4' ,x(4));
            model.param.set('w1' , x(5));
            model.param.set('w2' ,x(6));
            model.param.set('w3' , x(7));
            model.param.set('w4', x(8));
            
            try 
                model.study('std1').run
                a = mphmean(model,'spf.cellRe', 'volume', 'selection',1);
                f = a;
            catch error
                disp(x)
                disp(error)
                f = inf;
            end
        end
    end
end