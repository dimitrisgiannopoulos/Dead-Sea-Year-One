local state = { name = "", debug = "" }
local inputs = {} -- we’ll store the created input indexes here

-- For classic inputs, height must still satisfy the rendering rule:
-- effective_height >= max(60, font_size + 23)
local function safeHeight(font) return math.max(60, (font or 34) + 23) end

-- Compute inverse of the object's current scale so inputs don't grow/shrink visually
local function inverseObjectScale()
    local s = self.getScale()
    return { x = 1/(s.x ~= 0 and s.x or 1),
            y = 1/(s.y ~= 0 and s.y or 1),
            z = 1/(s.z ~= 0 and s.z or 1) }
end

function onLoad(saved_state)
    if type(saved_state)=="string" and saved_state~="" then
        local ok,t = pcall(JSON.decode, saved_state)
        if ok and type(t)=="table" then for k,v in pairs(t) do state[k]=v end end
    end

    createInputs()
end

function createInputs()
    self.clearInputs()
    inputs = {}

    inputs.name = self.createInput({
        input_function = "onName", function_owner = self,
        position   = { x = -0.48, y = 0.2, z = -0.92 },
        rotation   = { x = 0, y = 0, z = 0 },
        width      = 900, 
        height     = 60, 
        font_size  = 34,
        alignment  = 2,
        font_color = {0,0,0,1},
        color      = {1,1,1,1},
        label      = "",
        value      = state.name or "",
        scale      = {x = 0.16, y = 0.1, z = 0.2}
    })

    inputs.name = self.createInput({
        input_function = "onAttachedTo", function_owner = self,
        position   = { x = -0.45, y = 0.2, z = -0.893 },
        rotation   = { x = 0, y = 0, z = 0 },
        width      = 710, 
        height     = 60, 
        font_size  = 34,
        alignment  = 2,
        font_color = {0,0,0,1},
        color      = {1,1,1,1},
        label      = "",
        value      = state.name or "",
        scale      = {x = 0.16, y = 0.1, z = 0.2}
    })

    inputs.name = self.createInput({
        input_function = "onInitiative", function_owner = self,
        position   = { x = -0.55, y = 0.2, z = -0.865 },
        rotation   = { x = 0, y = 0, z = 0 },
        width      = 310, 
        height     = 60, 
        font_size  = 34,
        alignment  = 2,
        font_color = {0,0,0,1},
        color      = {1,1,1,1},
        label      = "",
        value      = state.name or "",
        scale      = {x = 0.16, y = 0.1, z = 0.2}
    })

    inputs.name = self.createInput({
        input_function = "onArmyRating", function_owner = self,
        position   = { x = -0.35, y = 0.2, z = -0.865 },
        rotation   = { x = 0, y = 0, z = 0 },
        width      = 100, 
        height     = 60, 
        font_size  = 34,
        alignment  = 2,
        font_color = {0,0,0,1},
        color      = {1,1,1,1},
        label      = "",
        value      = state.name or "",
        scale      = {x = 0.16, y = 0.1, z = 0.2}
    })

    -- UNIT 1
    inputs.name = self.createInput({
        input_function = "onUnitName1", function_owner = self,
        position   = { x = -0.56, y = 0.2, z = -0.786 },
        rotation   = { x = 0, y = 0, z = 0 },
        width      = 860, 
        height     = 110, 
        font_size  = 60,
        alignment  = 2,
        font_color = {0,0,0,1},
        color      = {1,1,1,1},
        label      = "",
        value      = state.name or "",
        scale      = {x = 0.16, y = 0.1, z = 0.2}
    })
end


-- Save handlers
function onName(obj,color,text,selected)
    state.name = text or ""; if not selected then self.script_state = JSON.encode(state) end
end
function onAttachedTo(obj,color,text,selected)
    state.name = text or ""; if not selected then self.script_state = JSON.encode(state) end
end
function onInitiative(obj,color,text,selected)
    state.name = text or ""; if not selected then self.script_state = JSON.encode(state) end
end
function onArmyRating(obj,color,text,selected)
    state.name = text or ""; if not selected then self.script_state = JSON.encode(state) end
end
function onUnitName1(obj,color,text,selected)
    state.name = text or ""; if not selected then self.script_state = JSON.encode(state) end
end
