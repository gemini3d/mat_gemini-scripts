function setup()
%% configure paths to work with MatGemini

cwd = fileparts(mfilename("fullpath"));
addpath(cwd)

gemini_matlab = getenv("MATGEMINI");
if isempty(gemini_matlab)
  gemini_matlab = fullfile(cwd, "../mat_gemini");
end

setup_file = fullfile(gemini_matlab, "setup.m");

assert(isfile(setup_file), "please set the environment variable MATGEMINI to the path to the mat_gemini project directory. See README.md for how to get mat_gemini.")

run(setup_file)

end
