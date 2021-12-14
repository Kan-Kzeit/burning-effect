local pirate = display.newImageRect("pirate.png", 109, 111)
pirate.x, pirate.y = display.contentCenterX, display.contentCenterY

require "burn"
pirate.fill.effect = "filter.custom.burn"
pirate.fill.effect.startTime = system.getTimer()/1000
pirate.fill.effect.duration = 2

