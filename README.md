# Fitting algorithm from Sine Wave paper

This repository contains files used forfitting a model to experimental data. This project is built on the work of [Beattie et al](https://physoc.onlinelibrary.wiley.com/doi/abs/10.1113/JP275733), whose repository is available [here](https://github.com/mirams/sine-wave). To use this code you will need to add the [SharedFunctions repository](https://github.com/JohnWalmsley/SharedFunctions) and its sub-folders to your Matlab path. The major difference between this code and the [sine-wave](https://github.com/mirams/sine-wave) fitting code is that this code allows a model to be fit to data from multiple protocols simultaneously. Most files have been copied and lightly modified from that repository.

## CMAESFullSearchResults

Output folder for results of [FullGlobalSearch.m](Code/FullGlobalSearch.m).

## Code

#### Subroutines

[AdaptiveMCMCStartingBestCMAES.m](Code/AdaptiveMCMCStartingBestCMAES.m):

[CheckingRanges.m](Code/CheckingRanges.m):

[FindingBestFits.m](Code/FindingBestFits.m):

[FindingBestFitsAfterMCMC.m](Code/FindingBestFitsAfterMCMC.m):

[FullGlobalSearch.m](Code/FullGlobalSearch.m):

[objective_without_capacitance.m](Code/objective_without_capacitance.m):

[objective_without_capacitance_mcmc.m](Code/objective_without_capacitance_mcmc.m):

All of these files are as described in the [sine-wave](https://github.com/mirams/sine-wave) repository. The major difference is that they now take in a cell containing one or more fitting protocols in the place of a single fitting protocol as a string, for example `fitting_protocols = { 'ap', 'sine_wave' }`. Some files have also been adapted to work with additional models using [MexMh.c](https://github.com/JohnWalmsley/SharedFunctions/Models/MexMH.c). These models are `'mh'`, `'m2h'`, `'m3h'`, `'m4h'`, `'m2h2'`.

#### Running a fit

[RunParameterEstimation.m](Code/RunParameterEstimation.m): Run script for the parameter estimation process. Calls [FullGlobalSearch.m](Code/FullGlobalSearch.m), followed by [AdaptiveMCMCStartingBestCMAES.m](Code/AdaptiveMCMCStartingBestCMAES.m). Inputs:

1. Cell identifier `exp_ref` (string)
1. Protocol to fit to `protocol` (Cell)
1. model description `model` (string)

For example, `RunParameterEstimation( '16713110', { 'ap', 'sine_wave' }, 'hh' )` would fit the HH model to both the AP and the Sine Wave protocol data for cell 5. `RunParameterEstimation( '16713110', { 'sine_wave_wang' }, 'm3h' )` would fit an m^3h model to the data from the Wang model when it was fitted to the sine wave protocol for cell 5.

The random number generator seed is hard-coded to be the same as for cell 5 in the [sine-wave repository](https://github.com/mirams/sine-wave).


#### Plotting

[PlotParameterEstimationResults.m](Code/PlotParameterEstimationResults.m): Plots the results of a parameter fit for the fitting protocols, and any desired prediction protocols. Loads results of a fit performed using [RunParameterEstimation.m](Code/RunParameterEstimation.m). Input:

1. Cell identifier `exp_ref` (string)
1. Protocols used when fitting `fitting_protocols` (Cell)
1. Protocols for prediction `prediction_protocols` (Cell)
1. model description `model` (string)

Fitting protocols are shown on the top row, and prediction protocols are shown on the bottom row. The simulation using the fitted parameters and the experimental data for the cell are shown in each case. For example, 
```
PlotParameterEstimationResults( '16713110', {'ap', 'sine_wave' }, {'equal_proportions', 'original_sine', 'maz_wang_div_diff'}, 'hh')
```
would plot the AP and the Sine Wave simulations and experiments on the top row, and the equal proportions, original sine, and maz wang div diff simulations and experiments on the bottom row for cell 5. The parameters used would have been fitted to both the AP and the Sine Wave protocols for cell 5.

## ExperimentalData
[ExperimentalData](ExperimentalData/): Contains the experimental data used by [Beattie et al](https://physoc.onlinelibrary.wiley.com/doi/abs/10.1113/JP275733) and available in the [sine-wave repository](https://github.com/mirams/sine-wave). Includes additional processed files from [Kylie-Sine-Wave-Data](https://github.com/JohnWalmsley/Kylie-Sine-Wave-Data). Furthermore, contains files to allow fitting to simulated data for cell `'16713110'`, namely `'sine_wave_hh_16713110_dofetilide_subtracted_leak_subtracted.mat'` and `'sine_wave_wang_16713110_dofetilide_subtracted_leak_subtracted.mat'`. These files contain the simulation saved in the same format as the experimental data.

## MCMCResults

Output folder for results of [AdaptiveMCMCStartingBestCMAES.m](Code/AdaptiveMCMCStartingBestCMAES.m). Contains the MCMC chain, the likelihood for each entry in the chain, and the acceptance rate along the chain.

## ParameterSets

Baseline model parameter sets. Rarely used in this study except by [modeldata.m](https://github.com/JohnWalmsley/SharedFunctions/blob/master/modeldata.m). Additionally contains the [parameter set](ParameterSets/WangModelSineWaveSimulatedParameters.mat) used to generate the Wang model fitted to the sine wave protocol, as used for fitting the model to the data.

## Protocols

[Protocols](Protocols/): Contains a `.mat` file for each pacing protocol. Includes the additional protocols from [Kylie-Sine-Wave-Data](https://github.com/JohnWalmsley/Kylie-Sine-Wave-Data), the lag protocols generated using [CalculateImposedVoltage.m](https://github.com/JohnWalmsley/SharedFunctions/CalculateImposedVoltage.m), and two duplicated protocols for fitting to model generated data ([sine_wave_wang_protocol.mat](Protocols/sine_wave_wang_protocol.mat) and [sine_wave_hh_protocol.mat](Protocols/sine_wave_hh_protocol.mat)). These are the same as [sine_wave_protocol.mat](Protocols/sine_wave_protocol.mat), except for their file names.
