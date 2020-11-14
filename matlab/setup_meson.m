function setup_meson(srcdir, builddir)
%% setup using Meson+Fortran compiler

validateattributes(srcdir,{'char'},{'vector'})
validateattributes(builddir,{'char'},{'vector'})


[status, ret] = system(['meson setup ',builddir,' ',srcdir]);
if status~=0, error(ret), end
disp(ret)

[status, ret] = system(['ninja -C ',builddir]);
if status~=0, error(ret), end
disp(ret)

disp('Fortran compilation complete')

disp('Testing the Fortran executable and the MATLAB Wrapper');
test_mod;

disp('Testing glow.m: This function allows you to input a mono-energetic beam');
test_glow;

disp('Testing glowenergy.m: This function allows you to input an energy spectra of your choice.');
test_glow_energy_spectra;

end
