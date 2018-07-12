function PlotParameterEstimationResults( exp_ref, fitting_protocols, prediction_protocols, model )

addpath ../../SharedFunctions/
addpath ../../SharedFunctions/Models/

if nargin == 3
    model = 'hh';
end
seed = '30082148';

data_fig = figure;

% Get number of protocols used in the fitting process
num_fit = length( fitting_protocols );
num_pred = length( prediction_protocols );

max_num_plots = max( num_fit, num_pred );

% load parameters for fit
% fitting_protocol = fitting_protocols{ 1 };
% l = 1;
% while l < num_fit
%     l = l+1;
%     fitting_protocol = [ fitting_protocol '_' fitting_protocols{ l } ];
% end

for pr = 1 : num_fit
    
    protocol = fitting_protocols{ pr };
    % Simulate data
    [ ~, I, ~, ~, ~, ~, V, ~, time, ~ ] = CalculateVariables( protocol, exp_ref, fitting_protocols );

    % load experimental data
    I_exp = importdata([ '../ExperimentalData/' exp_ref '/' protocol '_',exp_ref,'_dofetilide_subtracted_leak_subtracted.mat']);
        
    % get indices for spike removal
    idx = GetNoSpikeIdx( protocol, length( time ) );
    
    % plot data
    subplot( 2, max_num_plots, pr )
    plot( time( idx ), I_exp( idx ), 'r' );
    hold on
    plot( time( idx ), I( idx ), 'b' )
    
    xlabel( 'Time (ms)' );
    ylabel( 'Current (nA)' );
    title( protocol, 'Interpreter', 'None' )
    
end

for pr = 1 : num_pred
    protocol = prediction_protocols{ pr };
    % Simulate data
    [ ~, I, ~, ~, ~, ~, ~, ~, time, ~ ] = CalculateVariables( protocol, exp_ref, fitting_protocols );
    % load experimental data
    I_exp = importdata([ '../ExperimentalData/' exp_ref '/' protocol '_',exp_ref,'_dofetilide_subtracted_leak_subtracted.mat']);
        
    % get indices for spike removal
    idx = GetNoSpikeIdx( protocol, length( time ) );
    
    % plot data
    subplot( 2, max_num_plots, max_num_plots + pr )
    plot( time( idx ), I_exp( idx ), 'r' );
    hold on
    plot( time( idx ), I( idx ), 'b' )
    
    xlabel( 'Time (ms)' );
    ylabel( 'Current (nA)' );
    title( protocol, 'Interpreter', 'None' )
    
end

end