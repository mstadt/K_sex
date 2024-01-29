function pars = set_params(sex)
% this file sets the current parameter values 
%% K intake at SS
if sex == 0  % male
    pars.Phi_Kin_ss        = 70/1440; %mEq/min, steady state for Phi_Kin (Preston 2015)
else  % female, 87% of male
    pars.Phi_Kin_ss        = 0.87 * 70/1440; %mEq/min, 
%     pars.Phi_Kin_ss        = 0.92 * 70/1440; %mEq/min, https://www.sciencedirect.com/science/article/pii/S0828282X15004766#sec2
end
pars.t_insulin_ss      = 270; % ss t_insulin value

%% gut parameters
pars.fecal_excretion = 0.1;
pars.kgut = 0.01;
pars.MKgutSS = (0.9*pars.Phi_Kin_ss)/pars.kgut;
%% volumes
if sex == 0  % male
    pars.V_plasma          = 4.5; %plasma fluid volume (L)
    pars.V_interstitial    = 10; % interstitial ECF volume (L)
    pars.V_muscle          = 24; %19.0; % intracellular fluid volume (L)
else
    pars.V_plasma          = 3.8; %plasma fluid volume (L), assume 170/200 F-to-M weight ratio
    pars.V_interstitial    = 8.5; % interstitial ECF volume (L)
    pars.V_muscle          = 17.3; %19.0; % intracellular fluid volume (L), F muscle mass as percentage of body mass is 85% of men
                                   %so 24 x .85 x 170/200 = 17.3
end

%% baseline concentrations
Kecf_baseline      = 4.3;% baseline ECF K concentration (total) mEq/L
pars.Kecf_total    = 4.2;
pars.P_ECF             = 0.3; % this parameter will have to be fit I think

pars.Kmuscle_baseline       = 130; % baseline muscle concentration mEq/L
%% NKA activity values
pars.Vmax              = 130;% mmol/min Cheng 2013
pars.Km                = 1.4; % mmol/L (Cheng 2013 gives between 0.8 and 1.5)

%% compute permeability values
NKA_baseline = pars.Vmax*Kecf_baseline/(pars.Km + Kecf_baseline);
pars.P_muscle = (NKA_baseline)/(pars.Kmuscle_baseline - Kecf_baseline);


%% Kidney
if sex == 0  % male
    pars.GFR_base   = 0.125; %baseline GFR L/min
else  % female
    pars.GFR_base   = 0.0963; %77% of men
end

if sex == 0  % male, total 92%
    pars.eta_ptKreab_base = 0.67; % fractional PT K reabsorption baseline
    pars.eta_LoHKreab = 0.25; % fractional LoH K reabsorption, fixed
else  % female, total 90.8%
    pars.eta_ptKreab_base = 0.55; % fractional PT K reabsorption baseline
    pars.eta_LoHKreab = 0.358; % fractional LoH K reabsorption, fixed
end

if sex == 0  % male
    pars.dtKsec_eq = 0.041;
else
    pars.dtKsec_eq = 0.017;  % 0.041(male value) * 0.042/0.0781 * .77
end

pars.A_dtKsec = 0.3475;
pars.B_dtKsec = 0.23792;
if sex == 1  % female, adjust for different baseline ALD
    pars.A_dtKsec = pars.A_dtKsec*(85/69.2)^pars.B_dtKsec;
end

if sex == 0  % male
    pars.cdKsec_eq = 0.0022;
else
    pars.cdKsec_eq = 0.00081;  % .0022*.002/.0042 *.77
end

pars.A_cdKsec = 0.161275;
pars.B_cdKsec = 0.410711;
if sex == 1  % female, adjust for different baseline ALD
    pars.A_cdKsec = pars.A_cdKsec*(85/69.2)^pars.B_cdKsec;
end

%% TGF response

GFR0 = pars.GFR_base; % baseline GFR
Tong_HighKeff = 0.29; % Reduction of GFR with high K from Tong
HighKeff_etaPT = 0.36; % fractional PT K reabsorption at high K (from Tong)
Base_etaPT = 0.67; % baseline fractional PT K reabsorption

HighKeff_etaPS = HighKeff_etaPT + pars.eta_LoHKreab; % proximal segment reabsorption (high K)
Base_etaPS = Base_etaPT + pars.eta_LoHKreab; % proximal segment reabsorption (base)
% This is baseline alpha_TGF
pars.alpha_TGF = ((1-Tong_HighKeff)*GFR0 - GFR0) / (HighKeff_etaPS - Base_etaPS);



%% parameters A and B are divided by 1000 and 100 respectively in k_reg_mod
% because otherwise, when fitting the parameters, the steps would be too small. 
if sex == 0  % male
    pars.A_cdKreab = 0.499994223625298;
else
    pars.A_cdKreab = 1.31 * 0.2381;  % 0.499994223625298*.002/.0042
end

%% ALD
if sex == 0  % male
    pars.ALD_eq = 85; % ng/L
else  % female
    pars.ALD_eq = 69.2; % ng/L
end

% pars.T_al = 60; % ALD half life (min)
% pars.Csod = 144; % sodium concentration mEq/L
% pars.xi_par = 2; %lower xi_pars makes C_al less sensitive

pars.m_K_ALDO = 0.5; %951.2/1000; % adjust for mL to L

%% effects
pars.FF = 0.250274; 

pars.A_insulin = 1.11;
end %set_params