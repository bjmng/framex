--[[ framex - VLC Frame eXtension ]]

function descriptor()
    return {
        title = "framex",
        version = "1.0",
        author = "bjmng",
        url = "https://github.com/bjmng/framex",
        shortdesc = "Frame eXtension",
        description = "Frame handling for the VLC Media Player.",
        capabilities = { "close" }
    }
end

local i18n = { language = "en" }

i18n.dictionary = {
    ["en"] = { ["fps"] = "Frame rate" }
}

i18n.t = function(key) return i18n.dictionary[key] or key end

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
    return i18n.t("fps") .. ": " .. fps.value .. " (" .. fps.mode .. ")"
end

function activate()
    fps.detect.auto()
    vlc.msg.info(fps.tostring())
end

function deactivate() end

function close() deactivate() end
