function P = getComsolPath() 
    if ispc
        P = getenv('COMSOL_PATH');
    else
        P = "comsol";
    end

end
