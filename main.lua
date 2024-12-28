function love.load()
    --Libaries
    anim8 = require 'libaries/anim8'

    love.graphics.setDefaultFilter("nearest", "nearest")
    width,height = love.graphics.getDimensions()
    
    love.window.setTitle("Racoon Clicker")


    playerstats = {}
    playerstats.clicks = 0
    playerstats.multi = 1
    playerstats.x = 200
    playerstats.y = 100
    playerstats.spriteSheet = love.graphics.newImage('sprites/racoonspritesheet.png')
    playerstats.grid = anim8.newGrid(122,104,playerstats.spriteSheet:getWidth(),playerstats.spriteSheet:getHeight())

    playerstats.mood = {}
    playerstats.mood.rich = anim8.newAnimation(playerstats.grid('2-3',4), 0.75)
    playerstats.mood.sad = anim8.newAnimation(playerstats.grid('1-2',3),0.75)
    playerstats.mood.neutral = anim8.newAnimation(playerstats.grid('2-3',2),0.75)
    
    playerstats.anim = playerstats.mood.neutral


    UpgradeBTN = {}
    UpgradeBTN.x = width/2-400
    UpgradeBTN.y = height-126
    UpgradeBTN.cost = 2
    UpgradeBTN.level = 1

    Helpers = {}
    Helpers.x = width/2-390
    Helpers.y = height - 40
    Helpers.amount = 0
    Helpers.cost = 10
    Helpers.level = 1
    Helpers.timer = 500
    Helpers.currentTimer = 0
end

function love.update(dt)
    --Quit
    if love.keyboard.isDown("escape") then
        love.event.quit()
    end
    --Multiplier upgrade 
    if love.keyboard.isDown("q") and playerstats.clicks >= UpgradeBTN.cost then
        love.timer.sleep(0.25)
        playerstats.multi = playerstats.multi + 1
        playerstats.clicks = playerstats.clicks - UpgradeBTN.cost
        UpgradeBTN.level = UpgradeBTN.level + 1
        UpgradeBTN.cost = UpgradeBTN.cost + math.floor(UpgradeBTN.cost^1.001)
    end

    --Helper progress
    Helpers.currentTimer = Helpers.currentTimer + 1

    --Helper payout
    if Helpers.currentTimer >= Helpers.timer and Helpers.amount >= 1 then
        playerstats.clicks = playerstats.clicks + Helpers.amount * playerstats.multi
        Helpers.currentTimer = 0
    end
    
    --Helper upgrade
    if love.keyboard.isDown("e") and playerstats.clicks >= Helpers.cost then
        love.timer.sleep(0.1)
        Helpers.amount = Helpers.amount + 1
        playerstats.clicks = playerstats.clicks - Helpers.cost
        Helpers.level = Helpers.level + 1 
        Helpers.cost = Helpers.cost + math.floor(Helpers.cost^1.0001)
    end


    --Animations
    if playerstats.clicks < UpgradeBTN.cost and playerstats.clicks < Helpers.cost then
        playerstats.anim = playerstats.mood.sad
    end

    if playerstats.clicks > UpgradeBTN.cost and playerstats.clicks > Helpers.cost then
        playerstats.anim = playerstats.mood.rich
    end

    playerstats.anim:update(dt)
end


function love.draw()
    --Amount of clicks the player has
    love.graphics.print("Clicks: ".. tostring(playerstats.clicks),0,0)
    --Upgrade the multiplier text
    love.graphics.print("Q to upgrade. You get ".. tostring(UpgradeBTN.level).. " per click. Level: "..tostring(playerstats.multi * 1+playerstats.multi).. " Cost: ".. tostring(math.floor(UpgradeBTN.cost)),UpgradeBTN.x+10,UpgradeBTN.y+64)
    --Upgrade the helper text
    love.graphics.print("E to upgrade. You get ".. tostring(Helpers.amount * playerstats.multi).. " when helpers activate. Level: ".. tostring(Helpers.level).." Cost: "..tostring(Helpers.cost) ,Helpers.x,Helpers.y)
    --Draws the Racoon
    playerstats.anim:draw(playerstats.spriteSheet,playerstats.x,playerstats.y,nil, 3)
end


function love.mousepressed(x, y, button, istouch, presses)
    if button == 1 then
        playerstats.clicks = playerstats.clicks + playerstats.multi
    end
end
