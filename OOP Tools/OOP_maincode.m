%{
OOP_MultipleCond.m

Written (original version): 03/11/2009
Last updated: 01/22/2019 - customization for the Weiss group

written for use with sarcDetect
Created by: Anya Grosberg


The purpose of this code is to calculate the orientational order parameter
for different conditions and perform statistical tests on them.

Input: the code will call a function that will
        asks for the .mat file produced by the angle detection code.
        
Output: Bar plot and data file with the
        orientational order parameter  for each condition and p values between them
                                       standard deviation for each condition
                                        number of cover-slips for each conditions
                                        number of conditions
                                        name of conditions
       Array with OOP for each coverslip/cell and condition (this is just for checking for errors)
%}
clear
close all
%Repeat run for plots or new run?
%Assume new run - uncomment if different
%Choose = input('Would you like to analyze [=0] or plot analyzed data [=1]]: ');
Choose = 0;

if Choose == 0
    path_user = uigetdir('E:\Research\Collaborations\Weiss_Shimon','Please pick a base directory...'); %You can put in the regular directory here to save time
    %How many conditions?
    NumCond = input('Enter the number of conditions: ');
    
    %You can ignore this variable - I just left it in for simplicity sace
    %-- or if you have another variable later
    variable_name_index = 2;
    
    changeUnits = 1; %If change units is equal to 1, they are not changed. If it is equal to 180/pi() they are changed
    if variable_name_index == 1 || variable_name_index == 3 || variable_name_index == 5  %This line is left as an example in case there are multiple input files later
        variable_name = 'nonzero_orientation';
    else if variable_name_index == 2
            variable_name = 'a';
            changeUnits = pi()/180;
        end
    end
    
    
    %%Take the non-zero angles -- this is important, because if the zero
    %%angles are not removed the orientational order parameter is very high
    %%as the zero vectors drown out the information from the other vectors.
    %%This is currently not relavant for you, but is very important if the
    %%OOP is found for all pixels with an angle
    
    
    
    %Find the OOP for each condition
    for i=1:NumCond
        condname_temp = input('Enter the name of the condition: ','s');
        condname_str(i,1:length(condname_temp)) = condname_temp;
        
        [OOP_temp,num_cs(i)]...
            = orientationalOrder_Matrix_function(path_user,...
            variable_name,changeUnits);
        
        
        OOP_VEC(1:num_cs(i),i) = OOP_temp;
        OOP_cond(i) = mean(OOP_temp);
        OOP_E(i) = std(OOP_temp);
    end
    
    %Perform statistical tests on each one for the OOP
    for i=1:(NumCond-1)
        for j=(i+1):NumCond
            if (num_cs(i)>1)&&(num_cs(j)>1)
                [h,p(i,j)]=ttest2(OOP_VEC(1:num_cs(i),i),OOP_VEC(1:num_cs(j),j));
            else
                h=0;
                p(i,j)=1;
            end
        end
    end
    
    %save orientational order parameter means, standard deviation and p values
    %Ask for the file name and path
    file_user = input('Please enter the filename for the summary file: ','s');
    filename_user = [path_user '\' file_user '.mat'];
    disp(filename_user)
    
    save(filename_user,'OOP_cond','OOP_E','num_cs','condname_str','NumCond',...
        'OOP_VEC','variable_name_index');
    
else
    [file,path]=uigetfile({'*.mat';'*.*'},'Select Summary File...','M:\Anya');
    filename = [path file];
    disp(filename)
    load(filename);
    filename_user = filename;
    
    %NumCond = length(num_cs);
end



FigNum =0;


max_y = ceil(10.*max(OOP_cond+OOP_E))/10;
FigNum = FigNum+1;
OOPbarPlotVar(FigNum,OOP_cond,OOP_E,num_cs,condname_str,max_y,...
    'bar_plot','Orientational Order Parameter',NumCond,filename_user)


