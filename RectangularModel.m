classdef RectangularModel < Model

    methods
        function obj = RectangularModel()
            obj.comsolmodel = "models/rectangular-channel.mph";
            obj.nvars = 2;
            obj.A = [];
            obj.b = [];
            obj.Aeq = [1 1];
            obj.beq = 10;
            obj.lb = [0.5 0.5];
            obj.ub = [9.5 9.5];
        end

        function f = fit(~, x, model)
            model.param.set('B_W', x(1));
            model.param.set('B_H', x(2));
            model.study('std1').run
        
            Q1 =  mphint2(model, 'spf.U', 'surface', 'selection', 5);
        
            f = 1 / Q1;
        end
    end
end