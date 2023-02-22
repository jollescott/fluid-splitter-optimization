function P = getComsolExec() 
    if ispc
        P = strcat('"', getenv('COMSOL_PATH'), '"');
    else
        P = "comsol mphserver";
    end

end
