-- =========================
-- CONFIG (edit this section)
-- =========================

local INPUT_SCALE  = {x=0.16, y=0.10, z=0.20}
local BUTTON_SCALE = {x=0.04, y=0.04, z=0.04}
local Y            = 0.20
local ROT          = {x=0, y=0, z=0}
local CHECKED, UNCHECKED = "☑", "☐"

local function safeHeight(font) return math.max(60, (font or 34) + 23) end

-- Top-of-sheet text fields
local FIELDS = {
  -- id                   x       z     width     height font align
  {"generalName",      -0.48,  -0.92,   900,     60, 34,   2 },
  {"generalAttachedTo", -0.45,  -0.893,  710,     60, 34,   2 },
  {"generalInitiative", -0.55,  -0.865,  310,     60, 34,   2 },
  {"generalArmyRating", -0.35,  -0.865,  100,     60, 34,   2 },
  {"generalBonuses",     0.51,  -0.90,   1140,    220,  34,   2 },
  {"armyName",          -0.47,  0.06,  850,     60, 34,   2 },
  {"armyUpkeep",        -0.535,  0.13,  350,     60, 34,   2 },
  {"armyRating",        -0.355,  0.13,  150,     60, 34,   2 },
  {"armyBattles",       0.0,  0.12,  300,     80, 34,   2 },
  {"armyUpgrades",      0.51,  0.1,  1140,    220,  34,   2 },
}

-- Units: name + TWO ammo grids (default 2x5, special 3x5)
local UNITS = {
  {
    id        = "u1",
    name_pos  = { x=-0.56, z=-0.786, width=860, font=60, height=110, align=2 },

    defaultAmmo = {                       -- 2 x 5
      origin = {x=0.60, z=-0.80}, rows=2, cols=5,
      dx=0.02, dz=0.02, tooltip="Unit 1 Default Ammo"
    },

    specialAmmo = {                       -- 3 x 6
      origin = {x=0.592, z=-0.748}, rows=3, cols=6,
      dx=0.018, dz=0.02, tooltip="Unit 1 Special Ammo"
    },
  },

  {
    id        = "u2",
    name_pos  = { x=-0.56, z=-0.615, width=860, font=60, height=110, align=2 },

    defaultAmmo = {                       -- 2 x 5
      origin = {x=0.60, z=-0.629}, rows=2, cols=5,
      dx=0.02, dz=0.02, tooltip="Unit 2 Default Ammo"
    },

    specialAmmo = {                       -- 3 x 6
      origin = {x=0.592, z=-0.577}, rows=3, cols=6,
      dx=0.018, dz=0.02, tooltip="Unit 2 Special Ammo"
    },
  },

  -- Copy and tweak for u2..u10
  -- { id="u2", name_pos={...}, defaultAmmo={...}, specialAmmo={...} },
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
    local id,x,z,w,h,font,align = f[1],f[2],f[3],f[4],f[5],f[6],f[7]
    addInput(id, {x=x, z=z, width=w, height=h, font=font, align=align})
  end

  -- 2) Units
  for _,u in ipairs(UNITS) do
    addInput(u.id.."_name", {
      x=u.name_pos.x, z=u.name_pos.z,
      width=u.name_pos.width, font=u.name_pos.font,
      height=u.name_pos.height, align=ensure(u.name_pos.align,2)
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
