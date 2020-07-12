require "Factory\\TileFactory"

NodeFactory = {}

--- @param t 当前第个单元的类型
function NodeFactory:CreatNode(x, y, t)
    local node = {}
    node.__index = node
    node.X = x
    node.Y = y
    --- 启发距离
    node.H = 0
    --- 实际距离
    node.G = 0
    --- 预测距离
    function node:F()
        return self.H + self.G
    end
    --- 相邻单元（无对角单元）
    node.Around = {}
    --- 父节点，标记一下可以使用
    node.ParentNode = nil

    node.tileData = TileFactory:fun_CreatTileBase(t)

    function node:fun_HasParentNode()
        if self.ParentNode ~= nil then
            return true
        end
        return false
    end

    function node:fun_SetParentNode(node)
        self.ParentNode = node
    end

    function node:fun_ClearParentNode()
        self.ParentNode = nil
    end

    -- function node:fun_AddAround(node)
    --     table.insert(self.Around, node)
    -- end
    function node:fun_ClearAround()
        for key, value in pairs(self.Around) do
            self.Around[key] = nil
        end
        self.Around = nil
        self.Around = {}
    end
    function node:fun_AddArounds(nodes)
        self:fun_ClearAround()
        for key, value in pairs(nodes) do
            table.insert(self.Around, value)
        end
        if (self.X + self.Y) % 2 == 0 then
            local len = #self.Around
            for i = 1, len / 2 do
                self.Around[i], self.Around[len - i + 1] = self.Around[len - i + 1], self.Around[i]
            end
        end
    end

    function node:fun_PosTag()
        return self.X .. "_" .. self.Y
    end

    return node
end

function NodeFactory:new(x, y)
    local o = o or {}
    local node = self:CreatNode(x, y)
    setmetatable(o, node)
    return o
end

function NodeFactory:fun_C_AS_Node(node)
    local n = {}
    n.ParentNode = nil
    n.X = node.X
    n.Y = node.Y
    function n:fun_PosTag()
        return self.X .. "_" .. self.Y
    end
    return n
end

return NodeFactory
