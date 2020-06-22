%% Plot all in situ leaf reflectance and transmittance
clear all;
clc;
RefInSitu=[];
TranInSitu=[];
RefProSpect=[];
TranProSpect=[];
Wavelength=400:2450;
Wavelength=Wavelength';
load('BestAngersdatasetProSpect_defaultAntBrown.mat');
RefInSitu=[RefInSitu,totalRinsitu];
TranInSitu=[TranInSitu,totalTinsitu];
RefProSpect=[RefProSpect,totalRProSpect];
TranProSpect=[TranProSpect,totalTProSpect];
load('BestLopexdatasetProSpect_defaultAntBrown.mat');
totalRinsitu=totalRinsitu(1:2051,:);
totalTinsitu=totalTinsitu(1:2051,:);
RefProSpect=RefProSpect(1:2051,:);
TranProSpect=TranProSpect(1:2051,:);

RefInSitu=[RefInSitu,totalRinsitu];
TranInSitu=[TranInSitu,totalTinsitu];
RefProSpect=[RefProSpect,RefProSpect];
TranProSpect=[TranProSpect,TranProSpect];

[indexx,indexy]=find(isnan(RefProSpect));
RefProSpect(:,indexy)=[];
TranProSpect(:,indexy)=[];
RefInSitu(:,indexy)=[];
TranInSitu(:,indexy)=[];

%% Calculate Mean and Std
RefInSituAver=mean(RefInSitu,2);
TranInSituAver=mean(TranInSitu,2);
RefInSituStd=std(RefInSitu,0,2);
TranInSituStd=std(TranInSitu,0,2);
RefInSituTotal=[Wavelength,RefInSituAver,RefInSituStd];
TranInSituTotal=[Wavelength,1-TranInSituAver,TranInSituStd];

RefProSpectAver=mean(RefProSpect,2);
TranProSpectAver=mean(TranProSpect,2);
RefProSpectStd=std(RefProSpect,0,2);
TranProSpectStd=std(TranProSpect,0,2);
RefProSpectTotal=[Wavelength,RefProSpectAver,RefProSpectStd];
TranProSpectTotal=[Wavelength,1-TranProSpectAver,TranProSpectStd];

ProSpecttotal=[Wavelength,RefProSpectTotal,TranProSpectTotal];

outfileName='RefProSpect.txt';
dlmwrite(outfileName,RefProSpectTotal);

outfileName='TranProSpect.txt';
dlmwrite(outfileName,TranProSpectTotal);