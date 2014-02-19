
function cnt = sim_double(p, st, lambda, arr_time, vmax, SAFE_DIS)
    n = (length(arr_time))
    maxT = 3600 * 2;
    cur = 1;
    cnt = zeros(length(p), 1);
    x = zeros(n, 1); y = zeros(n, 1);  v = zeros(n, 1); ti = zeros(n, 2);
    hash = zeros(1e5,2);
    V = [];
    cnt_collision1 = 0;    cnt_collision2 = 0;

    function k = prev_vehicle(x, y)
        k = 0;
        for ii = x + 1 : x + SAFE_DIS
            if hash(ii, y) > 0
                k = hash(ii, y);
                break;
            end
        end
    end

    for time = 1 : maxT
        if(mod(time, 1000) == 0)
%             hist(x(1:cur-1));
%             pause(3);
            fprintf('time %d density %f \n', time, sum(x > 10000 & x <= 15000) / 5000);
        end
        if cur <= n && arr_time(cur) <= time && (cur == 1 || min(x(1 : cur - 1)) >= SAFE_DIS)
            x(cur) = 1;
            y(cur) = 1;
            hash(1, 1) = cur;
            v(cur) = vmax(cur);
            cur = cur + 1;
        end
        
        %make decision
        [~, ind] = sort(x(1 : cur - 1));
        is_change = zeros(n, 1);
        for i = fliplr(ind')

            if y(i) == 1
                k = prev_vehicle(x(i), 1);

                %slower vehicle in safety space--change lane or slow down
%                 if(i == 247 && x(i) == 319)
%                     disp([i k v(i) v(k)]);
%                 end
                if k > 0 && v(k) < v(i)
                    j = prev_vehicle(x(i), 2);

                    if j > 0 && v(j) < v(i)
                        v(i) = v(k);
                    else
                        is_change(i) = 1;
                    end
                end
                
                %no slower vehicle in safety space--able to speed up
                if k == 0 || v(k) >= vmax(i)
                    v(i) = vmax(i);
                end
            end

            if y(i) == 2
                is_change(i) = 1;
                for j = [max(x(i) - SAFE_DIS, 1) : x(i) - 1, x(i) + 1 : x(i) + SAFE_DIS]
                    if hash(j, 1) > 0 
                        is_change(i) = 0;
                        break;
                    end
                end
                k = prev_vehicle(x(i), 2);
                if is_change(i) == 0
                    if k > 0 && v(i) > v(k)
                        v(i) = v(k);
                    end
                    
                    if k == 0 || vmax(i) <= v(k)
                        v(i) = vmax(i);
                    end
                end
            end
        end
        x_old = x;
        y_old = y;
        %update coordinates
        for i = 1 : cur - 1
            hash(x(i), y(i)) = 0;
            if is_change(i)
                y(i) = 3 - y(i);
            end
            t = x(i);
            x(i) = x(i) + v(i);% - is_change(i);
            if time >= st && time <= st + 2000 
                for j = 1 : length(p)
                if t < p(j) && x(i) >= p(j)
                    cnt(j) = cnt(j) + 1;
                end
%                 V = [V v(i)];
                end
            end
            if(t < 10000 && x(i) >= 10000)
                ti(i, 1) = time;
            end
            
            if(t < 15000 && x(i) >= 15000)
                ti(i, 2) = time;
            end
            hash(x(i), y(i)) = i;
        end
%         for i = 1 : cur - 1
%             for j = i + 1 : cur - 1
%                 if  ((x_old(i) < x_old(j) && x(i) >= x(j)) || (x_old(i) > x_old(j) && x(i) <= x(j)))
%                     if y(i) == y(j) 
%                         cnt_collision1 = cnt_collision1 + 1;
%                         fprintf('rear-end collision i: %d, j: %d\n i: (%d, %d) --> (%d, %d)\n j: (%d, %d) --> (%d, %d)\n', ...
%                             i, j, x_old(i), y_old(i), x(i), y(i), x_old(j), y_old(j), x(j), y(j));
%                     else
%                         if rand < 1e-4
%                             cnt_collision2 = cnt_collision2 + 1;
%                             fprintf('angle collision i: %d, j: %d\n i: (%d, %d) --> (%d, %d)\n j: (%d, %d) --> (%d, %d)\n', ...
%                             i, j, x_old(i), y_old(i), x(i), y(i), x_old(j), y_old(j), x(j), y(j));
%                         end
%                     end
%                 end
%             end
%         end
    %     axis([500 600 1 2])
    %     pause(0.01);
    end
%     tabulate(V);
    tt = ti(:, 2) - ti(:, 1);
    
    fprintf('average speed %f %d\n',  5000 / mean(tt(tt>0)), sum(tt>0));
    fprintf('rear-end collision: %d\n', cnt_collision1);
    fprintf('angle collision: %d\n', cnt_collision2);
%     plot(x, y, '.', 'MarkerSize', 20);
    cnt = [cnt; cnt_collision1; cnt_collision2];
end


