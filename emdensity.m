function [p, x, y] = emdensity(u, nPoints, kmax)
%function [p, x, y] = emdensity(u, nPoints, kmax)
%Estimador de PDF por Expectation Maximization.
%nPoints pode ser o numero de pontos, ou, SOMENTE pra o caso unidimensional,
%pode ser o vetor onde pegar os pontos da PDF.
%

  if nargin < 2, nPoints = 100; end
  if nargin < 3, kmax = 2; end
  
  nDim = size(u,1);
  
  [w,m,r] = em(u', [], kmax, 0, 0, 0);

  if length(nPoints) > 1,
    x = nPoints;
  else
    x = linspace(min(u(1,:)), max(u(1,:)), nPoints);
  end
  
  if nDim == 1,
    y = [];
    d = x';
  else
    x = repmat(x, nPoints, 1);
    y = repmat(linspace(min(u(2,:)), max(u(2,:)), nPoints)', 1, nPoints);
    d = [reshape(x, nPoints^2, 1), reshape(y, nPoints^2, 1)];
  end
  
  lx = em_gauss(d,m,r);
  p = (lx*w)';
  
  if nDim == 2,
    p = reshape(p, nPoints, nPoints);
  end
  