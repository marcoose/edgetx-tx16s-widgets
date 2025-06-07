-- TX16SDocs Widget
local txdPath = "/IMAGES/TX16SDocs/"

local options = {
  { "Image", FILE, string.sub(model.getInfo().name, 1, 8)..".png", txdPath }
}

local function loadImg(widget)
  widget.filename = txdPath .. widget.options.Image
  if fstat(widget.filename) then
    widget.img = Bitmap.open(widget.filename)
    widget.missing = false
  else
    widget.img = Bitmap.open(txdPath .."None.png")
    widget.missing = true
  end
end

local function create(zone, options)
  widget = {
    zone = zone,
    options = options,
    missing = false
  }
  loadImg(widget)
  return widget
end

local function update(widget, options)
  widget.options = options
  loadImg(widget)
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
