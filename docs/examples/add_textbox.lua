local state = { name = "", size = "" }
local inputs = {}

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

    inputs.size = self.createInput({
        input_function = "onSize", function_owner = self,
        position   = { x = -0.45, y = 0.2, z = -0.893 },
        rotation   = { x = 0, y = 0, z = 0 },
        width      = 710, 
        height     = 60, 
        font_size  = 34,
        alignment  = 2,
        font_color = {0,0,0,1},
        color      = {1,1,1,1},
        label      = "",
        value      = state.size or "",
        scale      = {x = 0.16, y = 0.1, z = 0.2}
    })
end


-- Save handlers
function onName(obj,color,text,selected)
    state.name = text or ""; if not selected then self.script_state = JSON.encode(state) end
end
function onSize(obj,color,text,selected)
    state.size = text or ""; if not selected then self.script_state = JSON.encode(state) end
end
