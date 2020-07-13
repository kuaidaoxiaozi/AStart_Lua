local map = {}
map.wide = 10
map.high = 10
map.StartStr = "S "
map.EndStr = "E "
map.data = require "MapData"

map.nodeMap = {}

function map:fun_AddNodeToMap(node)
    local y = node.Y
    if (type(self.nodeMap[y]) == "nil") then
        self.nodeMap[y] = {}
    end
    self.nodeMap[y][node.X] = node
end

function map:fun_GetNodeToMap(x, y)
    if (self.nodeMap[y] ~= nil) then
        return self.nodeMap[y][x]
    end
    return nil
end

function map:fun_InitMap()
    local x = 0
    local y = 0
    for i, v in ipairs(self.data) do
        x = ((i - 1) % 10) + 1
        if ((i - 1) % 10 == 0) then
            y = y + 1
        end
        local node = NodeFactory:CreatNode(x, y, v)
        self:fun_AddNodeToMap(node)
    end

    for y = 1, #self.nodeMap, 1 do
        for x = 1, #self.nodeMap[y], 1 do
            local xMin = x - 1
            local xMax = x + 1
            local yMin = y - 1
            local yMax = y + 1

            local left = self:fun_GetNodeToMap(xMin, y)
            local right = self:fun_GetNodeToMap(xMax, y)
            local up = self:fun_GetNodeToMap(x, yMin)
            local down = self:fun_GetNodeToMap(x, yMax)

            self:fun_GetNodeToMap(x, y):fun_AddArounds({left, right, up, down})
        end
    end
end

function map:fun_DebugMapPath(node_s, node_e, path)
    if node_s == nil or node_s == nil then
        print("起点或重点为空")
        return
    end

    if path == nil then
        print("路径为空")
        return
    end

    print(self.StartStr .. "坐标：( " .. node_s.X .. ", " .. node_s.Y .. " )")
    print(self.EndStr .."坐标：( " .. node_e.X .. ", " .. node_e.Y .. " )\n")

    local pathMap = {}
    for key, value in pairs(path) do
        pathMap[value:fun_PosTag()] = value
    end

    local m = {}

    for key, value in pairs(self.nodeMap) do
        local s = ""
        for key1, value1 in pairs(value) do
            local str = value1.tileData.debug

            if pathMap[value1:fun_PosTag()] ~= nil then
                if value1.X == node_s.X and value1.Y == node_s.Y then
                    str = self.StartStr
                elseif value1.X == node_e.X and value1.Y == node_e.Y then
                    str = self.EndStr
                else
                    local nn = pathMap[value1:fun_PosTag()]
                    local nnp = nn.ParentNode

                    if nn.X > nnp.X then
                        str = "→ "
                    elseif nn.X < nnp.X then
                        str = "← "
                    elseif nn.Y > nnp.Y then
                        str = "↓ "
                    elseif nn.Y < nnp.Y then
                        str = "↑ "
                    end
                end
            -- str=
            end
            s = s .. str
        end
        table.insert(m, s)
    end

    for key, value in pairs(m) do
        print(value)
    end

    m = nil
end

print("--- 地图显示说明 ---")
print(map.StartStr .. "表示起点")
print(map.EndStr .. "表示终点")
print("地图左上角为(0, 0)点")
print("-------------------\n")
return map
