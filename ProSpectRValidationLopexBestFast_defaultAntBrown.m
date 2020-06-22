%% Vadliation ProSpect leaf reflectance model with Lopex dataset;
%% In situe dataset
clear all;
clc;
folder='..\..\data\Lopex1993\';
info='..\..\data\LDB_lopex1993.xls';
[ndata,text,alldata]=xlsread(info,'Database');
totalRProSpect=[];
totalRinsitu=[];
totalTProSpect=[];
totalTinsitu=[];
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
        totalRProSpect=[totalRProSpect,R];
        totalRinsitu=[totalRinsitu,InsituR];
        totalTProSpect=[totalTProSpect,T];
        totalTinsitu=[totalTinsitu,InsituT];
    end
    i
end
save('BestLopexdatasetProSpect_defaultAntBrown.mat','totalRProSpect','totalRinsitu','totalTProSpect','totalTinsitu');
scatter(totalRinsitu(:),totalRProSpect(:),0.1);
box on;
axis([0 1 0 1]);
set(gca,'ytick',0:0.2:1);
xlabel('Lopex observations');
ylabel('ProSpect model');
hold on
z=0:0.1:1;
plot(z,z,'k');
title('Leaf reflectance (R)');


figure;
scatter(totalTinsitu(:),totalTProSpect(:),0.1);
box on;
axis([0 1 0 1]);
set(gca,'ytick',0:0.2:1);
xlabel('Lopex observations');
ylabel('ProSpect model');
hold on
z=0:0.1:1;
plot(z,z,'k');
title('Leaf Transmittance (T)');
