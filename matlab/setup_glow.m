
cwd = fileparts(mfilename('fullpath'));

srcdir =   [cwd, filesep,'..'];
builddir = [cwd, filesep,'..',filesep,'build'];

assert(exist(srcdir,'dir')==7, ['source directory ',srcdir,' does not exist'])
assert(exist(builddir,'dir')==7, ['build directory ',builddir,' does not exist'])

addpath(genpath(srcdir));

try
  setup_meson(srcdir, builddir)
catch
  setup_cmake(srcdir, builddir)
end
