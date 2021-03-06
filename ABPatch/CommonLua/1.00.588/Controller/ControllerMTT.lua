ControllerMTT = ControllerBase:new(nil)

function ControllerMTT:new(o,controller_mgr,controller_data,guid)
	o = o or {}  
    setmetatable(o,self)  
    self.__index = self

	o.ControllerData = controller_data
	o.ControllerMgr = controller_mgr
	o.Guid = guid
	o.ViewMgr = ViewMgr:new(nil)

    return o
end

function ControllerMTT:onCreate()
	self.ControllerMgr.ViewMgr:bindEvListener("EvUiRequestPublicMatchList", self)
	self.ControllerMgr.ViewMgr:bindEvListener("EvUiRequestPrivateMatchList", self)
	self.ControllerMgr.ViewMgr:bindEvListener("EvUiRequestUpdatePublicMatchPlayerNum", self)
	self.ControllerMgr.ViewMgr:bindEvListener("EvUiRequestUpdatePrivateMatchPlayerNum", self)
	self.ControllerMgr.ViewMgr:bindEvListener("EvUiRequestSignUpMatch", self)
	self.ControllerMgr.ViewMgr:bindEvListener("EvUiRequestCreatePrivateMatch", self)
	self.ControllerMgr.ViewMgr:bindEvListener("EvUiRequestMatchDetailedInfo", self)
	self.ControllerMgr.ViewMgr:bindEvListener("EvUiRequestEnterMatch", self)
	self.ControllerMgr.ViewMgr:bindEvListener("EvUiRequestCancelSignupMatch", self)
	self.RPC = self.ControllerMgr.RPC
	self.ControllerDesktop = self.ControllerMgr:GetController("Desk")
	self.MC = CommonMethodType
	self.RPC:RegRpcMethod1(self.MC.MatchTexasRequestGetListResult, function(matchTexasGetListResponse)
        self:s2cMatchTexasRequestGetListResult(matchTexasGetListResponse)
    end)
	self.RPC:RegRpcMethod1(self.MC.MatchTexasRequestUpdatePlayerNumInListResult,function(matchtype,list_matchplayernum)
		self:s2cMatchTexasRequestUpdatePlayerNumInListResult(matchtype,list_matchplayernum)
	end)
	self.RPC:RegRpcMethod1(self.MC.MatchTexasRequestGetMoreInfoResult,function(detailedMatchInfo)
		self:s2cMatchTexasRequestGetMoreInfoResult(detailedMatchInfo)
	end)
	self.RPC:RegRpcMethod1(self.MC.MatchTexasRequestSignupResult,function(matchTexasSignUpResponse)
		self:s2cMatchTexasRequestSignupResult(matchTexasSignUpResponse)
	end)
	self.RPC:RegRpcMethod1(self.MC.MatchTexasRequestCancelSignupResult,function(matchTexasCancelSignUpResponse)
		self:s2cMatchTexasRequestCancelSignupResult(matchTexasCancelSignUpResponse)
	end)
	self.RPC:RegRpcMethod1(self.MC.MatchTexasRequestEnterResult,function(matchTexasEnterResponse)
		self:s2cMatchTexasRequestEnterResult(matchTexasEnterResponse)
	end)
	self.RPC:RegRpcMethod1(self.MC.MatchTexasStartNotify,function(matchTexasStartNotify)
		self:s2cMatchTexasStartNotify(matchTexasStartNotify)
	end)
	self.RPC:RegRpcMethod1(self.MC.MatchTexasRequestCreateResult,function(result)
		self:s2cMatchTexasRequestCreateResult(result)
	end)
	self.RPC:RegRpcMethod1(self.MC.MatchTexasRequestDisbandResult,function(result)
		self:s2cMatchTexasRequestDisbandResult(result)
	end)
	self.RPC:RegRpcMethod1(self.MC.MatchTexasPlayerGameEndNotify,function(matchTexasDisbandNotify)
		self:s2cMatchTexasDisbandNotify(matchTexasDisbandNotify)
	end)
	self.RPC:RegRpcMethod2(self.MC.MatchTexasRequestJoinNotPublicResult,function(result,match_info)
		self:s2cMatchTexasRequestJoinNotPublicResult(result,match_info)
	end)
	self.ListAllMatch = {}
	self.ListSelfMatch = {}
	self.AllMatchNum = 0
	self.SelfMatchNum = 0
end

function ControllerMTT:onDestroy()
	self.ViewMgr:unbindEvListener(self)
end

function ControllerMTT:onHandleEv(ev)
	if(ev.EventName == "EvUiRequestPublicMatchList")
	then
		self:requestGetMatchTexasList(MatchTexasScopeType.Public)
	elseif(ev.EventName =="EvUiRequestPrivateMatchList")
	then
		self:requestGetMatchTexasList(MatchTexasScopeType.Private)
	elseif(ev.EventName == "EvUiRequestUpdatePublicMatchPlayerNum")
	then
		self:requestUpdatePlayerNumInMatchTexasList(MatchTexasScopeType.Public)
	elseif(ev.EventName == "EvUiRequestUpdatePrivateMatchPlayerNum")
	then
		self:requestUpdatePlayerNumInMatchTexasList(MatchTexasScopeType.Private)
	elseif(ev.EventName == "EvUiRequestSignUpMatch")
	then
		local match_guid = ev.MatchGuid
		self:requestSignupMatchTexas(match_guid)
	elseif(ev.EventName == "EvUiRequestMatchDetailedInfo")
	then
		local match_guid = ev.MatchGuid
		local match_type = ev.MatchType
		self:requestGetMatchDetailedInfo(match_type,match_guid)
	elseif(ev.EventName == "EvUiRequestCancelSignupMatch")
	then
		self:requestCancelSignupMatchTexas(ev.MatchGuid)
	elseif(ev.EventName == "EvUiRequestCreatePrivateMatch")
	then
		local createMatchInfo = ev.CreateMatchInfo
		self:requestCreateMatchTexas(createMatchInfo)
	elseif(ev.EventName == "EvUiRequestEnterMatch")
	then
		local match_guid = ev.MatchGuid
		self:requestEnterMatch(match_guid)
	elseif(ev.EventName == "EvUiRequestGetMatchDetailedInfoByInvitation")
	then
		local invitationCode = ev.InvitationCode
		self:requestGetMatchDetailedInfoByInvitation(invitationCode)
	end
end

-- 请求获取赛事信息列表
function ControllerMTT:requestGetMatchTexasList(match_type)
	self.RPC:RPC1(self.MC.MatchTexasRequestGetList,match_type)
end

-- 请求更新赛事信息列表中的参赛人数
function ControllerMTT:requestUpdatePlayerNumInMatchTexasList(match_type)
	self.RPC:RPC1(self.MC.MatchTexasRequestUpdatePlayerNumInList,match_type)
end

-- 请求报名或者延迟报名
function ControllerMTT:requestSignupMatchTexas(match_guid)
	--if #self.ListSelfMatch > 0 then
	--	ViewHelper:UiShowInfoFailed(self.ControllerMgr.LanMgr:getLanValue("SignupMatchTip"))
	--	return
	--end
	self.RPC:RPC1(self.MC.MatchTexasRequestSignup,match_guid)
end

-- 请求取消报名
function ControllerMTT:requestCancelSignupMatchTexas(match_guid)
	self.RPC:RPC1(self.MC.MatchTexasRequestCancelSignup,match_guid)
end

-- 请求获取赛事详情
function ControllerMTT:requestGetMatchDetailedInfo(match_type,match_guid)
	self.RPC:RPC2(self.MC.MatchTexasRequestGetMoreInfo,match_type,match_guid)
end

-- 请求创建比赛
function ControllerMTT:requestCreateMatchTexas(create_info)
	self.RPC:RPC1(self.MC.MatchTexasRequestCreate,create_info:getData4Pack())
end

-- 请求解散比赛
function ControllerMTT:requestDisbandMatchTexas()
	self.RPC:RPC0(self.MC.MatchTexasRequestDisband)
end

-- 请求进入比赛
function ControllerMTT:requestEnterMatch(match_guid)
	self.RPC:RPC1(self.MC.MatchTexasRequestEnter,match_guid)
end

-- 请求通过邀请码获取到赛事信息
function ControllerMTT:requestGetMatchDetailedInfoByInvitation(invitationCode)
	self.RPC:RPC1(self.MC.MatchTexasRequestJoinNotPublic,invitationCode)
end

-- 响应获取赛事信息列表
function ControllerMTT:s2cMatchTexasRequestGetListResult(matchTexasGetListResponse)
	local data = BMatchTexasGetListResponse:new(nil)
	data:setData(matchTexasGetListResponse)
	self.ListAllMatch = data.ListMatchTexasInfo
	self.ListSelfMatch = {}
	self.AllMatchNum = #self.ListAllMatch
	for i = 1,#data.ListMyMatch do
		local match_guid = data.ListMyMatch[i]
		for i = 1,#self.ListAllMatch do
			local match = self.ListAllMatch[i]
			if(match_guid == match.Guid)
			then
				table.insert(self.ListSelfMatch,match)
				break
			end
		end
	end
	local ev = self.ControllerMgr.ViewMgr:getEv("EvEntitySetPublicMatchLsit")
	if(ev == nil)
	then
		ev = EvEntitySetPublicMatchLsit:new(nil)
	end
	ev.SelfMatchNum = #self.ListSelfMatch
	self.ControllerMgr.ViewMgr:sendEv(ev)
end

-- 响应更新赛事信息列表中的参赛人数
function ControllerMTT:s2cMatchTexasRequestUpdatePlayerNumInListResult(list_matchPlayerNum)
	if(list_matchPlayerNum ~= nil and #list_matchPlayerNum > 0)
	then
		for i = 1,#list_matchPlayerNum do
			local temp = BMatchTexasPlayerNumUpdate:new(nil)
			temp:setData(list_matchPlayerNum[i])
			list_matchPlayerNum[i] = temp
		end
		--if(self.AllMatchNum ~= #list_matchPlayerNum)
		--then
		--	self:requestGetMatchTexasList(MatchTexasScopeType.Public)
		--	return
		--end
		local ev = self.ControllerMgr.ViewMgr:getEv("EvEntityUpdatePublicMatchPlayerNum")
		if(ev == nil)
		then
			ev = EvEntityUpdatePublicMatchPlayerNum:new(nil)
		end
		ev.ListMatchNum = list_matchPlayerNum
		self.ControllerMgr.ViewMgr:sendEv(ev)
	end
end

-- 响应报名或者延迟报名
function ControllerMTT:s2cMatchTexasRequestSignupResult(matchTexasSignUpResponse)
	local data = BMatchTexasCancelSignUpResponse:new(nil)
	data:setData(matchTexasSignUpResponse)
	local result = data.Result
	local match_guid = data.MatchGuid
	if(result == ProtocolResult.Success) --报名成功
	then
		--self:requestGetMatchTexasList(MatchTexasScopeType.Public)
		local ev = self.ControllerMgr.ViewMgr:getEv("EvEntitySignUpSucceed")
		if(ev == nil)
		then
			ev = EvEntitySignUpSucceed:new(nil)
		end
		ev.MatchGuid = match_guid
		self.ControllerMgr.ViewMgr:sendEv(ev)
	elseif(result == ProtocolResult.MatchTexasNotExist) --报名失败-比赛已经解散
	then
		local msg_box = self.ControllerMgr.ViewMgr:createView("MsgBox")
		msg_box:showMsgBox1("",string.format(self.ControllerMgr.LanMgr:getLanValue("MatchNotExist"),data.MatchName))
	elseif(result == ProtocolResult.MatchTexasNotEnoughGold or result == ProtocolResult.ChipNotEnough) --报名失败-筹码不足
	then
		local msg_box = self.ControllerMgr.ViewMgr:createView("MsgBox")
		msg_box:showMsgBox2("",self.ControllerMgr.LanMgr:getLanValue("BuyChipInShop"),
			function()
				self.ControllerMgr.ViewMgr:createView("Shop")
			end,
			function()
				self.ControllerMgr.ViewMgr:destroyView(msg_box)
			end
		)
	elseif(result == ProtocolResult.MatchTexasTimeOver)
	then
		ViewHelper:UiShowInfoFailed(self.ControllerMgr.LanMgr:getLanValue("MatchTexasTimeOver"))
	elseif(result == ProtocolResult.MatchTexasExist)
	then
		ViewHelper:UiShowInfoFailed(self.ControllerMgr.LanMgr:getLanValue("MatchTexasExist"))
	elseif(result == ProtocolResult.MatchTexasPlayerNumMax)
	then
		ViewHelper:UiShowInfoFailed(self.ControllerMgr.LanMgr:getLanValue("MatchTexasPlayerNumMax"))
	elseif(result == ProtocolResult.MatchTexasMatchEnd)
	then
		ViewHelper:UiShowInfoFailed(self.ControllerMgr.LanMgr:getLanValue("MatchTexasMatchEnd"))
		local ev = self.ControllerMgr.ViewMgr:getEv("EvRemoveMatch")
		if(ev == nil)
		then
			ev = EvRemoveMatch:new(nil)
		end
		ev.MatchGuid = match_guid
		self.ControllerMgr.ViewMgr:sendEv(ev)
	end
end

-- 响应获取赛事详细信息
function ControllerMTT:s2cMatchTexasRequestGetMoreInfoResult(detailedMatchInfo)
	local data = BMatchTexasMoreInfo:new(nil)
	data:setData(detailedMatchInfo)
	local ev = self.ControllerMgr.ViewMgr:getEv("EvEntitySetMatchDetailedInfo")
	if(ev == nil)
	then
		ev = EvEntitySetMatchDetailedInfo:new(nil)
	end
	ev.MatchDetailedInfo = data
	self.ControllerMgr.ViewMgr:sendEv(ev)
end

-- 响应取消报名
function ControllerMTT:s2cMatchTexasRequestCancelSignupResult(matchTexasCancelSignUpResponse)
	local data = BMatchTexasCancelSignUpResponse:new(nil)
	data:setData(matchTexasCancelSignUpResponse)
	local result = data.Result
	local match_guid = data.MatchGuid
	if(result == ProtocolResult.Success)
	then
		--self:requestGetMatchTexasList(MatchTexasScopeType.Public)
		local msg_box = self.ControllerMgr.ViewMgr:createView("MsgBox")
		local tips = self.ControllerMgr.LanMgr:getLanValue("CancelMatchSuccess")
		msg_box:showMsgBox1("",tips,
			function()
				self:requestGetMatchTexasList(MatchTexasScopeType.Public)
				self.ViewMgr:destroyView(msg_box)
			end
		)
		--[[local ev = self.ControllerMgr.ViewMgr:getEv("EvEntityResponseCancelSignUpMatch")
		if(ev == nil)
		then
			ev = EvEntityResponseCancelSignUpMatch:new(nil)
		end
		ev.MatchGuid = match_guid
		self.ControllerMgr.ViewMgr:sendEv(ev)]]
	elseif(result == ProtocolResult.MatchTexasNotExist)
	then
		ViewHelper:UiShowInfoFailed(self.ControllerMgr.LanMgr:getLanValue("CancelMatchFailed1"))
	elseif(result == ProtocolResult.MatchTexasNotSignUp)
	then
		ViewHelper:UiShowInfoFailed(self.ControllerMgr.LanMgr:getLanValue("CancelMatchFailed2"))
	elseif(result == ProtocolResult.MatchTexasTimeOver)
	then
		ViewHelper:UiShowInfoFailed(self.ControllerMgr.LanMgr:getLanValue("CancelMatchFailed3"))
	else
		ViewHelper:UiShowInfoFailed(self.ControllerMgr.LanMgr:getLanValue("CancelMatchFailed"))
	end
end

--响应进入比赛
function ControllerMTT:s2cMatchTexasRequestEnterResult(matchTexasEnterResponse)
	local data = BMatchTexasEnterResponse:new(nil)
	data:setData(matchTexasEnterResponse)
end

-- 响应创建比赛
function ControllerMTT:s2cMatchTexasRequestCreateResult(result)
	
end

-- 响应解散比赛
function ControllerMTT:s2cMatchTexasRequestDisbandResult(result)
	if result == ProtocolResult.MatchTexasNotEnoughPlayer then
		ViewHelper:UiShowInfoFailed(self.ControllerMgr.LanMgr:getLanValue("MatchDisband"))
	end
end

-- 响应通过邀请码获取到赛事信息
function ControllerMTT:s2cMatchTexasRequestJoinNotPublicResult(result,match_info)
	if(result == ProtocolResult.Success)
	then
		local ev = self.ControllerMgr.ViewMgr:getEv("EvEntityGetMatchInfoByInvitationCodeSucceed")
		if(ev == nil)
		then
			ev = EvEntityGetMatchInfoByInvitationCodeSucceed:new(nil)
		end
		ev.MatchInfo = match_info
		self.ControllerMgr.ViewMgr:sendEv(ev)
	elseif(result == ProtocolResult.Failed)
	then
		
	end
end

-- 比赛解散通知
function ControllerMTT:s2cMatchTexasDisbandNotify(matchTexasDisbandNotify)
	local data = BMatchTexasPlayerGameEndNotify:new(nil)
	data:setData(matchTexasDisbandNotify)
	if(#self.ListAllMatch > 0)
	then
		for i = 1,#self.ListAllMatch do
			if(self.ListAllMatch[i].Guid == data.MatchGuid)
			then
				table.remove(self.ListAllMatch,i)
				break
			end
		end
	end
	if(#self.ListSelfMatch > 0)
	then
		for i = 1,#self.ListSelfMatch do
			if(self.ListSelfMatch[i].Guid == data.MatchGuid)
			then
				table.remove(self.ListSelfMatch,i)
				break
			end
		end
	end
	local ev = self.ControllerMgr.ViewMgr:getEv("EvEntitySetPublicMatchLsit")
	if(ev == nil)
	then
		ev = EvEntitySetPublicMatchLsit:new(nil)
	end
	ev.SelfMatchNum = #self.ListSelfMatch
	self.ControllerMgr.ViewMgr:sendEv(ev)
	if(data.Result == ProtocolResult.Failed)
	then
		local msg_box = self.ControllerMgr.ViewMgr:createView("MsgBox")
		msg_box:showMsgBox1("",self.ControllerMgr.LanMgr:getLanValue("YourMatchDisband"),
			function()
				self.ControllerMgr.ViewMgr:destroyView(msg_box)
			end
		)
	end
end

-- 比赛报名后开始通知
function ControllerMTT:s2cMatchTexasStartNotify(matchTexasStartNotify)
	local data = BMatchTexasStartNotify:new(nil)
	data:setData(matchTexasStartNotify)

	if (self.ControllerDesktop.DesktopBase == nil)
	then
		local view_enterMatchNotify = self.ControllerMgr.ViewMgr:createView("EnterMatchNotify")
		view_enterMatchNotify:Init(data.DtMatchBegin,data.MatchGuid,data.MatchName)
	end
end

function ControllerMTT:Clear()
	self.ListAllMatch = {}
	self.ListSelfMatch = {}
end

ControllerMTTFactory = ControllerFactory:new()

function ControllerMTTFactory:new(o)
	o = o or {}  
    setmetatable(o,self)  
    self.__index = self
	self.ControllerName = "Activity"
    return o
end

function ControllerMTTFactory:createController(controller_mgr,controller_data,guid)
	local controller = ControllerMTT:new(nil,controller_mgr,controller_data,guid)
	return controller
end