% Initialise the latent space with the outputs themselves.

function [X, bias, scale] = outputsEmbed(Y, dims, scale2var1, scaleVal)


if nargin < 4, scaleVal = [];   end
if nargin < 3, scale2var1 = 1; end

[X, bias, scale] = scaleData(Y, scale2var1, scaleVal);
