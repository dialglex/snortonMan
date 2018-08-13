function windowSetup()
	xWindowSize, yWindowSize = love.window.getDesktopDimensions(1)
	scale = getScale()

	love.window.setMode(xWindowSize, yWindowSize, {display = 1, centered = true, resizable = true})
	windowAspectRatio = xWindowSize / yWindowSize
	love.graphics.setDefaultFilter("nearest", "nearest")

	love.window.setTitle("Platformer Base")

	gameIconImage = love.graphics.newImage("images/tiles/exe.png")
	gameIconCanvas = love.graphics.newCanvas(16, 14)
	love.graphics.setCanvas(gameIconCanvas)
	love.graphics.draw(gameIconImage)
	love.graphics.setCanvas()
	gameIconImageData = gameIconCanvas:newImageData()
	love.window.setIcon(gameIconImageData)

	love.mouse.setGrabbed(false)
	love.mouse.setVisible(false)
end

function getScale()
	for i = 1, 9 do
		if xWindowSize >= 480 * i then
			scale = i
		end
	end
	return scale
end

function resolution()
	scale = getScale()
	xWindowSize, yWindowSize = love.graphics.getDimensions()
	if windowAspectRatio == 16 / 9 then
		if keyPress["1"] then
			love.window.setMode(1024, 576, {display = 1, centered = true})
			setupCanvases()
		end
		if keyPress["2"] then
			love.window.setMode(1152, 648, {display = 1, centered = true})
			setupCanvases()
		end
		if keyPress["3"] then
			love.window.setMode(1280, 720, {display = 1, centered = true})
			setupCanvases()
		end
		if keyPress["4"] then
			love.window.setMode(1366, 768, {display = 1, centered = true})
			setupCanvases()
		end
		if keyPress["5"] then
			love.window.setMode(1600, 900, {display = 1, centered = true})
			setupCanvases()
		end
		if keyPress["6"] then
			love.window.setMode(1920, 1080, {display = 1, centered = true})
			setupCanvases()
		end
		if keyPress["7"] then
			love.window.setMode(2560, 1440, {display = 1, centered = true})
			setupCanvases()
		end
		if keyPress["8"] then
			love.window.setMode(3840, 2160, {display = 1, centered = true})
			setupCanvases()
		end
		if keyPress["9"] then
			love.window.setMode(7680, 4320, {display = 1, centered = true})
			setupCanvases()
		end
	elseif windowAspectRatio == 4 / 3 then
		if keyPress["1"] then
			love.window.setMode(640, 480, {display = 1, centered = true})
			setupCanvases()
		end
		if keyPress["2"] then
			love.window.setMode(800, 600, {display = 1, centered = true})
			setupCanvases()
		end
		if keyPress["3"] then
			love.window.setMode(960, 720, {display = 1, centered = true})
			setupCanvases()
		end
		if keyPress["4"] then
			love.window.setMode(1024, 768, {display = 1, centered = true})
			setupCanvases()
		end
		if keyPress["5"] then
			love.window.setMode(1280, 960, {display = 1, centered = true})
			setupCanvases()
		end
		if keyPress["6"] then
			love.window.setMode(1400, 1050, {display = 1, centered = true})
			setupCanvases()
		end
		if keyPress["7"] then
			love.window.setMode(1440, 1080, {display = 1, centered = true})
			setupCanvases()
		end
		if keyPress["8"] then
			love.window.setMode(1600, 1200, {display = 1, centered = true})
			setupCanvases()
		end
		if keyPress["9"] then
			love.window.setMode(1856, 1392, {display = 1, centered = true})
			setupCanvases()
		end
	end

	if keyPress["f11"] then
		local fullscreen = not love.window.getFullscreen()
		love.window.setFullscreen(fullscreen)
	end
end

function windowCheck()
	if keyPress["escape"] then
		love.window.close()
	end
end