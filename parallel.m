np = 2;
nw = 2;

pool = parpool(nw);

comsol = getComsolPath();

for i = 0:nw
    port = 2035 + i;
    cmd = [comsol, '-autosave off -np', num2str(np), 'server -silent -port',num2str(port)];
end

ga_options = optimoptions('ga', 'PopulationSize', 15, 'MaxGenerations', 10, 'UseParallel',true);

x = ga(obj, 2, [], [], [1 1], 10, [0.5 0.5], [9.5 9.5], [], ga_options);
disp(x)

delete(pool)

function y = obj(x) 
    wId = get(getCurrentTask, 'ID');
    model = mphload('models/rectangular-channel.mph');
    y= 0;
end