function [SS, exitflag, residual] = getSS(IC, sex, params, varargin)
    
    % default settings, varargin is used to change settings
    do_figs    = false;
    do_insulin = true;
    do_FF      = true;
    MKX        = 0; MKXslope = 0;
    alt_sim    = false; % use alternate equations
    for i = 1:2:length(varargin)
        temp = varargin{i+1};
        if strcmp(varargin{i}, 'alt_sim')
            alt_sim = temp;
        elseif strcmp(varargin{i}, 'do_MKX')
            MKX = temp(1);
            MKXslope = temp(2);
        elseif strcmp(varargin{i}, 'do_insulin')
            do_insulin = temp(1);
        elseif strcmp(varargin{i}, 'do_FF')
            do_FF = temp(1);
        elseif strcmp(varargin{i}, 'do_figs')
            do_figs = temp(1);
        else
            disp('WRONG VARARGIN INPUT')
            fprintf('What is this varargin input? %s \n', varargin{i})
            error('wrong varargin input')
        end % if
    end %for


    % ODE options
    tspan = [0 4000];
    options = odeset('RelTol',1.0e-6,'AbsTol',1e-9);

    %% solve ODE system
    %fprintf('solving ODEs \n')
    [t,y] = ode15s(@(t,y) kreg_eqns(t,y,sex,params,...
                                'SS', true, ...
                                'alt_sim', alt_sim,...
                                'do_MKX', [MKX, MKXslope],...
                                'do_insulin', do_insulin,...
                                'do_FF', do_FF), ...
                                tspan, IC, options);


    if do_figs
        %% make figures
        fprintf('making figures \n')
        % figure specs
        lw = 3;
        f.xlab = 16; f.ylab = 16; f.title = 18;
        cmap = parula(5);
        c1 = cmap(3,:);
        cgraymap = gray(5);
        cgray = cgraymap(3,:);
        lwgray = 2; lsgray = '--';
        
        % variables
        figure(1)
        clf
        nrows = 2; ncols  = 3;
        subplot(nrows,ncols,1)
        plot(t,y(:,1),'linewidth',lw,'color',c1)
        ylabel('M_{Kgut}', 'fontsize', f.ylab)
        xlabel('t', 'fontsize', f.xlab)
        title('Gut K', 'fontsize', f.title)
        grid on
        % Get the current y-axis limits
        yLimits = ylim;
        % Calculate the difference between the maximum and minimum
        yDiff = diff(yLimits);
        % If the difference is less than 1, adjust the maximum limit
        if yDiff < 1
        % Set the new y-axis limits
            ylim([yLimits(1) yLimits(1)+1]);
        end
        
        subplot(nrows,ncols,2)
        plot(t,y(:,2),'linewidth',lw,'color',c1)
        ylabel('M_{Kplas}', 'fontsize', f.ylab)
        xlabel('t', 'fontsize', f.xlab)
        title('Plasma K', 'fontsize', f.title)
        grid on
        yLimits = ylim;
        yDiff = diff(yLimits);
        if yDiff < 1
            ylim([yLimits(1) - 0.5 yLimits(1)+0.5])
        end

        
        subplot(nrows,ncols,3)
        plot(t,y(:,3),'linewidth',lw,'color',c1)
        ylabel('M_{Kinter}', 'fontsize', f.ylab)
        xlabel('t', 'fontsize', f.xlab)
        title('Interstitial K', 'fontsize', f.title)
        grid on
        yLimits = ylim;
        yDiff = diff(yLimits);
        if yDiff < 1
            ylim([yLimits(1) - 0.5 yLimits(1)+0.5])
        end

        
        subplot(nrows,ncols,4)
        plot(t,y(:,4),'linewidth',lw,'color',c1)
        ylabel('M_{Kmuscle}', 'fontsize', f.ylab)
        xlabel('t', 'fontsize', f.xlab)
        title('Muscle K', 'fontsize', f.title)
        grid on
        yLimits = ylim;
        yDiff = diff(yLimits);
        if yDiff < 2
            ylim([yLimits(1) - 1 yLimits(1)+1])
        end

        subplot(nrows,ncols,5)
        plot(t,y(:,5),'linewidth',lw,'color',c1)
        ylabel('N_{al}', 'fontsize', f.ylab)
        xlabel('t', 'fontsize', f.xlab)
        title('[ALD] (normalized)', 'fontsize', f.title)
        grid on
        yLimits = ylim;
        yDiff = diff(yLimits);
        if yDiff < 1
            ylim([yLimits(1) - 0.5 yLimits(1)+0.5])
        end
        
    end
    


    %% take endpoint and make initial guess for fsolve
    fprintf('fsolve for SS \n')
    opts = optimoptions('fsolve', 'Display', 'off', 'MaxFunEvals', 10000, 'MaxIter', 10000);
    IG = y(end,:);

    [SS, residual, exitflag, output] = fsolve(@(y) kreg_eqns(0, y, sex, params, ...
                                                        'SS', true, ...
                                                        'alt_sim', alt_sim,...
                                                        'do_MKX', [MKX, MKXslope],...
                                                        'do_insulin', do_insulin,...
                                                        'do_FF', do_FF),...
                                                        IG, opts);

    
    % check between ODE and fsolve result
    fracchange = (SS - IG)./IG;
    if max(abs(fracchange)) > 0.1
        fprintf('WARNING: maximum ODE to fsolve change: %0.4f \n', max(abs(fracchange)))

        fprintf('steady states \n')
        fprintf('                ODE       fsolve \n')
        fprintf('M_Kgut       %0.4f     %0.4f \n', IG(1), SS(1))
        fprintf('M_Kplas       %0.4f     %0.4f \n', IG(2), SS(2))
        fprintf('M_Kinter       %0.4f     %0.4f \n', IG(3), SS(3))
        fprintf('M_Kmuscle       %0.4f     %0.4f \n', IG(4), SS(4))
    end

    if exitflag < 1
        fprintf('***WARNING: exitflag indicates error!***\n')
    end
    



end

    