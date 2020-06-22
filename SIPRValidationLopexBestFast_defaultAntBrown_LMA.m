%% Vadliation p-based leaf reflectance model with Lopex dataset;
%% In situe dataset
clear all;
clc;
folder='..\..\data\Lopex1993\';
info='..\..\data\LDB_lopex1993.xls';
[ndata,text,alldata]=xlsread(info,'Database');
load('Bootstrap_Train_PvsLMA_AngerLopex.mat');

totalRSIP=[];
totalRinsitu=[];
totalTSIP=[];
totalTinsitu=[];
alpha=600;

for i=1:size(ndata,1)
    N=ndata(i,4);       %% Leaf layer
    Cab=ndata(i,7);    %% Chlorophyll (a+b)(cm-2.microg)
    Cw=ndata(i,10);   %% Water  (cm)
    Cm=ndata(i,11);   %% dry matter (cm-2.g)
    Car=ndata(i,8);     %% Carotenoids (cm-2.microg)
    Ant=0;     %% Anthocyanins (cm-2.microg)
    Brown=0.0;   %% brown pigments (arbitrary units)
    
    RfileName=[folder,'lo93r',sprintf('%04d',i),'.txt'];
    TfileName=[folder,'lo93t',sprintf('%04d',i),'.txt'];
    InsituR=importdata(RfileName);
    InsituT=importdata(TfileName);
    InsituR=InsituR(:,2);
    InsituT=InsituT(:,2);
    
    %% SIP model
    data    = dataSpec_PDB;
    lambda  = data(:,1);    nr      = data(:,2);
    Kab     = data(:,3);    Kcar    = data(:,4);
    Kant    = data(:,5);    KBrown  = data(:,6);
    Kw      = data(:,7);    Km      = data(:,8);
    Kall    = (Cab*Kab+Car*Kcar+Ant*Kant+Brown*KBrown+Cw*Kw+Cm*Km)/(Cm*alpha);
    
    W0=exp(-Kall);
    SimP=f(Cm);
    SimW=W0.*(1-SimP)./(1-SimP.*W0+eps); %% Single scattering albedo
    
    q1=-7/(1-2/9*exp(-85.12*Cm))+8;
    q2=(q1^2)^0.5;
    R=SimW.*(1/2+q1/2.*(1-SimP.*W0)./(1-q2.*SimP.*W0));
    T=SimW.*(1/2-q1/2.*(1-SimP.*W0)./(1-q2.*SimP.*W0));
    
    R=R(1:size(InsituR,1));
    T=T(1:size(InsituR,1));
    
    if N>0
        totalRSIP=[totalRSIP,R];
        totalRinsitu=[totalRinsitu,InsituR];
        totalTSIP=[totalTSIP,T];
        totalTinsitu=[totalTinsitu,InsituT];
    end
end
save('BestLopexdatasetSIP_defaultAntBrown_LMA.mat','totalRSIP','totalRinsitu','totalTSIP','totalTinsitu');

figure;
scatter(totalRinsitu(:),totalRSIP(:),0.1);
axis([0 1 0 1]);
set(gca,'ytick',0:0.2:1);
box on;
xlabel('Angers observations');
ylabel('SIP model');
hold on
z=0:0.1:1;
plot(z,z,'k');
title('Leaf reflectance (R)');

figure;
scatter(totalTinsitu(:),totalTSIP(:),0.1);
axis([0 1 0 1]);
set(gca,'ytick',0:0.2:1);
box on;
xlabel('Angers observations');
ylabel('SIP model');
hold on
z=0:0.1:1;
plot(z,z,'k');
title('Leaf Transmittance (T)');