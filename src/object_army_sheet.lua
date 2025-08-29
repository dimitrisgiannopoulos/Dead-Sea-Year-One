local state = { name = "" }

function onLoad(saved_state)
  if type(saved_state)=="string" and saved_state~="" then
    local ok,t = pcall(JSON.decode, saved_state)
    if ok and type(t)=="table" then state = t end
  end

  self.clearInputs()

  self.createInput({
    input_function = "onName",
    function_owner = self,
    position       = { x = -0.50, y = 0.2, z = -0.92 },
    rotation       = { x = 0, y = 0, z = 0 },
    width          = 120,
    height         = 14,
    font_size      = 10,
    alignment      = 2,                 -- left align
    font_color     = {0,0,0,1},         -- black text
    -- color          = {1,1,1,0},         -- transparent background
    label          = "Name",            -- grey placeholder when value is empty
    value          = state.name or ""   -- empty -> shows placeholder
  })
end

function onName(obj, color, text, selected)
  state.name = text or ""
  if not selected then
    self.script_state = JSON.encode(state)
  end
end
