%% Object Oriented testing code %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Author : Arnau Pena Sapena %%%
%%%     Date : 15/09/2021      %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear; clc;

s.solver_type    = 'DIRECT';
s.staticfiledata = 'staticData.m';
s.stifnessmatrix = 'Kgt.mat';
s.Kll            = 'Kll.mat';
s.Fl             = 'Fl.mat';
staticCase = Tester(s);
clear s;

