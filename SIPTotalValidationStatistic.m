%% Plot all in situ leaf reflectance and transmittance
clear all;
clc;
RefInSitu=[];
TranInSitu=[];
RefSIP=[];
TranSIP=[];
Wavelength=400:2450;
Wavelength=Wavelength';
load('BestAngersdatasetSIP_defaultAntBrown.mat');
RefInSitu=[RefInSitu,totalRinsitu];
TranInSitu=[TranInSitu,totalTinsitu];
RefSIP=[RefSIP,totalRSIP];
TranSIP=[TranSIP,totalTSIP];
load('BestLopexdatasetSIP_defaultAntBrown.mat');
totalRinsitu=totalRinsitu(1:2051,:);
totalTinsitu=totalTinsitu(1:2051,:);
RefSIP=RefSIP(1:2051,:);
TranSIP=TranSIP(1:2051,:);

RefInSitu=[RefInSitu,totalRinsitu];
TranInSitu=[TranInSitu,totalTinsitu];
RefSIP=[RefSIP,RefSIP];
TranSIP=[TranSIP,TranSIP];

[indexx,indexy]=find(isnan(RefSIP));
RefSIP(:,indexy)=[];
TranSIP(:,indexy)=[];
RefInSitu(:,indexy)=[];
TranInSitu(:,indexy)=[];

%% Calculate Mean and Std
RefInSituAver=mean(RefInSitu,2);
TranInSituAver=mean(TranInSitu,2);
RefInSituStd=std(RefInSitu,0,2);
TranInSituStd=std(TranInSitu,0,2);
RefInSituTotal=[Wavelength,RefInSituAver,RefInSituStd];
TranInSituTotal=[Wavelength,1-TranInSituAver,TranInSituStd];

RefSIPAver=mean(RefSIP,2);
TranSIPAver=mean(TranSIP,2);
RefSIPStd=std(RefSIP,0,2);
TranSIPStd=std(TranSIP,0,2);
RefSIPTotal=[Wavelength,RefSIPAver,RefSIPStd];
TranSIPTotal=[Wavelength,1-TranSIPAver,TranSIPStd];

SIPtotal=[RefSIPTotal,TranSIPTotal];

outfileName='RefInsitu.txt';
dlmwrite(outfileName,RefInSituTotal);

outfileName='TranInsitu.txt';
dlmwrite(outfileName,TranInSituTotal);

outfileName='RefSIP.txt';
dlmwrite(outfileName,RefSIPTotal);

outfileName='TranSIP.txt';
dlmwrite(outfileName,TranSIPTotal);
