np = 2;
nw = 2;

pool = parpool(nw);

comsol = getComsolPath();

for i = 0:nw
    port = 2035 + i;
    cmd = [comsol, ' -autosave off -np ', num2str(np), ' server -silent -port ',num2str(port), ' &'];
    system(cmd)

    pause(5);
end

ga_options = optimoptions('ga', 'PopulationSize', 4, 'MaxGenerations', 4, 'UseParallel',true);

obj = @(x) fit(x);
x = ga(obj, 2, [], [], [1 1], 10, [0.5 0.5], [9.5 9.5], [], ga_options);

delete(pool)

function y = fit(x) 
    wId = get(getCurrentTask, 'ID');

    if isempty(wId)
        port = 2035;
    else
        port = 2035 + wId;
    end

    mphstart(port)
    import com.comsol.model.util.*

    model = mphload('models/rectangular-channel.mph');
    y = rectangularfit(x, model);
   
    ModelUtil.disconnect;
end
