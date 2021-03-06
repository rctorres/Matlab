function [r_mse, r_sp] = do_relevance(net_str, trn, val, tst)
%function [r_mse, r_sp] = do_relevance(net, trn, val, tst)
%Faz a analise da relevancia. net_str e uma estrutura tal como retornada
%pelo fullTrain, contendo os pre-processamentos aplicados, a rede treinada,
%e toda a informacao necessaria. Esta funcao retorna os valores de
%relavancia por MSE, e por SP.
%

  net = net_str.net;
  pp = net_str.pp;
  
  [trn, val, tst] = do_pre_proc(pp, trn, val, tst);
  clear tst;
  
  r_mse = relevance(net, cell2mat(trn), cell2mat(val));
  r_sp = relevance(net, trn, val);
  