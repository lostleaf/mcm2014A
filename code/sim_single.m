function cnt = sim_single(P, st)
AT = round( poisson(100) * 60 ); % arrive time
disp(length(AT));
maxT = 3600 * 2;
SPEED = [5 6 7 8];
cur = 1;
cnt = 0;
X = zeros(maxT, 1); Y = zeros(maxT, 1); V = zeros(maxT, 1);
for time = 1 : maxT
    if cur <= length(AT) && AT(cur) <= time
        X(cur) = 1;
        Y(cur) = 1;
        t = randi(4);
        V(cur) = SPEED(t);
        cur = cur + 1;
    end
    for i = 1 : cur-1
        if i > 1 && X(i) + V(i) >= X(i-1)
            V(i) = V(i-1);
        end
        if time >= st && time - st <= 1000 && X(i) < P && X(i) + V(i) >= P
            cnt = cnt + 1;
        end
        X(i) = X(i) + V(i);
    end
end
end
