% _______________________________________________________________________
% Main function for SIP model
% Version 1.0 (November, 5th 2020)
% _______________________________________________________________________
% for any question or request, please contact:
%
% Dr. Yelu Zeng & Dr. Min Chen
% Joint Global Change Research Institute, Pacific Northwest National Laboratory, College Park, MD 20740, USA
% E-mail: zengyelu@163.com & chenminbnu@gmail.com
%
% Dr. Shengbiao Wu & Dr. Dalei Hao
% E-mail: wushengbiao90@163.com & dalei.hao.93@gmail.com
%
% https://github.com/chenminbnu/SIP-RTM-Leaf
% _______________________________________________________________________
% Function: Simulate leaf spectra properties from 400 nm to 2500 nm with 1 nm interval
%    Input:
%           - Cab = chlorophyll a+b content in ug/cm?
%           - Car = carotenoids content in ug/cm?
%           - Anth = Anthocyanin content in ug/cm?
%           - Cbrown= brown pigments content in arbitrary units
%           - Cw  = equivalent water thickness in g/cm? or cm
%           - Cm  = dry matter content in g/cm?
%   Output:leaf single scattering albedo, reflectance and transmittance
%
% reference: Wu S.,Zeng Y.,Hao D.,Liu Q.,Li J., Chen X.,R.Asrar G.,Yin G.,
%            Wen J., Yang B., Zhu P.,Chen M.,2020.Quantifying leaf optical
%            properties with spectral invariants theory.
%            DOI: https://doi.org/10.1016/j.rse.2020.112131
%
% Acknowledgement: The authors thank the PROPSECT team for providing the
%                  specific absorption coefficient in calctav.m, dataSpec_PDB.m

function Main=SIP_Main()

plot=1; % plot figure

% input leaf structural and biochemical traits
load('leaf_parameter.txt');
Cab   = leaf_parameter(1); Car   = leaf_parameter(2);
Anth  = leaf_parameter(3); Cbrown= leaf_parameter(4);
Cw    = leaf_parameter(5); Cm    = leaf_parameter(6);

LRT=SIP_Model(Cab,Car,Anth,Cbrown,Cw,Cm);

fileID = fopen('leaf_spectrum.txt','w');
fprintf(fileID,'Wavelength(nm)\tsingle scattering albedo\tReflectance\tTransmittance\n');
for wavelength = 400:2500
    fprintf(fileID,'%d\t%4.3f\t%4.3f\t%4.3f\n',LRT(wavelength - 400 + 1, :));
end
fclose(fileID);

if plot
    
    % plot leaf single scattering albedo
    figure;
    subplot(121)
    scatter(LRT(:,1),LRT(:,2));
    xlim([400,2400]);
    xticks([400:400:2400]);
    ylim([0,1]);
    yticks([0:0.2:1]);
    box on
    yticklabels({'0.0','0.2','0.4','0.6','0.8','1.0'});
    xlabel('Wavelength (nm)','FontName','Calibri','FontSize',14);
    ylabel('Leaf single scattering albedo','FontName','Calibri','FontSize',14);
    set(gca,'FontSize',14);
    set(gca,'LineWidth',1.2);
    
    % plot leaf reflectance
    subplot(122)
    yyaxis left
    scatter(LRT(:,1),LRT(:,3));
    xlim([400,2400]);
    xticks([400:400:2400]);
    ylim([0,1]);
    yticks([0:0.2:1]);
    box on
    yticklabels({'0.0','0.2','0.4','0.6','0.8','1.0'});
    xlabel('Wavelength (nm)','FontName','Calibri','FontSize',14);
    ylabel('Leaf reflectance','FontName','Calibri','FontSize',14);
    
    % plot leaf transmittance
    hold on
    yyaxis right
    scatter(LRT(:,1),1-LRT(:,4));
    xlim([400,2400]);
    xticks([400:400:2400]);
    ylim([0,1]);
    yticks([0:0.2:1]);
    box on
    yticklabels({'1.0','0.8','0.6','0.4','0.2','0.0'});
    xlabel('Wavelength (nm)','FontName','Calibri','FontSize',14);
    ylabel('Leaf transmittance','FontName','Calibri','FontSize',14);
    
    set(gca,'FontSize',14);
    set(gca,'LineWidth',1.2);
end
end