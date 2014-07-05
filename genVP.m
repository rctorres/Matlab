function [cut, vpp, vpn] = genVP(out_signal, out_noise, numPts, doNorm)
%function [cut, vpp, vpn] = genVP(out_signal, out_noise, numPts, doNorm)
%Plots the VPP and VPN for a classifier by varying its decision threshold.
%Input Parameters are:
%   out_signal     -> The output generated by your detection system when
%                     electrons were applied to it.
%   out_noise      -> The output generated by your detection system when
%                     jets were applied to it
%   numPts         -> (opt) The number of points to generate your ROC.
%   doNorm         -> If true (default is false), will normalize the classifier output so its
%                     dynamic range lies within [+1,-1].
%

if nargin < 3, numPts = 1000; end
if nargin < 4, doNorm = false; end

if doNorm,
  %Placing the data within the [-1,+1] range.
  [~, pp] = mapminmax([out_signal out_noise]);
  out_signal = mapminmax('apply', out_signal, pp);
  out_noise = mapminmax('apply', out_noise, pp);
end

%Stablishing where to calculate the efficiencies (thresholds).
cut = -1 : (2/numPts) : 1;
cut = cut(1:numPts);
vpp = zeros(1,numPts);
vpn = zeros(1,numPts);

for i=1:numPts,
    threshold = cut(i);
    tp = length(find(out_signal >= threshold));
    fp = length(find(out_noise >= threshold));
    tn = length(find(out_noise < threshold));
    fn = length(find(out_signal < threshold));
    vpp(i) = tp / (tp + fp);
    vpn(i) = tn / (tn + fn);
end

%Sinde we normalize the output values to be within +- 1, the vector of
%thresholds shoube be, at the end of this function, with the same dnamic
%range as the original output values (non-normalized).
if doNorm,
  cut = mapminmax('reverse', cut, pp);
end
