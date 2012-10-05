function [Y, bias, scale] = scaleData(Y, scale2var1, scaleVal)

if nargin < 3, scaleVal = [];   end
if nargin < 2, scale2var1 = []; end

d = size(Y,2);
bias = mean(Y);
scale = ones(1, d);

if ~isempty(scale2var1)
    if(scale2var1)
        scale = std(Y);
        scale(find(scale==0)) = 1;
        if ~isempty(scaleVal) && scaleVal
            warning('Both scale2var1 and scaleVal set for GP');
        end
    end
end
if ~isempty(scaleVal) && scaleVal
    scale = repmat(scaleVal, 1, d);
end

% Remove bias and apply scale.
m = Y;
for i = 1:d
  m(:, i) = m(:, i) - bias(i);
  if scale(i)
    m(:, i) = m(:, i)/scale(i);
  end
end
Y = m;