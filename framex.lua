--[[ framex © 2025, Benjamin Grill ]]

function descriptor()
    return {
        title = "framex",
        version = "1.0",
        author = "Benjamin Grill",
        url = "https://github.com/bjmng/framex",
        shortdesc = "Frame eXtension",
        description = "Frame handling for the VLC Media Player.",
        capabilities = { "input-listener", "close" }
    }
end

local i18n = { language = "en" }

i18n.dictionary = {
    ["en"] = { ["fps"] = "Frame rate" },
    ["de"] = { ["fps"] = "Bildwiederholrate" }
}

i18n.t = function(key) return i18n.dictionary[i18n.language][key] or key end

local fps = { value = nil, default = 25, mode = "undefined" }

fps.detect = {}
fps.detect.from = {}

fps.detect.from.info = function()
    local item = vlc.input.item()
    if not item then return nil end
    local info = item:info()
    for _, entries in pairs(info) do
        for key, value in pairs(entries) do
            if string.match(key, i18n.t("fps")) then return tonumber(value) end
        end
    end
    return nil
end

fps.detect.from.object = function()
    local input = vlc.object.input()
    if input then return tonumber(vlc.var.get(input, "fps")) end
    return nil
end

fps.detect.auto = function()
    for _, fn in pairs(fps.detect.from) do
        fps.value = fn()
        if fps.value and fps.value > 0 then
            fps.mode = "auto"
            return
        end
    end
    fps.value = fps.default
    fps.mode = "default"
end

fps.tostring = function()
    return i18n.t("fps") .. ": " .. tostring(fps.value) .. " (" .. fps.mode .. ")"
end

local ui = { dialog = nil }

ui.symbols = { reload = "⟳", play = "▷" }

ui.label = {}
ui.label.table = {}

ui.label.add = function(key, value, x, y, w, h)
    ui.label.table[key] = ui.dialog:add_label(value, x, y, w, h)
end

ui.label.get = function(key) return ui.label.table[key] end

ui.button = {}
ui.button.table = {}

ui.button.add = function(key, value, callback, x, y, w, h)
    ui.button.table[key] = ui.dialog:add_button(value, callback, x, y, w, h)
end

ui.init = function()
    ui.dialog = vlc.dialog(descriptor().title)
    ui.label.add("fps", fps.tostring(), 1, 1, 1, 1)
    ui.button.add("reload", ui.symbols.reload, update, 2, 1, 1, 1)
end

function activate()
    ui.init()
end

function update()
    fps.detect.auto()
    ui.label.get("fps"):set_text(fps.tostring())
end

function input_updated() update() end

function deactivate()
    if ui.dialog then ui.dialog:delete() end
end

function close() deactivate() end
