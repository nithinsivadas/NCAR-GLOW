%% MATLAB Test
time = datenum(2015,12,13,10,0,0);
glat = 65.1;
glon = -147.5;
Ap = 7;
f107 = 118.7;
f107a = 78.7;
f107p = 113.1;
Q = 1;
Echar = 100e3;
Nbins = 250;

cwd = fileparts(mfilename('fullpath'));
addpath([cwd, filesep, '..', filesep, 'matlab'])

iono = glow(time, glat, glon, f107a, f107, f107p, Ap, Q, Echar, Nbins);

[~,i] = min(abs(iono.alt-100)); % Find altitude closest to 100

assert(abs(iono.alt(i)  -  100.7) < 0.1, ['alt_km: expected 100.7, but got: ', num2str(iono.alt(i))])
assert(abs(iono.Tn(i)  - 187.) < 0.01, ['Tn: expected 187., but got: ', num2str(iono.Tn(i))])
assert(abs(iono.A5577(i) - 87.71) < 0.0001,   ['A5577: expected 87.71, but got: ', num2str(iono.A5577(i))])
assert(abs(iono.totalIonizationRate(i) - 820.) < 0.01, ['ionrate: expected 820. but got: ', num2str(iono.totalIonizationRate(i))])
assert(abs(iono.hall(i) - 1.1100e-4) < 1e-7, ['hall: expected 1.1100e-4 but got: ', num2str(iono.hall(i))])

disp('MATLAB Test Successful!');