classdef TestLint < matlab.unittest.TestCase

properties
TestData
end

properties (TestParameter)
file = get_files()
end

methods (TestClassSetup)

function get_cfg(tc)

cwd = fileparts(mfilename('fullpath'));
cfg_file = fullfile(cwd, "MLint.txt");

if isfile(cfg_file)
  tc.TestData.cfg_file = cfg_file;
else
  tc.TestData.cfg_file = string.empty;
end

end

end


methods (Test)

function test_lint(tc, file)

if isempty(tc.TestData.cfg_file)
  res = checkcode(file, "-fullpath");
else
  res = checkcode(file, "-config=" + tc.TestData.cfg_file, "-fullpath");
end

for j = 1:length(res)
  tc.verifyFail(append(file, ":", int2str(res(j).line), " ", res(j).message))
end
end

end

end


function filenames = get_files()
flist = dir(fullfile(fileparts(mfilename('fullpath')), '/**/*.m'));
for i = 1:length(flist)
 filenames{i} = fullfile(flist(i).folder, flist(i).name); %#ok<AGROW>
end
end
