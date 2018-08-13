function AABB(x1, y1, width1, height1, x2, y2, width2, height2)
    local xCheck = x1 + width1 > x2 and x1 < x2 + width2
    local yCheck = y1 + height1 > y2 and y1 < y2 + height2
    return xCheck and yCheck
end

function checkCollision(x, y, width, height)
    table.insert(hitboxes, {x, y, width, height})
    for _, actor in ipairs(actors) do
        if actor.collidable then
            if AABB(x, y, width, height, actor.x + actor.hitboxX, actor.y + actor.hitboxY, actor.hitboxWidth, actor.hitboxHeight) and actor.actor ~= "player" then
                return true
            end
        end
    end
    return false
end

function getCollidingActors(x, y, width, height, collidable)
    collides = {}
    table.insert(hitboxes, {x, y, width, height})
    for _, actor in ipairs(actors) do
        if actor.collidable and collidable or actor.actor == "object" and collidable == false then -- or actor.interactable and collidable == false 
            if AABB(x, y, width, height, actor.x, actor.y, actor.hitboxWidth, actor.hitboxHeight) and actor.actor ~= "player" then
                table.insert(collides, actor)
            end
        end
    end
    return collides
end