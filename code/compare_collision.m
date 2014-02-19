L = 3:7;
SD = [25 37 50];
B = zeros(length(L), 3);
for i = 1 : length(L)
    for j = 1 : length(SD)
        [rate, cnt_collision] = simu(8, L(i), SD(j));
        B(i, j) = rate;
    end
end
