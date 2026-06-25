local state = require("main.program_handler.state")

local M = {}

function M.start(type)
    print("executing", type)
    pprint("state.nodes: ", state.nodes)
    for k,v in pairs(state.nodes) do
        if v.type == type then
            M.execute(k)
        end
    end
end

function M.execute(num)
    local node = state.nodes[num]
    if node.type == state.types.W or node.type == state.types.A or node.type == state.types.S or node.type == state.types.D then

    elseif node.type == state.types.UP or node.type == state.types.DOWN or node.type == state.types.LEFT or node.type == state.types.RIGHT then
            msg.post(".", "character_input"
            , {
                binding = node.type,
            })    
    end

    for k,v in pairs(node.to) do
        M.execute(v)
    end
end

return M