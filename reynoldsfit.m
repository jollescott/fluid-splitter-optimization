function f = reynoldsfit(x, model)
    model.param.set('r1' , x(1));
    model.param.set('r2', x(2));
    model.param.set('r3' , x(3));
    model.param.set('r4' ,x(4)); 
    model.param.set('w1' , x(5));
    model.param.set('w2' ,x(6));
    model.param.set('w3' , x(7));
    model.param.set('w4', x(8));

    model.study('std1').run

   a = mphmean(model,'spf.cellRe', 'volume', 'selection',1);
   f = a;
end

