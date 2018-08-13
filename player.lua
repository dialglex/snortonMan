function newPlayer(playerX, playerY)
    local player = {}
    player.previousX = playerX
    player.previousY = playerY
    player.x = playerX
    player.y = playerY
    player.width = 13
    player.height = 24

    player.hitboxX = player.x
    player.hitboxY = player.y
    player.hitboxWidth = 13
    player.hitboxHeight = 24
    player.hitboxXOffset = 0

    player.xVelocity = 0
    player.yVelocity = 0
    player.previousYVelocity = 0
    player.xAcceleration = 0.5
    player.xDeceleration = 0.15
    player.xTerminalVelocity = 1.80
    player.jumpAcceleration = 4.25
    player.fallAcceleration = 0.225
    player.yTerminalVelocity = 8
    player.transitioning = false
    player.directon = "right"
    player.grounded = true
    player.oldGrounded = true
    player.runDust = false
    player.onLadder = false
    player.actor = "player"
    player.tileAbove = ""
    player.tileBelow = ""
    player.tileLeft = ""
    player.tileRight = ""
    player.paused = false
    player.outOfMap = false
    player.win = false
    player.checkpointX = player.x
    player.checkpointY = player.y

    player.jumpHoldDuration = 0.15 * 60
    player.jumpHoldCounter = 0
    player.jumpAble = true
    player.jumpAbleDuration = 0.03 * 60
    player.jumpAbleCounter = 0

    player.runCounter = 0
    player.runQuadSection = 0
    player.jumpCounter = 0
    player.jumpQuadSection = 0
    player.idleCounter = 0
    player.idleQuadSection = 0

    player.idleLeftSpritesheet = love.graphics.newImage("images/player/playerIdleLeftSpritesheet.png")
    player.idleRightSpritesheet = love.graphics.newImage("images/player/playerIdleRightSpritesheet.png")
    player.runLeftSpritesheet = love.graphics.newImage("images/player/playerRunLeftSpritesheet.png")
    player.runRightSpritesheet = love.graphics.newImage("images/player/playerRunRightSpritesheet.png")
    player.jumpLeftSpritesheet = love.graphics.newImage("images/player/playerJumpLeftSpritesheet.png")
    player.jumpRightSpritesheet = love.graphics.newImage("images/player/playerJumpRightSpritesheet.png")

	player.canvas = love.graphics.newCanvas(21, 24)

    function player:getX()
        return math.floor(player.x + 0.5)
    end

    function player:getY()
        return math.floor(player.y + 0.5)
    end

    function player:act(index)
        if player.paused == false and player.outOfMap == false then
            player.previousX = player.x
            player.previousY = player.y
            player:checkGrounded()
            if player.jumpAble then
                player:jump()
            end
            if player.onLadder == false then
                player:physics()
                player:xMovement()
                if player.grounded == false then
                    player:airPhysics()
                end
            end
            player:animations()
            --player:dust()
            player:isOutOfMap()

            debugPrint("player.x: " .. player.x)
            debugPrint("player.y: " .. player.y)
            debugPrint("player.xVelocity: " .. player.xVelocity)
            debugPrint("player.yVelocity: " .. player.yVelocity)
            debugPrint("player.grounded: " .. tostring(player.grounded))
            debugPrint("player.oldGrounded: " .. tostring(player.oldGrounded))
            debugPrint("player.transitioning: " .. tostring(player.transitioning))
            debugPrint("player.jumpAble: " .. tostring(player.jumpAble))
            debugPrint("player.runDust: " .. tostring(player.runDust))
        else
            if love.keyboard.isDown("space") then
                player.x = player.checkpointX
                player.y = player.checkpointY
                player.xVelocity = 0
                player.yVelocity = 0
                player.paused = false
                player.outOfMap = false
                backgroundImage = love.graphics.newImage("images/backgrounds/hills.png")
            end
        end
    end

    function player:ladder()
        if true then
            if keyPress["space"] or keyPress["left"] or keyPress["right"] then
                if player.onLadder then
                    player.onLadder = false
                    player.jumpAble = true
                    player.yVelocity = 0
                    print("off")
                end
            end
            if player.onLadder then
                if keyDown["up"] then
                    player.y = player.y - 2
                elseif keyDown["down"] then
                    player.y = player.y + 2
                end
            end
        end
    end

    function player:isOutOfMap()
        if player.x + player.hitboxWidth <= 0 or player.x >= 480 or player.y + player.hitboxHeight <= 0 or player.y >= 270 then
            player.outOfMap = true
            dieSound:play()
            backgroundImage = love.graphics.newImage("images/backgrounds/invertedHills.png")
        end
    end

   	function player:jump()
        if keyPress["space"] then
            player.grounded = false
            player.jumpAble = false
            player.y = player.y - 1
            player.yVelocity = - player.jumpAcceleration
        end
    end

    function player:checkGrounded()
        player.transitioning = false
        player.oldGrounded = player.grounded
        if checkCollision(player:getX() + player.hitboxXOffset, player:getY() + player.hitboxHeight, player.hitboxWidth, 1) then
            player.grounded = true
            player.jumpHoldCounter = 0
            player.yVelocity = 0
        else
            player.grounded = false
        end
    end

    function player:physics()
        local minXMovement = player.xVelocity
        if minXMovement < 0 then
            --collision to the left
            for _, actor in ipairs(getCollidingActors(player:getX() - 32 + player.hitboxXOffset, player:getY(), 32, player.hitboxHeight, true)) do -- 32 = 2*16 tile width
                local newXMovement = (actor.x + actor.hitboxX) + actor.hitboxWidth - player.x + player.hitboxXOffset
                if newXMovement > minXMovement then
                    minXMovement = newXMovement
                end
            end
        else
          --collision to the right
            for _, actor in ipairs(getCollidingActors(player:getX() + player.hitboxWidth + player.hitboxXOffset, player:getY(), 32, player.hitboxHeight, true)) do
                local newXMovement = (actor.x + actor.hitboxX) - (player.x + player.hitboxWidth + player.hitboxXOffset)
                if newXMovement < minXMovement then
                    minXMovement = newXMovement
                end
            end
        end

        for _, actor in ipairs(getCollidingActors(player:getX() + player.hitboxXOffset - 16, player:getY(), 16, player.hitboxHeight, true)) do
            player.tileLeft = actor.name
        end

        for _, actor in ipairs(getCollidingActors(player:getX() + player.hitboxXOffset + player.hitboxWidth, player:getY(), 16, player.hitboxHeight, true)) do
            player.tileRight = actor.name
        end
        for _, actor in ipairs(getCollidingActors(player:getX() + player.hitboxXOffset, player:getY() + player.hitboxHeight, player.hitboxWidth, 16, true)) do
            player.tileBelow = actor.name
        end
        for _, actor in ipairs(getCollidingActors(player:getX() + player.hitboxXOffset, player:getY() - 16, player.hitboxWidth, 16, true)) do
            player.tileAbove = actor.name
        end

        for _, actor in ipairs(actors) do
            actor.near = false
        end

        for _, actor in ipairs(getCollidingActors(player:getX() + player.hitboxXOffset, player:getY(), player.hitboxWidth, player.hitboxHeight, false)) do
            if actor.actor == "object" then
                actor.near = true
                if actor.type == "folder" then
                    player.checkpointX = player.x
                    player.checkpointY = player.y
                    if keyPress["up"] then
                        setupLevel("levels/levels/"..actor.name, player)
                        interactSound:play()
                    end
                elseif actor.type == "exe" then
                    if actor.name == "deletThis.exe" then
                        if keyPress["up"] then
                            backgroundImage = love.graphics.newImage("images/backgrounds/invertedHills.png")
                            player.paused = true
                            dieSound:play()
                        end
                    elseif actor.name == "killClippy.exe" then
                        if keyPress["up"] then
                            player.paused = true
                            player.win = true
                            love.audio.stop(music)
                            music = love.audio.newSource("audio/menu.wav", "stream")
                            music:setVolume(0.2)
                            music:setLooping(true)
                            music:play()
                            dieSound:play()
                        end
                    end
                elseif actor.type == "music" then
                    if actor.name == "Despacito.mp3" then
                        if keyPress["up"] then
                            love.audio.stop(music)
                            music = love.audio.newSource("audio/despacito.mp3", "stream")
                            music:setVolume(0.2)
                            music:setLooping(true)
                            music:play()
                        end
                    end
                end
            end
        end

        if player.grounded then
            player.jumpAble = true
        end

        player.x = player.x + minXMovement
    end

    function player:airPhysics()
        player.previousYVelocity = player.yVelocity
        player.yVelocity = player.yVelocity + player.fallAcceleration

        local minYMovement = player.yVelocity
        if minYMovement > 0 then
            --collision below player
            for _, actor in ipairs(getCollidingActors(player:getX() + player.hitboxXOffset, player:getY() + player.hitboxHeight, player.hitboxWidth, 32, true)) do
                local newYMovement = (actor.y + actor.hitboxY) - (player.y + player.hitboxHeight)
                if newYMovement < player.yVelocity then
                    minYMovement = newYMovement
                end
            end
        else
            --collision above player
            for _, actor in ipairs(getCollidingActors(player:getX() + player.hitboxXOffset, player:getY() - 32, player.hitboxWidth, 32, true)) do
                local newYMovement = (actor.y + actor.hitboxY) + actor.hitboxHeight - player.y
                if newYMovement > player.yVelocity then
                    minYMovement = newYMovement
                    player.yVelocity = 0
                end
            end
        end

        if player.yVelocity >= player.yTerminalVelocity then
            player.yVelocity = player.yTerminalVelocity
        end

        if player.jumpAbleCounter <= player.jumpAbleDuration and player.jumpAble then
            player.jumpAbleCounter = player.jumpAbleCounter + 1
        else
            player.jumpAble = false
            player.jumpAbleCounter = 0
        end

        player.jumpHoldCounter = player.jumpHoldCounter + 1
        if keyDown["space"] and player.jumpHoldCounter <= player.jumpHoldDuration then
            player.yVelocity = player.previousYVelocity
        end

        player.y = player.y + minYMovement
    end

    function player:xMovement()
        if love.keyboard.isDown("left") then
            if player.xVelocity > - player.xTerminalVelocity then
                player.xVelocity = player.xVelocity - player.xAcceleration
            else
                player.xVelocity = - player.xTerminalVelocity
            end
            player.direction = "left"
            player.hitboxXOffset = 0
        elseif love.keyboard.isDown("right") then
            if player.xVelocity < player.xTerminalVelocity then
                player.xVelocity = player.xVelocity + player.xAcceleration
            else
                player.xVelocity = player.xTerminalVelocity
            end
            player.direction = "right"
            player.hitboxXOffset = 8
        else
            if player.xVelocity > 0 then
                player.xVelocity = player.xVelocity - player.xDeceleration
                if player.xVelocity < player.xDeceleration then
                    player.xVelocity = 0
                end
            elseif player.xVelocity < 0 then
                player.xVelocity = player.xVelocity + player.xDeceleration
                if player.xVelocity > - player.xDeceleration then
                    player.xVelocity = 0
                end
            end
        end
    end

    function player:animations()
        player.runDust = false
        if player.xVelocity == 0 then
            player.runQuadSection = 0
        end
        if player.grounded then
            if player.xVelocity == 0 then
                if player.idleCounter >= 10 then
                    player.idleQuadSection = player.idleQuadSection + 21
                    player.idleCounter = 0
                end
                if player.idleQuadSection >= 84 then
                    player.idleQuadSection = 0
                    player.idleCounter = 0
                end
                player.idleCounter = player.idleCounter + 1
            else
                if player.runCounter >= 10 then
                    if player.runQuadSection == 0 or player.runQuadSection == 84 then
                        player.runDust = true
                    end
                    player.runQuadSection = player.runQuadSection + 21
                    player.runCounter = 0
                end
                if player.runQuadSection >= 42 then
                    player.runQuadSection = 0
                    player.runCounter = 0
                end
                player.runCounter = player.runCounter + 1
            end
            player.jumpCounter = 0
            player.jumpQuadSection = 0
        else
            if player.jumpCounter >= 5 and player.jumpQuadSection < 42 and player.yVelocity < 0 then
                player.jumpQuadSection = player.jumpQuadSection + 21
                player.jumpCounter = 0
            end
            if player.yVelocity > 0 and player.jumpQuadSection > 0 and player.jumpCounter >= 5 then
                player.jumpQuadSection = player.jumpQuadSection - 21
                player.jumpCounter = 0
            end
            player.jumpCounter = player.jumpCounter + 1
        end
    end

    function player:draw()
        love.graphics.setCanvas(player.canvas)
        love.graphics.clear()
    
        love.graphics.setBackgroundColor(0, 0, 0, 0)

        if player.direction == "left" then
            if player.grounded then
                if player.xVelocity == 0 then
                    player.Spritesheet = player.idleLeftSpritesheet
                    player.Quad = love.graphics.newQuad(player.idleQuadSection, 0, 21, 24, 84, 24)
                else
                    player.Spritesheet = player.runLeftSpritesheet
                    player.Quad = love.graphics.newQuad(player.runQuadSection, 0, 21, 24, 42, 24)
                end
            else
                player.Spritesheet = player.jumpLeftSpritesheet
                player.Quad = love.graphics.newQuad(player.jumpQuadSection, 0, 21, 24, 63, 24)
            end
        else
            if player.grounded then
                if player.xVelocity == 0 then
                    player.Spritesheet = player.idleRightSpritesheet
                    player.Quad = love.graphics.newQuad(player.idleQuadSection, 0, 21, 24, 84, 24)
                else
                    player.Spritesheet = player.runRightSpritesheet
                    player.Quad = love.graphics.newQuad(player.runQuadSection, 0, 21, 24, 42, 24)
                end
            else
                player.Spritesheet = player.jumpRightSpritesheet
                player.Quad = love.graphics.newQuad(player.jumpQuadSection, 0, 21, 24, 63, 24)
            end
        end
        love.graphics.draw(player.Spritesheet, player.Quad)
    end

    function player:dust()
        if player.xVelocity ~= 0 and player.grounded and player.runDust then
            table.insert(actors, newDust(player.x, player.y, "run", player.direction, player.tileBelow))
        end
        if player.oldGrounded ~= player.grounded then
            if player.jumpAble == false or player.oldGrounded == false then
                if player.oldGrounded then
                    table.insert(actors, newDust(player.x, player.previousY, "jump", player.direction, player.tileBelow))
                else
                    table.insert(actors, newDust(player.x, player.y, "land", player.direction, player.tileBelow))
                end
            end
            player.transitioning = true
        end
        player.oldGrounded = player.grounded
    end

    return player
end