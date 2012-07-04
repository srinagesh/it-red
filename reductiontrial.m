clear all;
clc;
%--------------------------------------------------------------------------
%This program reads the equations from a text file and a few parameters and
%is used to find the tightest upper bound among a set of equations on
%rates.
%       Author: Srinagesh Sharma, under Sandeep Pradhan
%Input parameters to the program
%       var_space:  number of state space variables A1, A2... An
%       sig_field:  All combinations of rates which occur in the set of
%                   equations
%              MC:  Markov chain matrix
%                   Eg: for A1A2A3--A4--A5A6
%                   MC = [1 1 1 0 0 0;
%                         0 0 0 1 0 0;
%                         0 0 0 0 1 1];
%        filename:  Name of file, and if in a different director, the path
% 
%       Example format for text file:
%          1R1 <= 1H(A1,A3) -1H(A1,A3|A5);
%          1R1 +1R2 <= 1H(A2,A3) -1H(A2,A3|A6);
%--------------------------------------------------------------------------
var_space = 6;
sig_field = [1 0;
             0 1;
             1 1;
             1 2];

%MARKOV CHAIN MATRIX
MC = [1 1 1 0 0 0;
      0 0 0 1 0 0;
      0 0 0 0 1 1];
  
%FILE ID
fid=fopen('testeqnfile.txt');

%END OF REQUIRED INPUT PARAMETERS, BEGINNING OF PROGRAM
S_sig = size(sig_field);

%read strings from file and convert them to the
%equation format
strt=textscan(fid,'%s', 'delimiter', sprintf(';'));
N=length(strt{1,1});
for i=1:N
    strg(i)=strt{1,1}(i);
end
Eqn = zeros(1,1,1);
eqn_list = zeros(1,2, S_sig(1));
for i=1:length(strg)
    string1 = char(strg(i)); 
    E = converttoeqn(string1,var_space);
    S = size(E);
    Eqn(1,1:2,i)=S;
    Eqn(3:S(1)+2, 1:S(2),i)=E;
    
    for j=1:S_sig(1)
        if(sig_field(j,:)==E(1,1:S_sig(2)))
            eqn_list(1,1,j)=eqn_list(1,1,j)+1;
            Neqn=eqn_list(1,1,j);
            eqn_list(Neqn+1,1,j)=Neqn;
            eqn_list(Neqn+1,2,j)=E(end,1);
            Eqn(2,1,i)=j;
            Eqn(2,2,i)=Neqn;
        end
    end 
end

eqn_list(find(eqn_list==0))=inf;
eqn_list_sorted = zeros(size(eqn_list));

 for i = 1:S_sig(1)
     eqn_set = eqn_list(2:end,:,i);
     eqn_set_sorted = sortrows(eqn_set,2);
     eqn_list_sorted(2:end,:,i) = eqn_set_sorted;
     eqn_list_sorted(1,:,i)=eqn_list(1,:,i);
 end
 
%EQUATION LIST has been sorted. the array eqn_list_sorted(2,:,i) consists
%of the most constrained upper bounds of the set i
 for i = 1:S_sig(1)
     a = eqn_list_sorted(2,:,i);
     for j = 1:N
         if(Eqn(2,1,j)==i && Eqn(2,2,j)==a(1))
             Eqn_sorted(:,:,i) = Eqn(:,:,j);
         end
     end
 end
 
 
%Further eliminate equations to find the shortest bound. Using Markov
%chains when needed.
for i = 1:S_sig(1)
    E2 = resetwithMC(Eqn_sorted(:,:,i),MC, var_space);
    Eqn_MC(:,:,i) = E2;
end

%Equations modified by the Markov Chain are used to find upper bounds for
%each of the rates
for i = 1:S_sig(2)
    C = (sig_field(:,i)~=0);
    
    eqn_numbers = [1:length(C)]'.*C;
    eqn_numbers(eqn_numbers == 0)=[];
    
    for j = 1:length(eqn_numbers);
        eqn_l = Eqn_MC(1,1,eqn_numbers(j));
        weighting_factor = sum(sig_field(eqn_numbers(j),:));
        val_eqn(j,:) = [eqn_numbers(j),Eqn_MC(eqn_l+2,1,eqn_numbers(j))/weighting_factor];
    end
    
    val_sorted = sortrows(val_eqn,2);
    
    Eqn_sorted_MC(:,:,i) = Eqn_sorted(:,:,val_sorted(1,1));
end

%Print equations out into strings
fprintf('The equations with the tightest upper bounds are ');
for i = 1:S_sig(2)
    sortedstrg(i,:)= converttostring(Eqn_sorted_MC(:,:,i));
    
    fprintf('for R%d \n',i);
    fprintf('%s \n',sortedstrg{i,:});
end
    
 
 
 
 
 
 
 