%% simple
time = datenum(2015,12,13,10,0,0);
glat = 65.1;
glon = -147.5;
Ap = 4;
f107 = 100;
f107a = 100;
f107p = 100;
Q = 1;
Echar = 100e3;
Nbins = 250;

cwd = fileparts(mfilename('fullpath'));
addpath([cwd, filesep, '..', filesep, 'matlab'])

iono = glow(time, glat, glon, f107a, f107, f107p, Ap, Q, Echar, Nbins);

i = 32-1;

assert(abs(iono.altkm(i)  -  101.8) < 0.1, 'wrong altitude?')
assert(abs(iono.Tn(i)  - 188.) < 0.01, 'Tn error')
assert(abs(iono.A5577(i) - 20.45) < 0.0001,  'A5577 error')
assert(abs(iono.ionrate(i) - 335.) < 0.01, 'ionrate error')
