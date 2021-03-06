ViewLockChatTexas = ViewBase:new()

function ViewLockChatTexas:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    o.ViewMgr = nil
    o.GoUi = nil
    o.ComUi = nil
    o.Panel = nil
    o.UILayer = nil
    o.InitDepth = nil
    o.ViewKey = nil
    o.GListPlayer = nil
    o.GBtnClose = nil
    o.GBtnLockAllSeatPlayer = nil
    o.GBtnLockAllStandPlayer = nil
    o.GComLockStandPlayer = nil
    o.GLoadSpectatorLock1 = nil
    o.GLoadSpectatorLock2 = nil
    o.MapPlayerChat = nil
    o.TextureLockedName = "TextureLocked"
    o.TextureUnLockName = "TextureUnLock"
    o.LockAllDesktopPlayerKey = "LockAllDesktopPlayerKey"
    o.LockAllSpectator = "LockAllSpectator"
    o.BtnLockedName = "BtnLocked"
    o.BtnUnLockName = "BtnUnlock"
    o.SystemIconKey = "System"

    return o
end

function ViewLockChatTexas:onCreate()
	ViewHelper:PopUi(self.ComUi,self.ViewMgr.LanMgr:getLanValue("LockChat"))
    self.ViewMgr:bindEvListener("EvEntityDesktopPlayerSit", self)
    self.ViewMgr:bindEvListener("EvEntityDesktopPlayerLeaveChair", self)
    self.ViewDesktop = self.ViewMgr:getView("DesktopTexas")
    local com_bg = self.ComUi:GetChild("ComBgAndClose").asCom
    self.GBtnClose = com_bg:GetChild("BtnClose").asButton
    self.GBtnClose.onClick:Add(
            function()
                self:_onClickClose()
            end
    )
	local com_shade = com_bg:GetChild("ComShade").asCom
	com_shade.onClick:Add(
		function()
		    self:_onClickClose()
		end
	)
    self.GBtnLockAllSeatPlayer = self.ComUi:GetChild("Lan_Btn_AllPlayer").asButton
    self.GBtnLockAllSeatPlayer.onClick:Add(
            function()
                self:_onClickBtnAllPlayer()
            end
    )
    self.GBtnLockAllStandPlayer = self.ComUi:GetChild("Lan_Btn_Onlooker").asButton
    self.GBtnLockAllStandPlayer.onClick:Add(
            function()
                self:_onClickBtnAllSpectator()
            end
    )
    self.GListPlayer = self.ComUi:GetChild("ListPlayer").asList
    self.GComLockStandPlayer = self.ComUi:GetChild("ComLockStandPlayer").asCom
    self.GComLockStandPlayer.onClick:Add(
            function()
                self:_onClickBtnAllSpectator()
            end
    )
    self.GLoadSpectatorLock1 = self.ComUi:GetChild("LoaderLock1").asLoader
    self.GLoadSpectatorLock2 = self.ComUi:GetChild("LoaderLock2").asLoader
    self.MapPlayerChat = {}
end

function ViewLockChatTexas:onDestroy()
    self.ViewMgr:unbindEvListener(self)
    self.MapPlayerChat = {}
end

function ViewLockChatTexas:onHandleEv(ev)
    if (ev ~= nil)
    then
        if (ev.EventName == "EvEntityDesktopPlayerSit")
        then
            self:_playerEnter(ev.guid, ev.icon_name, ev.account_id, ev.nick_name, ev.vip_level)
        elseif (ev.EventName == "EvEntityDesktopPlayerLeaveChair")
        then
            self:_playerLeave(ev.guid)
        end
    end
end

function ViewLockChatTexas:initLockChat(all_seat)
    if (CS.UnityEngine.PlayerPrefs.HasKey(self.LockAllDesktopPlayerKey))
    then
        self.GBtnLockAllSeatPlayer.selected = CS.System.Boolean.Parse(CS.UnityEngine.PlayerPrefs.GetString(self.LockAllDesktopPlayerKey))
    else
        self.GBtnLockAllSeatPlayer.selected = false
        CS.UnityEngine.PlayerPrefs.SetString(self.LockAllDesktopPlayerKey, tostring(self.GBtnLockAllSeatPlayer.selected))
    end
    if (CS.UnityEngine.PlayerPrefs.HasKey(self.LockAllSpectator))
    then
        self.GBtnLockAllStandPlayer.selected = CS.System.Boolean.Parse(CS.UnityEngine.PlayerPrefs.GetString(self.LockAllSpectator))
    else
        self.GBtnLockAllStandPlayer.selected = false
        CS.UnityEngine.PlayerPrefs.GetString(self.LockAllSpectator, tostring(self.GBtnLockAllStandPlayer.selected))
    end

    self:_createPlayerChatLock("", "", "", "", 0, true)

    for i = 0, #all_seat do
        local seat_info = all_seat[i]
        local et_guid = ""
        local icon = ""
        local name = ""
        local account_id = ""
        local vip_level = 0
        if (seat_info ~= nil and seat_info.player_texas ~= nil)
        then
            if (seat_info.player_texas ~= nil)
            then
                et_guid = seat_info.player_texas.Guid
                icon = seat_info.player_texas.PlayerDataDesktop.IconName
                name = seat_info.player_texas.PlayerDataDesktop.NickName
                account_id = seat_info.player_texas.PlayerDataDesktop.AccountId
                vip_level = seat_info.player_texas.PlayerDataDesktop.VIPLevel
            end
        end

        self:_createPlayerChatLock(et_guid, icon, name, account_id, vip_level, false)
    end
end

function ViewLockChatTexas:_createPlayerChatLock(et_guid, icon, name, account_id, vip_level, is_system)
    local is_lock = false
    if (is_system)
    then
        is_lock = self.ViewDesktop.ControllerDesktop.LockSysChat
    else
        is_lock = self.ViewDesktop.Desktop.MapSeatPlayerChatIsLock[et_guid]
    end

    local lock_player = self.GListPlayer:AddItemFromPool().asCom
    local player_chat = ItemPlayerChatLock:new(nil, lock_player, self.ViewMgr, self.ViewDesktop.ControllerDesktop.Guid)
    self.MapPlayerChat[player_chat] = player_chat

    player_chat:setPlayerChatInfo(et_guid, icon, name, account_id, vip_level, is_lock, is_system)
end

function ViewLockChatTexas:_playerEnter(guid, icon, account_id, nick_name, vip_level)
    local frist_emptylockpLayer = nil
    for k, v in pairs(self.MapPlayerChat) do
        local lock_player = v
        if (lock_player.IsSystem == false and CS.System.String.IsNullOrEmpty(lock_player.PlayerEtguid))
        then
            frist_emptylockpLayer = lock_player
            break
        end
    end

    local is_lock = self.ViewDesktop.Desktop.MapSeatPlayerChatIsLock[guid]
    frist_emptylockpLayer:setPlayerChatInfo(guid, icon, nick_name, account_id, vip_level, is_lock, false)
end

function ViewLockChatTexas:_playerLeave(guid)
    for k, v in pairs(self.MapPlayerChat) do
        local lock_player = v
        if (lock_player.PlayerEtguid == guid)
        then
            lock_player:setPlayerChatInfo("", "", "", "", 0, self.GBtnLockAllSeatPlayer.selected, false)
            break
        end
    end
end

function ViewLockChatTexas:_onClickBtnAllSpectator()
    CS.UnityEngine.PlayerPrefs.SetString(self.LockAllSpectator, tostring(self.GBtnLockAllStandPlayer.selected))
    local lock_name = self.TextureUnLockName
    if (self.GBtnLockAllStandPlayer.selected)
    then
        lock_name = self.TextureLockedName
    end
    self.GLoadSpectatorLock1.icon = CS.FairyGUI.UIPackage.GetItemURL("LockChat", lock_name)
    self.GLoadSpectatorLock2.icon = CS.FairyGUI.UIPackage.GetItemURL("LockChat", lock_name)

    local ev = self.ViewMgr:getEv("EvUiRequestLockAllSpectator")
    if (ev == nil)
    then
        ev = EvUiRequestLockAllSpectator:new(nil)
    end
    ev.requestLock = self.GBtnLockAllStandPlayer.selected
    self.ViewMgr:sendEv(ev)
end

function ViewLockChatTexas:_onClickBtnAllPlayer()
    CS.UnityEngine.PlayerPrefs.SetString(self.LockAllDesktopPlayerKey, tostring(self.GBtnLockAllSeatPlayer.selected))

    local ev = self.ViewMgr:getEv("EvUiRequestLockAllDesktopPlayer")
    if (ev == nil)
    then
        ev = EvUiRequestLockAllDesktopPlayer:new(nil)
    end
    ev.requestLock = self.GBtnLockAllSeatPlayer.selected
    self.ViewMgr:sendEv(ev)

    for k, v in pairs(self.MapPlayerChat) do
        local chat_lock = v
        chat_lock:setChatLock(self.GBtnLockAllSeatPlayer.selected)
    end
end

function ViewLockChatTexas:_onClickClose()
    self.ViewMgr:destroyView(self)
end

ViewLockChatTexasFactory = ViewFactory:new()

function ViewLockChatTexasFactory:new(o, ui_package_name, ui_component_name,
                                      ui_layer, is_single, fit_screen)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    self.PackageName = ui_package_name
    self.ComponentName = ui_component_name
    self.UILayer = ui_layer
    self.IsSingle = is_single
    self.FitScreen = fit_screen
    return o
end

function ViewLockChatTexasFactory:createView()
    local view = ViewLockChatTexas:new(nil)
    return view
end