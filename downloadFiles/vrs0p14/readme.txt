VARGPLVM software
Version 0.14		Tuesday 12 Jul 2011 at 18:47

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

kernkernVardistPsi2Gradient.m: Description
vargplvmToolboxes.m: Load in the relevant toolboxes for variational gplvm.
kernVardistPsi0Gradient.m: description.  
linard2biasVardistPsi2Compute.m: one line description
preprocessVideo.m: Transform video files of various types into 2-D matrices.
vargplvmSeqDynObjective.m: Wrapper function for objective of a group of points in latent space and the output locations..
biasVardistPsi1Compute.m: one line description
rbfard2VardistPsi0Gradient.m: Description
vargplvmRestorePrunedModel.m: Restore a pruned var-GPLVM model.
vargplvmObjective.m: Wrapper function for variational GP-LVM objective.
vargplvmPartExpand.m:
vargplvmPruneModel.m: Prune a var-GPLVM model.
vargplvmUpdateStats.m: Update stats for VARGPLVM model.
demHighDimVargplvmTrained.m: Perform tasks (predictions, sampling) for an already trained model on high dimensinoal video datasets.
demUspsVargplvm2.m: Demonstrate linear variational GPLVM (Bayesian PCA) on USPS data.
demCmu35vargplvmReconstructTaylor.m: Reconstruct right leg and body of CMU 35.
vardistExtractParam.m: Extract a parameter vector from a vardist structure.
skelPlayData2.m: Play skel motion capture data for more than one dataset (for comparison).
NIPS_demos.m: Reproduce all results and plots used for the NIPS 2011 paper.
kernVardistPsi0Compute.m: description.  
rbfardVardistPsi2Compute.m: one line description
demOil100VargplvmDyn1.m: Run variational GPLVM on 100 points from the oil data.
rbfard2biasVardistPsi2Compute.m: description.
vargpTimeDynamicsVarPriorGradients.m: This function does all the work for calculating the
demStickVargplvmDynMissing1.m: Run variational GPLVM on stick man data with
demHighDimVargplvmLoadPred.m: Load predictions of the var. GPLVM made on high dimensional video datasets.
demBrendanVargplvmDyn1.m: Run variational GPLVM on Brendan face data.
demBrendanVargplvm2.m: Run variational GPLVM on Brendan face data.
vargpTimeDynamicsVarPriorBound.m: Computes the term of the variational
biasVardistPsi1Gradient.m: Compute gradient of bias variational PSI1.
vargplvmCreate.m: Create a GPLVM model with inducing variables.
linardVardistPsi1Gradient.m: description.
vargplvmProbabilityCompute.m: description
vargplvmOptionsDyn.m: Fill in an options structure with default parameters
saveMovieScript.m: A demonstration on the use of playMov.m for saving a
vargplvmPointObjectiveGradient.m: Wrapper function for objective and gradient of a single point in latent space and the output location..
kernKuuXuGradient.m: Description
demFinance2.m: Demonstrate Variational GPLVM with dynamics on financial data for multivariate time series (i.e multiple univariate time series)
demSwissRollVargplvm1.m: Run variational GPLVM on swiss roll data.
whiteVardistPsi2Gradient.m: Compute gradient of white variational PSI2.
modelPriorReparamGrads.m: Wrapper function for the gradients of the various types of the
rbfard2biasVardistPsi2Gradient.m: description.
demOilVargplvm2.m: Run variational GPLVM on oil data.
demCmu35VargplvmPlotsScaled.m: Load results for the dyn. GPLVM on CMU35 data and produce plots
vargpTimeDynamicsUpdateStats.m: Supplementary update stats for when the model contains
linard2biasVardistPsi2Gradient.m: description.
vargplvmOptimiseSeqDyn.m: Optimise the positions of a group of latent
rbfardjitVardistPsi2Compute.m: one line description
vargplvmSeqDynLogLikeGradient.m: Log-likelihood gradient for of a point of the GP-LVM.
vargplvmLogLikelihood.m: Log-likelihood for a variational GP-LVM.
biasVardistPsi2Gradient.m: Compute gradient of bias variational PSI2.
vargplvmDynamicsUpdateModelTestVar.m: return the original variational means and
biasVardistPsi0Gradient.m: one line description
biasVardistPsi2Compute.m: one line description
vardistCreate.m: description.
vargplvmOptions.m: Return default options for VARGPLVM model.
vargplvmReduceModel.m: prunes out dimensions of the model.
demCmu35gplvmVargplvm3.m: Run variational GPLVM with dynamics on CMU35 data.
vargplvmParamInit.m: Initialize the variational GPLVM from the data
vargplvmPointLogLikelihood.m: Log-likelihood of one or more points for the GP-LVM.
vargplvmReduceVidModel.m: Take a model computed on a video dataset and return a model which is computed on
demRobotWirelessVargplvmDyn1.m: Run variational GPLVM on robot wireless
vargplvmExtractParam.m: Extract a parameter vector from a variational GP-LVM model.
playMov.m: Play a video file which is stored by rows in a 2-D matrix.
vargplvmGradient.m: Variational GP-LVM gradient wrapper.
vargplvmSeqDynGradient.m: Wrapper function for gradient of a single point.
vargpTimeDynamicsExtractParam.m: Extract parameters from the GP time dynamics model.
rbfard2VardistPsi2Gradient.m: description.
linard2VardistPsi1Compute.m: description.
demHighDimVargplvm3.m: This is the main script to run variational GPLVM on
whiteVardistPsi0Compute.m: one line description
rbfardVardistPsi2Gradient.m: description.
vargplvmPointGradient.m: Wrapper function for gradient of a single point.
rbfardVardistPsi1Compute.m: one line description
demosNIPS.m:
rbfardjitVardistPsi1Gradient.m: description.
kernVardistPsi2Gradient.m: description.  
demOilVargplvm1.m: Run variational GPLVM on oil data.
rbfard2VardistPsi2Compute.m: one line description
rbfard2linard2VardistPsi2Compute.m: description
biasVardistPsi0Compute.m: one line description
vardistExpandParam.m: Expand a parameter vector into a vardist structure.
vargplvmPointObjective.m: Wrapper function for objective of a single point in latent space and the output location..
kernVardistPsi2Compute.m: description.  
rbfardjitVardistPsi2Gradient.m: description.
whiteVardistPsi0Gradient.m: one line description
vargplvmPosteriorMeanVar.m: Mean and variances of the posterior at points given by X.
vargplvmPosteriorVar.m: variances of the posterior at points given by X.
whiteVardistPsi1Compute.m: one line description
linard2VardistPsi0Compute.m: Description
vargpTimeDynamicsPriorReparamGrads.m: Returns the gradients of the various types of the
vargplvmDynamicsUpdateStats.m: wrapper function which according to the type
modelPriorKernGrad.m:
vargplvmLogLikeGradients.m: Compute the gradients for the variational GPLVM.
vargpTimeDynamicsCreate.m: Create the time dynamics variational model.
rbfard2linard2VardistPsi2Gradient.m: description
kernkernVardistTest.m: Description
addDefaultVargpTimeDynamics.m:
linard2VardistPsi2Gradient.m: description.
linard2VardistPsi2Compute.m: description.
rbfard2VardistPsi1Compute.m: description.
demUspsVargplvm1.m: Demonstrate variational GPLVM on USPS data. 
kernkernVardistPsi2Compute.m: description.
vargpTimeDynamicsExpandParam.m: Place the parameters vector into the model for GP time dynamics.
modelVarPriorBound.m: Wrapper function for the various types of the
vargplvmInitDynamics.m: Initialize the dynamics of a var-GPLVM model.
vargplvmSeqDynLogLikelihood.m: Log-likelihood of a point for the GP-LVM.
rbfardjitVardistPsi1Compute.m: description.
linard2VardistPsi1Gradient.m: description.
rbfard2VardistPsi1Gradient.m: description.
rbfardjitVardistPsi0Gradient.m: Description
vargplvmTaylorAngleErrors.m: Helper function for computing angle errors for CMU 35 data using 
vargplvmExpandParam.m: Expand a parameter vector into a GP-LVM model.
demosDynamics.m: Reproduce all results and plots used for the VGPDS ARXIV 2011 paper.
demCmu35VargplvmLoadChannels.m: Given a dataset load the skeleton channels
kernVardistTest.m: description.
linardVardistPsi1Compute.m: description.
linard2VardistPsi0Gradient.m: description.
rbfard2VardistPsi0Compute.m: description.
demBrendanVargplvm1.m: Run variational GPLVM on Brendan face data.
kernVardistPsi1Gradient.m: description.  
vargplvmReduceVideo.m: Receives a video and reduces its resolution by factor1 (lines) and factor2).
vargplvmAddDynamics.m: Add a dynamics structure to the model.
demBrendanVargplvm3.m: Run variational GPLVM on Brendan face data.
whiteVardistPsi1Gradient.m: Compute gradient of white variational Psi1.
demBrendanVargplvm4.m: Run variational GPLVM on Brendan face data with missing (test) data.
vargplvmPredictPoint.m: Predict the postions of a number of latent points.
kernVardistPsi1Compute.m: description.  
vargplvmOptimisePoint.m: Optimise the postion of one or more latent points.
%VARGPTIMEDYNAMICSSAMPLE
vargplvmPointLogLikeGradient.m: Log-likelihood gradient for of some points of the GP-LVM.
whiteVardistPsi2Compute.m: one line description
vargplvmOptimise.m: Optimise the VARGPLVM.
vargplvmObjectiveGradient.m: Wrapper function for VARGPLVM objective and gradient.
demCmu35VargplvmAnimate.m: Load results for the dyn. GPLVM on CMU35 data and
rbfardjitVardistPsi0Compute.m: description.
