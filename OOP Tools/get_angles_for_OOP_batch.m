%{
Created by: Arkaprabha Basu

Last Updated Version: 11/03/2021 for GitHub repository

The purpose of this code is to create a matrix with angles of individual
filaments extracted from the Cell Image Analysis package

Should only be used for batches with similar names that can be run on a
loop

Input: data file generated from Cell Image Analysis
Output: .mat file containing list of angles
%}

clear all

%setup hour mark and number of images

hr = 48;
m = 18;

%create loop and save for every image for one hour mark

for i = 1:m
    %fname1 = strcat('dataM-Cell_',num2str(hr),'hrs_act_',num2str(i),'.tif.mat');
    fname1 = strcat('dataM-Cell_XAV_act_',num2str(i),'.tif.mat');
    %fname1 = strcat('dataM-Cell',num2str(i),'.tif.mat');
    load ([fname1])
    a = all_data.dataM(:,1);
    fname2 = strcat('angle_XAV_',num2str(i),'.mat');
    %fname2 = strcat('angle_',num2str(hr),'hrs_',num2str(i),'.mat');
    save ([fname2], 'a')
    i
end

