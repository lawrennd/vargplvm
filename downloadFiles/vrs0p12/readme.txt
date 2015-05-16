VARGPLVM software
Version 0.12		Monday 07 Feb 2011 at 18:11

The vargplvm toolbox is an implementation of the variational approximation for the Bayesian GPLVM.


Version 0.11
------------

Second version with improved numerical stability implemented by Andreas Damianou and Michalis Titsias. 

Version 0.1
-----------

First version of the software with implementation of the 2010 AISTATS paper.


MATLAB Files
------------

Matlab files associated with the toolbox are:

vargplvmUpdateStats.m: Update stats of VARGPLVM model.
vargplvmReduceModel.m: prunes out dimensions of the model.
biasVardistPsi0Compute.m: one line description
vargplvmToolboxes.m: Load in the relevant toolboxes for variational gplvm.
vargplvmPosteriorMeanVar.m: Mean and variances of the posterior at points given by X.
linard2VardistPsi1Compute.m: description.
vargplvmPointLogLikelihood.m: Log-likelihood of a point for the GP-LVM.
kernVardistTest.m: description.
vargplvmOptimise.m: Optimise the VARGPLVM.
kernVardistPsi0Gradient.m: description.  
kernVardistPsi1Compute.m: description.  
kernkernVardistPsi2Compute.m: description.
whiteVardistPsi0Gradient.m: one line description
kernVardistPsi2Gradient.m: description.  
vargplvmObjective.m: Wrapper function for variational GP-LVM objective.
linard2VardistPsi0Gradient.m: description.
rbfard2VardistPsi0Compute.m: description.
demOil100Point.m: Description
demRobotWirelessVargplvm1.m: Run variational GPLVM on robot wireless data.
rbfard2biasVardistPsi2Compute.m: description.
demOilVargplvm2.m: Run variational GPLVM on oil data.
rbfard2VardistPsi2Compute.m: one line description
rbfard2VardistPsi0Gradient.m: Description
demBrendanFgplvm9.m: Reconstruction of partial observed test data in Brendan faces using sparse GP-LVM (with dtcvar) and 30 latent dimensions
vargplvmPointLogLikeGradient.m: Log-likelihood gradient for of a point of the GP-LVM.
vargplvmExtractParam.m: Extract a parameter vector from a variational GP-LVM model.
linardVardistPsi1Compute.m: description.
vargplvmProbabilityCompute.m: description
demBrendanFgplvm8.m: Reconstruction of partial observed test data in Brendan faces using sparse GP-LVM (with dtcvar) and 10 latent dimensions
biasVardistPsi0Gradient.m: one line description
vargplvmPointGradient.m: Wrapper function for gradient of a single point.
whiteVardistPsi1Compute.m: one line description
vardistExpandParam.m: Expand a parameter vector into a vardist structure.
vargplvmObjectiveGradient.m: Wrapper function for VARGPLVM objective and gradient.
demUspsVargplvm1.m: Demonstrate variational GPLVM on USPS data. 
whiteVardistPsi2Compute.m: one line description
kernVardistPsi2Compute.m: description.  
biasVardistPsi2Gradient.m: Compute gradient of bias variational PSI2.
whiteVardistPsi1Gradient.m: Compute gradient of white variational Psi1.
rbfard2linard2VardistPsi2Gradient.m: description
kernkernVardistPsi2Gradient.m: Description
linard2biasVardistPsi2Compute.m: one line description
kernKuuXuGradient.m: Description
vargplvmPointObjective.m: Wrapper function for objective of a single point in latent space and the output location..
whiteVardistPsi2Gradient.m: Compute gradient of white variational PSI2.
rbfard2linard2VardistPsi2Compute.m: description
vargplvmPointObjectiveGradient.m: Wrapper function for objective and gradient of a single point in latent space and the output location..
vargplvmOptimisePoint.m: Optimise the postion of a latent point.
linardVardistPsi1Gradient.m: description.
vargplvmExpandParam.m: Expand a parameter vector into a GP-LVM model.
biasVardistPsi1Compute.m: one line description
demSwissRollVargplvm1.m: Run variational GPLVM on swiss roll data.
demUspsVargplvm2.m: Demonstrate linear variational GPLVM (Bayesian PCA) on USPS data.
biasVardistPsi2Compute.m: one line description
kernVardistPsi0Compute.m: description.  
demBrendanVargplvm1.m: Run variational GPLVM on Brendan face data.
vargplvmOptions.m: Return default options for VARGPLVM model.
linard2VardistPsi2Compute.m: description.
vardistExtractParam.m: Extract a parameter vector from a vardist structure.
demoVargplvm1.m: Description ...
kernVardistPsi1Gradient.m: description.  
rbfard2VardistPsi1Gradient.m: description.
vargplvmLogLikeGradients.m: Compute the gradients for the variational GPLVM.
demOil100Vargplvm1.m: Run variational GPLVM on 100 points from the oil data.
rbfard2biasVardistPsi2Gradient.m: description.
rbfardVardistPsi1Compute.m: one line description
vargplvmLogLikelihood.m: Log-likelihood for a variational GP-LVM.
rbfardVardistPsi2Compute.m: one line description
rbfardVardistPsi2Gradient.m: description.
linard2VardistPsi0Compute.m: Description
rbfard2VardistPsi2Gradient.m: description.
rbfard2VardistPsi1Compute.m: description.
vargplvmPosteriorVar.m: variances of the posterior at points given by X.
demBrendanVargplvm3.m: Run variational GPLVM on Brendan face data.
kernkernVardistTest.m: Description
linard2VardistPsi2Gradient.m: description.
vardistCreate.m: description.
linard2VardistPsi1Gradient.m: description.
whiteVardistPsi0Compute.m: one line description
demBrendanFgplvm6.m: Reconstruction of partial observed test data in Brendan faces using sparse GP-LVM (with dtcvar) and 2 latent dimensions
demBrendanFgplvm7.m: Reconstruction of partial observed test data in Brendan faces using sparse GP-LVM (with dtcvar) and 5 latent dimensions
biasVardistPsi1Gradient.m: Compute gradient of bias variational PSI1.
vargplvmParamInit.m: Initialize the variational GPLVM from the data
vargplvmCreate.m: Create a GPLVM model with inducing variables.
demBrendanVargplvm2.m: Run variational GPLVM on Brendan face data.
demOilVargplvm1.m: Run variational GPLVM on oil data.
linard2biasVardistPsi2Gradient.m: description.
vargplvmGradient.m: Variational GP-LVM gradient wrapper.
