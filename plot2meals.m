% Plots 3 outputs from driverMeal.m with compute_vars output
% Choose MealOnly, KCl Only and Meal + KCl to show the 3 Preston
% experiments

clear all;
%---------------------
% Begin user input
%---------------------
% File names where simulation results are stored
f1 = './MealSim/29-Jan-2024_driverMeal_insulin-1_Kin-35_sex-0_notes-male.mat';
lab1 = 'Male'; % label for figures


% KCl Only simulation results
f2 = './MealSim/29-Jan-2024_driverMeal_insulin-1_Kin-35_sex-1_notes-female.mat';
lab2 = 'Female'; % label for figures

%----------------------
% End user input
%----------------------


%% Load Data
dat1 = load(f1);
dat2 = load(f2);



%% make figures
fprintf('making figures \n')
% figure specs
lw = 3;
f.xlab = 20; f.ylab = 20; f.title = 22;
f.leg = 16; f.gca = 16; f.figlab = 18;
cmap = parula(4);
c1 = cmap(1,:);
c2 = cmap(3,:);
ls1 = '-'; ls2 = ':';
cgraymap = gray(5);
cgray = cgraymap(3,:);
lwgray = 2; lsgray = '--';
leglabs = {lab1, lab2};
xlims = [-6, 10];
xtickvals = -6:2:10;

% time in hours
meal_start = 6;
t1_hrs = dat1.t/60 - meal_start;
t2_hrs = dat2.t/60 - meal_start;

%% concentrations
figure(1)
clf
nrows = 1; ncols  = 3;
subplot(nrows,ncols,1)
hold on
plot(t1_hrs,dat1.y(:,2)/dat1.pars.V_plasma,'linewidth',lw,'color',c1, 'linestyle',ls1)
plot(t2_hrs,dat2.y(:,2)/dat2.pars.V_plasma,'linewidth',lw,'color',c2, 'linestyle',ls2)
yline(3.5,'color',cgray,'linestyle',lsgray, 'linewidth', lwgray)
yline(5.0,'color',cgray,'linestyle',lsgray, 'linewidth', lwgray)
set(gca, 'fontsize',f.gca)
ylabel('[K^+]_{plasma}', 'fontsize', f.ylab)
xlabel('time (hours)', 'fontsize', f.xlab)
xlim(xlims)
xticks(xtickvals)
yticks(3.5:0.25:5.0)
title('Plasma [K^+]', 'fontsize', f.title)
grid on
legend(leglabs, 'fontsize', f.leg)

subplot(nrows,ncols,2)
hold on
plot(t1_hrs,dat1.y(:,3)/dat1.pars.V_interstitial,'linewidth',lw,'color',c1, 'linestyle',ls1)
plot(t2_hrs,dat2.y(:,3)/dat2.pars.V_interstitial,'linewidth',lw,'color',c2, 'linestyle',ls2)
yline(3.5,'color',cgray,'linestyle',lsgray, 'linewidth', lwgray)
yline(5.0,'color',cgray,'linestyle',lsgray, 'linewidth', lwgray)
ylabel('[K^+]_{inter}', 'fontsize', f.ylab)
xlabel('time (hours)', 'fontsize', f.xlab)
set(gca, 'fontsize',f.gca)
xlim(xlims)
xticks(xtickvals)
yticks(3.5:0.25:5.0)
title('Interstitial [K^+]', 'fontsize', f.title)
grid on
legend(leglabs, 'fontsize', f.leg)

subplot(nrows,ncols,3)
hold on
plot(t1_hrs,dat1.y(:,4)/dat1.pars.V_muscle,'linewidth',lw,'color',c1, 'linestyle',ls1)
plot(t2_hrs,dat2.y(:,4)/dat2.pars.V_muscle,'linewidth',lw,'color',c2, 'linestyle',ls2)
yline(120,'color',cgray,'linestyle',lsgray, 'linewidth', lwgray)
yline(140,'color',cgray,'linestyle',lsgray, 'linewidth', lwgray)
set(gca, 'fontsize',f.gca)
ylabel('[K^+]_{intracellular}', 'fontsize', f.ylab)
xlabel('time (hours)', 'fontsize', f.xlab)
xlim(xlims)
xticks(xtickvals)
title('Intracellular [K^+]', 'fontsize', f.title)
grid on
legend(leglabs, 'fontsize', f.leg)

AddLetters2Plots(figure(1), {'(a)', '(b)','(c)'},...
                'HShift', -0.05, 'VShift', -0.06, ...
                'fontsize', f.figlab)

%% variables
figure(2)
clf
nrows = 2; ncols  = 3;
subplot(nrows,ncols,1)
hold on
plot(t1_hrs,dat1.y(:,1),'linewidth',lw,'color',c1, 'linestyle',ls1)
plot(t2_hrs,dat2.y(:,1),'linewidth',lw,'color',c2, 'linestyle',ls2)
set(gca, 'fontsize',f.gca)

ylabel('M_{Kgut}', 'fontsize', f.ylab)
xlabel('time (hrs)', 'fontsize', f.xlab)
title('Gut K+ amount', 'fontsize', f.title)
xlim(xlims)
grid on
legend(leglabs, 'fontsize', f.leg)

subplot(nrows,ncols,2)
hold on
plot(t1_hrs,dat1.y(:,2),'linewidth',lw,'color',c1, 'linestyle',ls1)
plot(t2_hrs,dat2.y(:,2),'linewidth',lw,'color',c2, 'linestyle',ls2)
set(gca, 'fontsize',f.gca)
ylabel('M_{Kplas}', 'fontsize', f.ylab)
xlabel('time (hrs)', 'fontsize', f.xlab)
title('Plasma K+ amount', 'fontsize', f.title)
xlim(xlims)
grid on
legend(leglabs, 'fontsize', f.leg)

subplot(nrows,ncols,3)
hold on
plot(t1_hrs,dat1.y(:,3),'linewidth',lw,'color',c1, 'linestyle',ls1)
plot(t2_hrs,dat2.y(:,3),'linewidth',lw,'color',c2, 'linestyle',ls2)
set(gca, 'fontsize',f.gca)
ylabel('M_{Kinter}', 'fontsize', f.ylab)
xlabel('time (hrs)', 'fontsize', f.xlab)
title('Interstitial K+ amount', 'fontsize', f.title)
xlim(xlims)
grid on
legend(leglabs, 'fontsize', f.leg)

subplot(nrows,ncols,4)
hold on
plot(t1_hrs,dat1.y(:,4),'linewidth',lw,'color',c1, 'linestyle',ls1)
plot(t2_hrs,dat2.y(:,4),'linewidth',lw,'color',c2, 'linestyle',ls2)
set(gca, 'fontsize',f.gca)
ylabel('M_{Kmuscle}', 'fontsize', f.ylab)
xlabel('time (hrs)', 'fontsize', f.xlab)
title('Intracellular K+ amount', 'fontsize', f.title)
xlim(xlims)
grid on
legend(leglabs, 'fontsize', f.leg)


subplot(nrows,ncols,5)
hold on
plot(t1_hrs,dat1.y(:,5),'linewidth',lw,'color',c1, 'linestyle',ls1)
plot(t2_hrs,dat2.y(:,5),'linewidth',lw,'color',c2, 'linestyle',ls2)
set(gca, 'fontsize',f.gca)
ylabel('N_{al}', 'fontsize', f.ylab)
xlabel('time (hrs)', 'fontsize', f.xlab)
title('Normalized ALD', 'fontsize', f.title)
xlim(xlims)
grid on
legend(leglabs, 'fontsize', f.leg)

subplot(nrows,ncols,6)
hold on
plot(t1_hrs,dat1.y(:,5)*dat1.pars.ALD_eq,'linewidth',lw,'color',c1, 'linestyle',ls1)
plot(t2_hrs,dat2.y(:,5)*dat2.pars.ALD_eq,'linewidth',lw,'color',c2, 'linestyle',ls2)
set(gca, 'fontsize',f.gca)
ylabel('C_{al}', 'fontsize', f.ylab)
xlabel('time (hrs)', 'fontsize', f.xlab)
title('ALD', 'fontsize', f.title)
xlim(xlims)
grid on
legend(leglabs, 'fontsize', f.leg)




