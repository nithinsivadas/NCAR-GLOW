%% Glow Fortran Tests
clear all;
time = datenum(2008,03,26,11,0,0);
glat = 65.1;
glon = -147.5;
Ap = 4;
%% solar radio flux [10-22 W m-2]
f107 = 100;
f107a = 100;
f107p = 100;

%% energy [eV]
energyBin = logspace(1,6,250);
Echar1 = 1e3;
Echar2 = 100e3;

%% Number of energy bins
Nbins = length(energyBin);
Q = 1; %% energy flux [erg cm-2 == mW m-2  
numberFlux1 = (Q*1e-3*1e-4./(1.6e-19))./Echar1; %[cm-2 s-1]
numberFlux2 = (Q*1e-3*1e-4./(1.6e-19))./Echar2; %[cm-2 s-1]
phitop = zeros(1,Nbins);
[~,iE1] = min(abs(energyBin-Echar1));
[~,iE2] = min(abs(energyBin-Echar2));
binWidth = diff(energyBin);
binWidth(Nbins) = binWidth(Nbins-1);
phitop(iE1) = numberFlux1./binWidth(iE1);
phitop(iE2) = numberFlux2./binWidth(iE2);

%% Running GLOW Energy - directly inputs energy spectra of your choosing

output = glowenergy(time, glat, glon, f107a, f107, f107p, Ap, energyBin, phitop);

%%
%% Plotting
figureHandle = figure;
figureHandle.Units='normalized';

subplot(1,3,1);
loglog(output.energyBin,output.phitop+0.01);
xlabel('Energy [eV]');
ylabel({'Differential number flux of precipitating electrons','[cm^{-2} s^{-1} eV^{-1}]'});
set(gca,'XTick',[10^0,10^2,10^4,10^6],'XLim',[10^0,10^6],'YLim',[10^0,10^8]);

subplot(1,3,2);
plot(output.totalIonizationRate,output.alt);
xlabel({'Total Ionization Rate','[cm^{-3}s^{-1}]'});
ylabel({'Altitude [km]'});
title('Testing glowenergy.m');

subplot(1,3,3);
plot(output.A5577,output.alt,'g');
hold on;
plot(output.A4278,output.alt,'b');
hold on;
plot(output.A6300,output.alt,'r');
xlabel({'Volume Emission Rate','[cm^{-3}s^{-1}]'});
ylabel({'Altitude [km]'});
legend('5577 A^{\circ}','4278 A^{\circ}','6300 A^{\circ}');

figureHandle.Position = figureHandle.Position+[-0.25, 0, +0.25, 0];



% function [ener, del] = egrid(nbins)
%     for n=1:1:nbins
%         if n <= 21
%             ener(n) = 0.5*n;
%         else
%             ener(n) = exp(0.05 * (n+26));
%         end
%     end
%     
%     del(1) = 0.5;
%     
%     for n=2:1:nbins
%         del(n) = ener(n) - ener(n-1);
%     end
%     
%     for n=1:1:nbins
%         ener(n) = ener(n) -del(n)/2.0;
%     end
%     
% end
% 
% function [iono] = parse_data(dat)
%     datstr.input1  =  dat(regexp(dat,'Input1:')+7:regexp(dat,'Input2:')-1);
%     datstr.input2  =  dat(regexp(dat,'Input2:')+7:regexp(dat,'Output1:')-1);
%     datstr.output1 = dat(regexp(dat,'Output1:')+8:regexp(dat,'Output2:')-1);
%     datstr.output2 = dat(regexp(dat,'Output2:')+8:regexp(dat,'Output3:')-1);
% %     datstr.output3 = dat(regexp(dat,'Output3:')+8:regexp(dat,'Output4:')-1);
% %     datstr.output4 = dat(regexp(dat,'Output4:')+8:regexp(dat,'Output5:')-1);
% %     datstr.output5 = dat(regexp(dat,'Output5:')+8:end);
%     
%     % input1
%     [buff, pos] = textscan(datstr.input1,'%s',5);
%     [Nbins, temp] =  textscan(datstr.input1(pos+1:end),'%f',1);
%     pos = pos + temp;
%     [NAlt, temp] =  textscan(datstr.input1(pos+1:end),'%f',1);
%     pos = pos + temp;
%     input1 = cell2mat(textscan(datstr.input1(pos+1:end),repmat('%f ',1,Nbins{1})));
%     
%     
%     iono.Nbins = Nbins{1};
%     iono.NAlt = NAlt{1};
%     iono.deltaE = input1(1,:);
%     iono.energyBin = input1(2,:);
%     iono.phitop = input1(3,:);
%     
%     input2 = cell2mat(textscan(datstr.input2(regexp(datstr.input2,' ec')+3:end),'%f'));
%     iono.idate = input2(1);
%     iono.time = input2(2);
%     iono.glat = input2(3);
%     iono.glon = input2(4);
%     iono.f107a = input2(5);
%     iono.f107 = input2(6);
%     iono.f107p = input2(7);
%     iono.ap = input2(8);
%     
%     output1 = cell2mat(textscan(datstr.output1(regexp(datstr.output1,'Hall')+4:end),repmat('%f ',1,14)));
%     iono.alt = output1(:,1); %km
%     iono.Tn  = output1(:,2); %K
%     iono.Ne  = output1(:,6); % electron density at each alt; cm-3
%     iono.NeCalc = output1(:,7); %electron density, calculated below 200 km, a priori above; cm-3
%     iono.totalIonizationRate = output1(:,8); %total ionization rate at each altitude (TPI+TEI), cm-3 s-1
%     iono.pedersen = output1(:,13); 
%     iono.hall = output1(:,14);
%     
%     output2 = cell2mat(textscan(datstr.output2(regexp(datstr.output2,'1304')+4:end),repmat('%f ',1,16)));
%     % array of volume emission rates at each altitude; cm-3 s-1:
%     iono.A4278 = output2(:,3); 
%     iono.A5577 = output2(:,5);
%     iono.A6300 = output2(:,6);
%     
% end