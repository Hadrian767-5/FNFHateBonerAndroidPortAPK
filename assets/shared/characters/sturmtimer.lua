local frame = {}
local delay = {}
local anims = {}
local ends = {}
luaDebugMode = true
local key = {'left', 'down', 'up', 'right'}
function onUpdatePost(e)
    for i = 0, getProperty('strumLineNotes.length') - 1 do
        if frame[i] == nil then frame[i] = 0 end
        if delay[i] == nil then delay[i] = 0 end
        delay[i] = delay[i] + e
        local strums = 'strumLineNotes.members['..i..']'
        local animation = 'strumLineNotes.members['..i..'].animation'
        if anims[i] == nil then anims[i] = getProperty(animation..'.name') end
        if anims[i] ~= getProperty(animation..'.name') then
            anims[i] = getProperty(animation..'.name')
            frame[i] = 0
        end
        if delay[i] > getProperty(animation..'.curAnim.delay') then
            delay[i] = delay[i] - getProperty(animation..'.curAnim.delay')
            if frame[i] < getProperty(animation..'.curAnim.frames.length') - 1 then
                frame[i] = frame[i] + 1
            else
                if getProperty(animation..'.looped') then
                    frame[i] = 0
                end
            end
        end
        setProperty(animation..'.curAnim.curFrame', frame[i])
    end
    for i = 0, getProperty('playerStrums.length') - 1 do
        if ends[i] == nil then ends[i] = false end
        if key[i+1] ~= nil then
            if keyPressed(key[i+1]) and getProperty('playerStrums.members['..i..'].animation.name') == 'confirm' and ends[i] then
                ends[i] = false
                runHaxeCode('game.playerStrums.members['..i..'].playAnim("pressed", true);')
            end
        end
    end
end
function goodNoteHit(i, d, _, s)
    if not s then frame[d+4] = 0 end
    if s then
        if stringEndsWith(getProperty('notes.members['..i..'].animation.name'), 'end') then
            ends[d] = true
        else
            ends[d] = false
        end
    end
end
function opponentNoteHit(_, d, _, s)
    if not s then frame[d] = 0 end
    setProperty('opponentStrums.members['..d..'].resetAnim', s and 0.1 or 0.2)
    setProperty('opponentStrums.members['..d..'].animation.curAnim.curFrame', frame[d])
end

function onUpdate(elapsed)
    if (keyboardJustPressed("TWO")) then
        runHaxeCode([[
            game.setSongTime(Conductor.songPosition + 10000);
            game.clearNotesBefore(Conductor.songPosition);
        ]])
    end
end