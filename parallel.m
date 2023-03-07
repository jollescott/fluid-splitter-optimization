function parallel(model)
clear global

np = 10;
nw = 3;

pool = gcp('nocreate');

if ~isempty(pool)
    delete(pool)
end

pool = parpool(nw);

comsol = getComsolExec();

for i = 1:nw
    port = 2035 + i;
    cmd = strcat(comsol,' -autosave off -np', {' '}, num2str(np), ' -multi on -silent -port', {' '}, num2str(port), ' &');
    disp(cmd);
    system(cmd);

    pause(5);
end

ga_options = optimoptions('ga', 'PopulationSize', 15, 'MaxGenerations', 10, 'UseParallel',true);

tic;

x = ga(@(x) parallelFit(x), model.nvars, model.A, model.b, model.Aeq, model.beq, model.lb, model.ub, [], ga_options);

f = parfevalOnAll(pool, @disconnect, 0);
wait(f);

if isunix
    system('pkill -f comsol');
end

delete(pool);

pt = toc;

disp('Solution:')
disp(x)
disp(pt);

    function y = parallelFit(x)

        global cmodel

        wId = get(getCurrentTask, 'ID');

        if isempty(cmodel)
            if isempty(wId)
                port = 2036;
            else
                port = 2035 + wId;
            end

            mphstart(port)
            cmodel = mphload(model.comsolmodel);
        end

        y = model.fit(x, cmodel);
    end

    function disconnect()
        import com.comsol.model.util.*
        ModelUtil.disconnect;

        clear all
    end
end