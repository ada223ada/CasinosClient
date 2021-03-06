UiRegister = {}

function UiRegister:new(view)
	local o = {}
	setmetatable(o, self)
	self.__index = self
	o.ViewLogin = view
	local obj_register = view.ComUi:GetChild("Register")
	if (obj_register ~= nil)
	then
		local group_register = obj_register.asGroup
		local obj_btn_register = view.ComUi:GetChildInGroup(group_register, "BtnRegister")
		if (obj_btn_register ~= nil)
		then
			o.BtnRegister = obj_btn_register.asButton
			o.BtnRegister.onClick:Add(
					function()
						o:_onClickBtnRegister()
					end
			)
		end

		local btn_return = view.ComUi:GetChildInGroup(group_register, "BtnReturn")
		if (btn_return ~= nil)
		then
			btn_return.asButton.onClick:Add(
					function()
						o:_onClickBtnReturn()
					end
			)
		end

		local com_accregister = view.ComUi:GetChild("ComCountryCordReg").asCom
		local com_text_code = com_accregister:GetChild("ComTextCountryCode").asCom
		com_text_code.onClick:Add(
				function()
					o:_showChoseCountryCode()
				end)
		o.TextCountryCode = com_text_code:GetChild("TextCountryCord").asTextField
		o:setCurrentCountryCode(o.ViewLogin.UiChooseCountryCode.CountryKey
		,o.ViewLogin.UiChooseCountryCode.CountryCode,o.ViewLogin.UiChooseCountryCode.KeyAndCodeFormat)
		o.GTextInputAccRegister = com_accregister:GetChild("InputAccLogin").asTextInput
		o.GTextInputAccRegister.promptText = string.format("[color=#999999]%s[/color]",view.ViewMgr.LanMgr:getLanValue("EnterPhone"))
		o.GTextInputAccRegister.onChanged:Set(
				function()
					o:_checkRegisterInput()
				end
		)
		--o.GTextInputAccRegister:RequestFocus()

		local com_pwdregister = view.ComUi:GetChildInGroup(group_register, "ComPwdReg").asCom
		o.GTextInputPwdRegister = com_pwdregister:GetChild("InputPwdRegister").asTextInput
		o.GTextInputPwdRegister.promptText = string.format("[color=#999999]%s[/color]",view.ViewMgr.LanMgr:getLanValue("EnterPwdTips1"))
		o.GTextInputPwdRegister.onChanged:Set(
				function()
					o:_checkRegisterInput()
				end
		)

		o:_checkRegisterInput()
	end

	local obj_registercode = view.ComUi:GetChild("RegisterCode")
	if (obj_registercode ~= nil)
	then
		local group_registercode = obj_registercode.asGroup
		o.TextRegisterPhone = view.ComUi:GetChildInGroup(group_registercode, "TextRegisterPhone").asTextField
		o.TextRegisterCode = view.ComUi:GetChildInGroup(group_registercode, "TextRegisterCode").asTextInput
		o.TextRegisterCode.promptText =string.format("[color=#999999]%s[/color]",view.ViewMgr.LanMgr:getLanValue("PhoneCode"))
		o.TextRegisterCode.onChanged:Set(
				function()
					o:_checkRegisterCodeInput()
				end
		)
		o.TextResend = view.ComUi:GetChildInGroup(group_registercode, "Lan_Text_Resend").asTextField

		local btn_return = view.ComUi:GetChildInGroup(group_registercode, "BtnReturn")
		if (btn_return ~= nil)
		then
			btn_return.asButton.onClick:Add(
					function()
						o:_onClickBtnReturnRegisterCode()
					end
			)
		end

		o.BtnResend = view.ComUi:GetChildInGroup(group_registercode, "BtnReSend").asButton
		o.BtnResend.onClick:Add(
				function()
					o:_onClickBtnResend()
				end
		)

		o.BtnNext = view.ComUi:GetChildInGroup(group_registercode, "BtnNext").asButton
		o.BtnNext.onClick:Add(
				function()
					o:_onClickBtnNext()
				end
		)
		o:_checkRegisterCodeInput()
	end
	o.PhoneCodeIsSend = false
	o.NextPhoneCodeSendTm = 60

	return o
end

function UiRegister:OnUpdate(tm)
	if self.PhoneCodeIsSend then
		local next_tm = self.NextPhoneCodeSendTm
		next_tm = next_tm - tm
		self.NextPhoneCodeSendTm = next_tm

		if next_tm <= 0 then
			self.TextResend.text = self.ViewLogin.ViewMgr.LanMgr:getLanValue("Resend")
			self.BtnResend.enabled = true
			self.PhoneCodeIsSend = false
			self.NextPhoneCodeSendTm = 60
		else
			self.TextResend.text = string.format("%s(%s)",self.ViewLogin.ViewMgr.LanMgr:getLanValue("Resend"), math.floor(next_tm))
		end
	end
end

function UiRegister:setCurrentCountryCode(key, code, format)
	self.TextCountryCode.text = format
	self.CountryKey = key
	self.CountryCode = code
end

function UiRegister:_onClickBtnRegister()
	if (self.ViewLogin:_hasAgreeAgreement() == false)
	then
		return
	end
	if (self.ViewLogin.CasinosContext.ServerIsInvalid)
	then
		ViewHelper:UiShowInfoSuccess(self.ViewLogin.CasinosContext.ServerStateInfo)
		return
	end

	--发送验证码
	local msg_box = self.ViewLogin.ViewMgr:getView("MsgBox")
	if msg_box == nil then
		msg_box = self.ViewLogin.ViewMgr:createView("MsgBox")
	end
	msg_box:useTwoBtn(self.ViewLogin.ViewMgr.LanMgr:getLanValue("ConfirmPhone"), string.format("%s：\n%s%s",self.ViewLogin.ViewMgr.LanMgr:getLanValue("SendCodeToPhone"),self.CountryCode,self.GTextInputAccRegister.text),
			function()
				self.ViewLogin:Switch2RegisterCode();
				self.PhoneFormat = self.CountryCode .. self.GTextInputAccRegister.text
				self.Phone = self.GTextInputAccRegister.text
				local p_f = "+"..self.CountryCode .." ".. self.GTextInputAccRegister.text
				self.TextRegisterPhone.text = p_f
				local ev = self.ViewLogin.ViewMgr:getEv("EvUiRequestGetPhoneCode")
				if (ev == nil)
				then
					ev = EvUiRequestGetPhoneCode:new(nil)
				end
				ev.Phone = self.PhoneFormat
				self.ViewLogin.ViewMgr:sendEv(ev)
				self.PhoneCodeIsSend = true
				self.NextPhoneCodeSendTm = 60
				self.BtnResend.enabled = false
				self.ViewLogin.ViewMgr:destroyView(msg_box)
				--self.TextRegisterCode:RequestFocus()
			end,
			function()
				self.ViewLogin.ViewMgr:destroyView(msg_box)
			end
	)
end

function UiRegister:_onClickBtnReturn()
	self.ViewLogin:_switchController("LoginState", "Login")
end

function UiRegister:_checkRegisterInput()
	if (self.GTextInputAccRegister == nil or self.GTextInputPwdRegister == nil)
	then
		return
	end

	if ((self.GTextInputAccRegister ~= nil and string.len(self.GTextInputAccRegister.text) > 0)
			and (self.GTextInputPwdRegister ~= nil and string.len(self.GTextInputPwdRegister.text) > 0))
	then
		self.BtnRegister.alpha = 1
		self.BtnRegister.enabled = true
	else
		self.BtnRegister.alpha = 0.5
		self.BtnRegister.enabled = false
	end
end

function UiRegister:_checkRegisterCodeInput()
	if (self.TextRegisterCode == nil)
	then
		return
	end

	if ((self.TextRegisterCode ~= nil and string.len(self.TextRegisterCode.text) > 0))
	then
		self.BtnNext.alpha = 1
		self.BtnNext.enabled = true
	else
		self.BtnNext.alpha = 0.5
		self.BtnNext.enabled = false
	end
end

function UiRegister:_onClickBtnReturnRegisterCode()
	local msg_box = self.ViewLogin.ViewMgr:getView("MsgBox")
	if msg_box == nil then
		msg_box = self.ViewLogin.ViewMgr:createView("MsgBox")
	end
	msg_box:useTwoBtn2(self.ViewLogin.ViewMgr.LanMgr:getLanValue("SendCodeTipTitle"), self.ViewLogin.ViewMgr.LanMgr:getLanValue("SendCodeTipContent"),
			self.ViewLogin.ViewMgr.LanMgr:getLanValue("Wait"), self.ViewLogin.ViewMgr.LanMgr:getLanValue("Return"), 0, false,
			function()
				self.ViewLogin.ViewMgr:destroyView(msg_box)
			end,
			function()
				self.ViewLogin:_switchController("LoginState", "Register")
				--self.GTextInputAccRegister:RequestFocus()
				self.ViewLogin.ViewMgr:destroyView(msg_box)
			end
	)
end

function UiRegister:_onClickBtnResend()
	local msg_box = self.ViewLogin.ViewMgr:getView("MsgBox")
	if msg_box == nil then
		msg_box = self.ViewLogin.ViewMgr:createView("MsgBox")
	end
	msg_box:useTwoBtn(self.ViewLogin.ViewMgr.LanMgr:getLanValue("Confirm"), self.ViewLogin.ViewMgr.LanMgr:getLanValue("ResendCode"),
			function()
				local ev = self.ViewLogin.ViewMgr:getEv("EvUiRequestGetPhoneCode")
				if (ev == nil)
				then
					ev = EvUiRequestGetPhoneCode:new(nil)
				end
				ev.Phone = self.PhoneFormat
				self.ViewLogin.ViewMgr:sendEv(ev)
				self.PhoneCodeIsSend = true
				self.NextPhoneCodeSendTm = 60
				self.BtnResend.enabled = false
				self.ViewLogin.ViewMgr:destroyView(msg_box)
			end,
			function()
				self.ViewLogin.ViewMgr:destroyView(msg_box)
			end
	)
end

function UiRegister:_onClickBtnNext()
	local ev = self.ViewLogin.ViewMgr:getEv("EvUiLoginClickBtnRegister")
	if (ev == nil)
	then
		ev = EvUiLoginClickBtnRegister:new(nil)
	end
	ev.AccountName = ""
	ev.Password = self.GTextInputPwdRegister.text
	ev.SuperPassword = ""
	ev.remeber_pwd = true
	ev.Email = ""
	ev.Identity = ""
	ev.Phone = self.Phone
	ev.Name = ""
	ev.Device = nil
	ev.PhoneVerificationCode = self.TextRegisterCode.text
	ev.FormatPhone = self.PhoneFormat
	self.ViewLogin.ViewMgr:sendEv(ev)
end

function UiRegister:_showChoseCountryCode()
	self.ViewLogin.UiChooseCountryCode:show()
end