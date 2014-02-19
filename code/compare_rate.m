clear;
x = 1 : 4 : 20;
y = 3 : 7;
[X, Y] = meshgrid(x, y);
A = zeros(5, 5);
C = zeros(5, 5);
for i = 1 : 5
    for j = 1 : 5
        [rate, cnt_collision] = simu(X(i, j), Y(i, j));
        A(i, j) = rate;
        C(i, j) = cnt_collision;
    end
end
T = 0.7 * A + 0.3 * C / max(C(:)) / 3; 
surf(X, Y, A);
