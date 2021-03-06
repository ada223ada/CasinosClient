TbDataDesktopHInfoZhongFB = TbDataBase:new()

function TbDataDesktopHInfoZhongFB:new(id)
	o = {}
	setmetatable(o,self)
	self.__index = self
	o.Id = id
	o.DesktopHundredPlayerType = nil
	o.MinTakeGolds = nil
	o.MinLeaveGolds = nil
	o.Coefficient = 10000

	return o
end

function TbDataDesktopHInfoZhongFB:load(list_datainfo)
	for i = 0, list_datainfo.Count - 1 do
		local data = list_datainfo[i]
		if(data.data_name == "I_PlayerType")
		then
			self.DesktopHundredPlayerType = tonumber(data.data_value)
		end		
		if(data.data_name == "I_MinTakeGolds")
		then
			self.MinTakeGolds = tonumber(data.data_value) * self.Coefficient
		end		
		if(data.data_name == "I_MinLeaveGolds")
		then
			self.MinLeaveGolds = tonumber(data.data_value) * self.Coefficient
		end		
	end	
end


TbDataFactoryDesktopHInfoZhongFB = TbDataFactoryBase:new()

function TbDataFactoryDesktopHInfoZhongFB:new(o)
	o = o or {}  
    setmetatable(o,self)  
    self.__index = self  		
	
    return o
end

function TbDataFactoryDesktopHInfoZhongFB:createTbData(id)
	return TbDataDesktopHInfoZhongFB:new(id)
end