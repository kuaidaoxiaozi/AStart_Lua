require "AStart"
require "Factory\\NodeFactory"
require "Factory\\QueueFactory"

local map = require "map"

map:fun_InitMap()

local s = map:fun_GetNodeToMap(1, 1)
local e = map:fun_GetNodeToMap(7, 5)

local path = AStart:fun_PathFinding(s, e)

map:fun_DebugMapPath(s, e, path)
