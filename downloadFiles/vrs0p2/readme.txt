VARGPLVM software
Version 0.2		Tuesday 22 Nov 2011 at 00:39

The vargplvm toolbox is an implementation of the variational approximation for the Bayesian GPLVM.

Version 0.2
-----------

The software now is extended with dynamics.


Version 0.1
-----------

First version of the software with implementation of the 2010 AISTATS paper.


MATLAB Files
------------

Matlab files associated with the toolbox are:

vargplvmRestorePrunedModel.m: Restore a pruned var-GPLVM model.
rbfard2VardistPsi2Gradient.m: description.
demCmu35VargplvmAnimate.m: Load results for the dyn. GPLVM on CMU35 data and
vargplvmPartExpand.m:
whiteVardistPsi1Compute.m: one line description
vargplvmPruneModel.m: Prune a var-GPLVM model.
demSwissRollVargplvm1.m: Run variational GPLVM on swiss roll data.
demCmu35vargplvmReconstructTaylor.m: Reconstruct right leg and body of CMU 35.
linard2VardistPsi2Gradient.m: description.
vargplvmOptionsDyn.m: Fill in an options structure with default parameters
%VARGPTIMEDYNAMICSSAMPLE
biasVardistPsi1Compute.m: one line description
modelVarPriorBound.m: Wrapper function for the various types of the
vargplvmCreate.m: Create a GPLVM model with inducing variables.
linard2VardistPsi1Compute.m: description.
modelPriorReparamGrads.m: Wrapper function for the gradients of the various types of the
vardistCreate.m: description.
vargplvmUpdateStats.m: Update stats for VARGPLVM model.
demOil100Vargplvm1.m: Run variational GPLVM on 100 points from the oil data.
vargpTimeDynamicsExtractParam.m: Extract parameters from the GP time dynamics model.
vargplvmToolboxes.m: Load in the relevant toolboxes for variational gplvm.
demBrendanVargplvm1.m: Run variational GPLVM on Brendan face data.
demUspsVargplvm1.m: Demonstrate variational GPLVM on USPS data. 
kernVardistPsi1Gradient.m: description.  
biasVardistPsi2Compute.m: one line description
whiteVardistPsi0Gradient.m: one line description
vargplvmDynamicsUpdateStats.m: wrapper function which according to the type
vargplvmExtractParam.m: Extract a parameter vector from a variational GP-LVM model.
linard2VardistPsi2Compute.m: description.
vargplvmLogLikeGradients.m: Compute the gradients for the variational GPLVM.
vargplvmSeqDynLogLikeGradient.m: Log-likelihood gradient for of a point of the GP-LVM.
vargplvmLoadData.m: Load a latent variable model dataset from a local folder
whiteVardistPsi2Gradient.m: Compute gradient of white variational PSI2.
kernVardistTest.m: description.
biasVardistPsi0Compute.m: one line description
vargpTimeDynamicsPriorReparamGrads.m: Returns the gradients of the various types of the
kernVardistPsi2Compute.m: description.  
demBrendanVargplvm4.m: Run variational GPLVM on Brendan face data with missing (test) data.
whiteVardistPsi1Gradient.m: Compute gradient of white variational Psi1.
rbfard2VardistPsi2Compute.m: one line description
kernVardistPsi0Compute.m: description.  
demHighDimVargplvmLoadPred.m: Load predictions of the var. GPLVM made on high dimensional video datasets.
rbfard2VardistPsi0Compute.m: description.
demRobotWirelessVargplvmDyn1.m: Run variational GPLVM on robot wireless
demBrendanVargplvm3.m: Run variational GPLVM on Brendan face data.
vargplvmPointGradient.m: Wrapper function for gradient of a single point.
rbfardjitVardistPsi2Gradient.m: description.
vargplvmReduceVidModel.m: Take a model computed on a video dataset and return a model which is computed on
vargpTimeDynamicsUpdateStats.m: Supplementary update stats for when the model contains
demOilVargplvm2.m: Run variational GPLVM on oil data.
rbfard2biasVardistPsi2Gradient.m: description.
skelPlayData2.m: Play skel motion capture data for more than one dataset (for comparison).
vargplvmPosteriorVar.m: variances of the posterior at points given by X.
demRobotWirelessVargplvm1.m: Run variational GPLVM on robot wireless data.
rbfard2VardistPsi0Gradient.m: Description
demOilVargplvm1.m: Run variational GPLVM on oil data.
biasVardistPsi2Gradient.m: Compute gradient of bias variational PSI2.
demCmu35VargplvmLoadChannels.m: Given a dataset load the skeleton channels
vargplvmPointLogLikeGradient.m: Log-likelihood gradient for of some points of the GP-LVM.
vargplvmTaylorAngleErrors.m: Helper function for computing angle errors for CMU 35 data using
kernKuuXuGradient.m: Description
vargplvmPointObjectiveGradient.m: Wrapper function for objective and gradient of a single point in latent space and the output location..
vargplvmCreateToyData.m: Create a trivial dataset for testing var. GPLVM
demCmu35gplvmVargplvm3.m: Run variational GPLVM with dynamics on CMU35 data.
linard2biasVardistPsi2Gradient.m: description.
rbfardjitVardistPsi2Compute.m: one line description
vargplvmExpandParam.m: Expand a parameter vector into a GP-LVM model.
rbfard2linard2VardistPsi2Gradient.m: description
%DEMTOYDATAVARGPLVM1 Run Variational GPLVM with/without dynamics on toy data.
demosDynamics.m: Reproduce all results and plots used for the VGPDS ARXIV 2011 paper.
vargplvmReduceModel.m: prunes out dimensions of the model.
demUspsVargplvm2.m: Demonstrate linear variational GPLVM (Bayesian PCA) on USPS data.
rbfardVardistPsi1Compute.m: one line description
vargplvmOptimiseSeqDyn.m: Optimise the positions of a group of latent
vargplvmPosteriorMeanVar.m: Mean and variances of the posterior at points given by X.
whiteVardistPsi2Compute.m: one line description
demCmu35VargplvmPlotsScaled.m: Load results for the dyn. GPLVM on CMU35 data and produce plots
kernkernVardistPsi2Gradient.m: Description
rbfard2biasVardistPsi2Compute.m: description.
demOil100VargplvmDyn1.m: Run variational GPLVM on 100 points from the oil data.
kernVardistPsi0Gradient.m: description.  
vargplvmSeqDynGradient.m: Wrapper function for gradient of a single point.
vardistExtractParam.m: Extract a parameter vector from a vardist structure.
vargplvmInitDynamics.m: Initialize the dynamics of a var-GPLVM model.
biasVardistPsi1Gradient.m: Compute gradient of bias variational PSI1.
rbfardjitVardistPsi1Compute.m: description.
kernkernVardistTest.m: Description
vargplvmProbabilityCompute.m: description
demHighDimVargplvm3.m: This is the main script to run variational GPLVM on
vargplvmPointObjective.m: Wrapper function for objective of a single point in latent space and the output location..
vardistExpandParam.m: Expand a parameter vector into a vardist structure.
rbfardjitVardistPsi1Gradient.m: description.
vargplvmReduceVideo.m: Receives a video and reduces its resolution by factor1 (lines) and factor2).
vargplvmAddDynamics.m: Add a dynamics structure to the model.
vargplvmPointLogLikelihood.m: Log-likelihood of one or more points for the GP-LVM.
vargplvmDynamicsUpdateModelTestVar.m: return the original variational means and
demFinance2.m: Demonstrate Variational GPLVM with dynamics on financial data for multivariate time series (i.e multiple univariate time series)
linard2biasVardistPsi2Compute.m: one line description
demBrendanVargplvmDyn1.m: Run variational GPLVM on Brendan face data.
rbfardVardistPsi2Compute.m: one line description
modelPriorKernGrad.m:
vargplvmSeqDynLogLikelihood.m: Log-likelihood of a point for the GP-LVM.
kernkernVardistPsi2Compute.m: description.
vargpTimeDynamicsVarPriorGradients.m: This function does all the work for calculating the
addDefaultVargpTimeDynamics.m:
linard2VardistPsi1Gradient.m: description.
linard2VardistPsi0Gradient.m: description.
vargplvmOptions.m: Return default options for VARGPLVM model.
vargplvmPredictPoint.m: Predict the postions of a number of latent points.
kernVardistPsi2Gradient.m: description.  
kernVardistPsi1Compute.m: description.  
vargplvmGradient.m: Variational GP-LVM gradient wrapper.
demHighDimVargplvmTrained.m: Perform tasks (predictions, sampling) for an already trained model on high dimensinoal video datasets.
vargplvmLogLikelihood.m: Log-likelihood for a variational GP-LVM.
vargplvmOptimisePoint.m: Optimise the postion of one or more latent points.
vargplvmSeqDynObjective.m: Wrapper function for objective of a group of points in latent space and the output locations..
linardVardistPsi1Gradient.m: description.
linardVardistPsi1Compute.m: description.
vargplvmInitDynKernel.m: Initialise a compound dynamics kernel
vargpTimeDynamicsExpandParam.m: Place the parameters vector into the model for GP time dynamics.
vargpTimeDynamicsCreate.m: Create the time dynamics variational model.
vargplvmOptimise.m: Optimise the VARGPLVM.
vargpTimeDynamicsVarPriorBound.m: Computes the term of the variational
biasVardistPsi0Gradient.m: one line description
vargplvmParamInit.m: Initialize the variational GPLVM from the data
rbfard2VardistPsi1Gradient.m: description.
rbfard2linard2VardistPsi2Compute.m: description
rbfardjitVardistPsi0Gradient.m: Description
vargplvmObjectiveGradient.m: Wrapper function for VARGPLVM objective and gradient.
rbfardjitVardistPsi0Compute.m: description.
rbfardVardistPsi2Gradient.m: description.
linard2VardistPsi0Compute.m: Description
vargplvmObjective.m: Wrapper function for variational GP-LVM objective.
demBrendanVargplvm2.m: Run variational GPLVM on Brendan face data.
demYaleOneFaceVargplvm1.m: Run the variational GP-LVM on one of the faces in the YALE dataset.
whiteVardistPsi0Compute.m: one line description
rbfard2VardistPsi1Compute.m: description.
demStickVargplvmDynMissing1.m: Run variational GPLVM on stick man data with
