%% Symmetrical pipe
model = mphload("models/symmetrical-pipe.mph");
model.param.set('S_R', 0.2)
model.study('std1').run

[Q1, Q2] = mphint2(model,{'spf.T_stressz', 'spf.T_stress_tensorzz'}, 'line', 'selection',[6,7]);

display(Q1)
display(Q2)

%% Blood Vessel 
model = mphload('models/simple-vessel.mph');
y = [];

for x = 0.1:0.1:1
    model.param.set('R', x);
    model.study('std1').run;
    [r] = mphint2(model, {'spf.U'}, 'surface', [1,2,5,6]);
    y = [y; r];
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
x = ga(obj, 1, [], [], [], [], [0.5 00.5], 0.9999);


function y = fit(x, model) 
    display(x)
    display(x(1))
    model.param.set('B_W', x(1));
    model.study('std1').run

    Q1 = mphmean(model,'spf.U', 'volume');
    display(Q1)

    y = 1 / Q1;
end
