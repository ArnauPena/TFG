%% Object Oriented testing code %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Author : Arnau Pena Sapena %%%
%%% Date : 15/09/2021%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear; clc;

staticfiledata = 'Staticdata.m'; % Define script name in order to find all the data
StaticCase = FEMcomputer(staticfiledata);
StaticCase.solver();
StaticCase.checkifcorrect();
