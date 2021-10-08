%% Object Oriented testing code %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Author : Arnau Pena Sapena %%%
%%%     Date : 15/09/2021      %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear; clc;

s.solver_direct    = 'DIRECT';
s.solver_iterative = 'ITERATIVE';
s.staticfiledata   = 'staticData.m';
s.stifnessmatrix   = 'Kglobal.mat';
s.Kll              = 'Kll.mat';
s.Fl               = 'Fl.mat';
s.forcevector      = 'f.mat';

staticCaseTest = Tester(s);
staticCaseTest.run();

clear s;

