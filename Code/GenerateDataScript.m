% Comparison of different fitting protocols:
comparison_protocols = {'sine_wave', 'ap', 'equal_proportions', 'maz_wang_div_diff', 'original_sine' };

GenerateParametersAndFitsForReport( 'hh', {'sine_wave'}, '16713110', comparison_protocols ) 
GenerateParametersAndFitsForReport( 'hh', {'ap'}, '16713110', comparison_protocols ) 
GenerateParametersAndFitsForReport( 'hh', {'equal_proportions'}, '16713110', comparison_protocols ) 
GenerateParametersAndFitsForReport( 'hh', {'maz_wang_div_diff'}, '16713110', comparison_protocols ) 
GenerateParametersAndFitsForReport( 'hh', {'original_sine'}, '16713110', comparison_protocols ) 
% combo protocols
GenerateParametersAndFitsForReport( 'hh', {'ap','sine_wave'}, '16713110', comparison_protocols ) 
GenerateParametersAndFitsForReport( 'hh', {'ap','equal_proportions'}, '16713110', comparison_protocols ) 
GenerateParametersAndFitsForReport( 'hh', {'sine_wave','original_sine'}, '16713110', comparison_protocols ) 

% Comparison of diferent model structures
GenerateParametersAndFitsForReport( 'mh', {'sine_wave_wang'}, '16713110', {'sine_wave_wang', 'ap_wang' } ) 

GenerateParametersAndFitsForReport( 'mh', {'sine_wave'}, '16713110', {'sine_wave', 'ap' } ) 
GenerateParametersAndFitsForReport( 'm2h', {'sine_wave'}, '16713110', {'sine_wave', 'ap' } ) 
GenerateParametersAndFitsForReport( 'm3h', {'sine_wave'}, '16713110', {'sine_wave', 'ap' } ) 
GenerateParametersAndFitsForReport( 'm4h', {'sine_wave'}, '16713110', {'sine_wave', 'ap' } ) 
GenerateParametersAndFitsForReport( 'm2h2', {'sine_wave'}, '16713110', {'sine_wave', 'ap' } ) 