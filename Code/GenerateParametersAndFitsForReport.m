function GenerateParametersAndFitsForReport( model, fitting_protocols, exp_ref, comparison_protocols )

if~isdir('Output')
    mkdir( 'Output/' )
end

fitting_protocol = fitting_protocols{ 1 };
for pr = 2 : length( fitting_protocols )
    fitting_protocol = [ fitting_protocol '_' fitting_protocols{ pr } ];
end

num_comparisons = length( comparison_protocols );

% Get the best fit parameters
[chain,likelihood] = FindingBestFitsAfterMCMC(model,fitting_protocols,exp_ref);
[~,v]= max(likelihood);
params = chain(v,:);

% write parameters out, separated by & for copying into latex table

param_file = fopen( [ 'Output/ParameterFile_' model '_' fitting_protocol '.txt' ], 'w' );
fprintf( param_file, '%1.6f ',  params( end ) ); % conductance first
fprintf( param_file, '& %1.6f ',  params( 1 : 8 ) );
fprintf( param_file, '\n' );
fclose( param_file );

% Run the simulations:
for comp = 1 : num_comparisons
    
    [ ~, I, ~, ~, ~, ~, ~, ~, time, ~ ] ...
                    = CalculateVariables( comparison_protocols{ comp }, exp_ref, fitting_protocol, model );
    [ discrepancy, exp_data ] = CalculateDiscrepancy( exp_ref, comparison_protocols{ comp }, I );
    idx = GetNoSpikeIdx( comparison_protocols{ comp }, length( I ) );
    rmse = sqrt( sum( discrepancy( idx ).^2  )/length( idx ) );
    % save the data:
    save( [ 'Output/Data_' model '_' exp_ref  '_FP_' fitting_protocol '_CP_' comparison_protocols{ comp } '.mat' ], 'I', 'time', 'discrepancy', 'exp_data', 'rmse'  )
    
end

end