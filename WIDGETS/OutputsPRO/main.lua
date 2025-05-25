-- Based on https://gist.githubusercontent.com/DavBfr/b6e3619eaffd3e5a5f5828d72c957930/raw/42d8725c45f720528dd3204f32616a8d197af4f3/main.lua

local OP_ROW_HEIGHT = 17

local options = {
    {"FirstChans", STRING, "11111111"},
    {"LastChans", STRING, "00000000"},
    {"TextColor", COLOR, COLOR_THEME_PRIMARY1},
    {"BarColor", COLOR, COLOR_THEME_SECONDARY1},
    {"FillBackground", BOOL, 0},
    {"BgColor", COLOR, COLOR_THEME_SECONDARY3},
    {"ShowBorders", BOOL, 1},
    {"BorderColor", COLOR, COLOR_THEME_PRIMARY1}
}

local function padStart(self, maxLength, fillString)
    maxLength = maxLength - #self
    if maxLength > #fillString then
        fillString = fillString .. string.rep(fillString, math.floor(maxLength / #fillString))
    end
    return string.sub(fillString, 1, math.floor(maxLength)) .. self
end

local function divRoundClosest(n, d)
    if d == 0 then
        return 0
    else
        return n < 0 ~= (d < 0) and math.ceil((n - d / 2) / d) or math.floor((n + d / 2) / d)
    end
end

local function clamp(num, min, max)
    return math.min(math.max(num, min), max)
end

local function update(widget, options)
    widget.options = options
    local modelInfo = model.getInfo()
    widget.limitPct = modelInfo.extendedLimits and LIMIT_EXT_PERCENT or LIMIT_STD_PERCENT
    widget.chanMask = options.FirstChans .. options.LastChans
    widget.lastChan = 16
    for lastChan = 16, 1, -1 do
        if string.sub(widget.chanMask, lastChan, lastChan) == "1" then
            widget.lastChan = lastChan
            break
        end
    end
end

local function create(zone, options)
    local modelInfo = model.getInfo()

    local widget = {
        zone = zone,
        options = options,
        limitPct = 0
    }

    update(widget, options)

    return widget
end

local function refresh(widget, event, touch)
    local x = widget.zone.x
    local y = widget.zone.y
    local w = widget.zone.w
    local h = widget.zone.h

    local rowH = OP_ROW_HEIGHT - 1
    local barW = w - 1 * 2
    local barH = rowH - 1
    local barLft = x + 1
    local barMid = barLft + barW / 2

    local chansShown = 1
    for curChan = 1,widget.lastChan do
        if string.sub(widget.chanMask, curChan, curChan) == "1" then
            local chanVal = divRoundClosest(getOutputValue(curChan - 1) * 100, FULLSCALE)
            local rowTop = y + (chansShown - 1) * rowH
            local barTop = rowTop + 1
            local fillW = divRoundClosest(barW * clamp(0, math.abs(chanVal), widget.limitPct), widget.limitPct * 2)
            if widget.options.FillBackground ~= 0 then
                lcd.setColor(CUSTOM_COLOR, widget.options.BgColor)
                lcd.drawFilledRectangle(barLft, barTop, barW, barH, CUSTOM_COLOR)
            end
            if fillW ~= 0 then
                lcd.setColor(CUSTOM_COLOR, widget.options.BarColor)
                lcd.drawFilledRectangle(chanVal > 0 and barMid or barMid - fillW, barTop, fillW, barH, CUSTOM_COLOR)
            end
            lcd.drawLine(barMid, barTop, barMid, barTop + barH, SOLID, COLOR_THEME_SECONDARY1)
            if widget.options.ShowBorders ~= 0 then
                lcd.setColor(CUSTOM_COLOR, widget.options.BorderColor)
                lcd.drawRectangle(x, rowTop, w, rowH + 1, CUSTOM_COLOR)
            end
            lcd.setColor(CUSTOM_COLOR, widget.options.TextColor)
            lcd.drawText(x + barW - 10, barTop - 2, tostring(chanVal) .. "%", SMLSIZE + CUSTOM_COLOR + RIGHT)
            local output = model.getOutput(curChan - 1)
            if #output.name > 0 then
                lcd.drawText(barLft + 1, barTop - 2, (padStart(tostring(curChan), 2, "0") .. " ") .. output.name,
                    SMLSIZE + CUSTOM_COLOR + LEFT)
            else
                lcd.drawText(barLft + 1, barTop - 2, "CH" .. tostring(curChan), SMLSIZE + CUSTOM_COLOR + LEFT)
            end
            chansShown = chansShown + 1
        end
    end
end

return {
    name = "OutputsPRO",
    options = options,
    create = create,
    update = update,
    refresh = refresh
}