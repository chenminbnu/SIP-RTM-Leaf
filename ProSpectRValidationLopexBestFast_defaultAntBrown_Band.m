%% Vadliation ProSpect leaf-scale optical spectra model with in situ LOPEX dataset for three broadband windows
%% Load in situ spectra dataset
clear all;
clc;
folder='..\..\data\Lopex1993\';
info='..\..\data\LDB_lopex1993.xls';
[ndata,text,alldata]=xlsread(info,'Database');
% VIS: 400-700 nm; NIR: 700-1200 nm; SWNIR: 1200:2500 nm
totalRProSpectVIS=[];
totalRinsituVIS=[];
totalRProSpectNIR=[];
totalRinsituNIR=[];
totalRProSpectSWNIR=[];
totalRinsituSWNIR=[];
totalTProSpectVIS=[];
totalTinsituVIS=[];
totalTProSpectNIR=[];
totalTinsituNIR=[];
totalTProSpectSWNIR=[];
totalTinsituSWNIR=[];
for i=1:size(ndata,1)
    
    RfileName=[folder,'lo93r',sprintf('%04d',i),'.txt'];
    TfileName=[folder,'lo93t',sprintf('%04d',i),'.txt'];
    InsituR=importdata(RfileName);
    InsituT=importdata(TfileName);
    InsituR=InsituR(:,2);
    InsituT=InsituT(:,2);
    
    N=ndata(i,4);       %% Leaf layer
    Cab=ndata(i,7);    %% Chlorophyll (a+b)(cm-2.microg)
    Cw=ndata(i,10);   %% Water  (cm)
    Cm=ndata(i,11);   %% dry matter (cm-2.g)
    Car=ndata(i,8);     %% Carotenoids (cm-2.microg)
    Brown=0.0;   %% brown pigments (arbitrary units)
    Ant=0.0;     %% Anthocyanins (cm-2.microg)
    
    %% ProSpect model
    LRT=prospect_DB(N,Cab,Car,Ant,Brown,Cw,Cm);
    R=LRT(:,2);
    T=LRT(:,3);
    R=R(1:size(InsituR,1));
    T=T(1:size(InsituR,1));
    LRT=LRT(1:size(InsituR,1),:);
    if N>0
        totalRProSpectVIS=[totalRProSpectVIS,R(1:300)];
        totalRinsituVIS=[totalRinsituVIS,InsituR(1:300)];
        totalRProSpectNIR=[totalRProSpectNIR,R(301:800)];
        totalRinsituNIR=[totalRinsituNIR,InsituR(301:800)];
        totalRProSpectSWNIR=[totalRProSpectSWNIR,R(801:end)];
        totalRinsituSWNIR=[totalRinsituSWNIR,InsituR(801:end)];
        totalTProSpectVIS=[totalTProSpectVIS,T(1:300)];
        totalTinsituVIS=[totalTinsituVIS,InsituT(1:300)];
        totalTProSpectNIR=[totalTProSpectNIR,T(301:800)];
        totalTinsituNIR=[totalTinsituNIR,InsituT(301:800)];
        totalTProSpectSWNIR=[totalTProSpectSWNIR,T(801:end)];
        totalTinsituSWNIR=[totalTinsituSWNIR,InsituT(801:end)];
    end
    i
end
save('BestLopexdatasetProSpect_defaultAntBrown_Band.mat','totalRProSpectVIS','totalRinsituVIS','totalRProSpectNIR','totalRinsituNIR','totalRProSpectSWNIR','totalRinsituSWNIR','totalTProSpectVIS','totalTinsituVIS','totalTProSpectNIR','totalTinsituNIR','totalTProSpectSWNIR','totalTinsituSWNIR');

figure;
scatter(totalRinsituVIS(:),totalRProSpectVIS(:),0.1);
axis([0 1 0 1]);
set(gca,'ytick',0:0.2:1);
box on;
xlabel('Angers observations');
ylabel('ProSpect model');
hold on
z=0:0.1:1;
plot(z,z,'k');
title('Leaf reflectance (R)');

figure;
scatter(totalTinsituVIS(:),totalTProSpectVIS(:),0.1);
axis([0 1 0 1]);
set(gca,'ytick',0:0.2:1);
box on;
xlabel('Angers observations');
ylabel('ProSpect model');
hold on
z=0:0.1:1;
plot(z,z,'k');
title('Leaf Transmittance (T)');