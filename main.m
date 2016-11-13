%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CEA Plotter (RSE Presentation #8)
% Seongheon Lee, AE Dept., 20165234
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%
clc;    clear all;  close all;

default_Colors = [0 0.4470 0.7410;
    0.8500 0.3250 0.0980;
    0.9290 0.6940 0.1250;
    0.4940 0.1840 0.5560;
    0.4660 0.6740 0.1880;
    0.3010 0.7450 0.9330;
    0.6350 0.0780 0.1840];

grav_acc = 9.81;
component_ID = ['CO ';'CO2';'H  ';'H2 ';'H2O';'NO ';'NO2';'N2 ';'O  ';'OH ';'O2 '];
%%

nameInput = inputdlg('Enter the file name only(*.txt):','Input', [1 50], {'kerosene'});
fileName = strcat(nameInput{1},'.txt');
% fileName='kerosene.txt';
data = dlmread(fileName);

num_of_components = data(1,1);
num_of_mixture_ratios = data(2,1);
num_of_pressure_ratios = data(3,1);
num_of_atm_location = data(3,2);

num_of_rows = 13 + 2 * data(1,1); %rows in one group of mixture ratio
row_offset = 3; % 3 rows contating basic data
col_offset = 2; % 2 columns contating chamber and throat conditions

components = data(1,2:(num_of_components+1));
%read component ID: 1=CO, 2=CO2, 3=H, 4=H2, 5=H2O, 6=NO, 7=NO2, 8=N2, 9=O, 10=OH, 11=O2
mixture_ratios = data(2,2:(num_of_mixture_ratios+1));
pressure_ratios = data(3,3:(num_of_pressure_ratios+2));

%% Figure 5-1. Performance analysis (p1 = 1000psia, p2 = 14.696psia(atmospheric))
for i=1:num_of_mixture_ratios
    chamber_temperature(i,:) = data(row_offset + (i-1)*num_of_rows + 2, 1);
    nozzle_exit_temperature_frozen(i,:) = data(row_offset + (i-1)*num_of_rows + 2, col_offset + num_of_atm_location);
    nozzle_exit_temperature_shifting(i,:) = data(row_offset + (i-1)*num_of_rows + 3, col_offset + num_of_atm_location);
    mm_chamber(i,:) = data(row_offset + (i-1)*num_of_rows + 5, 1);
    mm_exit(i,:) = data(row_offset + (i-1)*num_of_rows + 5, col_offset + num_of_atm_location);
    c_star_frozen(i,:) = data(row_offset + (i-1)*num_of_rows + 8, col_offset + num_of_atm_location);
    c_star_shifting(i,:) = data(row_offset + (i-1)*num_of_rows + 9, col_offset + num_of_atm_location);
    isp_frozen(i,:) = data(row_offset + (i-1)*num_of_rows + 12, col_offset + num_of_atm_location)/grav_acc;
    isp_shifting(i,:) = data(row_offset + (i-1)*num_of_rows + 13, col_offset + num_of_atm_location)/grav_acc;    
end

%%
figure(1)
ax1_min=floor(min(min(chamber_temperature),min(nozzle_exit_temperature_frozen)))-mod(floor(min(min(chamber_temperature),min(nozzle_exit_temperature_frozen))),500);
ax1_max=ceil(max(max(chamber_temperature),max(nozzle_exit_temperature_frozen)))+(500-mod(ceil(max(max(chamber_temperature),max(nozzle_exit_temperature_frozen))),500));
ax2_min=floor(min(min(mm_chamber),min(mm_exit)))-mod(floor(min(min(mm_chamber),min(mm_exit))),1);
ax2_max=ceil(max(max(mm_chamber),max(mm_exit)))+(1-mod(ceil(max(max(mm_chamber),max(mm_exit))),1));

[ax, h1, h2] = plotyy(mixture_ratios, chamber_temperature,mixture_ratios, mm_chamber,'plot');
set(h2,'Color',default_Colors(4,:), 'LineStyle','--');

hold(ax(1),'on');
hold(ax(2),'on');
grid on;
plot(ax(1),mixture_ratios,nozzle_exit_temperature_frozen);
plot(ax(1),mixture_ratios,nozzle_exit_temperature_shifting);

set(ax(1),'Ycolor',[0 0 0]);
set(ax(2),'ColorOrder',default_Colors(5,:),'LineStyleOrder','--','Ycolor',[0 0 0]);
set(ax(1),'YLim',[ax1_min ax1_max],'YTick',[ax1_min:500:ax1_max]); % 'YLim',[1000 3500],'YTick',[1000:500:3500],...
set(ax(2),'YLim',[ax2_min ax2_max],'YTick',[ax2_min:1:ax2_max]); %'YLim',[20 24],'YTick',[20:1:24],...
plot(ax(2),mixture_ratios,mm_exit);

title('FIG 5-1(a). Performance Analysis (p_1=1000psia, p_2=14.696psia)');
xlabel('Mixture ratio (oxidizer/fuel)');
set(get(ax(1), 'Ylabel'), 'String', 'Temperature, K');
set(get(ax(2), 'Ylabel'), 'String', 'Molecular weight');
legend('Chamber T.','Exit T.(frozen)','Exit T.(shifting)','MM(chamber)','MM(exit)', 'Location', 'west');

%%
figure(2)
ax1_min=floor(min(min(isp_frozen),min(isp_shifting)))-mod(floor(min(min(isp_frozen),min(isp_shifting))),10);
ax1_max=ceil(max(max(isp_frozen),max(isp_shifting)))+(10-mod(ceil(max(max(isp_frozen),max(isp_shifting))),10));
ax2_min=floor(min(min(c_star_frozen),min(c_star_shifting)))-mod(floor(min(min(c_star_frozen),min(c_star_shifting))),10);
ax2_max=ceil(max(max(c_star_frozen),max(c_star_shifting)))+(10-mod(ceil(max(max(c_star_frozen),max(c_star_shifting))),10));

[ax, h1, h2] = plotyy(mixture_ratios, isp_frozen, mixture_ratios, c_star_frozen,'plot');
set(h2,'Color',default_Colors(3,:), 'LineStyle','--');

hold(ax(1),'on');
hold(ax(2),'on');
grid on;
plot(ax(1),mixture_ratios,isp_shifting);

set(ax(1),'Ycolor',[0 0 0]);
set(ax(2),'ColorOrder',default_Colors(4,:),'LineStyleOrder','--','Ycolor',[0 0 0]);
set(ax(1),'YLim',[ax1_min ax1_max],'YTick',[ax1_min:2:ax1_max]);
set(ax(2),'YLim',[ax2_min ax2_max],'YTick',[ax2_min:10:ax2_max]);
plot(ax(2),mixture_ratios,c_star_shifting);

title('FIG 5-1(b). Performance Analysis (p_1=1000psia, p_2=14.696psia)');
xlabel('Mixture ratio (oxidizer/fuel)');
set(get(ax(1), 'Ylabel'), 'String', 'Isp, sec');
set(get(ax(2), 'Ylabel'), 'String', 'c^*, m/sec');
legend('Isp(frozen).','Isp(shifting)','c^*(frozen)','c^*(shifting)', 'Location', 'southwest');

%% Figure 5-2(a). Chamber gas composition (w/ water) (p1 = 1000psia)
figure(3)
for i=1:num_of_mixture_ratios
    for j=1:num_of_components
        chamber_gas_composition(i,j) = data(row_offset + (i-1)*num_of_rows + (13 + j), 1) * 100;
    end
end

for j=1:num_of_components
    plot(mixture_ratios, chamber_gas_composition(:,j), 'DisplayName', component_ID(components(j),:));
    hold on;
end
grid on;
hold off;

title('FIG 5-2(a). Chamber gas composition (p_1=1000psia)');
xlabel('Mixture ratio (oxidizer/fuel)');
ylabel('Composition, mole percent');
legend(gca,'show');

%% Figure 5-2(b). Chamber gas composition (w/o/ water) (p1 = 1000psia)
figure(4)
for j=1:num_of_components
    if (components(j)~=5)
        plot(mixture_ratios, chamber_gas_composition(:,j), 'DisplayName', component_ID(components(j),:));
        hold on;
    end
end
grid on;
hold off;

title('FIG 5-2(b). Chamber gas composition (p_1=1000psia)');
xlabel('Mixture ratio (oxidizer/fuel)');
ylabel('Composition, mole percent');
legend(gca,'show');

%% Figure 5-3(a). Nozzle exit gas composition (w/ water) (p1 = 1000psia, p2=14.696psia)
figure(5)
for i=1:num_of_mixture_ratios
    for j=1:num_of_components
        exit_gas_composition(i,j) = data(row_offset + (i-1)*num_of_rows + (13 + num_of_components + j), col_offset + num_of_atm_location) * 100;
    end
end

for j=1:num_of_components
    plot(mixture_ratios, exit_gas_composition(:,j), 'DisplayName', component_ID(components(j),:));
    hold on;
end
grid on;
hold off;

title('FIG 5-3(a). Exit gas composition (p_1=1000psia, p2=14.696psia)');
xlabel('Mixture ratio (oxidizer/fuel)');
ylabel('Composition, mole percent');
legend(gca,'show');

%% Figure 5-3(b). Nozzle exit gas composition (w/o/ water) (p1 = 1000psia, p2=14.696psia)
figure(6)
for j=1:num_of_components
    if (components(j)~=5)
        plot(mixture_ratios, exit_gas_composition(:,j), 'DisplayName', component_ID(components(j),:));
        hold on;
    end
end
grid on;
hold off;

title('FIG 5-3(b). Exit gas composition (p_1=1000psia, p2=14.696psia)');
xlabel('Mixture ratio (oxidizer/fuel)');
ylabel('Composition, mole percent');
legend(gca,'show');

%% Figure 5-4. Variation of Specific Impulse (frozen)
figure(7)
for i=1:num_of_mixture_ratios
    for j=1:num_of_pressure_ratios
        specific_impulse_frozen(i,j) = data(row_offset + (i-1)*num_of_rows + 12, col_offset + j) / grav_acc;
    end
end

for j=1:num_of_pressure_ratios
    if (pressure_ratios(j)==10 || pressure_ratios(j)==68.05 || pressure_ratios(j)==100 || pressure_ratios(j)==400 || pressure_ratios(j)==1000)
        plot(mixture_ratios, specific_impulse_frozen(:,j), 'DisplayName', ['p1/p2 = ' num2str(pressure_ratios(j))]);
        hold on;
    end
end
grid on;
hold off;

title('FIG 5-4. Variation of Isp (frozen, p_1=1000psia)');
xlabel('Mixture ratio (oxidizer/fuel)');
ylabel('Specific Impulse, sec');
legend(gca,'show', 'Location', 'south');

%% Figure 5-5. Variation w/r/t the pressure ratio @ a given mixture ratio
figure(8)
for i=1:num_of_mixture_ratios
    for j=1:num_of_pressure_ratios
        specific_impulse_shifting(i,j) = data(row_offset + (i-1)*num_of_rows + 13, col_offset + j) / grav_acc;
        temperature_frozen(i,j) = data(row_offset + (i-1)*num_of_rows + 2, col_offset + j);
        temperature_shifting(i,j) = data(row_offset + (i-1)*num_of_rows + 3, col_offset + j);
    end
end


ax1_min=floor(min(min(min(specific_impulse_frozen),min(specific_impulse_shifting))))-mod(floor(min(min(min(specific_impulse_frozen),min(specific_impulse_shifting)))),50);
ax1_max=ceil(max(max(max(specific_impulse_frozen),max(specific_impulse_shifting))))+(50-mod(ceil(max(max(max(specific_impulse_frozen),max(specific_impulse_shifting)))),50));
ax2_min=floor(min(min(min(temperature_frozen),min(temperature_shifting))))-mod(floor(min(min(min(temperature_frozen),min(temperature_shifting)))),500);
ax2_max=ceil(max(max(max(temperature_frozen),max(temperature_shifting))))+(500-mod(ceil(max(max(max(temperature_frozen),max(temperature_shifting)))),500));

i = 2;
[ax, h1, h2] = plotyy(pressure_ratios, specific_impulse_frozen(i,:),pressure_ratios, temperature_frozen(i,:),'plot');
set(h2,'Color',default_Colors(3,:), 'LineStyle','--');
hold(ax(1),'on');
hold(ax(2),'on');
grid on;
plot(ax(1),pressure_ratios,specific_impulse_shifting(i,:));

set(ax(1),'xscale','log','XLim',[2 1000],'Xdir','reverse','Ycolor',[0 0 0]);
set(ax(2),'xscale','log','XLim',[2 1000],'Xdir','reverse','Ycolor',[0 0 0],...
    'LineStyleOrder','--','ColorOrder',default_Colors(4,:));
set(ax(1),'YLim',[ax1_min ax1_max],'YTick',[ax1_min:50:ax1_max]);
set(ax(2),'YLim',[ax2_min ax2_max],'YTick',[ax2_min:500:ax2_max]);

plot(ax(2),pressure_ratios,temperature_shifting(i,:));

% set(gca,'Xdir','reverse')

title(['FIG 5-5. Variation of params. w/r/t the pressure ratio @ MR = ' num2str(mixture_ratios(i))]);
xlabel('Pressure ratio, p1/p2');
set(get(ax(1), 'Ylabel'), 'String', 'Specific impulse, sec');
set(get(ax(2), 'Ylabel'), 'String', 'Temperature, K');
legend('Isp (frozen)', 'Isp (shifting)', 'Exit T. (frozen)', 'Exit T. (shifting)', 'Location', 'north');

%% Figure 5-6. Composition w/r/t the pressure ratio @ a given mixture ratio
figure(9)

mr_number = 2;
for i=1:num_of_pressure_ratios
    for j=1:num_of_components
        gas_composition(i,j) = data(row_offset + (mr_number-1)*num_of_rows + (13 + num_of_components + j), col_offset + i) * 100;
    end
end

for j=1:num_of_components
    plot(pressure_ratios, gas_composition(:,j), 'DisplayName', component_ID(components(j),:));
    hold on;
end
grid on;
hold off;
set(gca,'Xdir','reverse','xscale','log','Xlim',[2 1000]);

title(['FIG 5-6(a). Composition w/r/t the pressure ratio @p_1 = 1000psia, MR = ' num2str(mixture_ratios(mr_number))]);
xlabel('Pressure ratio, p1/p2');
ylabel('Composition, mole percent');
legend(gca,'show','Location','east');

%% Figure 5-6. Composition w/r/t the pressure ratio @ a given mixture ratio (w/o H2O)
figure(10)

mr_number = 2;
for i=1:num_of_pressure_ratios
    for j=1:num_of_components
        gas_composition(i,j) = data(row_offset + (mr_number-1)*num_of_rows + (13 + num_of_components + j), col_offset + i) * 100;
    end
end

for j=1:num_of_components
    if (components(j)~=5)
        plot(pressure_ratios, gas_composition(:,j), 'DisplayName', component_ID(components(j),:));
        hold on;
    end
end
grid on;
hold off;
set(gca,'Xdir','reverse','xscale','log','Xlim',[2 1000]);

title(['FIG 5-6(b). Composition w/r/t the pressure ratio @p_1 = 1000psia, MR = ' num2str(mixture_ratios(mr_number))]);
xlabel('Pressure ratio, p1/p2');
ylabel('Composition, mole percent');
legend(gca,'show','Location','east');
