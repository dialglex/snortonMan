function newObject(objectX, objectY, objectWidth, objectHeight, objectType, objectName)
	local object = {}
	object.x = objectX
	object.y = objectY
	object.width = objectWidth
	object.height = objectHeight
	object.type = objectType
	object.name = objectName
	object.near = false
	object.actor = "object"

	object.hitboxX = object.x
	object.hitboxY = object.y
	object.hitboxWidth = object.width
	object.hitboxHeight = object.height

	function object:act(index) end

	function object:draw() end

    return object
end