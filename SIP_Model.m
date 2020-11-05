% _______________________________________________________________________
% SIP model
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


function LRT=SIP_Model(Cab,Car,Ant,Brown,Cw,Cm)

alpha=600; % constant for the the optimal size of the leaf scattering element 

% input specific absorption coefficient
data    = dataSpec_PDB;
lambda  = data(:,1);    nr      = data(:,2);
Kab     = data(:,3);    Kcar    = data(:,4);
Kant    = data(:,5);    KBrown  = data(:,6);
Kw      = data(:,7);    Km      = data(:,8);
Kall    = (Cab*Kab+Car*Kcar+Ant*Kant+Brown*KBrown+Cw*Kw+Cm*Km)/(Cm*alpha);
w0=exp(-Kall);

% spectral invariant parameters
fLMA=2765.0*Cm;
gLMA=102.8*Cm;
p=1-(1-exp(-fLMA))./(fLMA+eps);
q=1-2*exp(-gLMA);
qabs=(q^2)^0.5;

% leaf single scattering albedo
w=w0.*(1-p)./(1-p.*w0+eps); 

% leaf reflectance and leaf transmittance
refl=w.*(1/2+q/2.*(1-p.*w0)./(1-qabs.*p.*w0));
tran=w.*(1/2-q/2.*(1-p.*w0)./(1-qabs.*p.*w0));

LRT     = [lambda w refl tran];

