% Make plots of overview of Arctic Sites
clear
clc
close all

%% Surface Part
start_date = datetime(2018, 8, 1); end_date = datetime(2019, 8, 1);
data1 = load('LPTEG_TREES_1_SLw_Rn_AirT_RH_SrfT.mat');
data2 = load('LPTEG_TREES_2_SLw_Rn_AirT_RH_SrfT.mat');
data3 = load('LPTEG_TUNDRA_2_SLw_Rn_AirT_RH_SrfT.mat');
n1_start = find(data1.TS == start_date); n1_end = find(data1.TS == end_date);
n2_start = find(data2.TS == start_date); n2_end = find(data2.TS == end_date);
n3_start = find(data3.TS == start_date); n3_end = find(data3.TS == end_date);

fieldname_data1 = fieldnames(data1);
for i = 1 : length(fieldname_data1)
    curr = cell2mat(fieldname_data1(i));
    data1.(curr) = data1.(curr)(n1_start:n1_end);
    if strcmp(curr, 'TS')
        data1.(curr) = data1.(curr)';
    end
end
fieldname_data2 = fieldnames(data2);
for i = 1 : length(fieldname_data2)
    curr = cell2mat(fieldname_data2(i));
    data2.(curr) = data2.(curr)(n2_start:n2_end);
    if strcmp(curr, 'TS')
        data2.(curr) = data2.(curr)';
    end
end
fieldname_data3 = fieldnames(data3);
for i = 1 : length(fieldname_data3)
    curr = cell2mat(fieldname_data3(i));
    data3.(curr) = data3.(curr)(n3_start:n3_end);
    if strcmp(curr, 'TS')
        data3.(curr) = data3.(curr)';
    end
end
% Find missing
Time = start_date:minutes(30):end_date;
missing1 = ismember(Time, data1.TS);
missing = find(missing1 == 0);
for i = 1 : length(missing)
    pos = missing(i);
    for j = 1 : length(fieldname_data1)
        curr = cell2mat(fieldname_data1(j));
        if strcmp(curr, 'TS')
            data1.(curr) = [data1.(curr)(1:pos-1); Time(pos); data1.(curr)(pos:end)];
        else
            data1.(curr) = [data1.(curr)(1:pos-1); nan; data1.(curr)(pos:end)];
        end
    end
end

missing2 = ismember(Time, data2.TS);
missing = find(missing2 == 0);
for i = 1 : length(missing)
    pos = missing(i);
    for j = 1 : length(fieldname_data2)
        curr = cell2mat(fieldname_data2(j));
        if strcmp(curr, 'TS')
            data2.(curr) = [data2.(curr)(1:pos-1); Time(pos); data2.(curr)(pos:end)];
        else
            data2.(curr) = [data2.(curr)(1:pos-1); nan; data2.(curr)(pos:end)];
        end
    end
end
missing3 = ismember(Time, data3.TS);
missing = find(missing3 == 0);
for i = 1 : length(missing)
    pos = missing(i);
    for j = 1 : length(fieldname_data3)
        curr = cell2mat(fieldname_data3(j));
        if strcmp(curr, 'TS')
            data3.(curr) = [data3.(curr)(1:pos-1); Time(pos); data3.(curr)(pos:end)];
        else
            data3.(curr) = [data3.(curr)(1:pos-1); nan; data3.(curr)(pos:end)];
        end
    end
end

% Air Temperature
figure
set(gcf,'Position',[200 400 1500 300])
hold on; grid on;
plot(data1.TS, data1.AirT);
title('Air Temperature')
ylabel('^oC')


% G flux
figure
set(gcf,'Position',[200 400 1500 300])
hold on; grid on;
plot(data1.TS, data1.Gflux_1);
plot(data2.TS, data2.Gflux_1);
plot(data3.TS, data3.Gflux_1);
legend('T1','T2','TR')
title('Ground Heat Flux')
ylabel('W m^{-2}')

mean_G_T1 = mean(data1.Gflux_1, 'omitnan');
mean_G_T1_withSnow = mean(data1.Gflux_1(3307:14312),'omitnan');
mean_G_T1_withoutSnow = mean([data1.Gflux_1(1:3306); data1.Gflux_1(14313:end)],'omitnan');
mean_G_T2 = mean(data2.Gflux_1, 'omitnan');
mean_G_T2_withSnow = mean(data2.Gflux_1(3307:14312),'omitnan');
mean_G_T2_withoutSnow = mean([data2.Gflux_1(1:3306); data2.Gflux_1(14313:end)],'omitnan');
mean_G_T3 = mean(data1.Gflux_3, 'omitnan');
mean_G_T3_withSnow = mean(data3.Gflux_1(3307:14312),'omitnan');
mean_G_T3_withoutSnow = mean([data3.Gflux_1(1:3306); data3.Gflux_1(14313:end)],'omitnan');

%Net Radiation
figure
set(gcf,'Position',[200 100 1500 750])
subplot(3, 1, 1)
plot(data1.TS, data1.Slr_1 - data1.Slr_2 + data1.LR_1 - data1.LR_2);
hold on; grid on;
plot(data1.TS, data1.Slr_1 - data1.Slr_2);
legend('Rn','RnS')
ylabel('W m^{-2}')
title({'T1','(a)'})
subplot(3, 1, 2)
plot(data1.TS, data1.Slr_1 - data1.Slr_2 + data1.LR_1 - data1.LR_2);
hold on; grid on;
plot(data1.TS, data1.Slr_1 - data1.Slr_2);
ylabel('W m^{-2}')
xlim([datetime(2018, 12, 20), datetime(2019, 1, 5)])
title('(b)')
subplot(3, 1, 3)
plot(data1.TS, data1.Slr_1 - data1.Slr_2 + data1.LR_1 - data1.LR_2);
hold on; grid on;
plot(data1.TS, data1.Slr_1 - data1.Slr_2);
ylabel('W m^{-2}')
xlim([datetime(2019, 6, 20), datetime(2019, 7, 5)])
title('(c)')
A  = data1.Slr_1 - data1.Slr_2 + data1.LR_1 - data1.LR_2;
B = data1.Slr_1 - data1.Slr_2;
mean_Rn_T1 = mean(A, 'omitnan');
mean_Rn_T1_winter = mean(A(4417:8833), 'omitnan');
mean_Rn_T1_nonwinter = mean([A(1:4416); A(8834:end)], 'omitnan');
mean_RnS_T1 = mean(B, 'omitnan');
mean_RnS_T1_winter = mean(B(4417:8833), 'omitnan');
mean_RnS_T1_nonwinter = mean([B(1:4416); B(8834:end)], 'omitnan');
mean_Rs_down_T1_winter = mean(data1.Slr_1(4417:8833), 'omitnan');
mean_Rs_up_T1_winter = mean(data1.Slr_2(4417:8833), 'omitnan');
mean_Rs_down_T1_nonwinter = mean([data1.Slr_1(1:4416); data1.Slr_1(8834:end)], 'omitnan');
mean_Rs_up_T1_nonwinter = mean([data1.Slr_2(1:4416); data2.Slr_2(8834:end)], 'omitnan');


figure
set(gcf,'Position',[200 100 1500 750])
subplot(3, 1, 1)
plot(data2.TS, data2.Slr_1 - data2.Slr_2 + data2.LR_1 - data1.LR_2);
hold on; grid on;
plot(data2.TS, data2.Slr_1 - data2.Slr_2);
ylabel('W m^{-2}')
title({'T2','(a)'})
legend('Rn','RnS')
subplot(3, 1, 2)
plot(data2.TS, data2.Slr_1 - data2.Slr_2 + data2.LR_1 - data1.LR_2);
hold on; grid on;
plot(data2.TS, data2.Slr_1 - data2.Slr_2);
ylabel('W m^{-2}')
xlim([datetime(2018, 12, 20), datetime(2019, 1, 5)])
title('(b)')
subplot(3, 1, 3)
plot(data2.TS, data2.Slr_1 - data2.Slr_2 + data2.LR_1 - data1.LR_2);
hold on; grid on;
plot(data2.TS, data2.Slr_1 - data2.Slr_2);
ylabel('W m^{-2}')
xlim([datetime(2019, 6, 20), datetime(2019, 7, 5)])
title('(c)')
A  = data2.Slr_1 - data2.Slr_2 + data2.LR_1 - data1.LR_2;
B = data2.Slr_1 - data2.Slr_2;
mean_Rn_T2 = mean(A, 'omitnan');
mean_Rn_T2_winter = mean(A(4417:8833), 'omitnan');
mean_Rn_T2_nonwinter = mean([A(1:4416); A(8834:end)], 'omitnan');
mean_RnS_T2 = mean(B, 'omitnan');
mean_RnS_T2_winter = mean(B(4417:8833), 'omitnan');
mean_RnS_T2_nonwinter = mean([B(1:4416); B(8834:end)], 'omitnan');

figure
set(gcf,'Position',[200 100 1500 750])
subplot(3, 1, 1)
plot(data3.TS, data3.Slr_1 - data3.Slr_2 + data3.LR_1 - data1.LR_2);
hold on; grid on;
plot(data3.TS, data3.Slr_1 - data3.Slr_2);
ylabel('W m^{-2}')
title({'TR','(a)'})
legend('Rn','RnS')
subplot(3, 1, 2)
plot(data3.TS, data3.Slr_1 - data3.Slr_2 + data3.LR_1 - data1.LR_2);
hold on; grid on;
plot(data3.TS, data3.Slr_1 - data3.Slr_2);
ylabel('W m^{-2}')
xlim([datetime(2018, 12, 20), datetime(2019, 1, 5)])
title('(b)')
subplot(3, 1, 3)
plot(data3.TS, data3.Slr_1 - data3.Slr_2 + data3.LR_1 - data1.LR_2);
hold on; grid on;
plot(data3.TS, data3.Slr_1 - data3.Slr_2);
ylabel('W m^{-2}')
xlim([datetime(2019, 6, 20), datetime(2019, 7, 5)])
title('(c)')
A  = data3.Slr_1 - data3.Slr_2 + data3.LR_1 - data1.LR_2;
B = data3.Slr_1 - data3.Slr_2;
mean_Rn_T3 = mean(A, 'omitnan');
mean_Rn_T3_winter = mean(A(4417:8833), 'omitnan');
mean_Rn_T3_nonwinter = mean([A(1:4416); A(8834:end)], 'omitnan');
mean_RnS_T3 = mean(B, 'omitnan');
mean_RnS_T3_winter = mean(B(4417:8833), 'omitnan');
mean_RnS_T3_nonwinter = mean([B(1:4416); B(8834:end)], 'omitnan');


% Wind Speed
figure
set(gcf,'Position',[200 400 1500 300])
hold on; grid on;
plot(data1.TS, data1.WS);
plot(data2.TS, data2.WS);
plot(data3.TS, data3.WS);
legend('T1','T2','TR')
title('Wind Speed')
ylabel('ms^{-1}')


% Relative Humidity
figure
set(gcf,'Position',[200 400 1500 300])
hold on; grid on;
plot(data1.TS, data1.RH);
title('Relative Humidity')
ylabel('%')

W = whos;
surface = struct();
for i = 1 :length(W)
    curr = W(i).name;
    surface.(curr) = eval(curr);
end


%% Snow Part
clearvars -except surface
clc

start_date = datetime(2018, 8, 1); end_date = datetime(2019, 8, 1);
data1 = load('LPTEG_TREES_1_Snow_Info.mat');
data2 = load('LPTEG_TREES_2_Snow_Info.mat');
data3 = load('LPTEG_TUNDRA_2_Snow_Info.mat');

n1_start = find(data1.TS == start_date); n1_end = find(data1.TS == end_date);
n2_start = find(data2.TS == start_date); n2_end = find(data2.TS == end_date);
n3_start = find(data3.TS == start_date); n3_end = find(data3.TS == end_date);

fieldname_data1 = fieldnames(data1);
for i = 1 : length(fieldname_data1)
    curr = cell2mat(fieldname_data1(i));
    if strcmp(curr, 'cs')
        data1.(curr) = data1.(curr)(:,:,n1_start:n1_end);
        continue
    end
    data1.(curr) = data1.(curr)(n1_start:n1_end);
    if strcmp(curr, 'TS')
        data1.(curr) = data1.(curr)';
    end
end
fieldname_data2 = fieldnames(data2);
for i = 1 : length(fieldname_data2)
    curr = cell2mat(fieldname_data2(i));
    if strcmp(curr, 'cs')
        data2.(curr) = data2.(curr)(:,:,n2_start:n2_end);
        continue
    end
    data2.(curr) = data2.(curr)(n2_start:n2_end);
    if strcmp(curr, 'TS')
        data2.(curr) = data2.(curr)';
    end
end
fieldname_data3 = fieldnames(data3);
for i = 1 : length(fieldname_data3)
    curr = cell2mat(fieldname_data3(i));
    if strcmp(curr, 'cs')
        data3.(curr) = data3.(curr)(:,:,n3_start:n3_end);
        continue
    end
    data3.(curr) = data3.(curr)(n3_start:n3_end);
    if strcmp(curr, 'TS')
        data3.(curr) = data3.(curr)';
    end
end
% Find missing
Time = start_date:minutes(60):end_date;
missing1 = ismember(Time, data1.TS);
missing = find(missing1 == 0);
for i = 1 : length(missing)
    pos = missing(i);
    for j = 1 : length(fieldname_data1)
        curr = cell2mat(fieldname_data1(j));
        if strcmp(curr, 'TS')
            data1.(curr) = [data1.(curr)(1:pos-1); Time(pos); data1.(curr)(pos:end)];
        elseif strcmp(curr, 'cs')
            data1.(curr) = cat(3, data1.(curr)(:,:, 1:pos-1), nan(10, 6, 1), data1.(curr)(:,:, pos:end));
        else
            data1.(curr) = [data1.(curr)(1:pos-1); nan; data1.(curr)(pos:end)];
        end
    end
end

missing2 = ismember(Time, data2.TS);
missing = find(missing2 == 0);
for i = 1 : length(missing)
    pos = missing(i);
    for j = 1 : length(fieldname_data2)
        curr = cell2mat(fieldname_data2(j));
        if strcmp(curr, 'TS')
            data2.(curr) = [data2.(curr)(1:pos-1); Time(pos); data2.(curr)(pos:end)];
        elseif strcmp(curr, 'cs')
            data2.(curr) = cat(3, data2.(curr)(:,:, 1:pos-1), nan(10, 6, 1), data2.(curr)(:,:, pos:end));
        else
            data2.(curr) = [data2.(curr)(1:pos-1); nan; data2.(curr)(pos:end)];
        end
    end
end
missing3 = ismember(Time, data3.TS);
missing = find(missing3 == 0);
for i = 1 : length(missing)
    pos = missing(i);
    for j = 1 : length(fieldname_data3)
        curr = cell2mat(fieldname_data3(j));
        if strcmp(curr, 'TS')
            data3.(curr) = [data3.(curr)(1:pos-1); Time(pos); data3.(curr)(pos:end)];
        elseif strcmp(curr, 'cs')
            data3.(curr) = cat(3, data3.(curr)(:,:, 1:pos-1), nan(10, 6, 1), data3.(curr)(:,:, pos:end));
        else
            data3.(curr) = [data3.(curr)(1:pos-1); nan; data3.(curr)(pos:end)];
        end
    end
end

figure
set(gcf,'Position',[200 100 1500 700])
hold on; grid on;
plot(data1.TS, data1.SnowDepth);
plot(data2.TS, data2.SnowDepth);
plot(data3.TS, data3.SnowDepth);


W = whos;
Snow = struct();
for i = 1 :length(W)
    curr = W(i).name;
    Snow.(curr) = eval(curr);
end

%% Subsurface Part
clearvars -except surface Snow
clc

start_date = datetime(2018, 8, 1); end_date = datetime(2019, 8, 1);
data1 = load('LPTEG_TREES_1_Subsurface.mat');
data2 = load('LPTEG_TREES_2_Subsurface.mat');
data3 = load('LPTEG_TUNDRA_2_Subsurface.mat');
n1_start = find(data1.TS == start_date); n1_end = find(data1.TS == end_date);
n2_start = find(data2.TS == start_date); n2_end = find(data2.TS == end_date);
n3_start = find(data3.TS == start_date); n3_end = find(data3.TS == end_date);

fieldname_data1 = fieldnames(data1);
for i = 1 : length(fieldname_data1)
    curr = cell2mat(fieldname_data1(i));
    if strcmp(curr, 'cs')
        data1.(curr) = data1.(curr)(:,:,n1_start:n1_end);
        continue
    end
    data1.(curr) = data1.(curr)(n1_start:n1_end);
    if strcmp(curr, 'TS')
        data1.(curr) = data1.(curr)';
    end
end
fieldname_data2 = fieldnames(data2);
for i = 1 : length(fieldname_data2)
    curr = cell2mat(fieldname_data2(i));
    if strcmp(curr, 'cs')
        data2.(curr) = data2.(curr)(:,:,n2_start:n2_end);
        continue
    end
    data2.(curr) = data2.(curr)(n2_start:n2_end);
    if strcmp(curr, 'TS')
        data2.(curr) = data2.(curr)';
    end
end
fieldname_data3 = fieldnames(data3);
for i = 1 : length(fieldname_data3)
    curr = cell2mat(fieldname_data3(i));
    if strcmp(curr, 'cs')
        data3.(curr) = data3.(curr)(:,:,n3_start:n3_end);
        continue
    end
    data3.(curr) = data3.(curr)(n3_start:n3_end);
    if strcmp(curr, 'TS')
        data3.(curr) = data3.(curr)';
    end
end
% Find missing
Time = start_date:minutes(60):end_date;
missing1 = ismember(Time, data1.TS);
missing = find(missing1 == 0);
for i = 1 : length(missing)
    pos = missing(i);
    for j = 1 : length(fieldname_data1)
        curr = cell2mat(fieldname_data1(j));
        if strcmp(curr, 'TS')
            data1.(curr) = [data1.(curr)(1:pos-1); Time(pos); data1.(curr)(pos:end)];
        elseif strcmp(curr, 'cs')
            data1.(curr) = cat(3, data1.(curr)(:,:, 1:pos-1), nan(10, 6, 1), data1.(curr)(:,:, pos:end));
        else
            data1.(curr) = [data1.(curr)(1:pos-1); nan; data1.(curr)(pos:end)];
        end
    end
end

missing2 = ismember(Time, data2.TS);
missing = find(missing2 == 0);
for i = 1 : length(missing)
    pos = missing(i);
    for j = 1 : length(fieldname_data2)
        curr = cell2mat(fieldname_data2(j));
        if strcmp(curr, 'TS')
            data2.(curr) = [data2.(curr)(1:pos-1); Time(pos); data2.(curr)(pos:end)];
        elseif strcmp(curr, 'cs')
            data2.(curr) = cat(3, data2.(curr)(:,:, 1:pos-1), nan(10, 6, 1), data2.(curr)(:,:, pos:end));
        else
            data2.(curr) = [data2.(curr)(1:pos-1); nan; data2.(curr)(pos:end)];
        end
    end
end
missing3 = ismember(Time, data3.TS);
missing = find(missing3 == 0);
for i = 1 : length(missing)
    pos = missing(i);
    for j = 1 : length(fieldname_data3)
        curr = cell2mat(fieldname_data3(j));
        if strcmp(curr, 'TS')
            data3.(curr) = [data3.(curr)(1:pos-1); Time(pos); data3.(curr)(pos:end)];
        elseif strcmp(curr, 'cs')
            data3.(curr) = cat(3, data3.(curr)(:,:, 1:pos-1), nan(10, 6, 1), data3.(curr)(:,:, pos:end));
        else
            data3.(curr) = [data3.(curr)(1:pos-1); nan; data3.(curr)(pos:end)];
        end
    end
end

% Water Content and Soil Temperature
figure
set(gcf,'Position',[200 100 1500 700])
subplot(5, 1, 1)
title('Volumetric Water Content and Soil Temperature at T1')
hold on; grid on
water = reshape(data1.cs(1, 1, :), 1, size(data1.TS, 1));
temp = reshape(data1.cs(1, 3, :), 1, size(data1.TS, 1));
yyaxis left
plot(data1.TS, water)
ylabel('m^3 m^{-3}')
yyaxis right
plot(data1.TS, temp)
ylabel('^oC')
A = find(data1.TS == datetime(2018, 12, 1, 17, 0, 0)); B = find(data1.TS == datetime(2019, 5, 9, 7, 0, 0));
mean_soil_water_T1_1 = mean(water,'omitnan');
mean_soil_water_T1_1_winter = mean(water(A:B),'omitnan');
mean_soil_water_T1_1_nonwinter = mean([water(1:A),water(B:end)],'omitnan');
mean_soil_temp_T1_1 = mean(temp,'omitnan');
mean_soil_temp_T1_1_winter = mean(temp(A:B),'omitnan');
mean_soil_temp_T1_1_nonwinter = mean([temp(1:A),temp(B:end)],'omitnan');
subplot(5, 1, 2)
hold on; grid on
water = reshape(data1.cs(2, 1, :), 1, size(data1.TS, 1));
temp = reshape(data1.cs(2, 3, :), 1, size(data1.TS, 1));
yyaxis left
plot(data1.TS, water)
ylabel('m^3 m^{-3}')
yyaxis right
plot(data1.TS, temp)
ylabel('^oC')
A = find(data1.TS == datetime(2019, 1, 15, 17, 0, 0)); B = find(data1.TS == datetime(2019, 6, 4, 9, 0, 0));
mean_soil_water_T1_2 = mean(water,'omitnan');
mean_soil_water_T1_2_winter = mean(water(A:B),'omitnan');
mean_soil_water_T1_2_nonwinter = mean([water(1:A),water(B:end)],'omitnan');
mean_soil_temp_T1_2 = mean(temp,'omitnan');
mean_soil_temp_T1_2_winter = mean(temp(A:B),'omitnan');
mean_soil_temp_T1_2_nonwinter = mean([temp(1:A),temp(B:end)],'omitnan');
subplot(5, 1, 3)
hold on; grid on
water = reshape(data1.cs(3, 1, :), 1, size(data1.TS, 1));
temp = reshape(data1.cs(3, 3, :), 1, size(data1.TS, 1));
yyaxis left
plot(data1.TS, water)
ylabel('m^3 m^{-3}')
yyaxis right
plot(data1.TS, temp)
ylabel('^oC')
A = find(data1.TS == datetime(2019, 2, 9, 10, 0, 0)); B = find(data1.TS == datetime(2019, 6, 19, 12, 0, 0));
mean_soil_water_T1_3 = mean(water,'omitnan');
mean_soil_water_T1_3_winter = mean(water(A:B),'omitnan');
mean_soil_water_T1_3_nonwinter = mean([water(1:A),water(B:end)],'omitnan');
mean_soil_temp_T1_3 = mean(temp,'omitnan');
mean_soil_temp_T1_3_winter = mean(temp(A:B),'omitnan');
mean_soil_temp_T1_3_nonwinter = mean([temp(1:A),temp(B:end)],'omitnan');
subplot(5, 1, 4)
hold on; grid on
water = reshape(data1.cs(4, 1, :), 1, size(data1.TS, 1));
temp = reshape(data1.cs(4, 3, :), 1, size(data1.TS, 1));
yyaxis left
plot(data1.TS, water)
ylabel('m^3 m^{-3}')
yyaxis right
plot(data1.TS, temp)
ylabel('^oC')
A = find(data1.TS == datetime(2019, 4, 27, 8, 0, 0)); B = find(data1.TS == datetime(2019, 7, 5, 7, 0, 0));
mean_soil_water_T1_4 = mean(water,'omitnan');
mean_soil_water_T1_4_winter = mean(water(A:B),'omitnan');
mean_soil_water_T1_4_nonwinter = mean([water(1:A),water(B:end)],'omitnan');
mean_soil_temp_T1_4 = mean(temp,'omitnan');
mean_soil_temp_T1_4_winter = mean(temp(A:B),'omitnan');
mean_soil_temp_T1_4_nonwinter = mean([temp(1:A),temp(B:end)],'omitnan');
subplot(5, 1, 5)
hold on; grid on
water = reshape(data1.cs(5, 1, :), 1, size(data1.TS, 1));
temp = reshape(data1.cs(5, 3, :), 1, size(data1.TS, 1));
yyaxis left
plot(data1.TS, water)
ylabel('m^3 m^{-3}')
yyaxis right
plot(data1.TS, temp)
ylabel('^oC')
A = find(data1.TS == datetime(2019, 1, 15, 17, 0, 0)); B = find(data1.TS == datetime(2019, 6, 4, 9, 0, 0));
mean_soil_water_T1_5 = mean(water,'omitnan');
% mean_soil_water_T1_5_winter = mean(water(A:B),'omitnan');
% mean_soil_water_T1_5_nonwinter = mean([water(1:A),water(B:end)],'omitnan');
mean_soil_temp_T1_5 = mean(temp,'omitnan');
% mean_soil_temp_T1_5_winter = mean(temp(A:B),'omitnan');
% mean_soil_temp_T1_5_nonwinter = mean([temp(1:A),temp(B:end)],'omitnan');


figure
set(gcf,'Position',[200 100 1500 700])
subplot(5, 1, 1)
title('Volumetric Water Content and Soil Temperature at T2')
hold on; grid on
water = reshape(data2.cs(1, 1, :), 1, size(data2.TS, 1));
temp = reshape(data2.cs(1, 3, :), 1, size(data2.TS, 1));
yyaxis left
plot(data2.TS, water)
ylabel('m^3 m^{-3}')
yyaxis right
plot(data2.TS, temp)
ylabel('^oC')
A = find(data2.TS == datetime(2018, 12, 2, 2, 0, 0)); B = find(data2.TS == datetime(2019, 6, 8, 18, 0, 0));
mean_soil_water_T2_1 = mean(water,'omitnan');
mean_soil_water_T2_1_winter = mean(water(A:B),'omitnan');
mean_soil_water_T2_1_nonwinter = mean([water(1:A),water(B:end)],'omitnan');
mean_soil_temp_T2_1 = mean(temp,'omitnan');
mean_soil_temp_T2_1_winter = mean(temp(A:B),'omitnan');
mean_soil_temp_T2_1_nonwinter = mean([temp(1:A),temp(B:end)],'omitnan');
subplot(5, 1, 2)
hold on; grid on
water = reshape(data2.cs(2, 1, :), 1, size(data2.TS, 1));
temp = reshape(data2.cs(2, 3, :), 1, size(data2.TS, 1));
yyaxis left
plot(data2.TS, water)
ylabel('m^3 m^{-3}')
yyaxis right
plot(data2.TS, temp)
ylabel('^oC')
A = find(data2.TS == datetime(2018, 12, 25, 5, 0, 0)); B = find(data2.TS == datetime(2019, 6, 10, 5, 0, 0));
mean_soil_water_T2_2 = mean(water,'omitnan');
mean_soil_water_T2_2_winter = mean(water(A:B),'omitnan');
mean_soil_water_T2_2_nonwinter = mean([water(1:A),water(B:end)],'omitnan');
mean_soil_temp_T2_2 = mean(temp,'omitnan');
mean_soil_temp_T2_2_winter = mean(temp(A:B),'omitnan');
mean_soil_temp_T2_2_nonwinter = mean([temp(1:A),temp(B:end)],'omitnan');
subplot(5, 1, 3)
hold on; grid on
water = reshape(data2.cs(3, 1, :), 1, size(data2.TS, 1));
temp = reshape(data2.cs(3, 3, :), 1, size(data2.TS, 1));
yyaxis left
plot(data2.TS, water)
ylabel('m^3 m^{-3}')
yyaxis right
plot(data2.TS, temp)
ylabel('^oC')
A = find(data2.TS == datetime(2019, 2, 4, 19, 0, 0)); B = find(data2.TS == datetime(2019, 6, 25, 19, 0, 0));
mean_soil_water_T2_3 = mean(water,'omitnan');
mean_soil_water_T2_3_winter = mean(water(A:B),'omitnan');
mean_soil_water_T2_3_nonwinter = mean([water(1:A),water(B:end)],'omitnan');
mean_soil_temp_T2_3 = mean(temp,'omitnan');
mean_soil_temp_T2_3_winter = mean(temp(A:B),'omitnan');
mean_soil_temp_T2_3_nonwinter = mean([temp(1:A),temp(B:end)],'omitnan');
subplot(5, 1, 4)
hold on; grid on
water = reshape(data2.cs(4, 1, :), 1, size(data2.TS, 1));
temp = reshape(data2.cs(4, 3, :), 1, size(data2.TS, 1));
yyaxis left
plot(data2.TS, water)
ylabel('m^3 m^{-3}')
yyaxis right
plot(data2.TS, temp)
ylabel('^oC')
A = find(data2.TS == datetime(2019, 3, 26, 2, 0, 0)); B = find(data2.TS == datetime(2019, 7, 9, 1, 0, 0));
mean_soil_water_T2_4 = mean(water,'omitnan');
mean_soil_water_T2_4_winter = mean(water(A:B),'omitnan');
mean_soil_water_T2_4_nonwinter = mean([water(1:A),water(B:end)],'omitnan');
mean_soil_temp_T2_4 = mean(temp,'omitnan');
mean_soil_temp_T2_4_winter = mean(temp(A:B),'omitnan');
mean_soil_temp_T2_4_nonwinter = mean([temp(1:A),temp(B:end)],'omitnan');
subplot(5, 1, 5)
hold on; grid on
water = reshape(data2.cs(5, 1, :), 1, size(data2.TS, 1));
temp = reshape(data2.cs(5, 3, :), 1, size(data2.TS, 1));
yyaxis left
plot(data2.TS, water)
ylabel('m^3 m^{-3}')
yyaxis right
plot(data2.TS, temp)
ylabel('^oC')
A = find(data2.TS == datetime(2019, 5, 12, 10, 0, 0)); B = find(data2.TS == datetime(2019, 7, 21, 4, 0, 0));
mean_soil_water_T2_5 = mean(water,'omitnan');
mean_soil_water_T2_5_winter = mean(water(A:B),'omitnan');
mean_soil_water_T2_5_nonwinter = mean([water(1:A),water(B:end)],'omitnan');
mean_soil_temp_T2_5 = mean(temp,'omitnan');
mean_soil_temp_T2_5_winter = mean(temp(A:B),'omitnan');
mean_soil_temp_T2_5_nonwinter = mean([temp(1:A),temp(B:end)],'omitnan');


figure
set(gcf,'Position',[200 100 1500 700])
subplot(5, 1, 1)
title('Volumetric Water Content and Soil Temperature at TR')
hold on; grid on
water = reshape(data3.cs(1, 1, :), 1, size(data3.TS, 1));
temp = reshape(data3.cs(1, 3, :), 1, size(data3.TS, 1));
yyaxis left
plot(data3.TS, water)
ylabel('m^3 m^{-3}')
yyaxis right
plot(data3.TS, temp)
ylabel('^oC')
A = find(data3.TS == datetime(2018, 11, 10, 12, 0, 0)); B = find(data3.TS == datetime(2019, 5, 29, 7, 0, 0));
mean_soil_water_T3_1 = mean(water,'omitnan');
mean_soil_water_T3_1_winter = mean(water(A:B),'omitnan');
mean_soil_water_T3_1_nonwinter = mean([water(1:A),water(B:end)],'omitnan');
mean_soil_temp_T3_1 = mean(temp,'omitnan');
mean_soil_temp_T3_1_winter = mean(temp(A:B),'omitnan');
mean_soil_temp_T3_1_nonwinter = mean([temp(1:A),temp(B:end)],'omitnan');
subplot(5, 1, 2)
hold on; grid on
water = reshape(data3.cs(2, 1, :), 1, size(data3.TS, 1));
temp = reshape(data3.cs(2, 3, :), 1, size(data3.TS, 1));
yyaxis left
plot(data3.TS, water)
ylabel('m^3 m^{-3}')
yyaxis right
plot(data3.TS, temp)
ylabel('^oC')
A = find(data3.TS == datetime(2018, 12, 3, 2, 0, 0)); B = find(data3.TS == datetime(2019, 6, 3, 17, 0, 0));
mean_soil_water_T3_2 = mean(water,'omitnan');
mean_soil_water_T3_2_winter = mean(water(A:B),'omitnan');
mean_soil_water_T3_2_nonwinter = mean([water(1:A),water(B:end)],'omitnan');
mean_soil_temp_T3_2 = mean(temp,'omitnan');
mean_soil_temp_T3_2_winter = mean(temp(A:B),'omitnan');
mean_soil_temp_T3_2_nonwinter = mean([temp(1:A),temp(B:end)],'omitnan');
subplot(5, 1, 3)
hold on; grid on
water = reshape(data3.cs(3, 1, :), 1, size(data3.TS, 1));
temp = reshape(data3.cs(3, 3, :), 1, size(data3.TS, 1));
yyaxis left
plot(data3.TS, water)
ylabel('m^3 m^{-3}')
yyaxis right
plot(data3.TS, temp)
ylabel('^oC')
A = find(data3.TS == datetime(2018, 12, 28, 21, 0, 0)); B = find(data3.TS == datetime(2019, 6, 22, 12, 0, 0));
mean_soil_water_T3_3 = mean(water,'omitnan');
mean_soil_water_T3_3_winter = mean(water(A:B),'omitnan');
mean_soil_water_T3_3_nonwinter = mean([water(1:A),water(B:end)],'omitnan');
mean_soil_temp_T3_3 = mean(temp,'omitnan');
mean_soil_temp_T3_3_winter = mean(temp(A:B),'omitnan');
mean_soil_temp_T3_3_nonwinter = mean([temp(1:A),temp(B:end)],'omitnan');
subplot(5, 1, 4)
hold on; grid on
water = reshape(data3.cs(4, 1, :), 1, size(data3.TS, 1));
temp = reshape(data3.cs(4, 3, :), 1, size(data3.TS, 1));
yyaxis left
plot(data3.TS, water)
ylabel('m^3 m^{-3}')
yyaxis right
plot(data3.TS, temp)
ylabel('^oC')
A = find(data3.TS == datetime(2019, 1, 16, 3, 0, 0)); B = find(data3.TS == datetime(2019, 6, 29, 13, 0, 0));
mean_soil_water_T3_4 = mean(water,'omitnan');
mean_soil_water_T3_4_winter = mean(water(A:B),'omitnan');
mean_soil_water_T3_4_nonwinter = mean([water(1:A),water(B:end)],'omitnan');
mean_soil_temp_T3_4 = mean(temp,'omitnan');
mean_soil_temp_T3_4_winter = mean(temp(A:B),'omitnan');
mean_soil_temp_T3_4_nonwinter = mean([temp(1:A),temp(B:end)],'omitnan');
subplot(5, 1, 5)
hold on; grid on
water = reshape(data3.cs(5, 1, :), 1, size(data3.TS, 1));
temp = reshape(data3.cs(5, 3, :), 1, size(data3.TS, 1));
yyaxis left
plot(data3.TS, water)
ylabel('m^3 m^{-3}')
yyaxis right
plot(data3.TS, temp)
ylabel('^oC')
A = find(data3.TS == datetime(2019, 1, 27, 11, 0, 0)); B = find(data3.TS == datetime(2019, 7, 1, 20, 0, 0));
mean_soil_water_T3_5 = mean(water,'omitnan');
mean_soil_water_T3_5_winter = mean(water(A:B),'omitnan');
mean_soil_water_T3_5_nonwinter = mean([water(1:A),water(B:end)],'omitnan');
mean_soil_temp_T3_5 = mean(temp,'omitnan');
mean_soil_temp_T3_5_winter = mean(temp(A:B),'omitnan');
mean_soil_temp_T3_5_nonwinter = mean([temp(1:A),temp(B:end)],'omitnan');


% Plot Volumetric Water Content and Soil Temperature Together in one figure
% for three sites
figure
set(gcf,'Position',[200 100 1500 700])
subplot(5, 1, 1)
title('Volumetric Water Content and Soil Temperature')
hold on; grid on
water1 = reshape(data1.cs(1, 1, :), 1, size(data1.TS, 1));
temp1 = reshape(data1.cs(1, 3, :), 1, size(data1.TS, 1));
water2 = reshape(data2.cs(1, 1, :), 1, size(data2.TS, 1));
temp2 = reshape(data2.cs(1, 3, :), 1, size(data2.TS, 1));
water3 = reshape(data3.cs(1, 1, :), 1, size(data3.TS, 1));
temp3 = reshape(data3.cs(1, 3, :), 1, size(data3.TS, 1));
yyaxis left
plot(data1.TS, water1, 'Color','#AB47BC','LineStyle','-')
plot(data2.TS, water2,'Color','#2196F3','LineStyle','-')
plot(data3.TS, water3,'Color','#388E3C','LineStyle','-')
ylabel('m^3 m^{-3}')
yticks([0 0.1 0.2 0.3 0.4 0.5])
yyaxis right
plot(data1.TS, temp1,'Color','#FDD835','LineStyle','-')
plot(data2.TS, temp2,'Color','#F7630C','LineStyle','-')
plot(data3.TS, temp3,'Color','#FF4343','LineStyle','-')
legend('T1 Water','T2 Water','TR Water','T1 Temp','T2 Temp','TR Temp')
ylabel('^oC')
xlim([datetime(2018, 9, 1), datetime(2019, 8, 1)])
text(datetime(2019, 3, 1), 8, '6cm')
subplot(5, 1, 2)
hold on; grid on
water1 = reshape(data1.cs(2, 1, :), 1, size(data1.TS, 1));
temp1 = reshape(data1.cs(2, 3, :), 1, size(data1.TS, 1));
water2 = reshape(data2.cs(2, 1, :), 1, size(data2.TS, 1));
temp2 = reshape(data2.cs(2, 3, :), 1, size(data2.TS, 1));
water3 = reshape(data3.cs(2, 1, :), 1, size(data3.TS, 1));
temp3 = reshape(data3.cs(2, 3, :), 1, size(data3.TS, 1));
yyaxis left
plot(data1.TS, water1, 'Color','#AB47BC','LineStyle','-')
plot(data2.TS, water2,'Color','#2196F3','LineStyle','-')
plot(data3.TS, water3,'Color','#388E3C','LineStyle','-')
ylabel('m^3 m^{-3}')
yticks([0 0.1 0.2 0.3 0.4 0.5])
yyaxis right
plot(data1.TS, temp1,'Color','#FDD835','LineStyle','-')
plot(data2.TS, temp2,'Color','#F7630C','LineStyle','-')
plot(data3.TS, temp3,'Color','#FF4343','LineStyle','-')
ylabel('^oC')
text(datetime(2019, 3, 1), 8, '20cm')
subplot(5, 1, 3)
hold on; grid on
water1 = reshape(data1.cs(3, 1, :), 1, size(data1.TS, 1));
temp1 = reshape(data1.cs(3, 3, :), 1, size(data1.TS, 1));
water2 = reshape(data2.cs(3, 1, :), 1, size(data2.TS, 1));
temp2 = reshape(data2.cs(3, 3, :), 1, size(data2.TS, 1));
water3 = reshape(data3.cs(3, 1, :), 1, size(data3.TS, 1));
temp3 = reshape(data3.cs(3, 3, :), 1, size(data3.TS, 1));
yyaxis left
plot(data1.TS, water1, 'Color','#AB47BC','LineStyle','-')
plot(data2.TS, water2,'Color','#2196F3','LineStyle','-')
plot(data3.TS, water3,'Color','#388E3C','LineStyle','-')
ylabel('m^3 m^{-3}')
yticks([0 0.1 0.2 0.3 0.4 0.5])
yyaxis right
plot(data1.TS, temp1,'Color','#FDD835','LineStyle','-')
plot(data2.TS, temp2,'Color','#F7630C','LineStyle','-')
plot(data3.TS, temp3,'Color','#FF4343','LineStyle','-')
ylabel('^oC')
text(datetime(2019, 3, 1), 7, '40cm')
subplot(5, 1, 4)
hold on; grid on
water1 = reshape(data1.cs(4, 1, :), 1, size(data1.TS, 1));
temp1 = reshape(data1.cs(4, 3, :), 1, size(data1.TS, 1));
water2 = reshape(data2.cs(4, 1, :), 1, size(data2.TS, 1));
temp2 = reshape(data2.cs(4, 3, :), 1, size(data2.TS, 1));
water3 = reshape(data3.cs(4, 1, :), 1, size(data3.TS, 1));
temp3 = reshape(data3.cs(4, 3, :), 1, size(data3.TS, 1));
yyaxis left
plot(data1.TS, water1, 'Color','#AB47BC','LineStyle','-')
plot(data2.TS, water2,'Color','#2196F3','LineStyle','-')
plot(data3.TS, water3,'Color','#388E3C','LineStyle','-')
ylabel('m^3 m^{-3}')
yticks([0 0.1 0.2 0.3 0.4 0.5])
yyaxis right
plot(data1.TS, temp1,'Color','#FDD835','LineStyle','-')
plot(data2.TS, temp2,'Color','#F7630C','LineStyle','-')
plot(data3.TS, temp3,'Color','#FF4343','LineStyle','-')
ylabel('^oC')
text(datetime(2019, 4, 1), 4, '70cm')
subplot(5, 1, 5)
hold on; grid on
water1 = reshape(data1.cs(5, 1, :), 1, size(data1.TS, 1));
temp1 = reshape(data1.cs(5, 3, :), 1, size(data1.TS, 1));
water2 = reshape(data2.cs(5, 1, :), 1, size(data2.TS, 1));
temp2 = reshape(data2.cs(5, 3, :), 1, size(data2.TS, 1));
water3 = reshape(data3.cs(5, 1, :), 1, size(data3.TS, 1));
temp3 = reshape(data3.cs(5, 3, :), 1, size(data3.TS, 1));
yyaxis left
plot(data1.TS, water1, 'Color','#AB47BC','LineStyle','-')
plot(data2.TS, water2,'Color','#2196F3','LineStyle','-')
plot(data3.TS, water3,'Color','#388E3C','LineStyle','-')
ylabel('m^3 m^{-3}')
yticks([0 0.1 0.2 0.3 0.4 0.5])
yyaxis right
plot(data1.TS, temp1,'Color','#FDD835','LineStyle','-')
plot(data2.TS, temp2,'Color','#F7630C','LineStyle','-')
plot(data3.TS, temp3,'Color','#FF4343','LineStyle','-')
ylabel('^oC')
text(datetime(2019, 5, 1), 5, '100cm')

% Water Content Change During Melting
figure
set(gcf,'Position',[200 50 1000 850])
April_1 = find(data1.TS == datetime(2019, 4, 1));
subplot(5, 1, 1)
water1 = reshape(data1.cs(1, 1, :), 1, size(data1.TS, 1));
water2 = reshape(data2.cs(1, 1, :), 1, size(data2.TS, 1));
water3 = reshape(data3.cs(1, 1, :), 1, size(data3.TS, 1));
hold on; grid on
plot(data1.TS(April_1:end), water1(April_1:end));
plot(data2.TS(April_1:end), water2(April_1:end));
plot(data3.TS(April_1:end), water3(April_1:end));
legend('T1','T2','TR','Location','best')
title({'Water Content During Thawing','(a)'})
yticks([0 0.1 0.2 0.3 0.4 0.5])
yticklabels({'0' '0.1' '0.2' '0.3' '0.4' '0.5'})
ylabel('m^3 m^{-3}')
xticklabels({})
subplot(5, 1, 2)
water1 = reshape(data1.cs(2, 1, :), 1, size(data1.TS, 1));
water2 = reshape(data2.cs(2, 1, :), 1, size(data2.TS, 1));
water3 = reshape(data3.cs(2, 1, :), 1, size(data3.TS, 1));
hold on; grid on
plot(data1.TS(April_1:end), water1(April_1:end));
plot(data2.TS(April_1:end), water2(April_1:end));
plot(data3.TS(April_1:end), water3(April_1:end));
yticks([0 0.1 0.2 0.3 0.4 0.5])
yticklabels({'0' '0.1' '0.2' '0.3' '0.4' '0.5'})
ylabel('m^3 m^{-3}')
xticklabels({})
title('(b)')
subplot(5, 1, 3)
water1 = reshape(data1.cs(3, 1, :), 1, size(data1.TS, 1));
water2 = reshape(data2.cs(3, 1, :), 1, size(data2.TS, 1));
water3 = reshape(data3.cs(3, 1, :), 1, size(data3.TS, 1));
hold on; grid on
plot(data1.TS(April_1:end), water1(April_1:end));
plot(data2.TS(April_1:end), water2(April_1:end));
plot(data3.TS(April_1:end), water3(April_1:end));
yticks([0 0.1 0.2 0.3 0.4 0.5])
yticklabels({'0' '0.1' '0.2' '0.3' '0.4' '0.5'})
ylabel('m^3 m^{-3}')
xticklabels({})
title('(c)')
subplot(5, 1, 4)
water1 = reshape(data1.cs(4, 1, :), 1, size(data1.TS, 1));
water2 = reshape(data2.cs(4, 1, :), 1, size(data2.TS, 1));
water3 = reshape(data3.cs(4, 1, :), 1, size(data3.TS, 1));
hold on; grid on
plot(data1.TS(April_1:end), water1(April_1:end));
plot(data2.TS(April_1:end), water2(April_1:end));
plot(data3.TS(April_1:end), water3(April_1:end));
yticks([0 0.1 0.2 0.3 0.4 0.5])
yticklabels({'0' '0.1' '0.2' '0.3' '0.4' '0.5'})
ylabel('m^3 m^{-3}')
xticklabels({})
title('(d)')
subplot(5, 1, 5)
water1 = reshape(data1.cs(5, 1, :), 1, size(data1.TS, 1));
water2 = reshape(data2.cs(5, 1, :), 1, size(data2.TS, 1));
water3 = reshape(data3.cs(5, 1, :), 1, size(data3.TS, 1));
hold on; grid on
plot(data1.TS(April_1:end), water1(April_1:end));
plot(data2.TS(April_1:end), water2(April_1:end));
plot(data3.TS(April_1:end), water3(April_1:end));
yticks([0 0.1 0.2 0.3 0.4 0.5])
yticklabels({'0' '0.1' '0.2' '0.3' '0.4' '0.5'})
ylabel('m^3 m^{-3}')
title('(e)')

W = whos;
subsurface = struct();
for i = 1 :length(W)
    curr = W(i).name;
    subsurface.(curr) = eval(curr);
end

%% More combined calculations
G_flux_1 = surface.data1.Gflux_1; G_flux_1 = G_flux_1(1:2:end);
G_flux_2 = surface.data2.Gflux_1; G_flux_2 = G_flux_2(1:2:end);
G_flux_3 = surface.data3.Gflux_1; G_flux_3 = G_flux_3(1:2:end);

T_s_1 = reshape(subsurface.data1.cs(1, 3, :), 1, size(subsurface.data1.TS, 1));
T_s_2 = reshape(subsurface.data2.cs(1, 3, :), 1, size(subsurface.data2.TS, 1));
T_s_3 = reshape(subsurface.data3.cs(1, 3, :), 1, size(subsurface.data3.TS, 1));

Is_1 = find_thermalInertia(G_flux_1, T_s_1, 300, 2000, 1);
Is_2 = find_thermalInertia(G_flux_2, T_s_1, 300, 2000, 1);
Is_3 = find_thermalInertia(G_flux_3, T_s_1, 300, 2000, 1);

mean_air_temperature = mean(surface.data1.AirT, 'omitnan');
min_air_temperature = min(surface.data1.AirT);
max_air_temperature = max(surface.data1.AirT);
No_air_temperature_aboveZero = 0;
for i = 49 : 48 :length(surface.data1.AirT)
    sub = mean(surface.data1.AirT(i-48:i), 'omitnan');
    if sub > 0
        No_air_temperature_aboveZero = No_air_temperature_aboveZero + 1;
    end
end

No_air_temperature_belowZero = 365 - No_air_temperature_aboveZero;

figure
set(gcf,'Position',[200 50 1000 550])
yyaxis left
hold on;grid on;
plot(Time, G_flux_1, 'Color','#2196F3','LineStyle','-');
plot(Time, G_flux_2, 'Color','#9C27B0','LineStyle','-');
plot(Time, G_flux_3, 'Color','#9CCC65','LineStyle','-');
ylabel('Ground Heat Flux (W m^{-2})')
yyaxis right
plot(Time(1:7849), Snow.data1.SnowDepth(1:7849)+0.358);
ylabel('Snow Depth (m)')
legend('T1','T2','TR','Snow Depth')

%% Freezing Related Part

freeze_time_T1 = [datetime(2018, 12, 1, 10, 0, 0), datetime(2019, 1, 13, 23, 0, 0), datetime(2019, 2, 10, 20, 0, 0), datetime(2019, 4, 7, 6, 0, 0)];
freeze_time_T2 = [datetime(2018, 12, 2, 20, 0, 0), datetime(2018, 12, 26, 16, 0, 0), datetime(2019, 2, 4, 12, 0, 0), datetime(2019, 3, 26, 19, 0, 0), datetime(2019, 4, 9, 19, 0, 0)];
freeze_time_TR = [datetime(2018, 11, 12, 4, 0, 0), datetime(2018, 12, 19, 18, 0, 0), datetime(2018, 12, 30, 1, 0, 0), datetime(2019, 1, 15, 17, 0, 0), datetime(2019, 1, 27, 5, 0, 0)];

thaw_time_T1 = [datetime(2019, 5, 31, 21, 0, 0), datetime(2019, 6, 9, 15, 0, 0), datetime(2019, 6, 21, 20, 0, 0), datetime(2019, 7, 5, 9, 0, 0)];
thaw_time_T2 = [datetime(2019, 6, 11, 18, 0, 0), datetime(2019, 6, 22, 13, 0, 0), datetime(2019, 7, 1, 15, 0, 0), datetime(2019, 7, 6, 20, 0, 0), datetime(2019, 7, 17, 13, 0, 0)];
thaw_time_TR = [datetime(2019, 6, 3, 6, 0, 0), datetime(2019, 6, 7, 9, 0, 0), datetime(2019, 6, 23, 12, 0, 0), datetime(2019, 7, 2, 21, 0, 0), datetime(2019, 7, 7, 11, 0, 0)];

figure
set(gcf,'Position',[200 50 1500 550])
subplot(1, 2, 1)
hold on; grid on;
plot(freeze_time_T1, [0.06, 0.2, 0.4, 0.7],'o-')
plot(freeze_time_T2, [0.06, 0.2, 0.4, 0.7, 1],'o-')
plot(freeze_time_TR, [0.06, 0.2, 0.4, 0.7, 1],'o-')
legend('T1','T2','TR')
ylabel('m')
ylim([0.06, 1.1])
yticks([0.06, 0.2, 0.4, 0.7, 1])
yticklabels({'0.06', '0.2', '0.4', '0.7', '1'})
xlim([datetime(2018, 11, 1), datetime(2019, 5, 1)])
subplot(1, 2, 2)
hold on; grid on;
plot(thaw_time_T1, [0.06, 0.2, 0.4, 0.7],'o-')
plot(thaw_time_T2, [0.06, 0.2, 0.4, 0.7, 1],'o-')
plot(thaw_time_TR, [0.06, 0.2, 0.4, 0.7, 1],'o-')
ylabel('m')
ylim([0.06, 1.1])
yticks([0.06, 0.2, 0.4, 0.7, 1])
yticklabels({'0.06', '0.2', '0.4', '0.7', '1'})
xlim([datetime(2019, 5, 1), datetime(2019, 11, 1)])

% snow_index = 3307:14312;
snow_index = 4000:12000;
nosnow_index = [1:3306, 14313:17521];
%Albedo
albedo_snow = surface.data3.Slr_2(snow_index)./surface.data3.Slr_1(snow_index);
albedo_nosnow = surface.data1.Slr_2(nosnow_index)./surface.data1.Slr_1(nosnow_index);

albedo_snow(find(albedo_snow> 1 | albedo_snow <0)) = nan;
albedo_nosnow(find(albedo_nosnow> 1 | albedo_nosnow <0)) = nan;

albedo_snow_diurnal_mean = get_diurnal_hourly_mean(albedo_snow, surface.data1.TS(snow_index), 0, 2);
albedo_nosnow_diurnal_mean = get_diurnal_hourly_mean(albedo_nosnow, surface.data1.TS(nosnow_index), 0, 2);

figure
hold on; grid on;
set(gcf,'Position',[200 50 1500 550])
plot(0:0.5:23.5, albedo_snow_diurnal_mean)
plot(0:0.5:23.5, albedo_nosnow_diurnal_mean)
legend('snow','no snow')



save Arctic_OBS.mat
