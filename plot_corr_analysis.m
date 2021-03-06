function plot_corr_analysis(data, ringsDist, tit, fname, w, w_seg)
%function plot_corr_analysis(data, ringsDist, tit, w, w_seg)
%Plota, p/ o caso segmentado e nao segmentado, as matrizes de correlacao
%linear e nao-linear. Caso w seja especificado, devera ser uma estrutura
%contendo um campo chamado 'W' contendo as direcoes de projecao (uma
%direcao por LINHA). w_seg e um vetor de celulas (1 p/ cada segmento), onde
%cada celula carrega uma estrutura com a mesma organizacao de w. Se forem
%omitidos, ou [], a funcao nao realizara nenhuma projecao. tit e um titulo
%a ser adicionado a plot gerada.
%

if nargin < 3, fname = ''; end;
if nargin < 4, tit = ''; end;
if nargin < 5, w = []; end;
if nargin < 6, w_seg = []; end;

%Correlacao linear.
[fs, fb] = do_plot(data, ringsDist, w, w_seg, sprintf('%s (linear)', tit));
if ~isempty(fname),
  saveas(fs, sprintf('%s-seg-linear', fname), 'fig');
  saveas(fb, sprintf('%s-nseg_plus_em1-linear', fname), 'fig');
end

%Correlacao nao-linear.
[fs, fb] = do_plot(tanh(data), ringsDist, w, w_seg, sprintf('%s (nao-linear)', tit));
if ~isempty(fname),
  saveas(fs, sprintf('%s-seg-nao_linear', fname), 'fig');
  saveas(fb, sprintf('%s-nseg_plus_em1-nao_linear', fname), 'fig');
end


function [fs, fb] = do_plot(data, ringsDist, w, w_seg, tit)
  leg = {'PS', 'EM1', 'EM2', 'EM3', 'HD1', 'HD2', 'HD3'};
  fs = figure;

  toPlot = [1 3 4 5 6 7]; %Pegando todas menos EM1.
  for p=1:length(toPlot),
    i = toPlot(p);
    subplot(2,3,p);
    ldata = getLayer(data, ringsDist, i);  
    if ~isempty(w_seg),
      ldata = w_seg{i}.W * ldata;
    end
    do_job(ldata, sprintf('%s %s', leg{i}, tit));
  end

  fb = figure;
  subplot(1,2,1);
  ldata = getLayer(data, ringsDist, 2);  
  if ~isempty(w_seg),
    ldata = w_seg{2}.W * ldata;
  end
  do_job(ldata, sprintf('%s %s', leg{2}, tit));

  subplot(1,2,2);
  if ~isempty(w),
    data = w.W * data;
  end
  do_job(data, sprintf('All %s', tit));


function do_job(data, tit)
  c = abs(corrcoef(data'));
  c = [c c(:,end)];
  c = [c; c(end,:)];
  pcolor(c);
  colorbar('Location', 'SouthOutside');
  colormap('cool');
  title(tit);
