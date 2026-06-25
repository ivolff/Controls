local M = {}

M.move_step = 16

M.command_execution_times = {
	up = 0.25,
	left = 0.25,
	down = 0.25,
	right = 0.25,
}

M.max_execution_steps_per_update = 100

M.bindings = {
	w = true,
	a = true,
	s = true,
	d = true,
}

M.pressed = {
	w = false,
	a = false,
	s = false,
	d = false,
}

return M
