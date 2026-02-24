function plan = buildfile
plan = buildplan(localfunctions);
plan.DefaultTasks = "setup";

assert(~isMATLABReleaseOlderThan("R2024b"), "Matlab >= R2024b needed for auto-setup")

plan("check") = matlab.buildtool.tasks.CodeIssuesTask(plan.RootFolder, IncludeSubfolders=true, ...
    WarningThreshold=0, Results="CodeIssues.sarif");

end


function setupTask(context)

addpath(context.Plan.RootFolder)

mat_gemini = fullfile(context.Plan.RootFolder, "mat_gemini");
matbf = fullfile(mat_gemini, "buildfile.m");

if ~isfile(matbf)
  % Matlab R2025a has only a GUI submodule update - don't want gitpull() though that updates submodules
  ok = system("git -C " + context.Plan.RootFolder + " submodule update --init --recursive");
  assert(ok == 0, "Failed to update MatGemini Git submodule");
end

buildtool("-buildFile", mat_gemini, "setup")

end
