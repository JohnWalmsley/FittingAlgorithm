function RunParameterEstimation( exp_ref, protocol )
%RUNPARAMETERESTIMATION Summary of this function goes here
%   Detailed explanation goes here

addpath(genpath('../../SharedFunctions'))

seed = 30082148; % hard-coded: same seed as used in Beattie et al.

FullGlobalSearch( seed, exp_ref, protocol )
AdaptiveMCMCStartingBestCMAES( seed, exp_ref, protocol )

end
