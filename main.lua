local pirate = display.newImageRect("pirate.png", 200, 200)

pirate.x, pirate.y = display.contentCenterX, display.contentCenterY


require "burn"

timer.performWithDelay(2000,function()

    pirate.fill = {
        type = "composite",
        paint1 = { type="image", filename="pirate.png" },
        paint2 = { type="image", filename="noise.jpg" }
    }
  
    pirate.fill.effect = "filter.custom.burn"
    pirate.fill.effect.startTime = system.getTimer()/1000
    pirate.fill.effect.duration = 2
    graphics.undefineEffect( "filter.custom.burn")
end, -1)

