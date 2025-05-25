-- InfoCard Widget
local options = {}

local function create(zone, options)
  widget = {
    zone = zone,
    options = options,
    filename = "/IMAGES/TX16SDocs/"..model.getInfo().name..".png",
    missing = false
  }

  if fstat(widget.filename) then
    widget.img = Bitmap.open(widget.filename)
  else
    widget.img = Bitmap.open("/IMAGES/TX16SDocs/None.png")
    widget.missing = true
  end

  return widget
end

local function update(widget, options)
  widget.options = options
end

local function refresh(widget, event, touchState)
  lcd.drawBitmap(widget.img, 0, 0)
  if widget.missing then
    lcd.drawFilledRectangle(0, 250, 480, 272, GREY)
    lcd.drawText(5, 253, "Missing: "..widget.filename, WHITE + SMLSIZE)
  end
end

return {
  name="TX16SDocs",
  options=options,
  create=create,
  update=update,
  refresh=refresh
}
