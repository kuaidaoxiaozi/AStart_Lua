QueueFactory = {}

function QueueFactory:Queue()
    local q = {}
    q.__index = q
    q.data = {}

    function q:Count()
        return #self.data
    end

    function q:push(o)
        table.insert(self.data, o)
    end
    function q:pop()
        if #self.data > 0 then
            return table.remove(self.data, 1)
        end
        return nil
    end
    return q
end

function QueueFactory:Queue_Priority()
    local q = {}
    --- 优先级数组
    q.priArr = {}
    q.priDic = {}
    q.priData = {}


    --- 是否拥有元素
    function q:fun_HasItem()
        if #self.priArr == 0 then
            return false
        end
        return true
    end

    --- 添加优先级
    function q:fun_AddPriority(pri)
        if self.priDic[pri] == nil then
            self.priDic[pri] = pri

            local i = 1
            for key, value in pairs(self.priArr) do
                if (value > pri) then
                    break
                end
                i = i + 1
            end
            table.insert(self.priArr, i, pri)

            self.priData[pri] = QueueFactory:Queue()
        end
    end

    ---添加一个元素
    ---@param o 队列数据
    ---@param pri 优先级
    function q:push(o, pri)
        if type(pri) ~= "number" then
            print("????????????")
            return
        end
        self:fun_AddPriority(pri)
        self.priData[pri]:push(o)
    end

    --- 删除一个优先级
    function q:fun_ClearPriority(pri)
        self.priDic[pri] = nil
        self.priData[pri] = nil
        for key, value in pairs(self.priArr) do
            if (value == pri) then
                table.remove(self.priArr, key)
                break
            end
        end
    end

    --- 弹出一个元素
    function q:pop()
        if #self.priArr > 0 then
            local pri = self.priArr[1]
            local item = self.priData[pri]:pop()

            if self.priData[pri]:Count() < 1 then
                self:fun_ClearPriority(pri)
            end
            return item
        end

        return nil
    end

    return q
end
