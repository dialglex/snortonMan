require("player")
require("tiles")
require("collision")
require("window")
require("input")
require("setup")
require("draw")
require("dust")
require("require")
require("objects")

function love.load()
	windowSetup()
	drawLoadingScreen()

	keyPress = {}
	keyDown = {}
	hitboxes = {}
	debug = false
	debugStrings = {"debug"}

	luaLevels = require.tree('levels/levels')
	--setupLevel(luaLevels.grassland.introduction1)
	setupLevel("levels/levels/C")
	getImages()
	--cursorType()

	interactSound = love.audio.newSource("audio/interact.wav", "stream")
	interactSound:setVolume(0.5)
	dieSound = love.audio.newSource("audio/die.wav", "stream")
	dieSound:setVolume(0.5)
	music = love.audio.newSource("audio/main.wav", "stream")
	music:setVolume(0.2)
	music:setLooping(true)
	music:play()
end

function love.update()
	windowCheck()
	resolution()

	if not debug then
		frameStep = false
	elseif keyPress["f"] then
		frameStep = true
	end

	if keyPress["d"] then
		--debug = not debug
		keyPress = {}
	elseif not (debug and frameStep and not keyPress["f"]) then
		gameLogic()
    	keyPress = {}
    end
end

function debugPrint(string)
	table.insert(debugStrings, string)
end

function gameLogic()
	hitboxes = {}
	debugStrings = {"debug"}
	for index, actor in ipairs(actors) do
		actor:act(index)
	end
end

function love.draw()
	setScreenCanvas()
	drawScreen()
	drawDebug()
	drawFPS()
	drawScreenCanvas()
end