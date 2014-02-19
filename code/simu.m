function [rate, cnt_collision] = simu(lambda, lowspeed, sd)
if nargin < 3
    sd = 25;
end
% rand('seed', 9361);
arr_time = round( poisson(lambda) * 60 );
n = length(arr_time);
SPEED = lowspeed + (0 : 3);
v = SPEED(randi(4, n, 1));
time_point = 5000;
a = (time_point - arr_time) .* v;
b = (time_point - arr_time + 2000) .* v;
sum(a < 15000 & b >= 15000)
sim_ret = sim_double([15000 5000 30000], time_point, lambda, arr_time, v, sd);
rate = mean(sim_ret(1:3)) / (n / 3.6);
cnt_collision = sum(sim_ret(4:5));
fprintf('pass rate: %f\n', rate);
% sim_double(5000, time_point, lambda, arr_time, v)
% sim_double(30000, time_point, lambda, arr_time, v)

% sim_double_without_overtaking(15000, time_point, lambda, arr_time, v)
end