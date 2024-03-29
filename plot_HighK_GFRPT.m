% Plot simulation results from driver_multiday.m

clear all;

%% load data
%f1 = './MultiDaySim/22-Oct-2023_driver_multiday_insulin-1_Kamt_meal-104_TGFeff-1_alphaTGF-0.11694_etaPTKreab-0.67_ndays-50_notes-baseline.mat';
% New no effect
f1 = './MultiDaySim/15-Jan-2024_driver_multiday_insulin-1_Kamt_meal-104_TGFeff-0_alphaTGF-0.11694_etaPTKreab-0.36_ndays-50_notes-noPTTGF.mat';  %'./MultiDaySim/22-Nov-2023_driver_multiday_insulin-1_Kamt_meal-104_TGFeff-0_alphaTGF-0.11694_etaPTKreab-0.67_ndays-50_notes-noeffect_new.mat';
f2 = './MultiDaySim/15-Jan-2024_driver_multiday_insulin-1_Kamt_meal-104_TGFeff-1_alphaTGF-0.11694_etaPTKreab-0.36_ndays-50_notes-PTTGF.mat'; %'./MultiDaySim/22-Oct-2023_driver_multiday_insulin-1_Kamt_meal-104_TGFeff-1_alphaTGF-0.11694_etaPTKreab-0.36_ndays-50_notes-TongHighK.mat';
f3 = './MultiDaySim/15-Jan-2024_driver_multiday_insulin-1_Kamt_meal-104_TGFeff-3_alphaTGF-0.11694_etaPTKreab-0.36_ndays-50_notes-PTonly.mat'; %'./MultiDaySim/22-Oct-2023_driver_multiday_insulin-1_Kamt_meal-104_TGFeff-3_alphaTGF-0.11694_etaPTKreab-0.36_ndays-50_notes-PTonly.mat';
f4 = './MultiDaySim/15-Jan-2024_driver_multiday_insulin-1_Kamt_meal-26_TGFeff-0_alphaTGF-0.11694_etaPTKreab-0.36_ndays-50_notes-control.mat'; %'./MultiDaySim/22-Oct-2023_driver_multiday_insulin-1_Kamt_meal-26_TGFeff-3_alphaTGF-0.11694_etaPTKreab-0.67_ndays-50_notes-control.mat';


% NOTE: TGF only is exactly the same as "no effect"
%f4 = './MultiDaySim/22-Oct-2023_driver_multiday_insulin-1_Kamt_meal-104_TGFeff-2_alphaTGF-0.11694_etaPTKreab-0.36_ndays-50_notes-GFRonly.mat';
% New TGF only
%f4 = './MultiDaySim/22-Nov-2023_driver_multiday_insulin-1_Kamt_meal-104_TGFeff-2_alphaTGF-0.11694_etaPTKreab-0.67_ndays-50_notes-newTGFonly.mat';


dat1 = load(f1);
dat2 = load(f2);
dat3 = load(f3);
dat4 = load(f4);
%dat5 = load(f5);


lab1 = 'High K^+ - no PT/TGF effect';
lab2 = 'High K^+ - PT + TGF effects';
lab3 = 'High K^+ - only PT effect'; 
lab4 = 'Control K^+'; %'High K^+ - only TGF effect';
%lab5 = 'Control K^+';

%% All the days
T_all1 = []; Y_all1 = [];
T_all2 = []; Y_all2 = [];
T_all3 = []; Y_all3 = [];
T_all4 = []; Y_all4 = [];
%T_all5 = []; Y_all5 = [];
for ii = 1:dat1.n_days
    temp = dat1.Tvals{ii}./60 + (24)*(ii - 1);
    T_all1 = [T_all1; temp];
    Y_all1 = [Y_all1; dat1.Yvals{ii}];
    temp = dat2.Tvals{ii}./60 + 24*(ii - 1);
    T_all2 = [T_all2; temp];
    Y_all2 = [Y_all2; dat2.Yvals{ii}];
    temp = dat3.Tvals{ii}./60 + 24 * (ii - 1);
    T_all3 = [T_all3; temp];
    Y_all3 = [Y_all3; dat3.Yvals{ii}];
    temp = dat4.Tvals{ii}./60 + 24 * (ii - 1);
    T_all4 = [T_all4; temp];
    Y_all4 = [Y_all4; dat4.Yvals{ii}];
%     temp = dat5.Tvals{ii}./60 + 24 * (ii - 1);
%     T_all5 = [T_all5; temp];
%     Y_all5 = [Y_all5; dat5.Yvals{ii}];
end
% convert to days
T_all1 = T_all1./24; T_all2 = T_all2./24; 
T_all3 = T_all3./24; T_all4 = T_all4./24;
% T_all5 = T_all5./24;

%% Make figures
figure(2)
clf;
nr = 1; nc = 2;
f.labs = 18; f.xlab = 18; f.ylab = 18; f.gca = 18; f.leg = 16; f.title = 22;
lw = 3; lwgray = 4.5; lsgray = ':';
ls1 = '-'; ls2 = '-'; ls3 = '-'; ls4 = '-'; ls5 = '-';
cmap = parula(3);
cmap2 = spring(3);
c1 = cmap2(1,:); c2 = cmap(1,:); 
c3 = cmap(2,:);c4 = cmap2(2,:);
%c4 = cmap(3,:);%c5 = cmap2(2,:);
cgraymap = gray(6);
cgray = cgraymap(1,:);
subplot(nr,nc,1)
hold on
plot(T_all1,Y_all1(:,2)/dat1.pars.V_plasma, 'linewidth',lw,'linestyle', ls1, 'color',c1)
plot(T_all2,Y_all2(:,2)/dat2.pars.V_plasma, 'linewidth',lw,'linestyle', ls2, 'color',c2)
plot(T_all3,Y_all3(:,2)/dat3.pars.V_plasma, 'linewidth',lw,'linestyle', ls3, 'color',c3)
plot(T_all4,Y_all4(:,2)/dat4.pars.V_plasma, 'linewidth',lw,'linestyle', ls4, 'color',c4)
%plot(T_all5,Y_all5(:,2)/dat5.pars.V_plasma, 'linewidth',lw,'linestyle', ls5, 'color',c5)
yline(3.5,'color',cgray,'linestyle',lsgray, 'linewidth', lwgray)
yline(5.0,'color',cgray,'linestyle',lsgray, 'linewidth', lwgray)
set(gca, 'fontsize', f.gca)
xlabel('Time (days)', 'fontsize', f.xlab)
ylabel('Plasma [K^+] (mmol/L)', 'fontsize', f.ylab)
ylim([3.4,8.5])
%title('Plasma [K^+]', 'fontsize', f.title)
grid on
legend({lab1, lab2,lab3,lab4}, 'fontsize', f.leg, 'location', 'northwest')
%legend({lab1, lab2,lab3,lab4,lab5}, 'fontsize', f.leg, 'location', 'northwest')

subplot(nr,nc,2)
hold on
plot(T_all1,Y_all1(:,4)/dat1.pars.V_muscle,'linewidth',lw,'linestyle', ls1, 'color',c1)
plot(T_all2,Y_all2(:,4)/dat2.pars.V_muscle,'linewidth',lw,'linestyle', ls2, 'color',c2)
plot(T_all3,Y_all3(:,4)/dat3.pars.V_muscle,'linewidth',lw,'linestyle', ls3, 'color',c3)
plot(T_all4,Y_all4(:,4)/dat4.pars.V_muscle,'linewidth',lw,'linestyle', ls4, 'color',c4)
%plot(T_all5,Y_all5(:,4)/dat5.pars.V_muscle,'linewidth',lw,'linestyle', ls5, 'color',c5)
yline(120,'color',cgray,'linestyle',lsgray, 'linewidth', lwgray)
yline(140,'color',cgray,'linestyle',lsgray, 'linewidth', lwgray)
set(gca, 'fontsize', f.gca)
ylim([115,280])
xlabel('Time (days)', 'fontsize', f.xlab)
ylabel('Intracellular [K^+] (mmol/L)', 'fontsize', f.ylab)
%title('Intracellular [K^+]', 'fontsize', f.title)
grid on

%legend({lab1, lab2,lab3,lab4,lab5}, 'fontsize', f.leg, 'location', 'northwest')
legend({lab1, lab2,lab3,lab4}, 'fontsize', f.leg, 'location', 'northwest')

AddLetters2Plots(figure(2), {'(A)', '(B)'},...
                'HShift', -0.05, 'VShift', -0.06, ...
                'fontsize', f.labs)
%% plasma K only (zoomed)
figure(10)
clf;
hold on
plot(T_all1,Y_all1(:,2)/dat1.pars.V_plasma, 'linewidth',lw,'linestyle', ls1, 'color',c1)
plot(T_all2,Y_all2(:,2)/dat2.pars.V_plasma, 'linewidth',lw,'linestyle', ls2, 'color',c2)
plot(T_all3,Y_all3(:,2)/dat3.pars.V_plasma, 'linewidth',lw,'linestyle', ls3, 'color',c3)
plot(T_all4,Y_all4(:,2)/dat4.pars.V_plasma, 'linewidth',lw,'linestyle', ls4, 'color',c4)
%plot(T_all5,Y_all5(:,2)/dat5.pars.V_plasma, 'linewidth',lw,'linestyle', ls5, 'color',c5)
yline(3.5,'color',cgray,'linestyle',lsgray, 'linewidth', lwgray)
yline(5.0,'color',cgray,'linestyle',lsgray, 'linewidth', lwgray)
set(gca, 'fontsize', f.gca)
xlabel('Time (days)', 'fontsize', f.xlab)
ylabel('Plasma [K^+] (mmol/L)', 'fontsize', f.ylab)
title('Plasma [K^+]', 'fontsize', f.title)
xlim([40,50])
grid on

%legend({lab1, lab2,lab3,lab4,lab5}, 'fontsize', f.leg, 'location', 'northwestoutside')
legend({lab1, lab2,lab3,lab4}, 'fontsize', f.leg, 'location', 'northwestoutside')