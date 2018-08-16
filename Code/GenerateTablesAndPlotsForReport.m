function GenerateTablesAndPlotsForReport

%% Alternative fitting protocols

exp_ref = '16713110';

model = 'hh';

comparison_protocols = {'sine_wave', 'ap', 'equal_proportions', 'maz_wang_div_diff', 'original_sine' };
num_comp = length( comparison_protocols );

fitting_protocols_cell{1} = {'sine_wave'};
fitting_protocols_cell{2} = {'ap'};
fitting_protocols_cell{3} = {'equal_proportions'};
fitting_protocols_cell{4} = {'maz_wang_div_diff'};
fitting_protocols_cell{5} = {'original_sine'};
fitting_protocols_cell{6} = {'ap', 'sine_wave'};
fitting_protocols_cell{7} = {'ap', 'equal_proportions'};
fitting_protocols_cell{8} = {'sine_wave', 'original_sine'};

num_fits = length( fitting_protocols_cell );

for fits = 1 : num_fits
    
    fitting_protocols = fitting_protocols_cell{ fits };
    fitting_protocol = fitting_protocols{ 1 };
    for pr = 2 : length( fitting_protocols )
        fitting_protocol = [ fitting_protocol '_' fitting_protocols{ pr } ];
    end
    
    RMSE_vec = zeros( 1, num_comp );
    
    for comp = 1 : num_comp
        
        load( [ 'Output/Data_' model '_' exp_ref  '_FP_' fitting_protocol '_CP_' comparison_protocols{ comp } '.mat' ] );
        RMSE_vec( comp ) = rmse;
        idx = GetNoSpikeIdx( comparison_protocols{ comp }, length( I ) );
        plot_fig = figure( 'Units', 'Normalized', 'OuterPosition', [ 0 0 1 1 ] );
        plot( time( idx ), I( idx ), 'b', 'LineWidth', 2 );
        hold on; plot( time( idx ), exp_data( idx ), 'r', 'LineWidth', 2 );
        xlim( [ 0 9500 ] );
        ylim( [ -2 2 ] );
        
        if strcmp( comparison_protocols{ comp }, 'sine_wave' )
            name = 'SW';
        end
        if strcmp( comparison_protocols{ comp }, 'ap' )
            name = 'AP';
        end
        if strcmp( comparison_protocols{ comp }, 'equal_proportions' )
            name = 'EP';
        end
        if strcmp( comparison_protocols{ comp }, 'maz_wang_div_diff' )
            name = 'MWDD';
        end
        if strcmp( comparison_protocols{ comp }, 'original_sine' )
            name = 'OSW';
        end
        
        title( name );
        
        xlabel( 'Time (ms)' );
        ylabel( 'Current (nA)' );
        legend( { 'Simulation', 'Experiment'} );
        
        % Beautify plot
        set( gcf, 'Color', 'w' );
        set(findall( gcf, 'type', 'axes'), 'Box', 'off' );
        set(findall( gcf, 'type', 'axes'), 'FontName','Arial','FontSize',12,'FontWeight','Bold',  'LineWidth', 2);
        set(findall( gca, 'type', 'text'), 'FontName','Arial','FontSize',12,'FontWeight','Bold',  'LineWidth', 2);
        
        %export_fig( plot_fig, [ 'Figures/Fig_' model '_' exp_ref  '_FP_' fitting_protocol '_CP_' comparison_protocols{ comp } '.png' ], '-png' )
        
        close( plot_fig );
    end
    
    rmse_file = fopen( [ 'Output/RMSEFile_' model '_' fitting_protocol '.txt' ], 'w' );
    fprintf( rmse_file, '%1.6f ',  RMSE_vec( 1 ) ); % conductance first
    fprintf( rmse_file, '& %1.6f ',  RMSE_vec( 2 : end ) );
    fprintf( rmse_file, '\n' );
    fclose( rmse_file );
end


%% Plot the AP + SW 'zoom' figure

load( [ 'Output/Data_' model '_' exp_ref  '_FP_sine_wave_CP_ap.mat' ] );
I_sw = I;
load( [ 'Output/Data_' model '_' exp_ref  '_FP_ap_sine_wave_CP_ap.mat' ] );
I_apsw = I;

idx = GetNoSpikeIdx( 'ap', length( I ) );

plot_fig = figure( 'Units', 'Normalized', 'OuterPosition', [ 0 0 1 1 ] );
subplot(1,3,1)
plot( time(idx), I_sw( idx ), 'b--', time(idx), I_apsw( idx ), 'b-', time(idx), exp_data( idx ), 'r', 'LineWidth', 2 );
xlim( [2945 2995] );
ylim( [ 0 1.65 ] );
xlabel( 'Time (ms)' );
ylabel( 'Current (nA)' );

subplot(1,3,2)
plot( time(idx), I_sw( idx ), 'b--', time(idx), I_apsw( idx ), 'b-', time(idx), exp_data( idx ), 'r', 'LineWidth', 2 );
xlim( [5050 5100] );
ylim( [ 0 1.65 ] );
xlabel( 'Time (ms)' );
ylabel( 'Current (nA)' );

subplot(1,3,3)
plot( time(idx), I_sw( idx ), 'b--', time(idx), I_apsw( idx ), 'b-', time(idx), exp_data( idx ), 'r', 'LineWidth', 2 );
xlim( [6390 6440] );
ylim( [ 0 1.65 ] );
xlabel( 'Time (ms)' );
ylabel( 'Current (nA)' );

% Beautify plot
set( gcf, 'Color', 'w' );
set(findall( gcf, 'type', 'axes'), 'Box', 'off' );
set(findall( gcf, 'type', 'axes'), 'FontName','Arial','FontSize',12,'FontWeight','Bold',  'LineWidth', 2);
set(findall( gca, 'type', 'text'), 'FontName','Arial','FontSize',12,'FontWeight','Bold',  'LineWidth', 2);

export_fig( plot_fig, [ 'Figures/Fig_' model '_' exp_ref  '_FP_ap_sine_wave_CP_ap_zoom.png' ], '-png' )

close( plot_fig );

%% Alternative model: wang

exp_ref = '16713110';

model = 'mh';

comparison_protocols = {'sine_wave_wang', 'ap_wang' };
num_comp = length( comparison_protocols );

fitting_protocol = 'sine_wave_wang';

RMSE_vec = zeros( 1, num_comp );

% load the original data

plot_fig_sw = figure( 'Units', 'Normalized', 'OuterPosition', [ 0 0 1 1 ] );
plot_fig_sw_zoom = figure( 'Units', 'Normalized', 'OuterPosition', [ 0 0 1 1 ] );
plot_fig_ap = figure( 'Units', 'Normalized', 'OuterPosition', [ 0 0 1 1 ] );

load( [ 'Output/Data_hh_' exp_ref  '_FP_sine_wave_CP_sine_wave.mat' ] );
I_sw_beattie = I;
exp_data_sw = exp_data;
rmse_sw = rmse;

load( [ 'Output/Data_hh_' exp_ref  '_FP_sine_wave_CP_ap.mat' ] );
I_ap_beattie = I;
exp_data_ap = exp_data;
rmse_ap = rmse;

load( [ 'Output/Data_' model '_' exp_ref  '_FP_sine_wave_wang_CP_sine_wave_wang.mat' ] );
I_sw_wang = I;
exp_data_sw_wang = exp_data;
rmse_sw_wang = rmse;
time_sw = time;

load( [ 'Output/Data_' model '_' exp_ref  '_FP_sine_wave_wang_CP_ap_wang.mat' ] );
I_ap_wang = I;
exp_data_ap_wang = exp_data;
rmse_ap_wang = rmse;
time_ap = time;

% Plot the SW data
figure( plot_fig_sw );
idx = GetNoSpikeIdx( 'sine_wave', length( I_sw_wang ) );
plot( time_sw( idx ), exp_data_sw_wang( idx  ), 'r', 'LineWidth', 2.0 );
hold on
plot( time_sw( idx ), I_sw_wang( idx  ), 'b-', 'LineWidth', 2.0 );
plot( time_sw( idx ), I_sw_beattie( idx  ), 'b--', 'LineWidth', 2.0 );

xlim( [ 0 9500 ] );
ylim( [ -2 2 ] );

title( 'SW' );

xlabel( 'Time (ms)' );
ylabel( 'Current (nA)' );
legend( { 'Wang_{SW}', 'HH_{Wang}', 'Beattie et al.' } );

% Beautify plot
set( gcf, 'Color', 'w' );
set(findall( gcf, 'type', 'axes'), 'Box', 'off' );
set(findall( gcf, 'type', 'axes'), 'FontName','Arial','FontSize',12,'FontWeight','Bold',  'LineWidth', 2);
set(findall( gca, 'type', 'text'), 'FontName','Arial','FontSize',12,'FontWeight','Bold',  'LineWidth', 2);

export_fig( plot_fig_sw, [ 'Figures/Fig_mh_' exp_ref  '_FP_sine_wave_wang_CP_sine_wave_wang.png' ], '-png' )
close( plot_fig_sw );

% Plot the AP data
figure( plot_fig_ap );
idx = GetNoSpikeIdx( 'ap', length( I_sw_wang ) );
plot( time_ap( idx ), exp_data_ap_wang( idx  ), 'r', 'LineWidth', 2.0 );
hold on
plot( time_ap( idx ), I_ap_wang( idx  ), 'b-', 'LineWidth', 2.0 );
plot( time_ap( idx ), I_ap_beattie( idx  ), 'b--', 'LineWidth', 2.0 );

xlim( [ 0 9500 ] );
ylim( [ -2 2 ] );

title( 'AP' );

xlabel( 'Time (ms)' );
ylabel( 'Current (nA)' );
legend( { 'Wang_{SW}', 'HH_{Wang}', 'Beattie et al.' } );

% Beautify plot
set( gcf, 'Color', 'w' );
set(findall( gcf, 'type', 'axes'), 'Box', 'off' );
set(findall( gcf, 'type', 'axes'), 'FontName','Arial','FontSize',12,'FontWeight','Bold',  'LineWidth', 2);
set(findall( gca, 'type', 'text'), 'FontName','Arial','FontSize',12,'FontWeight','Bold',  'LineWidth', 2);

export_fig( plot_fig_ap, [ 'Figures/Fig_mh_' exp_ref  '_FP_sine_wave_wang_CP_ap_wang.png' ], '-png' )
close( plot_fig_ap );

% Plot a zoom of the sine wave fit

figure( plot_fig_sw_zoom );
idx = GetNoSpikeIdx( 'sine_wave', length( I_sw_wang ) );
plot( time_sw( idx ), exp_data_sw_wang( idx  ), 'r', 'LineWidth', 2.0 );
hold on
plot( time_sw( idx ), I_sw_wang( idx  ), 'b-', 'LineWidth', 2.0 );
plot( time_sw( idx ), I_sw_beattie( idx  ), 'b--', 'LineWidth', 2.0 );

xlim( [ 5000 6000 ] );

title( 'SW' );

xlabel( 'Time (ms)' );
ylabel( 'Current (nA)' );
legend( { 'Wang_{SW}', 'HH_{Wang}', 'Beattie et al.' } );

% Beautify plot
set( gcf, 'Color', 'w' );
set(findall( gcf, 'type', 'axes'), 'Box', 'off' );
set(findall( gcf, 'type', 'axes'), 'FontName','Arial','FontSize',12,'FontWeight','Bold',  'LineWidth', 2);
set(findall( gca, 'type', 'text'), 'FontName','Arial','FontSize',12,'FontWeight','Bold',  'LineWidth', 2);

export_fig( plot_fig_sw_zoom, [ 'Figures/Fig_mh_' exp_ref  '_FP_sine_wave_wang_CP_sine_wave_wang_zoom.png' ], '-png' )
close( plot_fig_sw_zoom );

% RMSE
RMSE_vec = [ rmse_sw rmse_ap rmse_sw_wang rmse_ap_wang ];
rmse_file = fopen( [ 'Output/RMSEFile_mh_wang.txt' ], 'w' );
fprintf( rmse_file, '%1.6f ',  RMSE_vec( 1 ) );
fprintf( rmse_file, '& %1.6f ',  RMSE_vec( 2 : end ) );
fprintf( rmse_file, '\n' );
fclose( rmse_file );

%% Plot the data for the mh model family

exp_ref = '16713110';

comparison_protocols = {'sine_wave', 'ap' };
num_comp = length( comparison_protocols );

models = {'Cell 5','mh', 'm2h', 'm3h', 'm4h', 'm2h2'};
num_models = length( models );
dash = { 'r', 'b', 'g', 'k', 'y', 'c'};

for comp = 1 : num_comp
    plot_fig = figure( 'Units', 'Normalized', 'OuterPosition', [ 0 0 1 1 ] );
    plot_fig_zoom = figure( 'Units', 'Normalized', 'OuterPosition', [ 0 0 1 1 ] );
    rmse_file = fopen( ['Output/RMSEFile_mh_' comparison_protocols{comp} '.txt'], 'w' );
    RMSE_vec = zeros( 1, num_models );
    for mod = 2 : num_models
        
        model = models{ mod };
        
        load( [ 'Output/Data_' model '_' exp_ref  '_FP_sine_wave_CP_' comparison_protocols{ comp } '.mat' ] );
        RMSE_vec( mod ) = rmse;
        idx = GetNoSpikeIdx( comparison_protocols{ comp }, length( I ) );
        
        figure(plot_fig);
        if mod == 2
            plot( time( idx ), exp_data( idx ), 'r', 'LineWidth', 2 );
        end
        hold on; 
        plot( time( idx ), I( idx ), dash{mod}, 'LineWidth', 2 );
        
        figure(plot_fig_zoom);
        if mod == 2
            plot( time( idx ), exp_data( idx ), 'r', 'LineWidth', 2 );
        end
        hold on; 
        plot( time( idx ), I( idx ), dash{mod}, 'LineWidth', 2 );
        
    end
    
    figure(plot_fig)
    xlim( [ 0 9500 ] );
    ylim( [ -2 2 ] );
    
    if strcmp( comparison_protocols{ comp }, 'sine_wave' )
        name = 'SW';
    end
    if strcmp( comparison_protocols{ comp }, 'ap' )
        name = 'AP';
    end
    title( name );
    
    xlabel( 'Time (ms)' );
    ylabel( 'Current (nA)' );
    legend( models );
    
    % Beautify plot
    set( gcf, 'Color', 'w' );
    set(findall( gcf, 'type', 'axes'), 'Box', 'off' );
    set(findall( gcf, 'type', 'axes'), 'FontName','Arial','FontSize',12,'FontWeight','Bold',  'LineWidth', 2);
    set(findall( gca, 'type', 'text'), 'FontName','Arial','FontSize',12,'FontWeight','Bold',  'LineWidth', 2);
    
    export_fig( plot_fig, [ 'Figures/Fig_mh_family_' exp_ref  '_FP_sine_Wave_CP_' comparison_protocols{ comp } '.png' ], '-png' )
    
    close( plot_fig );
    
    figure(plot_fig_zoom)
    xlim( [5000 6000 ] );
    
    if strcmp( comparison_protocols{ comp }, 'sine_wave' )
        name = 'SW';
    end
    if strcmp( comparison_protocols{ comp }, 'ap' )
        name = 'AP';
    end
    title( name );
    
    xlabel( 'Time (ms)' );
    ylabel( 'Current (nA)' );
    legend( models );
    
    % Beautify plot
    set( gcf, 'Color', 'w' );
    set(findall( gcf, 'type', 'axes'), 'Box', 'off' );
    set(findall( gcf, 'type', 'axes'), 'FontName','Arial','FontSize',12,'FontWeight','Bold',  'LineWidth', 2);
    set(findall( gca, 'type', 'text'), 'FontName','Arial','FontSize',12,'FontWeight','Bold',  'LineWidth', 2);
    
    export_fig( plot_fig_zoom, [ 'Figures/Fig_mh_family_' exp_ref  '_FP_sine_Wave_CP_' comparison_protocols{ comp } '_zoom.png' ], '-png' )
    
    close( plot_fig_zoom );
       

    fprintf( rmse_file, '%1.6f ',  RMSE_vec( 1 ) );
    fprintf( rmse_file, '& %1.6f ',  RMSE_vec( 2 : end ) );
    fprintf( rmse_file, '\n' );
    fclose( rmse_file );

end
    
