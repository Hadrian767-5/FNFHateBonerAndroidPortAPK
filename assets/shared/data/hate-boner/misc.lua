--- @param swagCounter int
function onCountdownTick(swagCounter) end
--- @param elapsed float
function onUpdatePost(elapsed) end
--- @param elapsed float
function onUpdate(elapsed) end
--- @param membersIndex int
--- @param noteData int
--- @param noteType string
--- @param isSustainNote bool
function goodNoteHit(membersIndex, noteData, noteType, isSustainNote) end
--- @param membersIndex int
--- @param noteData int
--- @param noteType string
--- @param isSustainNote bool
function opponentNoteHit(membersIndex, noteData, noteType, isSustainNote) end
--- @param membersIndex int
--- @param noteData int
--- @param noteType string
--- @param isSustainNote bool
--- @param strumTime float
function onSpawnNote(membersIndex, noteData, noteType, isSustainNote, strumTime) end
--- @param key int
function onKeyPress(key) end
--- @param key int
function onKeyRelease(key) end
--- @param key int
function onGhostTap(key) end