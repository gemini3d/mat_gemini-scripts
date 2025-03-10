function plan = buildfile
plan = buildplan(localfunctions);
plan.DefaultTasks = "setup";

if ~isMATLABReleaseOlderThan("R2024a")
  plan("check") = matlab.buildtool.tasks.CodeIssuesTask(plan.RootFolder, IncludeSubfolders=true, ...
      WarningThreshold=0, Results="CodeIssues.sarif");
end

end


function setupTask(context)

addpath(context.Plan.RootFolder)

mat_gemini = fullfile(context.Plan.RootFolder, "mat_gemini");
matbf = fullfile(mat_gemini, "buildfile.m");

if ~isfile(matbf)
  ok = system("git -C " + context.Plan.RootFolder + " submodule update --init --recursive");
  assert(ok == 0, "Failed to update MatGemini Git submodule");
end

buildtool("-buildFile", mat_gemini, "setup")

end
