TableUiLayer = {
	None=0,
	Background = 1,
	SceneActor = 51,
	DesktopChat = 151,
	PlayerOperateUi = 251,
	ShootingText = 300,
	NomalUiMain = 351,
	NomalUi = 451,
	MessgeBox = 551,
	Loading = 651,
	Waiting = 751,
	QuitGame = 851,
	GM = 951,
}

ViewMgr = {
	STANDARD_WIDTH = 1066,
	STANDARD_HEIGHT = 640,
	LayerDistance = 1,
	Instance = nil,
	MainC = nil,
	EventSys = nil,
	TableViewFactory = {},
	TableViewSingle = {},
	TableViewMultiple = {},
	TableMaxDepth = {},
	TableUpdateView = {},
}

function ViewMgr:new(o)
	o = o or {}
	setmetatable(o,self)
	self.__index = self
	if(self.Instance==nil)
	then
		self.Instance = o
		self.UiPathRoot = nil
		self.ResourcesRowPathRoot = nil
		self.LayerDistance = 1
		self.MainC = nil
		self.EventSys = nil
		self.TableViewFactory = {}
		self.TableViewSingle = {}
		self.TableViewMultiple = {}
		self.TableMaxDepth = {}
		self.TableUpdateView = {}
		self.ControllerMgr = nil
		self.LanMgr	 = nil
	end
	return self.Instance
end

function ViewMgr:onCreate(uipath_root,resourcesrow_pathroot)
	print("ViewMgr:onCreate")
	self.UiPathRoot = uipath_root
	self.ResourcesRowPathRoot = resourcesrow_pathroot
	CS.FairyGUI.GRoot.inst:SetContentScaleFactor(self.STANDARD_WIDTH, self.STANDARD_HEIGHT,
			CS.FairyGUI.UIContentScaler.ScreenMatchMode.MatchWidthOrHeight)
	--CS.FairyGUI.UIConfig.defaultFont = "FZCuYuan-M03S"
	--CS.FairyGUI.UIConfig.defaultFont = "FZLanTingHei-R-GBK"
	CS.FairyGUI.UIConfig.defaultFont = "FontXi"
	if(CS.UnityEngine.PlayerPrefs.HasKey("ScreenAutoRotation"))
	then
		local autoRotation = CS.UnityEngine.PlayerPrefs.GetString("ScreenAutoRotation")
		if(autoRotation == "true")
		then
			CS.UnityEngine.Screen.orientation = CS.UnityEngine.ScreenOrientation.AutoRotation
			CS.UnityEngine.Screen.autorotateToLandscapeRight = true
			CS.UnityEngine.Screen.autorotateToLandscapeLeft = true
			CS.UnityEngine.Screen.autorotateToPortraitUpsideDown = false
			CS.UnityEngine.Screen.autorotateToPortrait = false
		end
	end
	self.MainC = MainC:new(nil)
	self.EventSys = EventSys:new(nil)

	MainC:doString("EventView")
	MainC:doString("ViewBase")
	MainC:doString("ViewFactory")
end

function ViewMgr:onDestroy()

end

function ViewMgr:onUpdate(tm)
	--ViewMgr.LuaHelper:CloneTableData(ViewMgr.TableViewSingle,ViewMgr.TableUpdateView)
	for k,v in pairs(self.TableViewSingle) do
		if(v~=nil)
		then
			v:onUpdate(tm)
		end
	end

	for i, v in pairs(self.TableViewMultiple) do
		if(v ~= nil)
		then
			for i_i, v_v in pairs(v) do
				v_v:onUpdate(tm)
			end
		end
	end
	--ViewMgr.TableUpdateView = {}
end

function ViewMgr:regView(view_key,view_factory)
	if(view_factory ~= nil)
	then
		self.TableViewFactory[view_key] = view_factory
	end
end

function ViewMgr:createView(view_key)
	local view_factory = self.TableViewFactory[view_key]
	if(view_factory == nil)
	then
		return nil
	end

	local view = self.TableViewSingle[view_key]
	if(view_factory.IsSingle and view ~= nil)
	then
		return view
	end

	self:_checkDestroyUi(view_factory.UILayer)
	local go = CS.UnityEngine.GameObject()
	go.name = view_factory.ComponentName
	local layer = CS.UnityEngine.LayerMask.NameToLayer(CS.FairyGUI.StageCamera.LayerName)
	go.layer = layer
	local ui_panel = CS.Casinos.LuaHelper.addFairyGUIPanel(go)
	ui_panel.packageName = view_factory.PackageName
	ui_panel.componentName = view_factory.ComponentName
	ui_panel.fitScreen = view_factory.FitScreen
	ui_panel:ApplyModifiedProperties(false, true)
	view = view_factory:createView()
	view.ViewMgr = self.Instance
	view.GoUi = go
	view.ComUi = ui_panel.ui
	view.Panel = ui_panel
	view.UILayer = view_factory.UILayer
	view.ViewKey = view_key
	view:onCreate()

	if(view_factory.IsSingle)
	then
		self.TableViewSingle[view_key] = view
	else
		local table_multiple = self.TableViewMultiple[view_key]
		if(table_multiple == nil)
		then
			table_multiple = {}
			self.TableViewMultiple[view_key] = table_multiple
		end
		table_multiple[view] = view
	end

	local depth_layer = self.TableMaxDepth[view_factory.UILayer]
	if(depth_layer == nil)
	then
		depth_layer = TableUiLayer[view_factory.UILayer]
		view.InitDepth = depth_layer
	else
		view.InitDepth = depth_layer
		depth_layer = depth_layer + self.LayerDistance
	end

	ui_panel:SetSortingOrder(depth_layer, true)
	self.TableMaxDepth[view_factory.UILayer] = depth_layer
	self.LanMgr:parseComponent(ui_panel.ui)
	if (view_factory.UILayer == "MessgeBox" or
			view_factory.UILayer == "NomalUiMain" or
			view_factory.UILayer == "NomalUi" or
			view_factory.UILayer == "QuitGame")
	then
		CS.Casinos.CasinosContext.Instance:play("CreateDialog", CS.Casinos._eSoundLayer.LayerReplace)
	end
	return view
end

function ViewMgr:destroyView(view)
	if(view~=nil)
	then
		local view_key = view.ViewKey
		local view_ex = self.TableViewSingle[view_key]
		if(view_ex~=nil)
		then
			self.TableViewSingle[view_key] = nil
			view:onDestroy()
		else
			local table_multiple = self.TableViewMultiple[view_key]
			if (table_multiple ~= nil and #table_multiple>0)
			then
				LuaHelper:TableRemoveV(table_multiple,view)
				view:onDestroy()
			end
		end
		self.TableMaxDepth[view.UILayer] = view.InitDepth
		view.ComUi:Dispose()
		CS.UnityEngine.GameObject.Destroy(view.GoUi)
		if (view.UILayer == "MessgeBox" or
				view.UILayer == "NomalUiMain" or
				view.UILayer == "NomalUi" or
				view.UILayer == "QuitGame")
		then
			CS.Casinos.CasinosContext.Instance:play("DestroyDialog", CS.Casinos._eSoundLayer.LayerReplace)
		end
		view = nil
	end
end

function ViewMgr:getView(view_key)
	local view = self.TableViewSingle[view_key]
	return view
end

function ViewMgr:destroyAllView()
	local table_need_destroyui = {}
	for k,v in pairs(self.TableViewSingle) do
		table_need_destroyui[k] = v
	end

	for k,v in pairs(self.TableViewMultiple) do
		for k1,v1 in pairs(v) do
			table_need_destroyui[k1] = v1
		end
	end

	for k,v in pairs(table_need_destroyui) do
		self.TableMaxDepth[v.UILayer] = v.InitDepth
		v:onDestroy()
		CS.UnityEngine.GameObject.Destroy(v.GoUi)
		v = nil
	end

	self.TableViewSingle = {}
	self.TableViewMultiple = {}
end

function ViewMgr:_checkDestroyUi(t_layer)
	if (t_layer == "None" or t_layer == "MessgeBox" or t_layer == "SceneActor"
			or t_layer == "PlayerOperateUi" or t_layer == "ShootingText")
	then
		return
	end

	local layer_v = TableUiLayer[t_layer]
	local map_need_destroyui = {}
	for i, v in pairs(self.TableViewSingle) do
		local v_layer_v = TableUiLayer[v.UILayer]
		if ((t_layer == "MessgeBox" and t_layer == v.UILayer) or (t_layer == "NomalUi" and t_layer == v.UILayer)
				or (layer_v > v_layer_v))
		then
		else
			map_need_destroyui[i] = v
		end
	end

	for i, v in pairs(map_need_destroyui) do
		local view = self.TableViewSingle[i]
		if (view ~= nil)
		then
			self.TableViewSingle[i] = nil
			local layer = v.UILayer
			self.TableMaxDepth[layer] = v.InitDepth
			v:onDestroy()
			v.ComUi:Dispose()
			CS.UnityEngine.GameObject.Destroy(v.GoUi)
		end
	end

	map_need_destroyui = {}

	local map_need_destroyuis = {}
	for i, v in pairs(self.TableViewMultiple) do
		local can_destroy = false
		for i_i, v_v in pairs(v) do
			local v_v_layer_v  = TableUiLayer[v_v.UILayer]
			if (t_layer == v_v.UILayer or (layer_v > v_v_layer_v))
			then
			else
				can_destroy = true
			end
		end

		if (can_destroy)
		then
			map_need_destroyuis[i]= v
		end
	end

	for i, v in pairs(map_need_destroyuis) do
		for i_i, v_v in pairs(v) do
			local views = self.TableViewMultiple[i]
			if (views ~= nil)
			then
				self.TableViewMultiple[i] = nil
				local layer = v_v.UILayer
				self.TableMaxDepth[layer] = v_v.InitDepth
				v_v:onDestroy()
				v_v.ComUi:Dispose()
				CS.UnityEngine.GameObject.Destroy(v_v.GoUi)
			end
		end
	end
	map_need_destroyuis = {}
end

function ViewMgr:bindEvListener(ev_name,ev_listener)
	if(self.EventSys ~= nil)
	then
		self.EventSys:bindEvListener(ev_name,ev_listener)
	end
end

function ViewMgr:unbindEvListener(ev_listener)
	if(self.EventSys ~= nil)
	then
		self.EventSys:unbindEvListener(ev_listener)
	end
end

function ViewMgr:getEv(ev_name)
	local ev = nil
	if(self.EventSys ~= nil)
	then
		ev = self.EventSys:getEv(ev_name)
	end
	return ev
end

function ViewMgr:sendEv(ev)
	if(self.EventSys ~= nil)
	then
		self.EventSys:sendEv(ev)
	end
end

function ViewMgr:getUiPackagePath(package_name)
	local s = CS.Casinos.CasinosContext.Instance.PathMgr:combinePersistentDataPath(
			self.UiPathRoot .. package_name .. "/" .. string.lower(package_name) .. ".ab")
	return s
end

function ViewMgr:packData(data)
	local p_datas = self.RPC:PackData(data)
	return p_datas
end

function ViewMgr:unpackData(data)
	local p_datas = self.RPC:UnPackData(data)
	return p_datas
end