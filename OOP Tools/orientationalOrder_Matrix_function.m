%{
orrientationalOrder_Matrix_function

Last updated: 03/11/2009
Last minor edits: 08/10/2009 by Anya

written for use with sarcDetect
Created by: Anya Grosberg
Disease Biophysics Group
School of Engineering and Applied Sciences
Havard University, Cambridge, MA 02138

The purpose of this function is to calculate the orientational order parameter 
for the detected sarcomeres.

Input: the code asks for the .mat file with orientational angles
        produced by the sarcDetect code. In this case the user needs 
        to put in the angle file for each cover slip of a single condition.
        
Output: number of cover-slips for this condition
        orientational order parameter  for each coverslip stored as a vector
                                        - a number between 0 (isotropic)
                                        and 1 (perfect alignment).

%}
% ask user to select file produced by the sarcDetect code
function [OOP_VEC,num_coverslips] = orientationalOrder_Matrix_function(path,variable_name,changeUnits)

[file,path]=uigetfile({'*.mat';'*.*'},'Select one .mat file for each cover-slip...',path,'MultiSelect','on');


if iscell(file)
    
    NumFiles = length(file);
    
    for i=1:NumFiles
        temp = file{i};
        FileIndex{i} = temp;
    end
else
    NumFiles = 1;
    FileIndex{1} = file;
end    
num_coverslips = NumFiles; % the number of coverslips should be the same as the files.

    

for count=1:NumFiles
    filename = FileIndex{count};
    path_and_filename = [path filename] ;
    filename2 = path_and_filename;
    
    DataFromFile= load(filename2); 
    angles_temp =getfield(DataFromFile,variable_name);
    angles = changeUnits.*angles_temp;
    
   
    
    %Check if the user forgot to change data into degrees, this doesn't
    %garantee that, but is a good quick check. I am comparing it to 3pi so
    %that I don't run into accuracy issues
    if (max(angles)-min(angles))>3*pi
        disp('It looks like you forgot to change to radiants. Press Ctrl+C to end code.')
    end
    
    %%%%%%%%%%%%% Tensor Method %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Calculate x and y components of each vector r
    r(1,:) = cos(angles);
    r(2,:) = sin(angles);
    %Calculate the Orientational Order Tensor for each r and the average
    %Orientational Order Tensor (OOT_Mean)
    for i=1:2
        for j=1:2
            OOT_All(i,j,:)=r(i,:).*r(j,:);
            OOT_Mean(i,j) = mean(OOT_All(i,j,:));
        end
    end
    %Normalize the orientational Order Tensor (OOT), this is necessary to get the
    %order paramter in the range from 0 to 1
    OOT = 2.*OOT_Mean-eye(2);
    %Find the eigenvalues (orientational parameters) and 
    %eigenvectors (directions) of the Orientational Order Tensor
    [directions,orient_parameters]=eig(OOT);
    %orientational order parameters is the maximal eigenvalue, while the
    %direcotor is the corresponding eigenvector
    [Orientation_order_parameter,I] = max(max(orient_parameters));
    director = directions(:,I);
    %calculate the angle corresponding to the director, note that by symmetry
    %the director = - director. This implies that any angle with a period of
    %180 degrees will match this director. To help compare these results to
    %the plot results we enforce the period to match the period of the
    %original data.
    directionAngle_defualt = acosd(director(1)/sum(director.^2));
    directionAngle = directionAngle_defualt+180*(floor(min(angles)/pi()));
    %
    %Calculate the difference between the director and the mean of the
    %angles. Note, that these are not necessarily the same thing because we
    %have a finite number of vectors, so there is some inacuracy introduced
    %in both methods. We can expect the difference to be very large for
    %isotropic and small for well aligned structures. The output of this is
    %suppressed unless someone needs it for something.
    direction_error = directionAngle-(180/pi())*mean(angles);
    
    
    
    %Save OOP for each cover-slip
    OOP_VEC(count)= Orientation_order_parameter;
    
   
        
    clear angle* r OOT* direc* orient* Orient* n xout dx 
end


end