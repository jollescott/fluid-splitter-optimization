function y = rectangularfit(x, model) 
    model.param.set('B_W', x(1));
    model.param.set('B_H', x(2));
    model.study('std1').run

    Q1 =  mphint2(model, 'spf.U', 'surface', 'selection', 5);

    y = 1 / Q1;
end