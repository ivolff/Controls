local M = {}

M.move_step = 16

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
