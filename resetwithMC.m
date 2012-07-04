function E = resetwithMC(Ein, MC, var_space)
    Ecut = Ein(3:end,:);
    E = zeros(size(Ein));
    E(1:2,:) = Ein(1:2,:);
    lastrow = Ein(1,1);
    rhsterms = Ecut(lastrow,2);
    MC_S = size(MC);
    MC_L = MC_S(1);
    Enew(1,:) = Ecut(1,:);
    
    for i = 1:rhsterms
        H = Ecut(3*(i-1)+2:3*(i-1)+4,:);
        X = H(1,:);
        Y = H(2,:);
        
        for j =1:MC_L
            if (sum(X.*MC(j,:))>0)
                X = X + sum(MC(1:j-1,:),1);
            end
            if (sum(Y.*MC(j,:))>0)
                Y = Y + sum(MC(j+1:end,:),1);
            end
        end
        
        X = (X>0);
        Y = (Y>0);
        sign = H(3,2);
        Hnew = entropy(var_space, X, Y, sign);
        Enew(3*(i-1)+2:3*(i-1)+4,:) = Hnew;
    end
    
    t_bnd = 0;
    
    for j = 1:rhsterms
        t_bnd = t_bnd + Enew(j*3+1,1)*Enew(j*3+1,2);
    end
    s1 = size(Enew, 1);
    Enew(s1 + 1,1) = t_bnd;
    Enew(s1 + 1,2) = rhsterms;
    E(3:lastrow+2,:) = Enew;
    
end
        