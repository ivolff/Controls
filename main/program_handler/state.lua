local M = {}

M.types = {
    W = 1,
    A = 2,
    S = 3,
    D = 4,
    UP= 5,
    LEFT = 6,
    DOWN = 7,
    RIGHT = 8,
}


M.nodes = {}

function M.add_node(type)
    local new_node = {
        from = {},
        to = {},
        type = type,
        num = #M.nodes + 1
    }

    table.insert(M.nodes, new_node)
    return new_node.num
end

function M.add_connection(from, to)
    table.insert(M.nodes[from].to, to)
    table.insert(M.nodes[to].from, from)
end

function M.remove_connection(from, to)
    for k,v in pairs(M.nodes[from].to) do
        if v == to then
            table.remove(M.nodes[from].to, k)
        end
    end

    for k,v in pairs(M.nodes[to].from) do
        if v == from then
            table.remove(M.nodes[to].from, k)
        end
    end
end

return M