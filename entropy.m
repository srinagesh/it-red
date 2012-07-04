function H = entropy(var_space, X, Y, sign)
    Hmat = zeros(3, var_space);
    %Hmat(1,:) = [X, var_space-length(X)];
    Hmat(1,:) = X;
    Hmat(2,:) = Y;
    H = Hmat;
    val = (2*(1-(0.5^sum(H(1,:)))))-(1-(0.5^sum(H(2,:))));
    H(3,1) = val;
    H(3,2) = sign;
end