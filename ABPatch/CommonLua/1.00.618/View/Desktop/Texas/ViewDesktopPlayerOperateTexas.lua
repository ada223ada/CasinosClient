ViewDesktopPlayerOperateTexas = ViewBase:new()

function ViewDesktopPlayerOperateTexas:new(o)
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
    o.GGroupLeaveWhile = nil
    o.GComContinue = nil
    --o.GTextLeaveWhileTips = nil
    o.GGroupAutoOperate = nil
    o.GSliderRise = nil
    o.GTextTopRaiseChip = nil
    o.GTextBottomRaiseChip = nil
    o.GTextCurrentRaiseChip = nil
    o.GComFold = nil
    o.GToggleFold = nil
    o.GComFoldOrCheck = nil
    o.GToggleFoldOrCheck = nil
    o.GComCheckOrCall = nil
    o.GToggleCheckOrCall = nil
    o.ComRaiseNClickRaise = nil
    o.GTextSelfTurnRaise = nil
    o.ControllerTurn = nil
    o.ListAutoOperate = {}
    o.ViewDesktop = nil
    o.DesktopPlayerTexas = {}
    o.MeTurnData = nil
    o.CanShowOperate = false
    o.IsMeTurn = false
    o.CurrentTopRaiseGoldValue = 0
    o.CurrentBottomRaiseGoldValue = 0
    o.CurrentRaiseGold = 0
    o.SliderMoved = false

    return o
end

function ViewDesktopPlayerOperateTexas:onCreate()
    self.ViewMgr:bindEvListener("EvCommonCardShowEnd", self)
    self.ViewMgr:bindEvListener("EvCommonCardDealEnd", self)
    self.ViewMgr:bindEvListener("EvUiClickDesktop", self)
    self.ViewMgr:bindEvListener("EvEntitySelfAutoActionChange", self)
    self.ViewMgr:bindEvListener("EvUiClickFastBet", self)
    self.ViewMgr:bindEvListener("EvEntitySelfIsOB", self)
    self.ListAutoOperate = {}

    self.GGroupLeaveWhile = self.ComUi:GetChild("GroupLeaveWhile").asGroup
    self.GComContinue = self.ComUi:GetChild("ComContinue").asCom
    self.GComContinue.onClick:Add(
            function()
                self:_onClickContinue()
            end
    )
    self.GLeaveTips = self.ComUi:GetChild("LeaveTips").asTextField
    self.GSliderRise = self.ComUi:GetChild("SliderRise").asSlider
    self.GSliderRise.changeOnClick = false
    self.GSliderRise.max = 1000000
    self.GSliderRise.onChanged:Add(
            function()
                self.SliderMoved = true
                local current_silder_value = self.GSliderRise.value
                local max_gold = self.CurrentTopRaiseGoldValue
                local raise_gold = 0
                local percent = current_silder_value / 1000000
                if (current_silder_value <= 0)
                then
                    raise_gold = self.CurrentBottomRaiseGoldValue
                else
                    local value = ((max_gold - self.CurrentBottomRaiseGoldValue) * percent)
                    value = value + self.CurrentBottomRaiseGoldValue
                    raise_gold = value
                end

                local need_getvalidegold = true
                if (percent >= 0.9998 and percent <= 1)
                then
                    need_getvalidegold = false
                    raise_gold = max_gold
                end
                CS.Casinos.CasinosContext.Instance:play("addchip", CS.Casinos._eSoundLayer.LayerReplace)
                self:_setCurrentRaiseChip(raise_gold, need_getvalidegold)
            end
    )

    local btn_grip = self.GSliderRise:GetChild("grip").asButton
    btn_grip.onClick:Add(
            function()
                if (self.SliderMoved)
                then
                    self.SliderMoved = false
                    return
                end

                self:_onClickConfirmRaise()
            end
    )
    local com_confirm_raise = btn_grip:GetChild("ComConfirmRaise").asCom
    self.GTextTopRaiseChip = self.GSliderRise:GetChild("TextTopRaiseChip").asTextField
    self.GTextBottomRaiseChip = self.GSliderRise:GetChild("TextBottomRaiseChip").asTextField
    self.GTextCurrentRaiseChip = com_confirm_raise:GetChild("TextCurrentRaiseChip").asTextField
    ViewHelper:setGObjectVisible(false, self.GSliderRise)
    self.GGroupAutoOperate = self.ComUi:GetChild("GroupAutoOperate").asGroup
    self.GGroupSelfNotRaise = self.ComUi:GetChild("GroupSelfNotRaise").asGroup
    self.GGroupQuick2 = self.ComUi:GetChild("GroupQuick2").asGroup
    self.GComFold = self.ComUi:GetChild("Lan_Btn_Fold").asCom
    self.GComFold.onClick:Add(
            function()
                self:_onClickFold()
            end
    )
    self.GBtnAutoCall = self.ComUi:GetChild("Lan_Btn_CallAny").asButton
    self.AutoCallTransitionClick = self.GBtnAutoCall:GetTransition("TransitionClick")
    self.GBtnAutoCall.onClick:Add(
            function()
                self.AutoCallTransitionClick:Play()
                self:_onClickCall()
            end
    )
    table.insert(self.ListAutoOperate, self.GBtnAutoCall)
    self.GBtnAutoFoldOrCheck = self.ComUi:GetChild("Lan_Btn_CheckOrFold").asCom
    self.AutoFoldOrCheckTransitionClick = self.GBtnAutoFoldOrCheck:GetTransition("TransitionClick")
    self.GBtnAutoFoldOrCheck.onClick:Add(
            function()
                self.AutoFoldOrCheckTransitionClick:Play()
                self:_onClickFoldOrCheck()
            end
    )
    table.insert(self.ListAutoOperate, self.GBtnAutoFoldOrCheck)
    self.GComCheckOrCall = self.ComUi:GetChild("ComCheckOrCall").asCom
    self.GComCheckOrCall.onClick:Add(
            function()
                self:_onClickCheckOrCall()
            end
    )
    self.GBtnAutoCheckOrCall = self.ComUi:GetChild("BtnAutoCheckOrCall").asButton
    self.AutoCheckOrCallTransitionClick = self.GBtnAutoCheckOrCall:GetTransition("TransitionClick")
    self.GBtnAutoCheckOrCall.onClick:Add(
            function()
                self.AutoCheckOrCallTransitionClick:Play()
                self:_onClickCheckOrCall()
            end
    )
    table.insert(self.ListAutoOperate, self.GBtnAutoCheckOrCall)
    self.ComRaiseNClickRaise = self.ComUi:GetChild("ComRaiseNClickRaise").asCom
    self.ComRaiseNClickRaise.onClick:Add(
            function(context)
                self:_onClickRaise(context)
            end
    )
    self.ComRaiseClickRaise = self.ComUi:GetChild("Lan_Btn_AddBet").asCom
    self.ComRaiseClickRaise.onClick:Add(
            function()
                self:_onClickConfirmRaise()
            end
    )
    self.ControllerTurn = self.ComUi:GetController("ControllerTurn")
    self.ControllerSelfRaise = self.ComUi:GetController("ControllerSelfRaise")
    self.ControllerSelfRaise.selectedIndex = 1
    self.SliderMoved = false
    self.ViewDesktop = self.ViewMgr:getView("DesktopTexas")
    self.ComAutoAction = self.ComUi:GetChild("ComAutoAction").asCom
    self.BtnBack = self.ComAutoAction:GetChild("BtnBack").asCom
    self.BtnBack.onClick:Add(
            function()
                self:_onClickBack()
            end)
    self.TableQuickBet = {}
    for i = 1, 8 do
        local btn_quick = self.ComUi:GetChild("BtnQuick" .. i)
        self.TableQuickBet[i] = DesktopFastBet:new(nil, btn_quick, i, self.ViewMgr)
    end
    self.IsAutoCallOrCheck = false
    self.IsCallOrCheck = false
    self.PlayerOperateAni = PlayerOperateAni:new(nil, self.ComUi)
end

function ViewDesktopPlayerOperateTexas:onDestroy()
    self.ViewMgr:unbindEvListener(self)
end

function ViewDesktopPlayerOperateTexas:onHandleEv(ev)
    if (ev ~= nil)
    then
        if (ev.EventName == "EvCommonCardShowEnd")
        then
            self.CanShowOperate = true
            if (self.IsMeTurn and self.MeTurnData ~= nil)
            then
                self:_checkPlayerOperate(self.IsMeTurn, self.MeTurnData, 0)
            end
        elseif (ev.EventName == "EvCommonCardDealEnd")
        then
            self.CanShowOperate = true
            if (self.IsMeTurn and self.MeTurnData ~= nil)
            then
                self:_checkPlayerOperate(self.IsMeTurn, self.MeTurnData, 0)
            end
        elseif (ev.EventName == "EvUiClickDesktop")
        then
            ViewHelper:setGObjectVisible(false, self.GSliderRise)
            self.ControllerSelfRaise.selectedIndex = 1
        elseif (ev.EventName == "EvEntitySelfAutoActionChange")
        then
            ViewHelper:setGObjectVisible(ev.is_autoaction, self.ComAutoAction)
        elseif (ev.EventName == "EvUiClickFastBet")
        then
            self:_raise(ev.bet_value)
        elseif (ev.EventName == "EvEntitySelfIsOB")
        then
            self:stand()
        end
    end
end

function ViewDesktopPlayerOperateTexas:setMeActorMirror(player)
    self.DesktopPlayerTexas = player
    self:meStateChange(self.DesktopPlayerTexas.PlayerDataDesktop.DesktopPlayerState)
    self.MeTurnData = nil
    self.CanShowOperate = true
    self.IsMeTurn = false
    self.CurrentTopRaiseGoldValue = 0
    self.CurrentBottomRaiseGoldValue = 0
    self.CurrentRaiseGold = 0
end

function ViewDesktopPlayerOperateTexas:showDown()
    self.CanShowOperate = false
    ViewHelper:setGObjectVisible(false, self.GSliderRise)
    ViewHelper:setGObjectVisible(false, self.GGroupAutoOperate)
    ViewHelper:setGObjectVisible(false, self.GGroupSelfNotRaise)
    ViewHelper:setGObjectVisible(false, self.GGroupQuick2)
    self.PlayerOperateAni:reset()
end

function ViewDesktopPlayerOperateTexas:gameEnd()
    self.CanShowOperate = false
    ViewHelper:setGObjectVisible(false, self.GSliderRise)
    ViewHelper:setGObjectVisible(false, self.GGroupAutoOperate)
    ViewHelper:setGObjectVisible(false, self.GGroupSelfNotRaise)
    ViewHelper:setGObjectVisible(false, self.GGroupQuick2)
    self.PlayerOperateAni:reset()
end

function ViewDesktopPlayerOperateTexas:meStateChange(player_state)
    local player_s = player_state--TexasDesktopPlayerState.__CastFrom(player_state)
    if (player_s == TexasDesktopPlayerState.Wait4Next)
    then
        self:_showWait4Next()
    elseif (player_s == TexasDesktopPlayerState.InGame)
    then
        self:_checkPlayerOperate(false, nil, 0)
    else
        ViewHelper:setGObjectVisible(false, self.GGroupLeaveWhile)
        ViewHelper:setGObjectVisible(false, self.GGroupAutoOperate)
        ViewHelper:setGObjectVisible(false, self.GGroupSelfNotRaise)
        ViewHelper:setGObjectVisible(false, self.GGroupQuick2)
        self.PlayerOperateAni:reset()
    end
    self.SliderMoved = false
end

function ViewDesktopPlayerOperateTexas:playerTurnChanged(call_chip, is_mechange, is_me)
    self.IsMeTurn = false
    self.MeTurnData = nil
    if is_mechange then
        self:_resetAutoChooseOperate(nil)
    end
    if is_me == false then
        local play_single = false
        if CS.System.String.IsNullOrEmpty(self.DesktopPlayerTexas.DesktopTexas.LastPlayerTurn) or self.DesktopPlayerTexas.DesktopTexas.IsSnapshot then
            play_single = true
        end
        self.PlayerOperateAni:showAutoOperate(play_single)
    end
    ViewHelper:setGObjectVisible(false, self.GSliderRise)
    if is_me == false then
        self:_checkPlayerOperate(false, nil, call_chip)
    end
end

function ViewDesktopPlayerOperateTexas:selfAction()
    self:_resetAutoChooseOperate(nil)
end

function ViewDesktopPlayerOperateTexas:isMeTurn(turn_data, auto_show_operate, t_fastbet, call_chip)
    local player_turn_data = turn_data
    for i, v in pairs(t_fastbet) do
        local desktop_fastbet = self.TableQuickBet[i]
        desktop_fastbet:setValue(v)
    end
    if (auto_show_operate)
    then
        self:_checkPlayerOperate(true, player_turn_data, call_chip)
    else
        if (self.CanShowOperate)
        then
            self:_checkPlayerOperate(true, player_turn_data, call_chip)
        else
            self.IsMeTurn = true
            self.MeTurnData = player_turn_data
        end
    end
end

function ViewDesktopPlayerOperateTexas:preflopBegin()
    self.CanShowOperate = false
    ViewHelper:setGObjectVisible(false, self.GGroupAutoOperate)
    ViewHelper:setGObjectVisible(false, self.GGroupSelfNotRaise)
    ViewHelper:setGObjectVisible(false, self.GGroupQuick2)
    self:_resetAutoChooseOperate(nil)
    ViewHelper:setGObjectVisible(false, self.GSliderRise)
end

function ViewDesktopPlayerOperateTexas:stand()
    self.CanShowOperate = false
    ViewHelper:setGObjectVisible(false, self.GSliderRise)
    ViewHelper:setGObjectVisible(false, self.GGroupAutoOperate)
    ViewHelper:setGObjectVisible(false, self.GGroupSelfNotRaise)
    ViewHelper:setGObjectVisible(false, self.GGroupQuick2)
    self.PlayerOperateAni:reset()
end

function ViewDesktopPlayerOperateTexas:setLeaveWhileTips(leave_time)
    if (leave_time <= 0)
    then
        ViewHelper:setGObjectVisible(false, self.GGroupLeaveWhile)
    else
        ViewHelper:setGObjectVisible(false, self.GSliderRise)
        ViewHelper:setGObjectVisible(false, self.GGroupAutoOperate)
        ViewHelper:setGObjectVisible(false, self.GGroupSelfNotRaise)
        ViewHelper:setGObjectVisible(false, self.GGroupQuick2)
        ViewHelper:setGObjectVisible(true, self.GGroupLeaveWhile)
        local tips = string.format("%s(%s)",self.ViewMgr.LanMgr:getLanValue("Continue"), tostring(leave_time))
        self.GLeaveTips.text = tips
    end
end

function ViewDesktopPlayerOperateTexas:_showWait4Next()
    self:_resetAutoChooseOperate(nil)
    ViewHelper:setGObjectVisible(false, self.GGroupAutoOperate)
    ViewHelper:setGObjectVisible(false, self.GGroupLeaveWhile)
    ViewHelper:setGObjectVisible(false, self.GGroupSelfNotRaise)
    ViewHelper:setGObjectVisible(false, self.GGroupQuick2)
end

function ViewDesktopPlayerOperateTexas:_setCurrentRaiseChip(current_gold, need_getvalidegold)
    self.CurrentRaiseGold = math.ceil(current_gold)
    if (need_getvalidegold)
    then
        self.CurrentRaiseGold = UiChipShowHelper:getValideGold(self.CurrentRaiseGold)
    end
    self.GTextCurrentRaiseChip.text = UiChipShowHelper:getGoldShowStr(self.CurrentRaiseGold, self.ViewMgr.LanMgr.LanBase)

    if (self.CurrentRaiseGold == self.DesktopPlayerTexas.PlayerDataDesktop.Stack)
    then
        ViewHelper:setGObjectVisible(false, self.GTextTopRaiseChip)
        CS.Casinos.CasinosContext.Instance:play("allin", CS.Casinos._eSoundLayer.LayerNormal)
        self.GTextCurrentRaiseChip.text = self.ViewMgr.LanMgr:getLanValue("All-in")
    else
        ViewHelper:setGObjectVisible(true, self.GTextTopRaiseChip)
    end
end

function ViewDesktopPlayerOperateTexas:_raise(raise_gold)
    --self.ViewDesktop:setActionTips("")
    local ev = self.ViewMgr:getEv("EvUiClickRaise")
    if (ev == nil)
    then
        ev = EvUiClickRaise:new(nil)
    end
    ev.raise_gold = raise_gold
    self.ViewMgr:sendEv(ev)
    self.PlayerOperateAni:showAutoOperate(false)
    ViewHelper:setGObjectVisible(false, self.GSliderRise)
end

function ViewDesktopPlayerOperateTexas:_resetAutoChooseOperate(obj)
    if obj == nil then
        for i, v in pairs(self.ListAutoOperate) do
            v.selected = false
        end
    else
        for i, v in pairs(self.ListAutoOperate) do
            if (v ~= obj)
            then
                v.selected = false
            end
        end
    end
end

function ViewDesktopPlayerOperateTexas:_checkPlayerOperate(is_me_turn, turn_data, call_chip)
    if (self.DesktopPlayerTexas.PlayerDataDesktop.DesktopPlayerState ~= TexasDesktopPlayerState.InGame)
    then
        return
    end

    if (self.DesktopPlayerTexas.PlayerDataDesktop.PlayerActionType == PlayerActionTypeTexas.Fold
            or self.DesktopPlayerTexas.PlayerDataDesktop.PlayerActionType == PlayerActionTypeTexas.AllIn)
    then
        ViewHelper:setGObjectVisible(false, self.GGroupLeaveWhile)
        ViewHelper:setGObjectVisible(false, self.GGroupAutoOperate)
        ViewHelper:setGObjectVisible(false, self.GGroupSelfNotRaise)
        ViewHelper:setGObjectVisible(false, self.GGroupQuick2)
    else
        ViewHelper:setGObjectVisible(true, self.GGroupAutoOperate)
        ViewHelper:setGObjectVisible(true, self.GGroupSelfNotRaise)
        ViewHelper:setGObjectVisible(true, self.GGroupQuick2)
        ViewHelper:setGObjectVisible(false, self.GGroupLeaveWhile)
        ViewHelper:setGObjectVisible(false, self.GSliderRise)
        self:_checkPlayerOperateBtn(is_me_turn, turn_data, call_chip)
    end
end

function ViewDesktopPlayerOperateTexas:_checkPlayerOperateBtn(self_acting, turn_data, call_chip)
    local list_valid_action = nil
    if (self_acting and turn_data ~= nil)
    then
        list_valid_action = {}
        local can_action1 = PlayerCanActionDataTexas:new(nil)
        can_action1.can_action = PlayerCanActionTypeTexas.Fold
        can_action1.chip = 0
        table.insert(list_valid_action, can_action1)

        local can_action2 = PlayerCanActionDataTexas:new(nil)
        if call_chip == 0 then
            can_action2.can_action = PlayerCanActionTypeTexas.Check
            can_action2.chip = 0
        else
            can_action2.can_action = PlayerCanActionTypeTexas.Call
            can_action2.chip = call_chip
        end
        table.insert(list_valid_action, can_action2)

        local can_action3 = PlayerCanActionDataTexas:new(nil)
        can_action3.can_action = PlayerCanActionTypeTexas.Raise
        local raise_chip = self.DesktopPlayerTexas.DesktopTexas.CurrentRountMaxBet * 2 - self.DesktopPlayerTexas.PlayerDataDesktop.CurrentRoundBet
        if call_chip >= self.DesktopPlayerTexas.PlayerDataDesktop.Stack then
            raise_chip = self.DesktopPlayerTexas.PlayerDataDesktop.Stack
        else
            if raise_chip == 0 then
                raise_chip = self.DesktopPlayerTexas.DesktopTexas.DesktopTypeBase.BigBlind
            end
        end
        can_action3.chip = raise_chip
        table.insert(list_valid_action, can_action3)
    end

    if (list_valid_action ~= nil)
    then
        self:_resetAutoChooseOperate(nil)
        if self.DesktopPlayerTexas.DesktopTexas.IsSnapshot == false then
            CS.Casinos.CasinosContext.Instance:play("on_turn", CS.Casinos._eSoundLayer.LayerNormal)
        end
        --self.ControllerTurn.selectedIndex = 2
        self.ControllerSelfRaise.selectedIndex = 1
        local play_single = false
        if CS.System.String.IsNullOrEmpty(self.DesktopPlayerTexas.DesktopTexas.LastPlayerTurn) or self.DesktopPlayerTexas.DesktopTexas.IsSnapshot then
            play_single = true
        end
        self.PlayerOperateAni:showOtherOperate(play_single)

        local can_raise = false
        local can_call = false
        local call_allin = false
        for i, v in pairs(list_valid_action) do
            local c_a = v
            local action = c_a.can_action
            if (action == PlayerCanActionTypeTexas.Fold)
            then
            elseif (action == PlayerCanActionTypeTexas.Check)
            then
                self.IsCallOrCheck = false
                self.GComCheckOrCall.title = self.ViewMgr.LanMgr:getLanValue("Check")
            elseif (action == PlayerCanActionTypeTexas.Call)
            then
                self.IsCallOrCheck = true
                local call_tips = self.ViewMgr.LanMgr:getLanValue("Call")
                local tips = CS.Casinos.CasinosContext.Instance:AppendStrWithSB(call_tips, UiChipShowHelper:getGoldShowStr(c_a.chip, self.ViewMgr.LanMgr.LanBase))
                if c_a.chip >= self.DesktopPlayerTexas.PlayerDataDesktop.Stack then
                    call_allin = true
                    tips = self.ViewMgr.LanMgr:getLanValue("All-in")
                end

                self.GComCheckOrCall.title = tips
                can_call = true
            elseif (action == PlayerCanActionTypeTexas.Raise)
            then
                if call_allin == true then
                    can_raise = false
                else
                    can_raise = true
                    local me_stack = self.DesktopPlayerTexas.PlayerDataDesktop.Stack
                    self.CurrentBottomRaiseGoldValue = c_a.chip
                    self.CurrentTopRaiseGoldValue = self.DesktopPlayerTexas.PlayerDataDesktop.Stack
                    local tips_add = self.ViewMgr.LanMgr:getLanValue("AddBet")--CS.Casinos.CasinosContext.Instance:AppendStrWithSB(self.ViewMgr.LanMgr:getLanValue("加注", "AddBet"),
                    --UiChipShowHelper:getGoldShowStr(self.CurrentBottomRaiseGoldValue, self.ViewMgr.LanMgr.LanBase))
                    local raise_btn_name = tips_add
                    if (me_stack <= self.CurrentBottomRaiseGoldValue)
                    then
                        raise_btn_name = self.ViewMgr.LanMgr:getLanValue("All-in")
                    end

                    self.ComRaiseNClickRaise.title = raise_btn_name
                end
            end
        end

        local a = 0.5
        if can_raise then
            a = 1
        end
        self.ComRaiseNClickRaise.alpha = a
        self.ComRaiseNClickRaise.touchable = can_raise
    else
        local btn_name = ""
        local is_call_allin = false
        if call_chip > 0 then
            self.IsAutoCallOrCheck = true
            if call_chip >= self.DesktopPlayerTexas.PlayerDataDesktop.Stack then
                btn_name = self.ViewMgr.LanMgr:getLanValue("All-in")
                is_call_allin = true
            else
                btn_name = self.ViewMgr.LanMgr:getLanValue("Call")
                btn_name = CS.Casinos.CasinosContext.Instance:AppendStrWithSB(btn_name, UiChipShowHelper:getGoldShowStr(call_chip, self.ViewMgr.LanMgr.LanBase))
            end
            self:_resetAutoChooseOperate(nil)
        else
            btn_name = self.ViewMgr.LanMgr:getLanValue("AutoCheck")
            self.IsAutoCallOrCheck = false
        end
        --print("_checkPlayerOperateBtn")
        self.GBtnAutoCheckOrCall.title = btn_name
        self.ComRaiseNClickRaise.alpha = 0.5
        self.ComRaiseNClickRaise.touchable = false
    end
end

function ViewDesktopPlayerOperateTexas:_onClickFold()
    if (self.DesktopPlayerTexas.DesktopTexas.PlayerTurn.player_guid == self.DesktopPlayerTexas.Guid)
    then
        local ev = self.ViewMgr:getEv("EvUiClickFlod")
        if (ev == nil)
        then
            ev = EvUiClickFlod:new(nil)
        end
        self.ViewMgr:sendEv(ev)
        --self.ViewDesktop:setActionTips("")
        --self.ControllerTurn.selectedIndex = 0
        self.PlayerOperateAni:showAutoOperate(false)
    end
end

function ViewDesktopPlayerOperateTexas:_onClickFoldOrCheck()
    if ((self.DesktopPlayerTexas.DesktopTexas.PlayerTurn.player_guid ~= self.DesktopPlayerTexas.Guid))
    then
        self:_resetAutoChooseOperate(self.GBtnAutoFoldOrCheck)
        --self.ControllerTurn.selectedIndex = 0
        if (self.GBtnAutoFoldOrCheck.selected == false)
        then
            local ev = self.ViewMgr:getEv("EvUiClickCancelAutoAction")
            if (ev == nil)
            then
                ev = EvUiClickCancelAutoAction:new(nil)
            end
            self.ViewMgr:sendEv(ev)
        else
            local ev = self.ViewMgr:getEv("EvUiClickAutoAction")
            if (ev == nil)
            then
                ev = EvUiClickAutoAction:new(nil)
            end
            ev.auto_action_type = PlayerAutoActionTypeTexas.CheckFold
            self.ViewMgr:sendEv(ev)
        end
    end
end

function ViewDesktopPlayerOperateTexas:_onClickCheckOrCall()
    if (self.DesktopPlayerTexas.DesktopTexas.PlayerTurn.player_guid == self.DesktopPlayerTexas.Guid)
    then
        if self.IsCallOrCheck == true then
            local ev = self.ViewMgr:getEv("EvUiClickCall")
            if (ev == nil)
            then
                ev = EvUiClickCall:new(nil)
            end
            self.ViewMgr:sendEv(ev)
        else
            local ev = self.ViewMgr:getEv("EvUiClickCheck")
            if (ev == nil)
            then
                ev = EvUiClickCheck:new(nil)
            end
            self.ViewMgr:sendEv(ev)
            --self.ViewDesktop:setActionTips("")
        end
        --self.ControllerTurn.selectedIndex = 0
        self.PlayerOperateAni:showAutoOperate(false)
    else
        self:_resetAutoChooseOperate(self.GBtnAutoCheckOrCall)
        if (self.GBtnAutoCheckOrCall.selected == false)
        then
            local ev = self.ViewMgr:getEv("EvUiClickCancelAutoAction")
            if (ev == nil)
            then
                ev = EvUiClickCancelAutoAction:new(nil)
            end
            self.ViewMgr:sendEv(ev)
        else
            if self.IsAutoCallOrCheck == true then
                local ev = self.ViewMgr:getEv("EvUiClickAutoAction")
                if (ev == nil)
                then
                    ev = EvUiClickAutoAction:new(nil)
                end
                ev.auto_action_type = PlayerAutoActionTypeTexas.CallAny
                self.ViewMgr:sendEv(ev)
            else
                local ev = self.ViewMgr:getEv("EvUiClickAutoAction")
                if (ev == nil)
                then
                    ev = EvUiClickAutoAction:new(nil)
                end
                ev.auto_action_type = PlayerAutoActionTypeTexas.Check
                self.ViewMgr:sendEv(ev)
            end
        end
    end
end

function ViewDesktopPlayerOperateTexas:_onClickCall()
    self:_resetAutoChooseOperate(self.GBtnAutoCall)
    if (self.GBtnAutoCall.selected == false)
    then
        local ev = self.ViewMgr:getEv("EvUiClickCancelAutoAction")
        if (ev == nil)
        then
            ev = EvUiClickCancelAutoAction:new(nil)
        end
        self.ViewMgr:sendEv(ev)
    else
        local ev = self.ViewMgr:getEv("EvUiClickAutoAction")
        if (ev == nil)
        then
            ev = EvUiClickAutoAction:new(nil)
        end
        ev.auto_action_type = PlayerAutoActionTypeTexas.CallAny
        self.ViewMgr:sendEv(ev)
    end
end

function ViewDesktopPlayerOperateTexas:_onClickRaise(context)
    context:StopPropagation()
    local s = self.GSliderRise.visible
    if (s == false)
    then
        local me_stack = self.DesktopPlayerTexas.PlayerDataDesktop.Stack
        if (me_stack <= self.CurrentBottomRaiseGoldValue)
        then
            self:_raise(me_stack)
        else
            --self.ControllerTurn.selectedIndex = 1
            self.ControllerSelfRaise.selectedIndex = 0
            --self.GTextSelfTurnRaise.text = self.ViewMgr.LanMgr:getLanValue("确定", "Confirm")
            ViewHelper:setGObjectVisible(true, self.GSliderRise)
            ViewHelper:setGObjectVisible(true, self.GTextTopRaiseChip)
            self.GSliderRise.value = 0
            self.GTextBottomRaiseChip.text = UiChipShowHelper:getGoldShowStr(self.CurrentBottomRaiseGoldValue, self.ViewMgr.LanMgr.LanBase)
            self.GTextTopRaiseChip.text = UiChipShowHelper:getGoldShowStr(self.CurrentTopRaiseGoldValue, self.ViewMgr.LanMgr.LanBase)
            self:_setCurrentRaiseChip(self.CurrentBottomRaiseGoldValue, true)
        end
    else
        self:_raise(self.CurrentRaiseGold)
    end
end

function ViewDesktopPlayerOperateTexas:_onClickConfirmRaise()
    self:_raise(self.CurrentRaiseGold)
end

function ViewDesktopPlayerOperateTexas:_onClickContinue()
    local ev = self.ViewMgr:getEv("EvUiClickPlayerReturn")
    if (ev == nil)
    then
        ev = EvUiClickPlayerReturn:new(nil)
    end
    self.ViewMgr:sendEv(ev)
end

function ViewDesktopPlayerOperateTexas:_onClickBack()
    local ev = self.ViewMgr:getEv("EvUiClickCancelAutoAction")
    if (ev == nil)
    then
        ev = EvUiClickCancelAutoAction:new(nil)
    end
    self.ViewMgr:sendEv(ev)
end

ViewDesktopPlayerOperateTexasFactory = ViewFactory:new()

function ViewDesktopPlayerOperateTexasFactory:new(o, ui_package_name, ui_component_name,
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

function ViewDesktopPlayerOperateTexasFactory:createView()
    local view = ViewDesktopPlayerOperateTexas:new(nil)
    return view
end