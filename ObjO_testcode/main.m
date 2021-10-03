%% Object Oriented testing code %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Author : Arnau Pena Sapena %%%
%%%     Date : 15/09/2021      %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear; clc;

s.solver_type = 'DIRECT';
s.staticfiledata = 'staticData.m';
s.stifnessmatrix = 'Kgt.mat';

staticCase = Tester(s);


