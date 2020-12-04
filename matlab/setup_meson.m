function setup_meson(srcdir, builddir)
%% setup using Meson+Fortran compiler

validateattributes(srcdir,{'char'},{'vector'})
validateattributes(builddir,{'char'},{'vector'})

[flag,out] = system('meson --v');
if flag==0 disp(['MESON version: ',out 10]); else error(out); end

[flag,out] = system('ninja --version');
if flag==0 disp(['NINJA version: ',out 10]); else error(out); end

disp(['Dependencies check successfull.' 10,...
    'If the installation fails, upgrade to the latest versions of the packages',...
    10]);

[status, ret] = system(['meson setup ',builddir,' ',srcdir]);
if status~=0, error(ret), end
disp(ret)

[status, ret] = system(['ninja -C ',builddir]);
if status~=0, error(ret), end
disp(ret)

disp('Fortran compilation complete')

disp('Testing the Fortran executable and the MATLAB Wrapper');

    try 
    test_mod;

    disp('Testing glow.m: This function allows you to input a mono-energetic beam');
    test_glow;

    disp('Testing glowenergy.m: This function allows you to input an energy spectra of your choice.');
    test_glow_energy_spectra;
    
    catch ME
        
        disp([10 'Tests unsuccessful' 10]);
        getReport(ME);
    
    end
end
