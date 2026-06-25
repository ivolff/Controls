local settings = require "settings"
local state = require("main.program_handler.state")

local M = {}
local executions = {}

local COMMAND_TYPE_TO_SETTINGS_KEY = {
    [state.types.UP] = "up",
    [state.types.LEFT] = "left",
    [state.types.DOWN] = "down",
    [state.types.RIGHT] = "right",
    [state.types.SHOOT] = "shoot",
    [state.types.ROTATE_LEFT] = "rotate_left",
    [state.types.ROTATE_RIGHT] = "rotate_right",
}

local function is_action_node(node)
    return node.type == state.types.UP
        or node.type == state.types.DOWN
        or node.type == state.types.LEFT
        or node.type == state.types.RIGHT
        or node.type == state.types.SHOOT
        or node.type == state.types.ROTATE_LEFT
        or node.type == state.types.ROTATE_RIGHT
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

local function enqueue_node(execution, num)
    table.insert(execution.queue, num)
end

local function finish_current_node(execution)
    if not execution.current_node then
        return
    end

    for _, next_num in ipairs(execution.current_node.to) do
        enqueue_node(execution, next_num)
    end

    execution.current_node = nil
    execution.current_time_left = 0
end

local function start_next_node(execution)
    while #execution.queue > 0 do
        local num = table.remove(execution.queue, 1)
        local node = state.nodes[num]
        if node and not node.deleted then
            execution.current_node = node
            execute_node(node)
            execution.current_time_left = get_execution_time(node)

            return true
        end
    end

    return false
end

function M.start(type)
    local execution = {
        queue = {},
        current_node = nil,
        current_time_left = 0,
    }

    for _,v in ipairs(state.nodes) do
        if not v.deleted and v.type == type then
            enqueue_node(execution, v.num)
        end
    end

    if #execution.queue > 0 then
        table.insert(executions, execution)
    end
end

function M.execute(num)
    local node = state.nodes[num]
    if not node or node.deleted then
        return
    end

    execute_node(node)
end

local function update_execution(execution, dt)
    local steps_left = math.max(settings.max_execution_steps_per_update or 100, 1)

    if execution.current_node then
        execution.current_time_left = execution.current_time_left - dt
        if execution.current_time_left > 0 then
            return true
        end

        finish_current_node(execution)
    end

    while steps_left > 0 do
        if not start_next_node(execution) then
            return false
        end

        if execution.current_time_left > 0 then
            return true
        end

        finish_current_node(execution)
        steps_left = steps_left - 1
    end

    return true
end

function M.update(dt)
    for index = #executions, 1, -1 do
        if not update_execution(executions[index], dt) then
            table.remove(executions, index)
        end
    end
end

return M
