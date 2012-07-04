function S = converttostring(Eqnmatrix)

Eqnsize = Eqnmatrix(1,1:2);
Eqn = Eqnmatrix(3:Eqnsize(1)+2,:);
rhsterms = Eqnmatrix(Eqnsize+2,2);
strg = [ ];
for i=1:size(Eqnmatrix,2)
    if(Eqnmatrix(1,i) ~=0)
        if(Eqnmatrix(1,i)>0)
            strg = strcat(strg,'+');
        end
        strg = strcat(strg, num2str(Eqn(1,i)),'R',num2str(i),{' '});
    end
end

strg = strcat(strg,{'<= '});

for i=1:rhsterms
    factor=Eqn(3*i+1,2);
        if (factor > 0)
            strg = strcat(strg,'+');
        end
    strg = strcat(strg,num2str(factor),'H(');
    for j=1:Eqnsize(2)
        if(Eqn(3*i-1,j)~=0)
            strg = strcat(strg,'A',num2str(j),',');
        end
    end
    
    strg = char(strg);
    strg = strg(1:end-1);
    
    if(sum(Eqn(3*i,:))~=0)
        strg = strcat(strg,'|');
    end
    
    for j=1:Eqnsize(2)
        if(Eqn(3*i,j)~=0)
            strg = strcat(strg,'A',num2str(j),',');
        end
    end
    if(sum(Eqn(3*i,:))~=0);
        strg = char(strg);
        strg = strg(1:end-1);
    end
    strg = strcat(strg,{') '});
end

S = strg;
end