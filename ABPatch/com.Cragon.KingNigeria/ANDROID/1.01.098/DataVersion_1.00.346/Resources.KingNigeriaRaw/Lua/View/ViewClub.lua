ViewClub = ViewBase:new()

function ViewClub:new(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self	
	o.ViewMgr = nil
	o.GoUi = nil
	o.ComUi = nil
	o.Panel = nil
	o.UILayer = nil
	o.InitDepth = nil
	o.ViewKey = nil
	o.UpdatePlayerNumTime = 0

    return o
end

function ViewClub:onCreate()
	self.ControllerMgr.ViewMgr:bindEvListener("EvEntitySetPrivateMatchLsit", self)
	self.ControllerMgr.ViewMgr:bindEvListener("EvEntityUpdatePrivateMatchPlayerNum", self)
	self.ControllerMgr.ViewMgr:bindEvListener("EvEntityGetMatchInfoByInvitationCodeSucceed", self)
	self.GTransitionShow = self.ComUi:GetTransition("TransitionShow")
	self.GTransitionShow:Play()
	local btn_return = self.ComUi:GetChild("BtnReturn").asButton
	btn_return.onClick:Add(
			function()
				self:onClickBtnReturn()
			end
	)
	local btn_creatematch = self.ComUi:GetChild("BtnCreateMatch").asButton
	btn_creatematch.onClick:Add(
			function()
				self:onClickBtnCreateMatch()
			end
	)
	local btn_createtable = self.ComUi:GetChild("BtnCreateTable").asButton
	btn_createtable.onClick:Add(
			function()
				self:onClickBtnCreateTable()
			end
	)
	local btn_joinMatch = self.ComUi:GetChild("BtnJoinMatch").asButton
	btn_joinMatch.onClick:Add(
			function()
				self:onClickBtnJoinMatch()
 			end
	)
	local btn_club = self.ComUi:GetChild("BtnClub").asButton
	btn_club.onClick:Add(
			function()
				self:onClickBtnClub()
 			end
	)
    local btn_clubHelp = self.ComUi:GetChild("BtnHelp").asButton
    btn_clubHelp.onClick:Add(
        function()
            self:onClickBtnHelp()
        end
    )
	self.GListAlreadyCreatedMatch = self.ComUi:GetChild("ListMatch").asList
	--self:requesetPrivateMatchList()
	self.ListItemMatch = {}
end

function ViewClub:onUpdate(tm)
	self.UpdatePlayerNumTime = self.UpdatePlayerNumTime + tm
	if(self.UpdatePlayerNumTime >= 30)
	then
		local ev = self.ViewMgr:getEv("EvUiRequestUpdatePrivateMatchPlayerNum")
		if(ev == nil)
		then
			ev = EvUiRequestUpdatePrivateMatchPlayerNum:new(nil)
		end
		self.ViewMgr:sendEv(ev)
		self.UpdatePlayerNumTime = 0
	end
end


function ViewClub:onHandleEv(ev)
	if(ev.EventName == "EvEntitySetPrivateMatchLsit")
	then
		self:setAlreadyCreatedMatchList(ev.ListMatch,ev.ListApplyMatchGuid)
	elseif(ev.EventName == "EvEntityUpdatePrivateMatchPlayerNum")
	then
		local list_matchnum = ev.ListMatchNum
		for i = 1,#list_matchnum do
			local guid_num = list_matchnum[i]
			for i = 1,#self.ListItemMatch do
				local temp = self.ListItemMatch[i]
				if(guid_num.Guid == temp.MatchInfo.Guid)
				then
					temp:UpdatePlayerNum(guid_num.PlayerNum)
				end
			end
		end
	elseif(ev.EventName == "EvEntityGetMatchInfoByInvitationCodeSucceed")
	then
		local match_guid = ev.MatchGuid
		local isSelfJoin = false
		for i = 1,#self.ListItemMatch do
			if(match_guid == self.ListItemMatch[i].MatchGuid and self.ListItemMatch[i].IsSelfJoin == true)
			then
				isSelfJoin = true
			end
		end
		local view_privateMatchInfo = self.ViewMgr:createView("PrivateMatchInfo")
		view_privateMatchInfo:Init(match_guid,isSelfJoin)
	end

end

function ViewClub:onClickBtnReturn()
	self.ViewMgr:destroyView(self)
	local ev = self.ViewMgr:getEv("EvUiCreateMainUi")
	if(ev == nil)
	then
		ev = EvUiCreateMainUi:new(nil)
	end
	self.ViewMgr:sendEv(ev)
end

function ViewClub:onClickBtnCreateMatch()
	self.ViewMgr:createView("CreateMatch")
end

function ViewClub:onClickBtnCreateTable()
	ViewHelper:UiShowInfoSuccess("施工中，敬请期待")
end

function ViewClub:onClickBtnJoinMatch()
	self.ViewMgr:createView("JoinMatch")
end

function ViewClub:onClickBtnClub()
	ViewHelper:UiShowInfoSuccess("施工中，敬请期待")
end

function ViewClub:onClickBtnHelp()
    self.ViewMgr:createView("ClubHelp")
end

function ViewClub:setAlreadyCreatedMatchList(list_match,list_applyguid)
	self.ListItemMatch = {}
	self.GListAlreadyCreatedMatch:RemoveChildrenToPool()
	if(list_match == nil or #list_match == 0)
	then
		return
	end
	for i = 1,#list do
		local match = list[i]
		local com = self.GListAlreadyCreatedMatch:AddItemFromPool()
		local item = ItemPrivateMatch:new(nil,com,match)
		self.ListItemMatch[i] = item
	end
	if(list_applyguid ~= nil and #list_applyguid > 0)
	then
		for i = 1,#list_applyguid do
			local guid = list_applyguid[i]
			for i = 1,#self.ListItemMatch do
				local temp = self.ListItemMatch[i]
				if(guid == temp.Guid)
				then
					temp:SetMatchState("已经报名")
					temp.IsSelfJoin = true
					break
				end
			end
		end
	end
end

function ViewClub:requesetPrivateMatchList()
	local ev = self.ViewMgr:getEv("EvUiRequestPrivateMatchList")
	if(ev == nil)
	then
		ev = EvUiRequestPrivateMatchList:new(nil)
	end
	self.ViewMgr:sendEv(ev)
end



ViewClubFactory = ViewFactory:new()

function ViewClubFactory:new(o,ui_package_name,ui_component_name,
	ui_layer,is_single,fit_screen)
	o = o or {}  
    setmetatable(o,self)  
    self.__index = self
	self.PackageName = ui_package_name
	self.ComponentName = ui_component_name
	self.UILayer = ui_layer
	self.IsSingle = is_single
	self.FitScreen = fit_screen
    return o
end

function ViewClubFactory:createView()	
	local view = ViewClub:new(nil)	
	return view
end