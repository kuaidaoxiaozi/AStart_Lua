local TileData = {}

TileData[0] = {
    type = 0,
    name = "障碍",
    hasMove = false,
    movePrice = 1,
    debug = "* "
}

TileData[1] = {
    type = 1,
    name = "路面",
    hasMove = true,
    movePrice = 1,
    debug = ". "
}

print("\n--- 瓦片数据说明 ---")
for key, value in pairs(TileData) do
    print(value.debug .. " 表示 " .. value.name)
end
print("-------------------\n")

return TileData
