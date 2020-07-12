local TileData = require "TileData"

TileFactory = {}

function TileFactory:fun_CreatTileBase(_t)
    local tile = TileData[_t]
    if tile == nil then
        print("不存在的 Tile 类型：" .. _t)
        return
    end
    local t = {}
    t.type = tile.type
    t.name = tile.name
    t.hasMove = tile.hasMove
    t.movePrice = tile.movePrice
    t.debug = tile.debug
    return t
end

function TileFactory:fun_CreatObstacles()
    return self:fun_CreatTileBase(0)
end

function TileFactory:fun_CreatRoad()
    return self:fun_CreatTileBase(1)
end