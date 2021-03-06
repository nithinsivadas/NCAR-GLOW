function iono = glow(time, glat, glon, f107a, f107, f107p, Ap, energyFlux, Echar, nEnergyBins)

% energyFlux  - Energy flux is units of erg cm-2 , mW m-2
% Echar       - characteristic energy is in [eV]
% nEnergyBins - Number of energy bins between 1 eV and 1 MeV

validateattributes(glat, {'numeric'}, {'scalar'})
validateattributes(glon, {'numeric'}, {'scalar'})
validateattributes(f107, {'numeric'}, {'positive', 'scalar'})
validateattributes(f107a, {'numeric'}, {'positive', 'scalar'})
validateattributes(f107p, {'numeric'}, {'positive', 'scalar'})
validateattributes(Ap, {'numeric'}, {'positive', 'scalar'})
validateattributes(energyFlux, {'numeric'}, {'positive', 'scalar'}) % [erg cm-2 == mW m-2]
validateattributes(Echar, {'numeric'}, {'positive', 'scalar'})
validateattributes(nEnergyBins, {'numeric'}, {'positive', 'integer', 'scalar'})
%% Convert energy flux of mono-energetic beam into number flux input
Phitop = zeros(1,nEnergyBins);
energyBin = logspace(1,6,nEnergyBins);
[~,iEnergyBin] = min(abs(energyBin-Echar)); % Echar - characterostoc energy in [eV]
binWidth = diff(energyBin);
binWidth(nEnergyBins) = binWidth(nEnergyBins-1);
numberFlux = (energyFlux*1e-3*1e-4./(1.6e-19))./Echar; %[cm-2 s-1]
%[cm-2 s-1] = [mW m-2]*[W/mW]*[cm-2/m-2]*[eV/J]/[eV]
Phitop(iEnergyBin) =  numberFlux./binWidth(iEnergyBin); % [cm-2 s-1 eV-1]

%% binary
iono = glowenergy(time, glat, glon, f107a, f107, f107p, Ap, energyBin, Phitop);
end
