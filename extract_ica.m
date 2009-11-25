function W = extract_ica(trn, ringsDist)
%function W = extract_ica(trn, ringsDist)
%Extrai as ICAs. Se ringsDist = [], ou omitido, a extracao sera nao segmentada. 
%Do contrario, a extracao sera feita camada a camada, e W sera 
%um vetor de celulas, com as projecoes.
%

if nargin < 2, ringsDist = []; end

data = cell2mat(trn);

if isempty(ringsDist),
  fprintf('Extraindo as %d ICAs do caso NAO segmentado.\n', size(data,1));
  W = jadeica(data);
else
  N = length(ringsDist);
  W = cell(1,N);
  for i=1:N,
    if ringsDist(i) ~= 0,
      ldata = getLayer(data, ringsDist, i);
      fprintf('Extraindo as %d ICAs do caso segmentado (camada %d).\n', size(ldata,1), i);
      W{i} = jadeica(ldata);
    else
      fprintf('Nao ha componentes na camada %d para a extracao de ICAs.\n', i);
    end
  end  
end
