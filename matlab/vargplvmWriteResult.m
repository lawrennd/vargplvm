function fileName = vargplvmWriteResult(model, type, dataset, number, varargin)

if ~isfield(model, 'saveName') || isempty(model.saveName)
  dataset(1) = upper(dataset(1));
  type(1) = upper(type(1));
  fileName = ['dem' dataset type num2str(number)];
  if nargin > 4
      fileName = [fileName varargin{1}];
  end
  if isoctave
    fileName = [fileName '.mat'];
  end
else
    fileName = model.saveName;
end

  if ~isempty(model)
    save(fileName, 'model');
  end
    
  