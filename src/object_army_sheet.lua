-- =========================
-- CONFIG (edit this section)
-- =========================

local INPUT_SCALE  = {x=0.16, y=0.10, z=0.20}
local BUTTON_SCALE = {x=0.04, y=0.04, z=0.04}
local Y            = 0.20
local ALIGN        = 2
local ROT          = {x=0, y=0, z=0}
local CHECKED, UNCHECKED = "☑", "☐"

local function safeHeight(font) return math.max(60, (font or 34) + 23) end

-- Top-of-sheet text fields
local FIELDS = {
  -- id                   x       z     width     height font
  {"generalName",       -0.48,  -0.92,   900,     60,     34},
  {"generalAttachedTo", -0.45,  -0.893,  710,     60,     34},
  {"generalInitiative", -0.55,  -0.865,  310,     60,     34},
  {"generalArmyRating", -0.35,  -0.865,  100,     60,     34},
  {"generalBonuses",     0.51,  -0.90,   1140,    220,    34},
  {"armyName",          -0.47,   0.06,   850,     60,     34},
  {"armyUpkeep",        -0.535,  0.13,   350,     60,     34},
  {"armyRating",        -0.355,  0.13,   150,     60,     34},
  {"armyBattles",        0.0,    0.12,   300,     80,     34},
  {"armyUpgrades",       0.51,   0.1,    1140,    220,    34},
}

-- Units: name + TWO ammo grids (default 2x5, special 3x5)
-- Units: name + stats + two ammo grids (default 2x5, special 3x6 as in your code)
local UNITS = {
  {
    id = "u1",
    name_pos            = { x=-0.56,  z=-0.786, width=860, font=60, height=110, align=ALIGN },
    type_pos            = { x=-0.297, z=-0.786, width=230, font=30, height=120, align=ALIGN },
    combatRating_pos    = { x=-0.124, z=-0.786, width=80,  font=30, height=120, align=ALIGN },

    hitPoints_pos       = { x=-0.680, z=-0.714, width=130, font=40, height=90,  align=ALIGN },
    armor_pos           = { x=-0.625, z=-0.714, width=130, font=40, height=90,  align=ALIGN },
    speed_pos           = { x=-0.570, z=-0.714, width=130, font=40, height=90,  align=ALIGN },
    missileDefense_pos  = { x=-0.515, z=-0.714, width=130, font=40, height=90,  align=ALIGN },
    meleeDefense_pos    = { x=-0.460, z=-0.714, width=130, font=40, height=90,  align=ALIGN },
    morale_pos         = { x=-0.405, z=-0.714, width=130, font=40, height=90,  align=ALIGN },
    meleeAttack_pos     = { x=-0.350, z=-0.714, width=130, font=40, height=90,  align=ALIGN },
    rangedAttack_pos    = { x=-0.300, z=-0.714, width=130, font=40, height=90,  align=ALIGN },
    damage_pos          = { x=-0.245, z=-0.714, width=130, font=40, height=90,  align=ALIGN },
    minimumDamage_pos   = { x=-0.190, z=-0.714, width=130, font=40, height=90,  align=ALIGN },
    armorProficiency_pos= { x=-0.135, z=-0.714, width=130, font=40, height=90,  align=ALIGN },

    currentHitPoints_pos= { x=-0.040, z=-0.775, width=400, font=40, height=90,  align=ALIGN },
    XP_pos              = { x=-0.020, z=-0.710, width=200, font=30, height=120, align=ALIGN },
    feats_pos           = { x= 0.174, z=-0.755, width=850, font=30, height=280, align=ALIGN },
    abilities_pos       = { x= 0.447, z=-0.755, width=760, font=30, height=280, align=ALIGN },

    defaultAmmo = { origin = {x=0.600, z=-0.800}, rows=2, cols=5, dx=0.020, dz=0.020, tooltip="Unit 1 Default Ammo" },
    specialAmmo = { origin = {x=0.592, z=-0.748}, rows=3, cols=6, dx=0.018, dz=0.020, tooltip="Unit 1 Special Ammo" },
  },

  {
    id = "u2",
    name_pos            = { x=-0.56,  z=-0.615, width=860, font=60, height=110, align=ALIGN },
    type_pos            = { x=-0.297, z=-0.615, width=230, font=30, height=120, align=ALIGN },
    combatRating_pos    = { x=-0.124, z=-0.615, width=80,  font=30, height=120, align=ALIGN },

    hitPoints_pos       = { x=-0.680, z=-0.543, width=130, font=40, height=90,  align=ALIGN },
    armor_pos           = { x=-0.625, z=-0.543, width=130, font=40, height=90,  align=ALIGN },
    speed_pos           = { x=-0.570, z=-0.543, width=130, font=40, height=90,  align=ALIGN },
    missileDefense_pos  = { x=-0.515, z=-0.543, width=130, font=40, height=90,  align=ALIGN },
    meleeDefense_pos    = { x=-0.460, z=-0.543, width=130, font=40, height=90,  align=ALIGN },
    morale_pos         = { x=-0.405, z=-0.543, width=130, font=40, height=90,  align=ALIGN },
    meleeAttack_pos     = { x=-0.350, z=-0.543, width=130, font=40, height=90,  align=ALIGN },
    rangedAttack_pos    = { x=-0.300, z=-0.543, width=130, font=40, height=90,  align=ALIGN },
    damage_pos          = { x=-0.245, z=-0.543, width=130, font=40, height=90,  align=ALIGN },
    minimumDamage_pos   = { x=-0.190, z=-0.543, width=130, font=40, height=90,  align=ALIGN },
    armorProficiency_pos= { x=-0.135, z=-0.543, width=130, font=40, height=90,  align=ALIGN },

    currentHitPoints_pos= { x=-0.040, z=-0.604, width=400, font=40, height=90,  align=ALIGN },
    XP_pos              = { x=-0.020, z=-0.539, width=200, font=30, height=120, align=ALIGN },
    feats_pos           = { x= 0.174, z=-0.584, width=850, font=30, height=280, align=ALIGN },
    abilities_pos       = { x= 0.447, z=-0.584, width=760, font=30, height=280, align=ALIGN },

    defaultAmmo = { origin = {x=0.600, z=-0.629}, rows=2, cols=5, dx=0.020, dz=0.020, tooltip="Unit 2 Default Ammo" },
    specialAmmo = { origin = {x=0.592, z=-0.577}, rows=3, cols=6, dx=0.018, dz=0.020, tooltip="Unit 2 Special Ammo" },
  },

  {
    id = "u3",
    name_pos            = { x=-0.56,  z=-0.444, width=860, font=60, height=110, align=ALIGN },
    type_pos            = { x=-0.297, z=-0.444, width=230, font=30, height=120, align=ALIGN },
    combatRating_pos    = { x=-0.124, z=-0.444, width=80,  font=30, height=120, align=ALIGN },

    hitPoints_pos       = { x=-0.680, z=-0.372, width=130, font=40, height=90,  align=ALIGN },
    armor_pos           = { x=-0.625, z=-0.372, width=130, font=40, height=90,  align=ALIGN },
    speed_pos           = { x=-0.570, z=-0.372, width=130, font=40, height=90,  align=ALIGN },
    missileDefense_pos  = { x=-0.515, z=-0.372, width=130, font=40, height=90,  align=ALIGN },
    meleeDefense_pos    = { x=-0.460, z=-0.372, width=130, font=40, height=90,  align=ALIGN },
    morale_pos         = { x=-0.405, z=-0.372, width=130, font=40, height=90,  align=ALIGN },
    meleeAttack_pos     = { x=-0.350, z=-0.372, width=130, font=40, height=90,  align=ALIGN },
    rangedAttack_pos    = { x=-0.300, z=-0.372, width=130, font=40, height=90,  align=ALIGN },
    damage_pos          = { x=-0.245, z=-0.372, width=130, font=40, height=90,  align=ALIGN },
    minimumDamage_pos   = { x=-0.190, z=-0.372, width=130, font=40, height=90,  align=ALIGN },
    armorProficiency_pos= { x=-0.135, z=-0.372, width=130, font=40, height=90,  align=ALIGN },

    currentHitPoints_pos= { x=-0.040, z=-0.433, width=400, font=40, height=90,  align=ALIGN },
    XP_pos              = { x=-0.020, z=-0.368, width=200, font=30, height=120, align=ALIGN },
    feats_pos           = { x= 0.174, z=-0.413, width=850, font=30, height=280, align=ALIGN },
    abilities_pos       = { x= 0.447, z=-0.413, width=760, font=30, height=280, align=ALIGN },

    defaultAmmo = { origin = {x=0.600, z=-0.458}, rows=2, cols=5, dx=0.020, dz=0.020, tooltip="Unit 3 Default Ammo" },
    specialAmmo = { origin = {x=0.592, z=-0.406}, rows=3, cols=6, dx=0.018, dz=0.020, tooltip="Unit 3 Special Ammo" },
  },

  {
    id = "u4",
    name_pos            = { x=-0.56,  z=-0.273, width=860, font=60, height=110, align=ALIGN },
    type_pos            = { x=-0.297, z=-0.273, width=230, font=30, height=120, align=ALIGN },
    combatRating_pos    = { x=-0.124, z=-0.273, width=80,  font=30, height=120, align=ALIGN },

    hitPoints_pos       = { x=-0.680, z=-0.201, width=130, font=40, height=90,  align=ALIGN },
    armor_pos           = { x=-0.625, z=-0.201, width=130, font=40, height=90,  align=ALIGN },
    speed_pos           = { x=-0.570, z=-0.201, width=130, font=40, height=90,  align=ALIGN },
    missileDefense_pos  = { x=-0.515, z=-0.201, width=130, font=40, height=90,  align=ALIGN },
    meleeDefense_pos    = { x=-0.460, z=-0.201, width=130, font=40, height=90,  align=ALIGN },
    morale_pos         = { x=-0.405, z=-0.201, width=130, font=40, height=90,  align=ALIGN },
    meleeAttack_pos     = { x=-0.350, z=-0.201, width=130, font=40, height=90,  align=ALIGN },
    rangedAttack_pos    = { x=-0.300, z=-0.201, width=130, font=40, height=90,  align=ALIGN },
    damage_pos          = { x=-0.245, z=-0.201, width=130, font=40, height=90,  align=ALIGN },
    minimumDamage_pos   = { x=-0.190, z=-0.201, width=130, font=40, height=90,  align=ALIGN },
    armorProficiency_pos= { x=-0.135, z=-0.201, width=130, font=40, height=90,  align=ALIGN },

    currentHitPoints_pos= { x=-0.040, z=-0.262, width=400, font=40, height=90,  align=ALIGN },
    XP_pos              = { x=-0.020, z=-0.197, width=200, font=30, height=120, align=ALIGN },
    feats_pos           = { x= 0.174, z=-0.242, width=850, font=30, height=280, align=ALIGN },
    abilities_pos       = { x= 0.447, z=-0.242, width=760, font=30, height=280, align=ALIGN },

    defaultAmmo = { origin = {x=0.600, z=-0.287}, rows=2, cols=5, dx=0.020, dz=0.020, tooltip="Unit 4 Default Ammo" },
    specialAmmo = { origin = {x=0.592, z=-0.236}, rows=3, cols=6, dx=0.018, dz=0.020, tooltip="Unit 4 Special Ammo" },
  },

  {
    id = "u5",
    name_pos            = { x=-0.56,  z=-0.102, width=860, font=60, height=110, align=ALIGN },
    type_pos            = { x=-0.297, z=-0.102, width=230, font=30, height=120, align=ALIGN },
    combatRating_pos    = { x=-0.124, z=-0.102, width=80,  font=30, height=120, align=ALIGN },

    hitPoints_pos       = { x=-0.680, z=-0.030, width=130, font=40, height=90,  align=ALIGN },
    armor_pos           = { x=-0.625, z=-0.030, width=130, font=40, height=90,  align=ALIGN },
    speed_pos           = { x=-0.570, z=-0.030, width=130, font=40, height=90,  align=ALIGN },
    missileDefense_pos  = { x=-0.515, z=-0.030, width=130, font=40, height=90,  align=ALIGN },
    meleeDefense_pos    = { x=-0.460, z=-0.030, width=130, font=40, height=90,  align=ALIGN },
    morale_pos         = { x=-0.405, z=-0.030, width=130, font=40, height=90,  align=ALIGN },
    meleeAttack_pos     = { x=-0.350, z=-0.030, width=130, font=40, height=90,  align=ALIGN },
    rangedAttack_pos    = { x=-0.300, z=-0.030, width=130, font=40, height=90,  align=ALIGN },
    damage_pos          = { x=-0.245, z=-0.030, width=130, font=40, height=90,  align=ALIGN },
    minimumDamage_pos   = { x=-0.190, z=-0.030, width=130, font=40, height=90,  align=ALIGN },
    armorProficiency_pos= { x=-0.135, z=-0.030, width=130, font=40, height=90,  align=ALIGN },

    currentHitPoints_pos= { x=-0.040, z=-0.091, width=400, font=40, height=90,  align=ALIGN },
    XP_pos              = { x=-0.020, z=-0.026, width=200, font=30, height=120, align=ALIGN },
    feats_pos           = { x= 0.174, z=-0.071, width=850, font=30, height=280, align=ALIGN },
    abilities_pos       = { x= 0.447, z=-0.071, width=760, font=30, height=280, align=ALIGN },

    defaultAmmo = { origin = {x=0.600, z=-0.116}, rows=2, cols=5, dx=0.020, dz=0.020, tooltip="Unit 5 Default Ammo" },
    specialAmmo = { origin = {x=0.592, z=-0.064}, rows=3, cols=6, dx=0.018, dz=0.020, tooltip="Unit 5 Special Ammo" },
  },
}

-- =========================
-- RUNTIME (no need to edit)
-- =========================

local state   = state   or { inputs = {}, toggles = {} }
local inputs  = inputs  or {}
local buttons = buttons or {}

local function save() self.script_state = JSON.encode(state) end
local function ensure(v, fallback) if v==nil then return fallback else return v end end

function onLoad(saved_state)
  if type(saved_state)=="string" and saved_state~="" then
    local ok,t = pcall(JSON.decode, saved_state)
    if ok and type(t)=="table" then state = t end
  end
  state.inputs  = state.inputs  or {}
  state.toggles = state.toggles or {}
  buildUI()
end

function buildUI()
  self.clearInputs()
  self.clearButtons()
  inputs, buttons = {}, {}

  -- 1) Top fields
  for _,f in ipairs(FIELDS) do
    local id,x,z,w,h,font = f[1],f[2],f[3],f[4],f[5],f[6]
    addInput(id, {x=x, z=z, width=w, height=h, font=font, align=ALIGN})
  end

  -- 2) Units
  for _,u in ipairs(UNITS) do
    addInput(u.id.."_name", {
      x=u.name_pos.x, z=u.name_pos.z,
      width=u.name_pos.width, font=u.name_pos.font,
      height=u.name_pos.height, align=ensure(u.name_pos.align,ALIGN)
    })
    addInput(u.id.."_type", {
      x=u.type_pos.x, z=u.type_pos.z,
      width=u.type_pos.width, font=u.type_pos.font,
      height=u.type_pos.height, align=ensure(u.type_pos.align,ALIGN)
    })
    addInput(u.id.."_combatRating", {
      x=u.combatRating_pos.x, z=u.combatRating_pos.z,
      width=u.combatRating_pos.width, font=u.combatRating_pos.font,
      height=u.combatRating_pos.height, align=ensure(u.combatRating_pos.align,ALIGN)
    })
    addInput(u.id.."_hitPoints", {
      x=u.hitPoints_pos.x, z=u.hitPoints_pos.z,
      width=u.hitPoints_pos.width, font=u.hitPoints_pos.font,
      height=u.hitPoints_pos.height, align=ensure(u.hitPoints_pos.align,ALIGN)
    })
    addInput(u.id.."_armor", {
      x=u.armor_pos.x, z=u.armor_pos.z,
      width=u.armor_pos.width, font=u.armor_pos.font,
      height=u.armor_pos.height, align=ensure(u.armor_pos.align,ALIGN)
    })
    addInput(u.id.."_speed", {
      x=u.speed_pos.x, z=u.speed_pos.z,
      width=u.speed_pos.width, font=u.speed_pos.font,
      height=u.speed_pos.height, align=ensure(u.speed_pos.align,ALIGN)
    })
    addInput(u.id.."_missileDefense", {
      x=u.missileDefense_pos.x, z=u.missileDefense_pos.z,
      width=u.missileDefense_pos.width, font=u.missileDefense_pos.font,
      height=u.missileDefense_pos.height, align=ensure(u.missileDefense_pos.align,ALIGN)
    })
    addInput(u.id.."_meleeDefense", {
      x=u.meleeDefense_pos.x, z=u.meleeDefense_pos.z,
      width=u.meleeDefense_pos.width, font=u.meleeDefense_pos.font,
      height=u.meleeDefense_pos.height, align=ensure(u.meleeDefense_pos.align,ALIGN)
    })
    addInput(u.id.."_morale", {
      x=u.morale_pos.x, z=u.morale_pos.z,
      width=u.morale_pos.width, font=u.morale_pos.font,
      height=u.morale_pos.height, align=ensure(u.morale_pos.align,ALIGN)
    })
    addInput(u.id.."_meleeAttack", {
      x=u.meleeAttack_pos.x, z=u.meleeAttack_pos.z,
      width=u.meleeAttack_pos.width, font=u.meleeAttack_pos.font,
      height=u.meleeAttack_pos.height, align=ensure(u.meleeAttack_pos.align,ALIGN)
    })
    addInput(u.id.."_rangedAttack", {
      x=u.rangedAttack_pos.x, z=u.rangedAttack_pos.z,
      width=u.rangedAttack_pos.width, font=u.rangedAttack_pos.font,
      height=u.rangedAttack_pos.height, align=ensure(u.rangedAttack_pos.align,ALIGN)
    })
    addInput(u.id.."_damage", {
      x=u.damage_pos.x, z=u.damage_pos.z,
      width=u.damage_pos.width, font=u.damage_pos.font,
      height=u.damage_pos.height, align=ensure(u.damage_pos.align,ALIGN)
    })
    addInput(u.id.."_minimumDamage", {
      x=u.minimumDamage_pos.x, z=u.minimumDamage_pos.z,
      width=u.minimumDamage_pos.width, font=u.minimumDamage_pos.font,
      height=u.minimumDamage_pos.height, align=ensure(u.minimumDamage_pos.align,ALIGN)
    })
    addInput(u.id.."_armorProficiency", {
      x=u.armorProficiency_pos.x, z=u.armorProficiency_pos.z,
      width=u.armorProficiency_pos.width, font=u.armorProficiency_pos.font,
      height=u.armorProficiency_pos.height, align=ensure(u.armorProficiency_pos.align,ALIGN)
    })
    addInput(u.id.."_currentHitPoints", {
      x=u.currentHitPoints_pos.x, z=u.currentHitPoints_pos.z,
      width=u.currentHitPoints_pos.width, font=u.currentHitPoints_pos.font,
      height=u.currentHitPoints_pos.height, align=ensure(u.currentHitPoints_pos.align,ALIGN)
    })
    addInput(u.id.."_XP", {
      x=u.XP_pos.x, z=u.XP_pos.z,
      width=u.XP_pos.width, font=u.XP_pos.font,
      height=u.XP_pos.height, align=ensure(u.XP_pos.align,ALIGN)
    })
    addInput(u.id.."_feats", {
      x=u.feats_pos.x, z=u.feats_pos.z,
      width=u.feats_pos.width, font=u.feats_pos.font,
      height=u.feats_pos.height, align=ensure(u.feats_pos.align,ALIGN)
    })
    addInput(u.id.."_abilities", {
      x=u.abilities_pos.x, z=u.abilities_pos.z,
      width=u.abilities_pos.width, font=u.abilities_pos.font,
      height=u.abilities_pos.height, align=ensure(u.abilities_pos.align,ALIGN)
    })


    addAmmoGrid(u.id, u.defaultAmmo, "default_ammo")  -- 2x5
    addAmmoGrid(u.id, u.specialAmmo, "special_ammo")  -- 3x5
  end
end

-- -------- builders --------

function addInput(id, cfg)
  local font  = cfg.font or 34
  local ih    = cfg.height
  local idx = self.createInput({
    input_function = makeInputHandler(id),
    function_owner = self,
    position   = {x=cfg.x, y=Y, z=cfg.z},
    rotation   = ROT,
    width      = cfg.width,
    height     = ensure(cfg.height, ih),
    font_size  = font,
    alignment  = ensure(cfg.align, 2),
    font_color = {0,0,0,1},
    color      = {1,1,1,1},
    value      = state.inputs[id] or "",
    scale      = INPUT_SCALE
  })
  inputs[id] = idx
end

function addToggle(id, pos, tooltip)
  local label = state.toggles[id] and CHECKED or UNCHECKED
  self.createButton({
    click_function = makeToggleHandler(id),
    function_owner = self,
    position       = {x=pos.x, y=Y, z=pos.z},
    rotation       = ROT,
    width          = 240, height = 240, font_size = 220,
    label          = label, tooltip = tooltip or id,
    color          = {1,1,1,1},
    font_color     = {0,0,0,1},
    scale          = BUTTON_SCALE
  })
  local btns = self.getButtons() or {}
  buttons[id] = btns[#btns] and btns[#btns].index or (#btns-1) or 0
end

-- Generic grid builder (used for BOTH default & special)
function addAmmoGrid(unitId, g, prefix)
  if not g then return end
  local origin = g.origin or {x=0,z=0}
  local rows   = ensure(g.rows, 2)
  local cols   = ensure(g.cols, 5)
  local dx     = ensure(g.dx, 0.02)
  local dz     = ensure(g.dz, 0.02)
  local tip    = g.tooltip or (unitId.." Ammo")

  for r=1, rows do
    for c=1, cols do
      local n   = (r-1)*cols + c
      local id  = string.format("%s_%s_%02d", unitId, prefix or "ammo", n)
      local pos = { x = origin.x + (c-1)*dx, z = origin.z + (r-1)*dz }
      addToggle(id, pos, tip.." "..n)
    end
  end
end

-- -------- handlers --------

function makeInputHandler(id)
  local fn = function(obj, color, text, selected)
    state.inputs[id] = text or ""
    if not selected then save() end
  end
  local name = "onInput__"..id
  self.setVar(name, fn)
  return name
end

function makeToggleHandler(id)
  local fn = function(obj, color, alt)
    state.toggles[id] = not state.toggles[id]
    local lbl = state.toggles[id] and CHECKED or UNCHECKED
    local idx = buttons[id]
    if idx ~= nil then self.editButton({index=idx, label=lbl}) end
    save()
  end
  local name = "onToggle__"..id
  self.setVar(name, fn)
  return name
end
