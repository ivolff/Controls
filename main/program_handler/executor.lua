local settings = require "settings"
local state = require("main.program_handler.state")

local M = {}
local execution_queue = {}
local current_node = nil
local current_time_left = 0
local is_executing = false

local COMMAND_TYPE_TO_SETTINGS_KEY = {
    [state.types.UP] = "up",
    [state.types.LEFT] = "left",
    [state.types.DOWN] = "down",
    [state.types.RIGHT] = "right",
}

local function is_action_node(node)
    return node.type == state.types.UP
        or node.type == state.types.DOWN
        or node.type == state.types.LEFT
        or node.type == state.types.RIGHT
end

local function execute_node(node)
    if is_action_node(node) then
        msg.post(".", "character_input", {
            binding = node.type,
        })
    end
end

local function get_execution_time(node)
    local settings_key = COMMAND_TYPE_TO_SETTINGS_KEY[node.type]
    if not settings_key or not settings.command_execution_times then
        return 0
    end

    return settings.command_execution_times[settings_key] or 0
end

local function enqueue_node(num)
    table.insert(execution_queue, num)
end

local function finish_current_node()
    if not current_node then
        return
    end

    for _, next_num in ipairs(current_node.to) do
        enqueue_node(next_num)
    end

    current_node = nil
    current_time_left = 0
end

local function start_next_node()
    local num = table.remove(execution_queue, 1)
    local node = state.nodes[num]
    if not node then
        return false
    end

    current_node = node
    execute_node(node)
    current_time_left = get_execution_time(node)

    return true
end

function M.start(type)
    if is_executing then
        return
    end

    execution_queue = {}
    current_node = nil
    current_time_left = 0

    for _,v in ipairs(state.nodes) do
        if v.type == type then
            enqueue_node(v.num)
        end
    end

    is_executing = #execution_queue > 0
end

function M.execute(num)
    local node = state.nodes[num]
    if not node then
        return
    end

    execute_node(node)
end

function M.update(dt)
    if not is_executing then
        return
    end

    if current_node then
        current_time_left = current_time_left - dt
        if current_time_left > 0 then
            return
        end

        finish_current_node()
    end

    local steps_left = math.max(settings.max_execution_steps_per_update or 100, 1)
    while steps_left > 0 do
        if not start_next_node() then
            is_executing = false
            return
        end

        if current_time_left > 0 then
            return
        end

        finish_current_node()
        steps_left = steps_left - 1
    end
end

return M
