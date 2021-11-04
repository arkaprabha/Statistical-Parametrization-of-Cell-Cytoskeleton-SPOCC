% orrientationalOrder_SarcOnly_Matrix_function
%
% Last updated: 02/25/2012
% Last minor edits: 02/25/2012 by Anya
%
% written for use with sarcDetect
% Created by: Anya Grosberg
% Disease Biophysics Group
% School of Engineering and Applied Sciences
% Havard University, Cambridge, MA 02138
%
% The purpose of this code is to provide plotted functions for the OOP code

function OOPbarPlotVar(FigNum,bars_to_plot,error_bars,num_cs,condname_str,max_y,...
    filExt,yAxisTit,NumCond,filename_user)

%Plot a histogram with error bars
figure(FigNum)
n=num_cs;
bar_xaxis = char(condname_str);
bar(bars_to_plot,'FaceColor',[0.8,0.8,0.8])
hold on
%%change to standard error
error_bars=error_bars./sqrt(n);
errorbar(bars_to_plot,error_bars,'k','LineStyle','none','Marker','none','LineWidth',2);
set(gca,'FontName','Arial','FontSize',16,'xticklabel',bar_xaxis);

axis([0 NumCond+1 0 max_y]);
ylabel(yAxisTit,'FontName','Arial','FontSize',16,'FontWeight','bold');
for i=1:NumCond
    text(i,max_y/20,['n=',num2str(num_cs(i))],'FontName','Arial','FontSize',14,'HorizontalAlignment','center')
end
filename_fig = [filename_user(1:(length(filename_user)-4)) filExt '-merror.pdf'];
set(gcf,'Color',[1 1 1]);
saveas(gcf,filename_fig)
