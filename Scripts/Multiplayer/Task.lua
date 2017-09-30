TaskEntry = {
	nInterval = 0,
	nDelay = 0,
	nNextrun = 0,
	sCommand = "",
}

TaskList = {
	lTasks = {},
	nCycle = 0,
	nNextId = 1,
}

function TaskList:AddTask(delay, interval, command)
	System:LogAlways("*** New Task "..TaskList.nNextId.." "..command);
	local newEntry = new(TaskEntry);
	newEntry.nInterval = interval;
	newEntry.nDelay = delay;
	newEntry.nNextrun = TaskList.nCycle+delay;
	newEntry.sCommand = command;
	TaskList.lTasks[TaskList.nNextId] = newEntry;
	TaskList.nNextId = TaskList.nNextId+1;
end

function TaskList:OnUpdate()
	
	local cycle = TaskList.nCycle+1;

	for id, task in TaskList.lTasks do
		if(task.nNextrun < cycle) then
			System:ExecuteCommand(task.sCommand);
			task.nNextrun = TaskList.nCycle+task.nInterval;
		end
	end

	TaskList.nCycle = cycle;

end

function TaskList:AddRAWTask(line)

	if(line) then	
		toktable = tokenize(line);
		if(toktable[1] and toktable[2] and toktable[3]) then
			local delay = tonumber(toktable[1]);
			local interval = tonumber(toktable[2]);
	
			if(delay and interval) then
				tremove(toktable, 1);
				tremove(toktable, 1);

				local command = untokenize(toktable);
	
				TaskList:AddTask(delay, interval, command);
			else
				TaskList:Error();
			end
		else
			TaskList:Error();
		end
	else
		TaskList:Error();
	end
end

function TaskList:Error()
--	System:LogAlways("Incorrect parameters");
--	System:LogAlways("Usage: sv_task <delay> <interval> <command>");
end

function TaskList:Save()
	System:LogAlways("*** Saving tasklist");
	local taskfile = openfile("task.txt", "w");
	
	if(taskfile) then 
		for id, task in TaskList.lTasks do
			write(taskfile, task.nDelay.." "..task.nInterval.." "..task.sCommand.."\n");
		end
		closefile(taskfile);
	end

end

function TaskList:List()
	System:LogAlways("*** Current Tasklist");
	System:LogAlways("delay | interval | nextrun | command");

	for id, task in TaskList.lTasks do
		System:LogAlways(task.nDelay.." "..task.nInterval.." "..(task.nNextrun-TaskList.nCycle).." " ..task.sCommand.."\n");
	end
	

end

function TaskList:Load()
	System:LogAlways("*** Reloading tasklist");
	local taskfile = openfile("task.txt", "r");
	
	if(taskfile) then

		TaskList.lTasks = {};		
		TaskList.nNextId = 1

		local line = read(taskfile, "*l");
		while(line) do
			TaskList:AddRAWTask(line);
			line = read(taskfile, "*l");
		end
		closefile(taskfile);
	end
end

Game:AddCommand("sv_task","TaskList:AddRAWTask(%line);","sv_addtask <delay> <interval> <command>");
Game:AddCommand("sv_tasksave","TaskList:Save();","sv_tasksave");
Game:AddCommand("sv_taskreload","TaskList:Load();","sv_taskreload");
Game:AddCommand("sv_tasklist","TaskList:List();","sv_tasklist");

local nHpkEnable = tonumber(getglobal("gr_task_autoload"));
if ( nHpkEnable == 1) then
	TaskList:Load();
end
