function drawLoadingScreen()
	loadingImage = love.graphics.newImage("images/HUD/loading.png")
	loadingCanvas = love.graphics.newCanvas(xWindowSize, yWindowSize)
	love.graphics.setCanvas(loadingCanvas)
	love.graphics.draw(loadingImage)
	love.graphics.setCanvas()
	love.graphics.draw(loadingCanvas, (xWindowSize - (480 * scale)) / 2, (yWindowSize - (270 * scale)) / 2, 0, scale, scale)
	love.graphics.present()
end

function setupCanvases()
	backgroundCanvas = love.graphics.newCanvas(xWindowSize, yWindowSize)
	foregroundCanvas = love.graphics.newCanvas(xWindowSize, yWindowSize)

	for _, actor in ipairs(actors) do
		actor:draw()
		if actor.actor == "tile" then
			if actor.background then
				love.graphics.setCanvas(backgroundCanvas)
			else
				love.graphics.setCanvas(foregroundCanvas)
			end
			love.graphics.draw(actor.canvas, actor:getX(), actor:getY())
			love.graphics.setCanvas()
        end
    end
end

function setupLevel(newMap, oldPlayer)
	actors = {}
	--chosenMap = newMap
	chosenMap = require(newMap)
	for _, layer in ipairs(chosenMap.layers) do
		for _, tilesetData in ipairs(chosenMap.tilesets) do
			local tileset = love.graphics.newImage(string.sub(tilesetData.image, 7))
			if layer.name == tilesetData.name then
				for mapX = 0, layer.width - 1 do
					for mapY = 0, layer.height - 1 do
						local blockID = layer.data[1 + mapX + mapY * layer.width]
						if blockID ~= 0 then
							local tileID = blockID - tilesetData.firstgid

							local tileX = tileID % (tilesetData.imagewidth / tilesetData.tilewidth)
							local tileY = math.floor(tileID / (tilesetData.imageheight / tilesetData.tileheight))

                			local blockQuad = love.graphics.newQuad(tileX * tilesetData.tilewidth, tileY * tilesetData.tileheight, tilesetData.tilewidth, tilesetData.tileheight, tilesetData.imagewidth, tilesetData.imageheight)

							if oldPlayer == nil then
								if layer.name == "player" then
                					table.insert(actors, newPlayer(mapX * 16, (mapY * 16) - 8))
                				end
                			end
                			
                			if layer.name ~= "player" and layer.name ~= "objects" then
                				local tile = tilesetData.tiles[tileID+1]
                				if tile.properties["collidable"] or tile.properties["interactable"] then
                					local tileHitbox = tile.objectGroup.objects[1]
                					table.insert(actors, newTile(tilesetData.name, tileX, tileY, tilesetData.tilewidth, tilesetData.tileheight, mapX * 16, mapY * 16, blockQuad,
                						tileset, tile.properties["collidable"], tile.properties["background"], tile.properties["ladder"], tile.properties["interactable"], tileHitbox.x, tileHitbox.y, tileHitbox.width, tileHitbox.height))
                				else
                					table.insert(actors, newTile(tilesetData.name, tileX, tileY, tilesetData.tilewidth, tilesetData.tileheight, mapX * 16, mapY * 16, blockQuad,
                						tileset, tile.properties["collidable"], tile.properties["background"], tile.properties["ladder"], tile.properties["interactable"]))
                				end
                			end
                		end
                	end
                end
            end
            if layer.name == "objects" then
				for _, object in ipairs(layer.objects) do
					table.insert(actors, newObject(object.x, object.y, object.width, object.height, object.properties["type"], object.properties["name"]))
               	end
            end
		end
	end

	if oldPlayer ~= nil then
	    table.insert(actors, oldPlayer)
	end

	backgroundImage = love.graphics.newImage(string.sub(chosenMap.properties["background"], 7))
	setupCanvases()

	leftMap = chosenMap.properties["leftMap"]
	rightMap = chosenMap.properties["rightMap"]
	topMap = chosenMap.properties["topMap"]
	bottomMap = chosenMap.properties["bottomMap"]

	if newMap == "levels/levels/SERIOUSLY" then
		love.audio.stop(music)
        music = love.audio.newSource("audio/boss.wav", "stream")
        music:setVolume(0.2)
        music:setLooping(true)
        music:play()
    end
end