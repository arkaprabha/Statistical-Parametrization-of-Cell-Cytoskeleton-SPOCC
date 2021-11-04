function []=process_thisnuclei( input_file, output_file, tr ),
  addpath('../levelset/');
  t=[];
  for j=1:100,
    t=process_nuclei( input_file, output_file, 0, 0, t, j, 100, tr );
  end;
end