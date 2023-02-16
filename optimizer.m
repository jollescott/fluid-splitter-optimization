%% Symmetrical pipe
model = mphload("models/symmetrical-pipe.mph");
model.param.set('S_R', 0.2)
model.study('std1').run

[Q1, Q2] = mphint2(model,{'spf.T_stressz', 'spf.T_stress_tensorzz'}, 'line', 'selection',[6,7]);

display(Q1)
display(Q2)

%% Blood Vessel 
model = mphload('models/simple-vessel.mph');
Y = [];
X = 1:10;

for x = X
    model.param.set('R', x);
    model.study('std1').run;
    [r] = mphint2(model, 'spf.U', 'surface', 'selection', 3);
    Y = [Y; r];
end 

%% Reynolds
model = mphload('models/reynoldsopt.mph');
obj = @(x) reynoldsfit(x, model)
a = [0 0 0 0 0 0 0 0]
b = [0.99 0.99 0.99 0.99 1 1 1 1]
x = ga(obj, 8, [], [], [], [], a, b);

%% Rectangular Channel 
model = mphload('models/rectangular-channel.mph');

obj = @(x) fit(x, model);
x = ga(obj, 2, [], [], [1 1], 10, [0.5 0.5], [9.5 9.5]);


function y = fit(x, model) 
    model.param.set('B_W', x(1));
    model.param.set('B_H', x(2));
    model.study('std1').run

    Q1 =  mphint2(model, 'spf.U', 'surface', 'selection', 5);

    y = 1 / Q1;
end
