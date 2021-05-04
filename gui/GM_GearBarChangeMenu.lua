--[[
  MIT License

  Copyright (c) 2021 Michael Wiesendanger

  Permission is hereby granted, free of charge, to any person obtaining
  a copy of this software and associated documentation files (the
  "Software"), to deal in the Software without restriction, including
  without limitation the rights to use, copy, modify, merge, publish,
  distribute, sublicense, and/or sell copies of the Software, and to
  permit persons to whom the Software is furnished to do so, subject to
  the following conditions:

  The above copyright notice and this permission notice shall be
  included in all copies or substantial portions of the Software.

  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
  LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
  OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
  WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
]]--

-- luacheck: globals CreateFrame MouseIsOver GetItemCooldown STANDARD_TEXT_FONT

local mod = rggm
local me = {}

mod.gearBarChangeMenu = me

me.tag = "GearBarChangeMenu"

--[[
  Local references to heavily accessed targetcastbar ui elements
]]--
local changeMenuFrame
local changeMenuSlots = {}

--[[
  ELEMENTS
]]--

--[[
  Build the initial changeMenu for bagged items
]]--
function me.BuildChangeMenu()
  changeMenuFrame = CreateFrame("Frame", RGGM_CONSTANTS.ELEMENT_GEAR_BAR_CHANGE_FRAME)
  changeMenuFrame:SetWidth(RGGM_CONSTANTS.GEAR_BAR_CHANGE_ROW_AMOUNT * RGGM_CONSTANTS.GEAR_BAR_DEFAULT_SLOT_SIZE)
  changeMenuFrame:SetHeight(RGGM_CONSTANTS.GEAR_BAR_CHANGE_DEFAULT_HEIGHT)
  changeMenuFrame:SetBackdropColor(0, 0, 0, .5)
  changeMenuFrame:SetBackdropBorderColor(0, 0, 0, .8)

  local row
  local col = 0

  for position = 1, RGGM_CONSTANTS.GEAR_BAR_CHANGE_SLOT_AMOUNT do
    local xPos
    local yPos

    if math.fmod(position, 2) ~= 0 then
      -- left
      row = 0

      yPos = col * RGGM_CONSTANTS.GEAR_BAR_DEFAULT_SLOT_SIZE
      xPos = row * RGGM_CONSTANTS.GEAR_BAR_DEFAULT_SLOT_SIZE
    else
      -- right
      row = 1

      yPos = col * RGGM_CONSTANTS.GEAR_BAR_DEFAULT_SLOT_SIZE
      xPos = row * RGGM_CONSTANTS.GEAR_BAR_DEFAULT_SLOT_SIZE
      col = col + 1
    end

    local changeSlot = me.CreateChangeSlot(changeMenuFrame, position, xPos, yPos)

    me.SetupEvents(changeSlot)
    changeSlot:Hide()
  end

  changeMenuFrame:Hide() -- hide menu initially
end

--[[
  Create a single changeSlot

  @param {table} frame
  @param {number} position
  @param {number} xPos
  @param {number} yPos

  @return {table}
    The created changeSlot
]]--
function me.CreateChangeSlot(frame, position, xPos, yPos)
  local changeSlot = CreateFrame("Button", RGGM_CONSTANTS.ELEMENT_GEAR_BAR_SLOT .. position, frame)
  changeSlot:SetFrameLevel(frame:GetFrameLevel() + 1)
  changeSlot:SetSize(RGGM_CONSTANTS.GEAR_BAR_DEFAULT_SLOT_SIZE, RGGM_CONSTANTS.GEAR_BAR_DEFAULT_SLOT_SIZE)
  changeSlot:SetPoint(
    "BOTTOMLEFT",
    frame,
    "BOTTOMLEFT",
    xPos,
    yPos
  )

  local backdrop = {
    bgFile = "Interface\\AddOns\\GearMenu\\assets\\ui_slot_background",
    edgeFile = "Interface\\AddOns\\GearMenu\\assets\\ui_slot_background",
    tile = false,
    tileSize = 32,
    edgeSize = 20,
    insets = {
      left = 12,
      right = 12,
      top = 12,
      bottom = 12
    }
  }

  changeSlot:SetBackdrop(backdrop)
  changeSlot:SetBackdropColor(0.15, 0.15, 0.15, 1)
  changeSlot:SetBackdropBorderColor(0, 0, 0, 1)

  mod.uiHelper.CreateHighlightFrame(changeSlot)
  mod.uiHelper.CreateCooldownOverlay(
    changeSlot,
    RGGM_CONSTANTS.ELEMENT_GEAR_BAR_CHANGE_COOLDOWN_FRAME,
    RGGM_CONSTANTS.GEAR_BAR_DEFAULT_SLOT_SIZE
  )

  table.insert(changeMenuSlots, changeSlot) -- store changeSlot

  return changeSlot
end

--[[
  UPDATE
]]--

--[[
  Update the changeMenu. Note that the gearSlotPosition and gearBarId can be nil in case of a manual trigger
  of UpdateChangeMenu instead of through a 'hover' event on a gearSlot. In this case the
  last used gearbar and gearSlot are used.

  @param {table} gearSlotPosition
    The gearSlot position that was hovered
  @param {number} gearBarId
    The id of the hovered gearBar
]]--
function me.UpdateChangeMenu(gearSlotPosition, gearBarId)
  me.ResetChangeMenu()

  if gearSlotPosition == nil or gearBarId == nil then
    if changeMenuFrame.gearBarId ~= nil then
      gearBarId = changeMenuFrame.gearBarId
    else
      return
    end

    if changeMenuFrame.gearSlotPosition ~= nil then
      gearSlotPosition = changeMenuFrame.gearSlotPosition
    else
      return
    end
  end

  local gearBar = mod.gearBarManager.GetGearBar(gearBarId)
  local gearSlotMetaData = gearBar.slots[gearSlotPosition]

  if gearSlotMetaData ~= nil then
    local items = mod.itemManager.GetItemsForInventoryType(gearSlotMetaData.type)

    for index, item in ipairs(items) do
      if index > RGGM_CONSTANTS.GEAR_BAR_CHANGE_SLOT_AMOUNT_ITEMS then
        mod.logger.LogInfo(me.tag, "All changeMenuSlots are in use skipping rest of items...")
        break
      end

      me.UpdateChangeSlot(index, gearSlotMetaData, item)
    end

    me.UpdateEmptyChangeSlot(items, gearSlotMetaData)
    me.UpdateChangeMenuSize(items)
    me.UpdateChangeMenuPosition(
      mod.gearBarStorage.GetGearBar(gearBarId).gearSlotReferences[gearSlotPosition]
    )

    me.UpdateChangeMenuGearSlotCooldown()

    mod.ticker.StartTickerChangeMenu()

    -- update changeMenuFrame's Id to the currently hovered gearBarId
    changeMenuFrame.gearBarId = gearBarId
    -- update changeMenuFrame's gearSlot position to the currently hovered gearSlot
    changeMenuFrame.gearSlotPosition = gearSlotPosition

    -- cache whether cooldowns should be shown in the changemenu or not
    if mod.gearBarManager.IsShowCooldownsEnabled(gearBarId) then
      changeMenuFrame.showCooldowns = true
    else
      changeMenuFrame.showCooldowns = false
    end

    local gearBarUi = mod.gearBarStorage.GetGearBar(gearBarId)

    if gearBarUi and MouseIsOver(gearBarUi.gearBarReference) or MouseIsOver(changeMenuFrame) then
      changeMenuFrame:Show()
    end
  end
end

--[[
  Visually update a changeslot

  @param {number} index
  @param {table} gearSlotMetaData
  @param {table} item
]]--
function me.UpdateChangeSlot(index, gearSlotMetaData, item)
  local changeMenuSlot = changeMenuSlots[index]
  mod.uiHelper.UpdateSlotTextureAttributes(changeMenuSlot)

  -- update metadata for slot
  changeMenuSlot.slotId = gearSlotMetaData.slotId
  changeMenuSlot.itemId = item.id
  changeMenuSlot.equipSlot = item.equipSlot

  changeMenuSlot:SetNormalTexture(item.icon)
  changeMenuSlot:Show()
end

--[[
  Visually update an empty changeslot

  @param {table} gearSlotMetaData
  @param {table} items
]]--
function me.UpdateEmptyChangeSlot(items, gearSlotMetaData)
  if not mod.configuration.IsUnequipSlotEnabled() then return end

  local itemCount = table.getn(items)
  local emptyChangeMenuSlot

  if itemCount >= RGGM_CONSTANTS.GEAR_BAR_CHANGE_SLOT_AMOUNT_ITEMS then
    emptyChangeMenuSlot = changeMenuSlots[itemCount]
  else
    emptyChangeMenuSlot = changeMenuSlots[itemCount + 1]
  end

  mod.uiHelper.UpdateSlotTextureAttributes(emptyChangeMenuSlot)

  emptyChangeMenuSlot.slotId = gearSlotMetaData.slotId
  emptyChangeMenuSlot.itemId = nil
  emptyChangeMenuSlot.equipSlot = nil

  emptyChangeMenuSlot:SetNormalTexture(gearSlotMetaData.textureId)
  emptyChangeMenuSlot:Show()
end



--[[
  Reset all changeMenuSlots into their initial state
]]--
function me.ResetChangeMenu()
  for i = 1, table.getn(changeMenuSlots) do
    changeMenuSlots[i]:SetNormalTexture(nil)
    changeMenuSlots[i].highlightFrame:Hide()
    changeMenuSlots[i].cooldownOverlay:SetCooldown(0, 0)
    changeMenuSlots[i].cooldownOverlay:GetRegions():SetText("") -- Trigger textupdate
    changeMenuSlots[i]:Hide()
  end

  changeMenuFrame:Hide()
end

--[[
  Updates the changeMenuFrame size depending on how many changeslots are displayed at the time

  @param {table} items
]]--
function me.UpdateChangeMenuSize(items)
  local rows

  if table.getn(items) > RGGM_CONSTANTS.GEAR_BAR_CHANGE_SLOT_AMOUNT then
    rows = RGGM_CONSTANTS.GEAR_BAR_CHANGE_SLOT_AMOUNT / RGGM_CONSTANTS.GEAR_BAR_CHANGE_ROW_AMOUNT
  else
    local totalItems

    if mod.configuration.IsUnequipSlotEnabled() then
      totalItems = table.getn(items) + 1
    else
      totalItems = table.getn(items)
    end

    rows = totalItems / RGGM_CONSTANTS.GEAR_BAR_CHANGE_ROW_AMOUNT
  end

  -- special case for if only one row needs to be displayed
  if rows < 1 then rows = 1 end

  changeMenuFrame:SetHeight(math.ceil(rows) * RGGM_CONSTANTS.GEAR_BAR_DEFAULT_SLOT_SIZE)
  changeMenuFrame:SetWidth(RGGM_CONSTANTS.GEAR_BAR_CHANGE_ROW_AMOUNT * RGGM_CONSTANTS.GEAR_BAR_DEFAULT_SLOT_SIZE)
end

--[[
  Moves the changeMenuFrame to the currently hovered gearSlot

  @param {table} gearSlot
    The gearSlot that was hovered
]]--
function me.UpdateChangeMenuPosition(gearSlot)
  changeMenuFrame:ClearAllPoints()
  changeMenuFrame:SetPoint("BOTTOMLEFT", gearSlot, "TOPLEFT", 0, 0)
end

--[[
  Updates the cooldown representations of all items in the changeMenu

  @param {number} gearBarId
    The id of the hovered gearBar
]]--
function me.UpdateChangeMenuGearSlotCooldown()
  for _, changeMenuSlot in pairs(changeMenuSlots) do
    if changeMenuSlot.itemId ~= nil then
      if changeMenuFrame.showCooldowns then
        local startTime, duration = GetItemCooldown(changeMenuSlot.itemId)
        changeMenuSlot.cooldownOverlay:SetCooldown(startTime, duration)
      else
        changeMenuSlot.cooldownOverlay:Hide()
      end
    end
  end
end

--[[
  GUI callback for updating the changeMenu - invoked regularly by a timer

  Close changeMenu frame after when mouse is not over either the main gearBarFrame or the
  changeMenuFrame.
]]--
function me.ChangeMenuOnUpdate()
  local gearBar = mod.gearBarStorage.GetGearBar(changeMenuFrame.gearBarId)

  if not MouseIsOver(gearBar.gearBarReference) and not MouseIsOver(changeMenuFrame) then
    me.CloseChangeMenu()
  end
end

--[[
  EVENTS
]]--

--[[
  Setup event for a changeSlot

  @param {table} changeSlot
]]--
function me.SetupEvents(changeSlot)
  -- register button to receive leftclick
  changeSlot:RegisterForClicks("LeftButtonUp", "RightButtonUp")

  changeSlot:SetScript("OnEnter", function(self)
    me.ChangeSlotOnEnter(self)
  end)

  changeSlot:SetScript("OnLeave", function(self)
    me.ChangeSlotOnLeave(self)
  end)

  changeSlot:SetScript("OnClick", function(self, button)
    me.ChangeSlotOnClick(self, button)
  end)
end

--[[
  Callback for a changeSlot OnEnter

  @param {table} self
]]--
function me.ChangeSlotOnEnter(self)
  self.highlightFrame:SetBackdropBorderColor(0.27, 0.4, 1, 1)
  self.highlightFrame:Show()

  mod.tooltip.BuildTooltipForBaggedItem(self.slotId, self.itemId)
end

--[[
  Callback for a changeSlot OnLeave

  @param {table} self
]]--
function me.ChangeSlotOnLeave(self)
  self.highlightFrame:Hide()
  mod.tooltip.TooltipClear()
end

--[[
  Callback for a changeSlot OnClick

  @param {table} self
  @param {string} button
]]--
function me.ChangeSlotOnClick(self, button)
  --[[
    If right button was used to equip we need to check whether the slot is a match for combined equipping
  ]]--
  if button == "RightButton" then
    if mod.gearManager.IsEnabledCombinedEquipSlot(self.equipSlot) then
      self.slotId = mod.gearManager.GetMatchedCombinedEquipSlot(self.equipSlot, self.slotId)
    end
  end

  --[[
    Check for empty slot
  ]]--
  if self.itemId == nil and self.equipSlot == nil and self.slotId ~= nil then
    mod.itemManager.UnequipItemToBag(self)
  else
    mod.itemManager.EquipItemById(self.itemId, self.slotId, self.equipSlot)
  end

  me.CloseChangeMenu()
end

--[[
  Close the changeMenu
]]--
function me.CloseChangeMenu()
  mod.ticker.StopTickerChangeMenu()
  changeMenuFrame:Hide()
end

--[[
  Hide cooldowns for bagged items
]]--
function me.HideCooldowns()
  for _, changeMenuSlot in pairs(changeMenuSlots) do
    changeMenuSlot.cooldownOverlay:Hide()
  end
end

--[[
  Show cooldowns for bagged items
]]--
function me.ShowCooldowns()
  for _, changeMenuSlot in pairs(changeMenuSlots) do
    changeMenuSlot.cooldownOverlay:Show()
  end
end
