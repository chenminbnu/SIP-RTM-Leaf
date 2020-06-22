%% Vadliation p-based leaf reflectance model with Lopex dataset;
%% In situe dataset
clear all;
clc;
folder='..\..\data\Lopex1993\';
info='..\..\data\LDB_lopex1993.xls';
[ndata,text,alldata]=xlsread(info,'Database');
totalRSIP=[];
totalRinsitu=[];
totalTSIP=[];
totalTinsitu=[];
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
    Kall    = (Cab*Kab+Car*Kcar+Ant*Kant+Brown*KBrown+Cw*Kw+Cm*Km);
    
    %% Leaf reflectance && Leaf Transmittance
    Kall=Kall/N;
    j       = find(Kall>0);               % Non-conservative scattering (normal case)
    t1      = (1-Kall).*exp(-Kall);
    t2      = Kall.^2.*expint(Kall);
    tau     = ones(size(t1));
    tau(j)  = t1(j)+t2(j);
    talf    = calctav(40,nr);
    ralf    = 1-talf;
    t12     = calctav(90,nr);
    r12     = 1-t12;
    t21     = t12./(nr.^2);
    r21     = 1-t21;
    
    % top surface side
    denom   = 1-r21.*r21.*tau.^2;
    Ta      = talf.*tau.*t21./denom; %% ta
    Ra      = ralf+r21.*tau.*Ta;   %% ra
    
    % bottom surface side
    t       = t12.*tau.*t21./denom; %% tau90
    r       = r12+r21.*tau.*t;      %% r90
    
    
    Kallc=Kall*(N-1);         %% N-1 Layer
    w0=exp(-Kallc);
    
    fN=-0.1648.*N.^4+2.023 .*N.^3-9.405 .*N.^2+19.44.*N-11.79;
    fN=fN*ones(size(Ta,1),size(Ta,2));
    P=1-(1-exp(-fN))./fN;
    w=w0.*(1-P)./(1-P.*w0);
    
    p1=0.04551;
    p2=-0.5862;
    p3=2.531;
    p4=-3.739;
    p5=0.918;
    q=p1*N^4 + p2*N^3 + p3*N^2 + p4*N + p5;
    q1=q;
    q2=(q1.^2)^0.5;
    
    Rn=w.*(1/2+q1/2.*(1-P.*w0)./(1-q2.*P.*w0));
    Tn=w.*(1/2-q1/2.*(1-P.*w0)./(1-q2.*P.*w0));
    R=Ra+Ta.*Rn.*t./(1-r.*Rn);
    T=Ta.*Tn./(1-r.*Rn);
    
    R=R(1:size(InsituR,1));
    T=T(1:size(InsituR,1));
    
    if N>0
        totalRSIP=[totalRSIP,R];
        totalRinsitu=[totalRinsitu,InsituR];
        totalTSIP=[totalTSIP,T];
        totalTinsitu=[totalTinsitu,InsituT];
    end
end
save('BestLopexdatasetSIP_defaultAntBrown_N.mat','totalRSIP','totalRinsitu','totalTSIP','totalTinsitu');

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