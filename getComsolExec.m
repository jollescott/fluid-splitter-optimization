function P = getComsolExec() 
    if ispc
        P = ['"' getenv('COMSOL_PATH') '"'];
    else
        P = "comsol mphserver";
    end

end
