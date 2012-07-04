function E = converttoeqn(string, var_space)
    stringcell = strread(string, '%s', 'delimiter', '<');
    stringrate = char(stringcell(1));
    [factor nbr] = strread(stringrate,'%f%*c%d');
    
    E = zeros(1,var_space);
    for i=1:length(nbr)
        j = nbr(i);
        E(1,j) = factor(i);
    end
    
    stringentropy = char(stringcell(2));
    if(stringentropy(1)=='=');
        stringentropy=stringentropy(2:end);
    end
    [factor1 Hcell] = strread(stringentropy, '%f%s', 'delimiter', ' ');
    rhsterms = length(Hcell);
    
    for i=1:rhsterms
        Hfactor = char(Hcell(i));
        Hfactor = Hfactor(3:end-1);
        condition_test = strfind(Hfactor,'|');
        if(isempty(condition_test))
            [misc nbr1] = strread(Hfactor,'%c%d','delimiter',',');
            X = zeros(1,var_space);
            Y = zeros(1,var_space);
            for j=1:length(nbr1)
                X(nbr1(j)) = 1;
            end
            H = entropy(var_space, X, Y, factor1(i));
            s = size(E);
            E(s+1:s+3, 1:var_space) = H;
        else
            Hp1 = Hfactor(1:condition_test(1)-1);
            Hp2 = Hfactor(condition_test(1)+1:end);
            X = zeros(1,var_space);
            Y = zeros(1,var_space);
            [misc nbr1] = strread(Hp1,'%c%d','delimiter',',');
            for j=1:length(nbr1)
                X(nbr1(j)) = 1;
            end
            [misc nbr2] = strread(Hp2,'%c%d','delimiter',',');
            for j=1:length(nbr2)
                Y(nbr2(j)) = 1;
            end
            H = entropy(var_space, X, Y, factor1(i));
            s = size(E);
            E(s+1:s+3, 1:var_space) = H;
        end
    end
    
    t_bnd = 0;
    
    for j = 1:rhsterms
        t_bnd = t_bnd + E(j*3+1,1)*E(j*3+1,2);
    end
    s1 = size(E, 1);
    E(s1 + 1,1) = t_bnd;
    E(s1 + 1,2) = rhsterms;
end