AStart = {}

-- node.X = x
-- node.Y = y
-- --- 启发距离
-- node.H = 0
-- --- 实际距离
-- node.G = 0
-- --- 预测距离
-- function node:F()
--     return self.H + self.G
-- end
-- --- 相邻单元（无对角单元）
-- node.Around = {}

--- 曼哈顿启发式
function AStart:Manhattan(Node1, Node2)
    local dif_x = math.abs(Node1.X - Node2.X)
    local dif_y = math.abs(Node1.Y - Node2.Y)
    return dif_x + dif_y
end

---@param StartNode 起点
---@param EndNode 终点
function AStart:fun_PathFinding(StartNode, EndNode)
    if StartNode.tileData.hasMove == false then
        print("起点无法通过")
    end

    if EndNode.tileData.hasMove == false then
        print("终点无法通过")
    end

    local nodeAddMap = {}
    local AS_NodeMap = {}
    local que = QueueFactory:Queue_Priority()

    StartNode.ParentNode = nil
    StartNode.G = 0
    StartNode.H = self:Manhattan(StartNode, EndNode)
    que:push(StartNode, StartNode:F())
    nodeAddMap[StartNode:fun_PosTag()] = StartNode

    while que:fun_HasItem() do
        local item = que:pop()

        if item.tileData.hasMove then

            if item.X == EndNode.X and item.Y == EndNode.Y then
                local path = {}

                while item.ParentNode ~= nil do
                    local acn = NodeFactory:fun_C_AS_Node(item)
                    table.insert(path, 1, acn)
                    item = item.ParentNode
                end
                table.insert(path, 1, NodeFactory:fun_C_AS_Node(StartNode))

                for i = 2, #path do
                    path[i].ParentNode = path[i - 1]
                end

                que = nil
                nodeAddMap = nil
                return path
            end

            for key, value in pairs(item.Around) do
                local G = item.G + value.tileData.movePrice
                local H = self:Manhattan(value, EndNode)
                if nodeAddMap[value:fun_PosTag()] == nil then
                    value.G = G
                    value.H = H
                    value:fun_SetParentNode(item)
                    nodeAddMap[value:fun_PosTag()] = value
                    que:push(value, value:F())
                elseif G + H < value:F() then
                    value.G = G
                    value.H = H
                    value:fun_SetParentNode(item)
                    nodeAddMap[value:fun_PosTag()] = value
                    que:push(value, value:F())
                end
            end
        end
    end

    que = nil
    nodeAddMap = nil
    return nil
end

return AStart
