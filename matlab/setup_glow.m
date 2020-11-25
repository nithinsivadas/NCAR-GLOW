
cwd = fileparts(mfilename('fullpath'));

srcdir =   [cwd, filesep,'..'];
builddir = [cwd, filesep,'..',filesep,'build'];

assert(exist(srcdir,'dir')==7, ['source directory ',srcdir,' does not exist'])

if exist(builddir,'dir')==7
    disp(['build directory ',builddir,' does not exist, creating one']);
    mkdir(builddir);
end

addpath(genpath(srcdir));

try
  setup_meson(srcdir, builddir)
catch
  setup_cmake(srcdir, builddir)
end
