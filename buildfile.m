function plan = buildfile
plan = buildplan(localfunctions);
plan.DefaultTasks = "test";
plan("test").Dependencies = ["check", "setup"];
end

function checkTask(~)
% Identify code issues (recursively all Matlab .m files)
issues = codeIssues;
assert(isempty(issues.Issues),formattedDisplayText(issues.Issues))
end

function setupTask(~)
setup()
end

function testTask(~)
r = runtests;
assert(~isempty(r), "No tests found")
assertSuccess(r)
end
