%{
Created by: Arkaprabha Basu

Last Updated Version: 11/03/2021 for GitHub repository

The purpose of this code is to create a .mat file with angles of individual
filaments extracted from the Cell Image Analysis package

Input: data file generated from Cell Image Analysis
Output: .mat file containing list of angles
%}


clear all

hr = 48;
m = 10;

%fname1 = strcat('dataM-Cell_alpha',num2str(hr),'hrs_act_',num2str(m),'.tif.mat');
fname1 = strcat('dataM-Cell_XAV_H3MVLM_',num2str(m),'.tif.mat');

load ([fname1])

a = all_data.dataM(:,1);

%fname2 = strcat('angle_alpha_',num2str(hr),'hrs_',num2str(m),'.mat');
fname2 = strcat('angle_XAV_H3MVLM_',num2str(m),'.mat');

save ([fname2], 'a')
