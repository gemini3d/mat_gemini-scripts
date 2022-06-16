function plan = buildfile
plan = buildplan(localfunctions);
end

function setupTask(~)
setup()
end

function testTask(~)
r = runtests;
assert(~isempty(r), "No tests found")
assertSuccess(r)
end
