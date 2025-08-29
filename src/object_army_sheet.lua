-- State (separate keys per field + toggle state)
local state  = state  or {
  name = "", attachedTo = "", initiative = "", armyRating = "", unitName1 = "",
  toggles = { ammo1Unit1_active = false }
}
local inputs  = inputs  or {}
local buttons = buttons or {}

-- If you prefer your fixed scale values, keep them:
local INPUT_SCALE = {x = 0.16, y = 0.10, z = 0.20}
local BUTTON_SCALE = {x = 0.04, y = 0.04, z = 0.04}

function onLoad(saved_state)
  if type(saved_state)=="string" and saved_state~="" then
    local ok,t = pcall(JSON.decode, saved_state)
    if ok and type(t)=="table" then
      -- merge saved keys
      for k,v in pairs(t) do state[k]=v end
    end
  end
  if type(state.toggles) ~= "table" then state.toggles = { ammo1Unit1_active=false } end
  if state.toggles.ammo1Unit1_active == nil then state.toggles.ammo1Unit1_active = false end

  createInputs()
end

function createInputs()
  -- Build everything here: inputs + buttons
  self.clearInputs()
  self.clearButtons()
  inputs  = {}
  buttons = {}

  -- Name
  inputs.name = self.createInput({
    input_function = "onName", function_owner = self,
    position = { x=-0.48, y=0.20, z=-0.92 }, rotation = {0,0,0},
    width=900, height=60, font_size=34, alignment=2,
    font_color={0,0,0,1}, color={1,1,1,1},
    label="", value=state.name or "",
    scale = INPUT_SCALE
  })

  -- Attached To
  inputs.attachedTo = self.createInput({
    input_function = "onAttachedTo", function_owner = self,
    position = { x=-0.45, y=0.20, z=-0.893 }, rotation = {0,0,0},
    width=710, height=60, font_size=34, alignment=2,
    font_color={0,0,0,1}, color={1,1,1,1},
    label="", value=state.attachedTo or "",
    scale = INPUT_SCALE
  })

  -- Initiative
  inputs.initiative = self.createInput({
    input_function = "onInitiative", function_owner = self,
    position = { x=-0.55, y=0.20, z=-0.865 }, rotation = {0,0,0},
    width=310, height=60, font_size=34, alignment=2,
    font_color={0,0,0,1}, color={1,1,1,1},
    label="", value=state.initiative or "",
    scale = INPUT_SCALE
  })

  -- Army Rating
  inputs.armyRating = self.createInput({
    input_function = "onArmyRating", function_owner = self,
    position = { x=-0.35, y=0.20, z=-0.865 }, rotation = {0,0,0},
    width=100, height=60, font_size=34, alignment=2,
    font_color={0,0,0,1}, color={1,1,1,1},
    label="", value=state.armyRating or "",
    scale = INPUT_SCALE
  })

  -- UNIT 1 - Name
  inputs.unitName1 = self.createInput({
    input_function = "onUnitName1", function_owner = self,
    position = { x=-0.56, y=0.20, z=-0.786 }, rotation = {0,0,0},
    width=860, height=110, font_size=60, alignment=2,
    font_color={0,0,0,1}, color={1,1,1,1},
    label="", value=state.unitName1 or "",
    scale = INPUT_SCALE
  })

  local checked, unchecked = "☑", "☐"
  local label = state.toggles.ammo1Unit1_active and checked or unchecked

  self.createButton({
    click_function = "onAmmo1Unit1",
    function_owner = self,
    position = { x=0.6, y=0.2, z=-0.8 }, rotation = {0,0,0},
    width=240, height=240, font_size=220,
    label = label, tooltip = "Unit 1 Ammo 1",
    color = {1,1,1,1},
    font_color = {0,0,0,1},
    scale = BUTTON_SCALE
  })

  -- capture the index of the last-created button (robust across builds)
  local btns = self.getButtons() or {}
  if #btns > 0 then
    buttons.ammo1Unit1 = btns[#btns].index or (#btns - 1)
  else
    buttons.ammo1Unit1 = 0
  end

  local label = state.toggles.ammo2Unit1_active and checked or unchecked

  self.createButton({
    click_function = "onAmmo2Unit1",
    function_owner = self,
    position = { x=0.62, y=0.2, z=-0.8 }, rotation = {0,0,0},
    width=240, height=240, font_size=220,
    label = label, tooltip = "Unit 1 Ammo 2",
    color = {1,1,1,1},
    font_color = {0,0,0,1},
    scale = BUTTON_SCALE
  })

  -- capture the index of the last-created button (robust across builds)
  local btns = self.getButtons() or {}
  if #btns > 0 then
    buttons.ammo2Unit1 = btns[#btns].index or (#btns - 1)
  else
    buttons.ammo2Unit1 = 0
  end
end

-- Toggle handler
function onAmmo1Unit1(obj, player_color, alt_click)
  state.toggles.ammo1Unit1_active = not state.toggles.ammo1Unit1_active
  local newLabel = state.toggles.ammo1Unit1_active and "☑" or "☐"

  if buttons.ammo1Unit1 ~= nil then
    self.editButton({ index = buttons.ammo1Unit1, label = newLabel })
  else
    -- fallback: rebuild if index missing
    createInputs()
  end
  self.script_state = JSON.encode(state)
end

function onAmmo2Unit1(obj, player_color, alt_click)
  state.toggles.ammo2Unit1_active = not state.toggles.ammo2Unit1_active
  local newLabel = state.toggles.ammo2Unit1_active and "☑" or "☐"

  if buttons.ammo2Unit1 ~= nil then
    self.editButton({ index = buttons.ammo2Unit1, label = newLabel })
  else
    -- fallback: rebuild if index missing
    createInputs()
  end
  self.script_state = JSON.encode(state)
end

-- Save handlers
function onName(obj,color,text,selected)
  state.name = text or ""; if not selected then self.script_state = JSON.encode(state) end
end
function onAttachedTo(obj,color,text,selected)
  state.attachedTo = text or ""; if not selected then self.script_state = JSON.encode(state) end
end
function onInitiative(obj,color,text,selected)
  state.initiative = text or ""; if not selected then self.script_state = JSON.encode(state) end
end
function onArmyRating(obj,color,text,selected)
  state.armyRating = text or ""; if not selected then self.script_state = JSON.encode(state) end
end
function onUnitName1(obj,color,text,selected)
  state.unitName1 = text or ""; if not selected then self.script_state = JSON.encode(state) end
end
