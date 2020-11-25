
cwd = fileparts(mfilename('fullpath'));

srcdir =   [cwd, filesep,'..'];
builddir = [cwd, filesep,'..',filesep,'build'];

assert(exist(srcdir,'dir')==7, ['source directory ',srcdir,' does not exist'])

if exist(builddir,'dir')~=7
    disp(['build directory ',builddir,' does not exist, creating one' 10]);
    mkdir(builddir);
end

%Checking dependencies
disp(['Checking dependencies on packages... ' 10]);
% gcc
[flag,out] = system('gcc --version');
if flag==0 disp(['GCC version: ',out 10]); else error(out); end

% gfortran
[flag,out] = system('gfortran --version');
if flag==0 disp(['GFORTRAN version: ',out 10]); else error(out); end

addpath(genpath(srcdir));

try
  setup_meson(srcdir, builddir)
catch
  setup_cmake(srcdir, builddir)
end
