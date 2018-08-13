function love.keypressed(key, _, _)
	keyPress[key] = true
	keyDown[key] = true
end

function love.keyreleased(key, _, _)
	keyPress[key] = false
	keyDown[key] = false
end

function cursorType()
	if scale <= 1 then
		cursor = love.mouse.newCursor("images/HUD/cursor1.png")
	elseif scale <= 2 then
		cursor = love.mouse.newCursor("images/HUD/cursor2.png")
	elseif scale <= 3 then
		cursor = love.mouse.newCursor("images/HUD/cursor3.png")
	elseif scale <= 4 then
		cursor = love.mouse.newCursor("images/HUD/cursor4.png")
	end
	love.mouse.setCursor(cursor)
end