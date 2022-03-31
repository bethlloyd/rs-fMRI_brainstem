t = timer;
t.StartDelay = 1800;
%t.TasksToExecute = 1;
t.ExecutionMode = 'SingleShot';
t.TimerFcn = @(src, event) run('run_fcwml_skullstrip');
start(t);
