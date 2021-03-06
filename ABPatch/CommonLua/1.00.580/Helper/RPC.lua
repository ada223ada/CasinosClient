RPC = {}

function RPC:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self

    if (self.Instance == nil)
    then
        self.Instance = o
        self.MapMethodInfo = {}
        self.MessagePack = require("MessagePack")
        self.MessagePack.set_string("binary")
    end

    return self.Instance
end

function RPC:onCreate()

end

function RPC:onRelease()

end

function RPC:PackData(data)
    local p_data = self.MessagePack.pack(data)
    return p_data
end

function RPC:UnPackData(data)
    local p_data = self.MessagePack.unpack(data)
    return p_data
end

function RPC:RegRpcMethod0(method_id, method)
    local reciver = RPCReciver0:new(nil)
    reciver:SetMethord(method)
    self.MapMethodInfo[method_id] = reciver
end

function RPC:RegRpcMethod1(method_id, method)
    local reciver = RPCReciver1:new(nil)
    reciver:SetMethord(method)
    self.MapMethodInfo[method_id] = reciver
end

function RPC:RegRpcMethod2(method_id, method)
    local reciver = RPCReciver2:new(nil)
    reciver:SetMethord(method)
    self.MapMethodInfo[method_id] = reciver
end

function RPC:RegRpcMethod3(method_id, method)
    local reciver = RPCReciver3:new(nil)
    reciver:SetMethord(method)
    self.MapMethodInfo[method_id] = reciver
end

function RPC:RegRpcMethod4(method_id, method)
    local reciver = RPCReciver4:new(nil)
    reciver:SetMethord(method)
    self.MapMethodInfo[method_id] = reciver
end

function RPC.OnRpcMethod(method_id, data)
    local rpc = RPC:new(nil)
    local reciver = rpc.MapMethodInfo[method_id]
    if (reciver ~= nil)
    then
        reciver:ReciverData(rpc.MessagePack, data)
    end
end

function RPC:RPC0(method_id)
    CS.Casinos.CasinosContext.Instance.NetBridge.RpcSession:send(method_id, nil)
end

function RPC:RPC1(method_id, data1)
    local string1 = self.MessagePack.pack(data1)
    --local string1_l = CS.Casinos.LuaHelper.getBytesLenShort(string1) --string.len(string1)
    --local byte_1 = CS.System.BitConverter.GetBytes(string1_l)
    --local t_tmp = {}
    --table.insert(t_tmp, byte_1)
    --table.insert(t_tmp, string1)
    --
    --local finale_data = table.concat(t_tmp)
    CS.Casinos.CasinosContext.Instance.NetBridge.RpcSession:send(method_id, string1)
end

function RPC:RPC2(method_id, data1, data2)
    local string1 = self.MessagePack.pack(data1)
    local string1_l = CS.Casinos.LuaHelper.getBytesLenShort(string1) --string.len(string1)
    local byte_1 = CS.System.BitConverter.GetBytes(string1_l)
    local t_tmp = {}
    table.insert(t_tmp, byte_1)
    table.insert(t_tmp, string1)

    local string2 = self.MessagePack.pack(data2)
    local string2_l = CS.Casinos.LuaHelper.getBytesLenShort(string2)--string.len(string2)
    local byte_2 = CS.System.BitConverter.GetBytes(string2_l)
    table.insert(t_tmp, byte_2)
    table.insert(t_tmp, string2)

    local finale_data = table.concat(t_tmp)
    CS.Casinos.CasinosContext.Instance.NetBridge.RpcSession:send(method_id, finale_data)
end

function RPC:RPC3(method_id, data1, data2, data3)
    local string1 = self.MessagePack.pack(data1)
    local string1_l = CS.Casinos.LuaHelper.getBytesLenShort(string1)
    local byte_1 = CS.System.BitConverter.GetBytes(string1_l)
    local t_tmp = {}
    table.insert(t_tmp, byte_1)
    table.insert(t_tmp, string1)

    local string2 = self.MessagePack.pack(data2)
    local string2_l = CS.Casinos.LuaHelper.getBytesLenShort(string2)
    local byte_2 = CS.System.BitConverter.GetBytes(string2_l)
    table.insert(t_tmp, byte_2)
    table.insert(t_tmp, string2)

    local string3 = self.MessagePack.pack(data3)
    local string3_l = CS.Casinos.LuaHelper.getBytesLenShort(string3)
    local byte_3 = CS.System.BitConverter.GetBytes(string3_l)
    table.insert(t_tmp, byte_3)
    table.insert(t_tmp, string3)

    local finale_data = table.concat(t_tmp)
    CS.Casinos.CasinosContext.Instance.NetBridge.RpcSession:send(method_id, finale_data)
end

function RPC:RPC4(method_id, data1, data2, data3, data4)
    local string1 = self.MessagePack.pack(data1)
    local string1_l = CS.Casinos.LuaHelper.getBytesLenShort(string1)
    local byte_1 = CS.System.BitConverter.GetBytes(string1_l)
    local t_tmp = {}
    table.insert(t_tmp, byte_1)
    table.insert(t_tmp, string1)

    local string2 = self.MessagePack.pack(data2)
    local string2_l = CS.Casinos.LuaHelper.getBytesLenShort(string2)
    local byte_2 = CS.System.BitConverter.GetBytes(string2_l)
    table.insert(t_tmp, byte_2)
    table.insert(t_tmp, string2)

    local string3 = self.MessagePack.pack(data3)
    local string3_l = CS.Casinos.LuaHelper.getBytesLenShort(string3)
    local byte_3 = CS.System.BitConverter.GetBytes(string3_l)
    table.insert(t_tmp, byte_3)
    table.insert(t_tmp, string3)

    local string4 = self.MessagePack.pack(data4)
    local string4_l = CS.Casinos.LuaHelper.getBytesLenShort(string4)
    local byte_4 = CS.System.BitConverter.GetBytes(string4_l)
    table.insert(t_tmp, byte_4)
    table.insert(t_tmp, string4)

    local finale_data = table.concat(t_tmp)
    CS.Casinos.CasinosContext.Instance.NetBridge.RpcSession:send(method_id, finale_data)
end

RPCReciver = {}

function RPCReciver:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function RPCReciver:ReciverData(m_p, data)

end

RPCReciver0 = RPCReciver:new(nil)

function RPCReciver0:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function RPCReciver0:SetMethord(method)
    self.Method = method
end

function RPCReciver0:ReciverData(m_p, data)
    if (self.Method ~= nil)
    then
        self.Method()
    end
end

RPCReciver1 = RPCReciver:new(nil)

function RPCReciver1:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function RPCReciver1:SetMethord(method)
    self.Method = method
end

function RPCReciver1:ReciverData(m_p, data)
    local data_1 = m_p.unpack(data)

    if (self.Method ~= nil)
    then
        self.Method(data_1)
    end
end

RPCReciver2 = RPCReciver:new(nil)

function RPCReciver2:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function RPCReciver2:SetMethord(method)
    self.Method = method
end

function RPCReciver2:ReciverData(m_p, data)
    local offset = 2
    local length_1 = CS.System.BitConverter.ToInt16(data, 0)
    local bytes_data_1 = CS.Casinos.LuaHelper.readBytesWithLength(data, offset, length_1)
    local data_1 = m_p.unpack(bytes_data_1)
    offset = offset + length_1

    local length_2 = CS.System.BitConverter.ToInt16(data, offset)
    offset = offset + 2
    local bytes_data_2 = CS.Casinos.LuaHelper.readBytesWithLength(data, offset, length_2)
    local data_2 = m_p.unpack(bytes_data_2)
    if (self.Method ~= nil)
    then
        self.Method(data_1, data_2)
    end
end

RPCReciver3 = RPCReciver:new(nil)

function RPCReciver3:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function RPCReciver3:SetMethord(method)
    self.Method = method
end

function RPCReciver3:ReciverData(m_p, data)
    local offset = 2
    local length_1 = CS.System.BitConverter.ToInt16(data, 0)
    local bytes_data_1 = CS.Casinos.LuaHelper.readBytesWithLength(data, offset, length_1)
    local data_1 = m_p.unpack(bytes_data_1)
    offset = offset + length_1

    local length_2 = CS.System.BitConverter.ToInt16(data, offset)
    offset = offset + 2
    local bytes_data_2 = CS.Casinos.LuaHelper.readBytesWithLength(data, offset, length_2)
    local data_2 = m_p.unpack(bytes_data_2)
    offset = offset + length_2

    local length_3 = CS.System.BitConverter.ToInt16(data, offset)
    offset = offset + 2
    local bytes_data_3 = CS.Casinos.LuaHelper.readBytesWithLength(data, offset, length_3)
    local data_3 = m_p.unpack(bytes_data_3)

    if (self.Method ~= nil)
    then
        self.Method(data_1, data_2, data_3)
    end
end

RPCReciver4 = RPCReciver:new(nil)

function RPCReciver4:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function RPCReciver4:SetMethord(method)
    self.Method = method
end

function RPCReciver4:ReciverData(m_p, data)
    local offset = 2
    local length_1 = CS.System.BitConverter.ToInt16(data, 0)
    local bytes_data_1 = CS.Casinos.LuaHelper.readBytesWithLength(data, offset, length_1)
    local data_1 = m_p.unpack(bytes_data_1)
    offset = offset + length_1

    local length_2 = CS.System.BitConverter.ToInt16(data, offset)
    offset = offset + 2
    local bytes_data_2 = CS.Casinos.LuaHelper.readBytesWithLength(data, offset, length_2)
    local data_2 = m_p.unpack(bytes_data_2)
    offset = offset + length_2

    local length_3 = CS.System.BitConverter.ToInt16(data, offset)
    offset = offset + 2
    local bytes_data_3 = CS.Casinos.LuaHelper.readBytesWithLength(data, offset, length_3)
    local data_3 = m_p.unpack(bytes_data_3)
    offset = offset + length_3

    local length_4 = CS.System.BitConverter.ToInt16(data, offset)
    offset = offset + 2
    local bytes_data_4 = CS.Casinos.LuaHelper.readBytesWithLength(data, offset, length_4)
    local data_4 = m_p.unpack(bytes_data_4)

    if (self.Method ~= nil)
    then
        self.Method(data_1, data_2, data_3, data_4)
    end
end