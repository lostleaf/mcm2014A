function cnt = sim_double_without_overtaking(p, st, lambda, arr_time, v, SAFE_DIS)
n = (length(arr_time))
maxT = 3600 * 2;
cur = 1;
cnt = 0;
x = zeros(n, 1); y = zeros(n, 1);
V = [];
for time = 1 : maxT
    if cur <= n && arr_time(cur) <= time && x(cur - 1) > SAFE_DIS
        x(cur) = 1;
        y(cur) = randi(2);
        cur = cur + 1;
    end
    %update coordinates
    for i = 1 : cur - 1
        for j = i - 1 : -1 : 1
            if y(i) == y(j)
                if x(j) - x(i) < SAFE_DIS && v(i) > x(j)
                    v(i) = v(j);
                end
                break;
            end
        end
        if time >= st && time - st <= 2000 && x(i) < p && x(i) + v(i) >= p
            cnt = cnt + 1;
            V = [V v(i)];
        end
        x(i) = x(i) + v(i);
    end
%     plot(x, y, '.');
%     axis([500 600 1 2])
%     pause(0.01);
end
tabulate(V);
end
