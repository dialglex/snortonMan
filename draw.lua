function getImages()
	lowResolutionBackground = love.graphics.newImage("images/backgrounds/lowResolutionBackground.png")
	--textFont = love.graphics.newImageFont("images/fonts/textFont.png", " abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789.,!/-+/():;%&`'{}|~$@^_<>") --bugs out with \
	--textFont = love.graphics.newFont("images/fonts/comicSans.ttf", 35)
	screenCanvas = love.graphics.newCanvas(480, 270)
	lowResolutionBackgroundCanvas = love.graphics.newCanvas(7680, 4320)
end

function drawScreen()
	love.graphics.draw(backgroundImage)

	love.graphics.draw(backgroundCanvas)
	--can be optimized to not go through every actor and check if it is player or dust
	for _, actor in ipairs(actors) do
		actor:draw()
		love.graphics.setCanvas(screenCanvas)
        if actor.actor == "object" then
        	if actor.near then
				love.graphics.rectangle("line", actor.x, actor.y, actor.width, actor.height)
			end
		elseif actor.actor == "player" then
        	love.graphics.draw(actor.canvas, actor:getX(), actor:getY())
        elseif actor.actor == "dust" then
        	love.graphics.draw(actor.canvas, actor:getX(), actor:getY())
        end

    end
    love.graphics.draw(foregroundCanvas)
end

function drawDebug()
	if debug then
    	for i, string in ipairs(debugStrings) do
    		--love.graphics.print(string, 2, (i - 1) * 12)
    	end
    end

    --draw hitboxes
    -- if love.keyboard.isDown("z") then
    --     for _, hitbox in ipairs(hitboxes) do
    --         x, y, w, h = unpack(hitbox)
    --         love.graphics.setColor(255, 0, 0, 160)
    --         love.graphics.rectangle("fill", x, y, w, h)
    --     end
    --     love.graphics.setColor(255, 255, 255)
    -- end
end

function drawFPS()
	if not debug then
		--love.graphics.setFont(textFont)
		--love.graphics.print("Current FPS: "..tostring(love.timer.getFPS()), 4, 4)
	end
end

function setScreenCanvas()
	love.graphics.setCanvas(lowResolutionBackgroundCanvas)
	love.graphics.draw(lowResolutionBackground)
	love.graphics.setCanvas()
	love.graphics.draw(lowResolutionBackgroundCanvas, 0, 0, 0, scale, scale)

	love.graphics.setCanvas(screenCanvas)

	love.graphics.clear()
end

function drawText()
	for _, actor in ipairs(actors) do
		if actor.actor == "object" then
			love.graphics.setFont(love.graphics.newFont("images/fonts/comicSans.ttf", 10*scale))
			love.graphics.setColor(0,0,0)
			love.graphics.print(actor.name, actor.x*scale - scale*string.len(actor.name), actor.y*scale + 11*scale)
			love.graphics.setColor(255,255,255,255)
		elseif actor.actor == "player" then
			if actor.win then
				love.graphics.setFont(love.graphics.newFont("images/fonts/comicSans.ttf", 25*scale))
				love.graphics.setColor(0, 0, 0)
				love.graphics.print("You killed Clippy!", 570, 400)
				love.graphics.setFont(love.graphics.newFont("images/fonts/comicSans.ttf", 10*scale))
				love.graphics.print("The virus will no longer waste your storage space.", 500, 550)
				love.graphics.setColor(255,255,255,255)
			elseif actor.paused then
				love.graphics.setFont(love.graphics.newFont("images/fonts/vibra.ttf", 250))
				love.graphics.setColor(255,255,255)
				love.graphics.print("SYSTEM 32 DELETED", 250, 0, 0.5)
				love.graphics.setFont(love.graphics.newFont("images/fonts/vibra.ttf", 6.25*scale))
				love.graphics.print("lol baited :P", 550, 550)
				love.graphics.setFont(love.graphics.newFont("images/fonts/vibra.ttf", 12.5*scale))
				love.graphics.print("Press alt+f4 to restart.", 600, 600)
				love.graphics.setColor(255,255,255,255)
			elseif actor.outOfMap then
				love.graphics.setFont(love.graphics.newFont("images/fonts/vibra.ttf", 62.5*scale))
				love.graphics.setColor(255,255,255)
				love.graphics.print("DIRECTORY NOT FOUND", 250, 0, 0.45)
				love.graphics.setFont(love.graphics.newFont("images/fonts/vibra.ttf", 12.5*scale))
				love.graphics.print("Press space to restart.", 600, 600)
				love.graphics.setColor(255,255,255,255)
			end
		end
	end
end

function drawScreenCanvas()
	love.graphics.setCanvas()
	love.graphics.draw(screenCanvas, (xWindowSize - (480 * scale)) / 2, (yWindowSize - (270 * scale)) / 2, 0, scale, scale)
	drawText()
end