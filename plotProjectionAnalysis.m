function plotProjectionAnalysis(data, ringsDist, secNames, w_all, w_seg, name)
%function plotProjectionAnalysis(data, ringsDist, secNames, w_all, w_seg, name)
%Realiza a analise dos dados de entrada.
%Esta funcao vai pegar um conjunto de entrada e vai realizar as analises
%principais encessarias p/ o desenvolvimento do classificador, que e a
%apresentacao da distribuicao da entrada para cada camada, e com todas as
%camadas juntas. Caso uma matriz de projecao W (com uma projecao por
%LINHA) tambem for passada, a analise sera feita projetando-se data em W.
%E, em seguida, a analise da projecao sera feita, apresentando graficos de
%analise da ortogonalidade das direcoes de W, bem como a correlacao linear
%e nao-linear. Todas as analises sao feitas p/c ada camada individualmente,
%bem como p/ todas juntas. 
%Parametros de entrada:
% data : a matriz de entrada de treino do classificador (um evento por
% coluna)
% ringDist : a quantidade de aneis em cada camada.
% secNames : o nome de cada camada do calorimetro (PS, EM1, etc)
% w_all : a matriz de projecao a ser usadada p/ projetar todos os aneis. E
% a matriz retornada pelo metodo extract.m de cada analise (ica, pcd, etc)
% w_seg : a matriz de projecao a ser usadada p/ projetar os aneis de cada 
% camada. E a matriz retornada pelo metodo extract.m de cada analise (ica, pcd, etc)
%name : e o nome, tanto em w_all, bem como w_seg{i} que a amtriz de
%projecao tem: exemplo, de tal forma que as direcoes de projecao sao
%achadas em w_all.(name).
%
%Se w_all e w_seg forem omitidos, as analises serao feitas em data, sem
%nenhum pre-processamento, e o grafico de ortogonalidade nao sera gerado.
%
%A funcao rtorna os seguintes graficos (p/c ada camada, e p/ todos os aneis juntos):
% - Grafico com a distribuicao dos valores de cada anel
% - A matriz de ortogonalidade de W (caso seja passado)
% - A matriz de correlacao linear de data, projetado em W, caso tenha sido
% passado.
% - A matriz de correlacao nao-linear de data, projetado em W, caso tenha sido
% passado.
%


data = double(data);
nLayers = length(ringsDist);

doProj = true;
%Se W nao foi passado, criamos um dummy.
if nargin == 3,
  doProj = false;
  name = 'dummy';
  w_seg = cell(1,nLayers);
  for i=1:nLayers, w_seg{i}.(name) = [];end
  w_all.(name) = [];
end

inHist = figure;
figCorr = figure;
figNlCorr = figure;
figOrt = figure;

for i=1:nLayers,
  ldata = project(getLayer(data, ringsDist, i), w_seg{i}.(name), doProj);
  figure(inHist);
  subplot(2,4,i);
  doPlot(ldata, secNames{i});
  doProjectionAnalysis(secNames{i}, ldata, i, figCorr, figNlCorr, figOrt, w_seg{i}.(name));
end

figure(inHist);
subplot(2,4,8);
ldata = project(data, w_all.(name), doProj);
doPlot(ldata, 'All Layers');
doProjectionAnalysis('All Layers', ldata, 8, figCorr, figNlCorr, figOrt, w_all.(name));




function doPlot(data, name)
  [n,m] = size(data);
  data  = reshape(data,1,n*m);
  histLog(data, 1000);
  title(name);
  xlabel('Input Dist')
  ylabel('Counts');
  fprintf('For %s inputs: mean = %f, std = %f\n', name, mean(data), std(data));



  
function pdata = project(data, w, doProj)
  if doProj,
    pdata = w * data;
  else
    pdata = data;
  end




function doProjectionAnalysis(name, data, figIdx, figCorr, figNlCorr, figOrt, W)

  if nargin == 7,
    %Doing ortogonalization
    figure(figOrt);
    subplot(2,4,figIdx);
    pcolor(calcAngles(W'));
    colorbar;
    title(sprintf('Ortogonalization Analysis - %s', name));
    xlabel('Projection');
    ylabel('Projection');
  end
  
  data = data';
  
  %Doing linear correlation analysis.
  figure(figCorr);
  subplot(2,4,figIdx);
  pcolor(abs(corrcoef(data)));
  colorbar;
  title(sprintf('Linear Correlation Analysis - %s', name));
  xlabel('Projection');
  ylabel('Projection');

  %Doing non-linear correlation analysis.
  ndata = size(data,1);
  data(1:round(ndata/2),:) = tanh(data(1:round(ndata/2),:));
  data(round(ndata/2)+1:end,:) = data(round(ndata/2)+1:end,:).^3;

  figure(figNlCorr);
  subplot(2,4,figIdx);
  pcolor(abs(corrcoef(data)));
  colorbar;
  title(sprintf('Non-linear Correlation Analysis - %s', name));
  xlabel('Projection');
  ylabel('Projection');

