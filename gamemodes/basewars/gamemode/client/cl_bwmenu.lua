-- BaseWars Menu for things and shit
-- by Ghosty

local me = LocalPlayer()

local button_width = 152
local grayTop 		= Color(128, 128, 128, 250)
local grayBottom 	= Color(96, 96, 96, 250)

local nodePanelBg	= Color(192, 192, 192, 250)
local shadowColor 	= Color(0, 0, 0, 200)

local bigFont = "BW.Menu.BigFont"
local medFont = "BW.Menu.MedFont"
local smallFont = "BW.Menu.SmallFont"

surface.CreateFont(bigFont, {
	font = "Roboto",
	size = 32,
})

surface.CreateFont(medFont, {
	font = "Roboto",
	size = 18,
})

surface.CreateFont(smallFont, {
	font = "Roboto",
	size = 16,
})


local PANEL = {}

local white = Color(255, 255, 255)
local gray = Color(192, 192, 192)
local black = Color(0, 0, 0)
local errorcolor = Color(255, 100, 100)
local highlight = Color(100, 100, 100, 200)

function PANEL:CheckError()
	return false
end

function PANEL:Paint(w, h)
	draw.RoundedBox(4, 0, 0, w, h, black)
	draw.RoundedBox(4, 1, 1, w - 2, h - 2, self:CheckError() and errorcolor or white)

	self:DrawTextEntryText(black, highlight, gray)

	return false
end

vgui.Register("BaseWars.ErrorCheckTextEntry", PANEL, "DTextEntry")

local function PrepMenu()
	local mainFrame = vgui.Create("DFrame")

	mainFrame:SetSize(900, 600)
	mainFrame:Center()
	mainFrame:SetTitle(BaseWars.LANG.BaseWarsMenu)
	mainFrame:SetIcon("icon16/application.png")
	mainFrame:MakePopup()
	mainFrame:SetDeleteOnClose(false)

	function mainFrame:Paint(w, h)
		draw.RoundedBoxEx(8, 0, 0, w, 24, grayTop, true, true, false, false)
		draw.RoundedBox(0, 0, 24, w, h - 24, grayBottom)
	end

	function mainFrame:Close()
		self:Hide()
		self:OnClose()
	end

	local tabPanel = mainFrame:Add("DPropertySheet")

	tabPanel:Dock(FILL)
	tabPanel:SetWide(200)

	function tabPanel:MakeTab(name, icon)
		local dpanel = vgui.Create("DPanel")
		self:AddSheet(name, dpanel, icon)

		return dpanel
	end

	local ftionTab = tabPanel:MakeTab(BaseWars.LANG.Factions, "icon16/layers.png")
	local raidsTab = tabPanel:MakeTab(BaseWars.LANG.Raids, "icon16/building_delete.png")
	local rulesTab = tabPanel:MakeTab(BaseWars.LANG.Rules, "icon16/script.png")
	--local infoTab  = tabPanel:MakeTab("", "icon16/help.png")

	return mainFrame, tabPanel, ftionTab, raidsTab, rulesTab--, infoTab
end

local function MakePlayerList(pnl)
	local plyList = pnl:Add("DListView")

	plyList:AddColumn(BaseWars.LANG.Player)
	plyList:AddColumn(BaseWars.LANG.Faction)

	plyList:Dock(FILL)

	plyList.PlayerLines = {}

	local function GetPlayer(t)
		for _, ply in next, player.GetAll() do
			if ply:Nick() == t then
			return ply end
		end

		return false
	end

	function plyList:UpdatePlayers()
		local plys = player.GetAll()

		for _, ply in pairs(plys) do
			if ply == me then continue end

			local plyInFaction, plyFaction = ply:InFaction(), ply:GetFaction()
			if not self.PlayerLines[ply] then
				local line = self:AddLine(ply:Nick(), plyInFaction and plyFaction or BaseWars.LANG.NoFaction)
				self.PlayerLines[ply] = line
			end
		end

		for ply, pnl in pairs(self.PlayerLines) do
			if not IsValid(pnl) then
				pnl:Remove()
				continue
			end

			if not pnl.SetColumnText then
				pnl:Remove()
				continue
			end

			if not IsValid(ply) then
				local id = pnl:GetID()
				self:RemoveLine(id)
				self.PlayerLines[ply] = nil

				continue
			end

			local plyInFaction, plyFaction = ply:InFaction(), ply:GetFaction()
			pnl:SetColumnText(2, plyInFaction and plyFaction or BaseWars.LANG.NoFaction)
		end
	end

	function plyList:Think()
		self:UpdatePlayers()
	end

	function plyList:OnRowSelected(id, panel)
		if not panel or not IsValid(panel) then return end

		self.SelectedPly = GetPlayer(panel:GetColumnText(1))
	end

	plyList:UpdatePlayers()

	return plyList
end

local dialogs = {
	Factions = {
		Create = function(pnl)
			pnl:SetTitle(BaseWars.LANG.CreateFaction:upper())

			local warning = pnl:Add("DLabel")
				warning:Dock(TOP)
				warning:SetText(BaseWars.LANG.CreateNotice)
				warning:SetFont(smallFont)
				warning:SetBright(true)
				warning:SizeToContents()

			local nameLabel = pnl:Add("DLabel")
				nameLabel:Dock(TOP)
				nameLabel:DockMargin(0, 16 + 4, 0, 0)
				nameLabel:SetText(BaseWars.LANG.FactionName)
				nameLabel:SetFont(smallFont)
				nameLabel:SizeToContents()

			local nameInput = pnl:Add("DTextEntry")
				nameInput:Dock(TOP)
				nameInput:DockMargin(0, 0, 260, 0)

			local pwLabel = pnl:Add("DLabel")
				pwLabel:Dock(TOP)
				pwLabel:DockMargin(0, 4, 0, 0)
				pwLabel:SetText(BaseWars.LANG.FactionPassword)
				pwLabel:SetFont(smallFont)
				pwLabel:SizeToContents()

			local pwInput = pnl:Add("DTextEntry")
				pwInput:Dock(TOP)
				pwInput:DockMargin(0, 0, 260, 0)

			local colorpanel = pnl:Add("DPanel")
				local defcol = HSVToColor(math.random(359), math.Rand(0.8, 1), math.Rand(0.8, 1))
				colorpanel:SetPos(480, 35 + 160 + 10)
				colorpanel:SetSize(160 + 10 + 25, 25)
				colorpanel:SetBackgroundColor(defcol)

				local bgCol = Color(30, 30, 30)
				function colorpanel:Paint(w, h)
					surface.SetDrawColor(bgCol)
					surface.DrawOutlinedRect(0, 0, w, h)
				end

			local colorcube = pnl:Add("DColorCube")
				colorcube:SetPos(480, 35)
				colorcube:SetSize(160, 160)
				colorcube.CurColor = defcol
				colorcube:SetColor(colorcube.CurColor)

				function colorcube:OnUserChanged(col)
					colorpanel:SetBackgroundColor(col)
					colorcube.CurColor = col
				end

			local colorpicker = pnl:Add("DRGBPicker")
				colorpicker:SetPos(480 + 160 + 10, 35)
				colorpicker:SetSize(25, 160)

				function colorpicker:OnChange(col)
					colorcube:SetColor(col)
					colorpanel:SetBackgroundColor(col)
					colorcube.CurColor = col
				end

			local buttonpar = pnl:Add("Panel")
				buttonpar:Dock(TOP)
				buttonpar:DockMargin(0, 24, 0, 0)
				buttonpar:SetTall(24)

			local createButton = buttonpar:Add("DButton")
				createButton:Dock(LEFT)
				createButton:SetWide(button_width)
				createButton:SetText(BaseWars.LANG.Create)
				createButton:SetImage("icon16/tick.png")
				createButton:SetFont(smallFont)

				function createButton:DoClick()
					local name, pw = nameInput:GetValue(), pwInput:GetValue()
					name, pw = name:Trim(), pw:Trim()

					me:CreateFaction(name, (#pw > 0 and pw), colorcube.CurColor)

					pnl:Close()
				end

				function createButton:Think()
					local name, pw = nameInput:GetValue(), pwInput:GetValue()
					name, pw = name:Trim(), pw:Trim()

					self:SetDisabled(false)

					if
						(#name < 5 or #name > 36)
						or
						(#pw > 0 and (#pw < 5 or #pw > 32))
					then
						self:SetDisabled(true)

						return
					end
				end

			local cancelButton = buttonpar:Add("DButton")
				cancelButton:Dock(LEFT)
				cancelButton:DockMargin(4, 0, 0, 0)
				cancelButton:SetWide(button_width)
				cancelButton:SetText(BaseWars.LANG.Nevermind)
				cancelButton:SetImage("icon16/cross.png")
				cancelButton:SetFont(smallFont)

			function cancelButton:DoClick()
				pnl:Close()
			end

			pnl:SetTall(250 - 8)
		end,

		Join = function(pnl, txt)
			pnl:SetTitle(BaseWars.LANG.JoinFaction:upper())

			local warning = pnl:Add("DLabel")
				warning:Dock(TOP)
				warning:SetText(BaseWars.LANG.JoinWarning)
				warning:SetFont(smallFont)
				warning:SetBright(true)
				warning:SizeToContents()

			local nameLabel = pnl:Add("DLabel")
				nameLabel:Dock(TOP)
				nameLabel:DockMargin(0, 16 + 4, 0, 0)
				nameLabel:SetText(BaseWars.LANG.FactionName)
				nameLabel:SetFont(smallFont)
				nameLabel:SizeToContents()

			local nameInput = pnl:Add("DTextEntry")
				nameInput:Dock(TOP)
				nameInput:SetValue(txt or "")

			local pwLabel = pnl:Add("DLabel")
				pwLabel:Dock(TOP)
				pwLabel:DockMargin(0, 4, 0, 0)
				pwLabel:SetText(BaseWars.LANG.FactionPassword)
				pwLabel:SetFont(smallFont)
				pwLabel:SizeToContents()

			local pwInput = pnl:Add("DTextEntry")
				pwInput:Dock(TOP)

			local buttonpar = pnl:Add("Panel")
				buttonpar:Dock(TOP)
				buttonpar:DockMargin(0, 24, 0, 0)
				buttonpar:SetTall(24)

			local createButton = buttonpar:Add("DButton")
				createButton:Dock(LEFT)
				createButton:SetWide(button_width)
				createButton:SetText(BaseWars.LANG.Join)
				createButton:SetImage("icon16/tick.png")
				createButton:SetFont(smallFont)

				function createButton:DoClick()
					local name, pw = nameInput:GetValue(), pwInput:GetValue()
					name, pw = name:Trim(), pw:Trim()

					me:JoinFaction(name, (#pw > 0 and pw), true)

					pnl:Close()
				end

				function createButton:Think()
					local name, pw = nameInput:GetValue(), pwInput:GetValue()
					name, pw = name:Trim(), pw:Trim()

					self:SetDisabled(false)

					if
						(#name < 5 or #name > 36)
						or
						(#pw > 0 and (#pw < 5 or #pw > 32))
					then
						self:SetDisabled(true)
						return
					end
				end

			local cancelButton = buttonpar:Add("DButton")
				cancelButton:Dock(LEFT)
				cancelButton:DockMargin(4, 0, 0, 0)
				cancelButton:SetWide(button_width)
				cancelButton:SetText(BaseWars.LANG.Nevermind)
				cancelButton:SetImage("icon16/cross.png")
				cancelButton:SetFont(smallFont)

				function cancelButton:DoClick()
					pnl:Close()
				end

			pnl:SetTall(250 - 8 - 46)
		end,

		Leave = function(pnl)
			pnl:SetTitle(BaseWars.LANG.LeaveFaction:upper())

			local warning = pnl:Add("DLabel")
				warning:Dock(TOP)
				warning:SetText(BaseWars.LANG.ConfirmLeave)
				warning:SetFont(smallFont)
				warning:SetBright(true)
				warning:SizeToContents()

			local buttonpar = pnl:Add("Panel")
				buttonpar:Dock(TOP)
				buttonpar:DockMargin(0, 24, 0, 0)
				buttonpar:SetTall(24)

			local createButton = buttonpar:Add("DButton")
				createButton:Dock(LEFT)
				createButton:SetWide(button_width)
				createButton:SetText(BaseWars.LANG.Leave)
				createButton:SetImage("icon16/user_delete.png")
				createButton:SetFont(smallFont)

			function createButton:DoClick()
				me:LeaveFaction(true)

				pnl:Close()
			end

			local cancelButton = buttonpar:Add("DButton")
				cancelButton:Dock(LEFT)
				cancelButton:DockMargin(4, 0, 0, 0)
				cancelButton:SetWide(button_width)
				cancelButton:SetText(BaseWars.LANG.Nevermind)
				cancelButton:SetImage("icon16/cross.png")
				cancelButton:SetFont(smallFont)

			function cancelButton:DoClick()
				pnl:Close()
			end

			pnl:SetSize(270, 162 - 8 - 40)
		end,
	}
}

local bgColor = Color(122, 122, 122)
local bdColor = Color(100, 100, 100)
local bbColor = Color(255, 255, 255, 20)

local function CreatePopupDialog(c, id, ...)
	local bgPanel = vgui.Create("DPanel")
		bgPanel:Dock(FILL)
		function bgPanel:Paint() end

	local stuff = dialogs[c] and dialogs[c][id]
	if not stuff then return end

	local pnl = vgui.Create("DFrame")

	local mX, mY = gui.MousePos()

    local sizex, sizey = 500, 300

    if c == "Factions" and id == "Create" then --"Factions","Create"
        sizex, sizey = 700, 300
    end

	pnl:SetSize(sizex, sizey)

	function pnl:Paint(w, h)
		self:NoClipping(false)
		draw.RoundedBox(0, -2, -2, w + 4, h + 4, bdColor)
		self:NoClipping(true)

		draw.RoundedBox(0, 0, 0, w, h, bgColor)
		draw.RoundedBox(0, 0, 24, w, h - 24, bbColor)
	end

	function bgPanel:OnMouseReleased()
		if not IsValid(pnl) then
			self:Remove()
			return
		end

		pnl:Close()
	end

	function pnl:Close()
		bgPanel:Remove()

		self:SizeTo(0, 0, 0.1, 0, -1, function(_, pnl)
			if IsValid(pnl) then pnl:Remove() end
		end)
	end

	pnl:SetTitle("")
	stuff(pnl, ...)

	pnl:SetPos(mX + 16, mY + 16)
	pnl.lblTitle:SetFont(smallFont)
	pnl.btnMaxim:Hide()
	pnl.btnMinim:Hide()

	local x, y = pnl:GetPos()
	local w, h = pnl:GetSize()

	if x + w > ScrW() then
		pnl.x = ScrW() - w
	end

	if y + h > ScrH() then
		pnl.y = ScrH() - h
	end

	pnl:MakePopup()

	pnl:SetSize(0, 0)
	pnl:SizeTo(w, h, 0.1, 0, -1, function() end)

	return pnl
end

local function MakeMenu(mainFrame, tabPanel, ftionTab, raidsTab, rulesTab--[[, infoTab]])
	function mainFrame:OpenMenuThing(c, i, ...)
		if IsValid(self.menuthing) then
			self.menuthing:Remove()
			self.menuthing = nil
		end

		self.menuthing = CreatePopupDialog(c, i, ...)
	end

	function mainFrame:OnClose()
		if IsValid(self.menuthing) then
			self.menuthing:Remove()
			self.menuthing = nil
		end
	end

	do -- Factions tab
		ftionTab:DockPadding(16, 8, 16, 16)

		local ftionLabel = ftionTab:Add("DLabel")
			ftionLabel:Dock(TOP)
			ftionLabel:SetText(BaseWars.LANG.Factions)
			ftionLabel:SetFont(bigFont)
			ftionLabel:SetDark(true)
			-- ftionLabel:SetExpensiveShadow(2, shadowColor)
			ftionLabel:SizeToContents()

		local yourfLabel = ftionTab:Add("DLabel")
			yourfLabel:SetPos(128 + 16, 20)
			yourfLabel:SetText("")
			yourfLabel:SetFont(medFont)
			yourfLabel:SetDark(true)
			yourfLabel:SizeToContents()

			function yourfLabel:Think()
				local inFaction, myFaction = me:InFaction(), me:GetFaction()

				if not inFaction then
					self:SetText(BaseWars.LANG.YouNotFaction)
				else
					self:SetText(BaseWars.LANG.YourFaction .. myFaction)
				end

				self:SizeToContents()
			end

		local plyList = MakePlayerList(ftionTab)

		local btns = ftionTab:Add("DPanel")
			btns:Dock(BOTTOM)
			btns:DockMargin(0, 8, 0, 0)
			btns:SetTall(32)

			function btns:Paint() end

		local btnCreate = btns:Add("DButton")
			btnCreate:Dock(LEFT)
			btnCreate:SetWide(button_width)
			btnCreate:SetImage("icon16/star.png")
			btnCreate:SetText(BaseWars.LANG.CreateFaction)

			function btnCreate:DoClick()
				mainFrame:OpenMenuThing("Factions", "Create")
			end

		local btnJoin = btns:Add("DButton")
			btnJoin:DockMargin(8, 0, 0, 0)
			btnJoin:Dock(LEFT)
			btnJoin:SetWide(button_width)
			btnJoin:SetImage("icon16/user_add.png")
			btnJoin:SetText(BaseWars.LANG.JoinFaction)

			function btnJoin:DoClick()
				local val
				local sel = plyList:GetLine(plyList:GetSelectedLine())

				if IsValid(sel) then
					val = sel:GetColumnText(2)
				end

				mainFrame:OpenMenuThing("Factions","Join",val)
			end

		local btnLeave = btns:Add("DButton")
			btnLeave:DockMargin(8, 0, 0, 0)
			btnLeave:Dock(LEFT)
			btnLeave:SetWide(button_width)
			btnLeave:SetImage("icon16/cancel.png")
			btnLeave:SetText(BaseWars.LANG.LeaveFaction)

			function btnLeave:DoClick()
				mainFrame:OpenMenuThing("Factions","Leave")
			end

			function btnLeave:Think()
				if me:InFaction() then self:SetDisabled(false) else self:SetDisabled(true) end
			end
	end

	do -- Raids tab
		raidsTab:DockPadding(16, 8, 16, 16)

		local raidLabel = raidsTab:Add("DLabel")
			raidLabel:Dock(TOP)
			raidLabel:SetText(BaseWars.LANG.Raids)
			raidLabel:SetFont(bigFont)
			raidLabel:SetDark(true)
			-- raidLabel:SetExpensiveShadow(2, shadowColor)
			raidLabel:SizeToContents()

		local yourfLabel = raidsTab:Add("DLabel")
			yourfLabel:SetPos(128 + 16, 20)
			yourfLabel:SetText("")
			yourfLabel:SetFont(medFont)
			yourfLabel:SetDark(true)
			yourfLabel:SizeToContents()

			function yourfLabel:Think()
				local inFaction, myFaction = me:InFaction(), me:GetFaction()

				if not inFaction then
					self:SetText(BaseWars.LANG.YouNotFaction)
				else
					self:SetText(BaseWars.LANG.YourFaction .. myFaction)
				end

				self:SizeToContents()
			end

		local plyList = MakePlayerList(raidsTab)

		local btns = raidsTab:Add("DPanel")
			btns:Dock(BOTTOM)
			btns:DockMargin(0, 8, 0, 0)
			btns:SetTall(32)

			function btns:Paint() end

		local btnStart = btns:Add("DButton")
			btnStart:Dock(LEFT)
			btnStart:SetWide(button_width)
			btnStart:SetImage("icon16/building_go.png")
			btnStart:SetText(BaseWars.LANG.StartRaid)

			function btnStart:DoClick()
				me:StartRaid(self.Enemy)
			end

			function btnStart:Think()
				local Enemy 	= plyList.SelectedPly
				Enemy = BaseWars.Ents:ValidPlayer(Enemy) and Enemy

				local InFac 	= me:InFaction()
				local InFac2 	= Enemy and Enemy:InFaction() and not (Enemy:InFaction(me:GetFaction()))

				if not Enemy or (InFac and not InFac2) or (InFac2 and not InFac) then self:SetDisabled(true) else self:SetDisabled(false) self.Enemy = Enemy end
			end

		local btnConceed = btns:Add("DButton")
			btnConceed:DockMargin(8, 0, 0, 0)
			btnConceed:Dock(LEFT)
			btnConceed:SetWide(button_width)
			btnConceed:SetImage("icon16/building_error.png")
			btnConceed:SetText(BaseWars.LANG.ConceedRaid)

			function btnConceed:DoClick()
				me:ConceedRaid()
			end

			function btnConceed:Think()
				local Disabled = not (me:InRaid() and (not me:InFaction() or me:InFaction(nil, true)))

				self:SetDisabled(Disabled)
			end
	end

	do -- Rules tab
		rulesTab:DockPadding(16, 8, 16, 16)

		local rulesLabel = rulesTab:Add("DLabel")
			rulesLabel:Dock(TOP)
			rulesLabel:SetText(BaseWars.LANG.Rules)
			rulesLabel:SetFont(bigFont)
			rulesLabel:SetDark(true)
			-- rulesLabel:SetExpensiveShadow(2, shadowColor)
			rulesLabel:SizeToContents()

		local rulesHTML = rulesTab:Add("DHTML")
			rulesHTML:Dock(FILL)
			if BaseWars.Config.Rules.IsHTML then
				rulesHTML:SetHTML(BaseWars.Config.Rules.HTML or [[Error Loading HTML]])
			else
				rulesHTML:OpenURL(BaseWars.Config.Rules.HTML)
			end
	end

	--[[do -- Info tab
		infoTab:DockPadding(16, 8, 16, 16)

		local rulesHTML = infoTab:Add("DHTML")
			rulesHTML:Dock(FILL)
			if BaseWars.Config.HelpInfo.IsHTML then
				rulesHTML:SetHTML(BaseWars.Config.HelpInfo.HTML or "Error Loading HTML")
			else
				rulesHTML:OpenURL(BaseWars.Config.HelpInfo.HTML)
			end
	end]]

	hook.Run("BaseWars_GenerateMenu", mainFrame, tabPanel)

	mainFrame:SetVisible(false)

	return mainFrame
end

local pnl

local function MakeNotExist()
	if pnl and IsValid(pnl) then return end

	pnl = MakeMenu(PrepMenu())
	pnl:Hide()
end

local a

hook.Add("Think", "BaseWars.Menu.Open", function()
	me = LocalPlayer()

    local wep = me:GetActiveWeapon()
	if wep ~= NULL and wep.CW20Weapon and wep.dt.State == (CW_CUSTOMIZE or 4) then return end

	if input.IsKeyDown(KEY_F3) then
		if not a then
			MakeNotExist()

			a = true

			if pnl:IsVisible() then
				pnl:Close()
			else
				pnl:Show()
			end
		end
	else
		a = nil
	end
end)

concommand.Add("bw_togglemenu", function()
	MakeNotExist()

	if pnl:IsVisible() then
		pnl:Close()
	else
		pnl:Show()
	end
end)
