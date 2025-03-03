--im too far in to port this to haxe im so sorry
local po = 10
local hm = false
local f = false
local okayArray = {'bg2', 'red2', 'fya', 'hud', 'p', 'bg', 'red'}
local hudArray = {'healthBar', 'timeBar', 'timeTxt', 'scoreTxt', 'iconP1', 'iconP2'}
local pixelArray = {'stage', 'act', 'fight', 'mercy', 'item', 'pixelHp', 'pixelBfHp', 'pixelDadHp'}
local overArray = {'camHUD', 'camGame', 'camOther'}
local pause = false;
local can = false;
local final = false;
local shake = 0.001;

function onCreate()
addLuaScript("characters/sturmtimer")
if downscroll then po = 600 end setProperty('camZoomingMult', 0.4) setProperty('healthGain', 0.3) doBG(); makeHUD(); setProperty('skipCountdown', true)
if shadersEnabled then setProperty('camGame.filtersEnabled', true) setProperty('camHUD.filtersEnabled', true) else setProperty('camGame.filtersEnabled', false) setProperty('camHUD.filtersEnabled', false) end end

    
function onCreatePost()
    initLuaShader("fire");
    addHaxeLibrary("ShaderFilter", "openfl.filters");
    updateHUD(); 
    for i = 0, getProperty("unspawnNotes.length")-1 do
        if getPropertyFromGroup('unspawnNotes', i, 'isSustainNote') then
            setPropertyFromGroup('unspawnNotes', i, 'noAnimation', true);
        end
    end
    addCharacterToList('sansmad', 'boyfriend')
    addCharacterToList('papsmad', 'dad')
    addCharacterToList('papspixel', 'dad')
    addCharacterToList('exepap', 'dad')
    setProperty('camGame.alpha', 0)
    setProperty('camHUD.alpha', 0)
    doAll();
end

function doAll() 
    precacheImage('SansFinale', true)
    precacheImage('bgnofire')
    precacheImage('bgfire')

    precacheImage('rednofire')
    precacheImage('redfire')
    precacheImage('firen')

    precacheImage('f')
    precacheImage('fire')

    precacheImage('act')
    precacheImage('mercy')
    precacheImage('fight')
    precacheImage('item')

    precacheImage('new')
end

function onUpdatePost(elapsed)
    setShaderFloat("fya", "iTime", os.clock())
    setShaderFloat("fya", "AMT", 0.1)
    addMoreToHudIdk(); 
    if dadName == 'papsmad' then 
        setProperty('dad.x', 746)   
    elseif boyfriendName == 'sansmad' then    
        setProperty('boyfriend.x', -90)
    end
end

function opponentNoteHit(i, d, t, s) 
    health = getProperty('health') 
    if f == false then    
        if getProperty('health') > 0.1 then 
         setProperty('health', health- 0.0001); 
        end 
    end
    if not s then
		callMethod('opponentStrums.members['..d..'].playAnim', {'static', true});
		callMethod('opponentStrums.members['..d..'].playAnim', {'confirm'});
    end
	if s then
		setProperty('dad.holdTimer', 0);
		if getProperty("opponentStrums.animation.curAnim") == nil and "" or getProperty("opponentStrums.animation.curAnim.name") == "static" then
			setProperty('opponentStrums.members['..d..'].animation.curAnim.curFrame', 3);
		end
		
		if(stringStartsWith(getAnimationName("dad"), "sing")) then	
			return;
		end
	end
end

function doBG()
    makeAnimatedLuaSprite('final', 'SansFinale', 500, 180);
	addAnimationByPrefix('final','idle','idle',24,true);
    addAnimationByPrefix('final','down','down',24,false);
    addAnimationByPrefix('final','left','left',24,false);
    addAnimationByPrefix('final','right','right',24,false);
    addAnimationByPrefix('final','up','up',24,false);
	addLuaSprite('final', false);
    setObjectCamera('final', 'camHUD')
    setProperty('final.alpha', 0)

    makeLuaSprite('red', 'rednofire', -400, -225);
    scaleObject('red', 2, 2);
    addLuaSprite('red', false);

    makeLuaSprite('red2', 'redfire', -400, -225);
    scaleObject('red2', 2, 2);
    addLuaSprite('red2', false);

    makeLuaSprite('fya', 'firen', -180, 1400);
    scaleObject('fya', 3, 3);
    setSpriteShader("fya", "fire");
    addLuaSprite('fya', false);

    makeLuaSprite('bg', 'bgnofire', -400, -200);
    scaleObject('bg', 1.4, 1.4);
    addLuaSprite('bg', false);

    makeLuaSprite('bg2', 'bgfire', -400, -200);
    scaleObject('bg2', 1.4, 1.4);
    addLuaSprite('bg2', false);

    setProperty('red2.alpha',0)
    setProperty('bg2.alpha',0)

    makeLuaSprite('yeah', '', 0, 0);makeGraphic('yeah',1280,720,'#ffffff')addLuaSprite('yeah', true);setScrollFactor('yeah',0,0)setProperty('yeah.scale.x',2)setProperty('yeah.scale.y',2)setProperty('yeah.alpha',0)setObjectCamera('yeah', 'camGame')setObjectOrder('yeah', getObjectOrder('boyfriendGroup')-1)
end

function noteMiss()
    --if hm == false then    
     --doTweenColor('well', 'boyfriend', '000000', 0.000001, 'linear')
     --runTimer('k',0.1)
    --end

    if final == true then     
        doTweenColor('well', 'final', 'FF0000', 0.000001, 'linear')
        runTimer('2',0.1)
    end
end


function onUpdate(elapsed)
    if f == false then setProperty('dadGroup.y', getProperty('dadGroup.y') + 0.4 * math.sin(curDecBeat / 5 * math.pi) * elapsed * 180) end
    -- god awful tapping i am so sorry
    if mustHitSection == true and f == false then cameraSetTarget('boyfriend') elseif mustHitSection == false and f == false then cameraSetTarget('boyfriend') elseif mustHitSection == true and f == true then cameraSetTarget('dad') elseif mustHitSection == false and f == true then cameraSetTarget('dad') end
end

function onSongStart()
    runHaxeCode([[
        var time = 2;    
        FlxG.camera.fade(FlxColor.BLACK,time,true);
        FlxTween.tween(game.camHUD, {alpha: 1},time +1, {ease: FlxEase.sineOut,startDelay: 0.50});
        FlxTween.tween(game.camGame, {alpha: 1},time +2, {ease: FlxEase.sineOut,startDelay: 2});
    ]]);
end
  
function onTimerCompleted(t)
    if t == 'k' then    
        doTweenColor('qwddqwdw', 'boyfriend', 'FFFFFF', 0.7, 'linear')
        hm = true 
        runTimer('goon', 0.5)
    elseif t == '2' then    
        doTweenColor('dw', 'final', 'FFFFFF', 0.7, 'linear')
    elseif t == 'goon' then    
        hm = false
    end
end


function changeNoteskin(skin, pixel)
    pixel = pixel or false
    if pixel then 
        runHaxeCode('PlayState.stageUI = "pixel";')
    else
        runHaxeCode('PlayState.stageUI = "normal";')
    end
    for i = 0, getProperty('playerStrums.length')-1 do
        setPropertyFromGroup('playerStrums', i, 'texture', skin);
    end
    for i = 0, getProperty('opponentStrums.length')-1 do
        setPropertyFromGroup('opponentStrums', i, 'texture', skin);
    end
    for i = 0, getProperty('unspawnNotes.length')-1 do
        setPropertyFromGroup('unspawnNotes', i, 'texture', skin);
    end
    for i = 0, getProperty('notes.length')-1 do
        setPropertyFromGroup('notes', i, 'texture', skin);
    end  
end

function makeHUD()
    makeLuaSprite('hud', 'new', 160, 0);
    if not downscroll then    
        setProperty('hud.y', 660)
    end
    scaleObject('hud', 0.9, 0.9);
    addLuaSprite('hud', true);
    setObjectCamera('hud', 'other')

    makeLuaText('p', '', 50,0,0)
    setProperty('p.y', getProperty('hud.y')+10) 
    setProperty('p.x', getProperty('hud.x')+109)     
    setTextSize('p', 25)
    setTextFont('p', 'sans.ttf')
    addLuaText('p')
    setObjectCamera('p', 'other')
    setTextBorder('p', 0)

    makeLuaSprite('border','whar?',0,0)
    makeGraphic('border',160,screenHeight,'000000')
    addLuaSprite('border',1)
    setObjectCamera('border','other')
    makeLuaSprite('border2','whar??',screenWidth-160,0)
    makeGraphic('border2',160,screenHeight,'000000')
    addLuaSprite('border2',1)
    setObjectCamera('border2','other')

  
    function addMoreToHudIdk()   
        if f == false then 
            setTextString("p", math.floor(getProperty("health") * 45))
        end
        setProperty('pixelDadHp._frame.frame.width', ((2 - getProperty('health')) + 0.01) * getProperty('pixelDadHp.width') / 2)
    end

    function updateHUD()
        for i = 1, #hudArray do setProperty(hudArray[i]..'.visible', false) end
        setProperty('showRating', false) setProperty('showComboNum', false) setProperty('grpNoteSplashes.visible',false) setProperty('timeBar.visible',false) setProperty('timeTxt.visible',false)--setProperty('boyfriend.x', -100) 
    
        for i = 0,3 do       
            setPropertyFromGroup('strumLineNotes', i, "x", -1000)
            setPropertyFromGroup('playerStrums',i,'y',po)
            setPropertyFromGroup('opponentStrums',i,'y',po)
        end
        for i = 4,7 do
            setPropertyFromGroup('strumLineNotes', i, "x", getPropertyFromGroup('strumLineNotes', i, "x") + - 560) --fix this
        end
        runHaxeCode([[
            for (strum in game.playerStrums)
            {
                strum.cameras = [game.camOther];
                strum.scrollFactor.set(1, 1);
            }
            for (note in game.unspawnNotes) 
            {
                if (note.mustPress) {
                    note.cameras = [game.camOther];
                    note.scrollFactor.set(1, 1);
                } 
            };
        ]]);
    end
end

function pixelMode()
    f = true
    runHaxeCode([[
        for (strum in game.playerStrums)
        {
            strum.cameras = [game.camHUD];
            strum.scrollFactor.set(1, 1);
        }
        for (note in game.unspawnNotes) 
        {
            if (note.mustPress) {
                note.cameras = [game.camHUD];
                note.scrollFactor.set(1, 1);
            } 
        };
    ]]);
    makeLuaSprite('stage', 'bgpixel', 0, 0);
    scaleObject('stage', 4, 4);
    screenCenter('stage', 'x')
    setProperty('stage.x', getProperty('stage.x')+60)
    screenCenter('stage', 'y')
    setProperty('stage.y', getProperty('stage.y')+200)
    addLuaSprite('stage', false);

    makeLuaSprite('act', 'act', -160, 860);
    addLuaSprite('act', true);

    makeLuaSprite('item', 'item', 1230 , 860);
    addLuaSprite('item', true);

    makeLuaSprite('fight', 'fight', -160, 1000);
    addLuaSprite('fight', true);

    makeLuaSprite('mercy', 'mercy', 1230, 1000);
    addLuaSprite('mercy', true);

    --HEALTHBAR
    makeLuaSprite('pixelHp', 'pixelBar', 0,0)
    scaleObject('pixelHp', 2.4, 2.4)
    setProperty('pixelHp.y', getProperty('healthBar.y') - getProperty('pixelHp.height') + 20)
    screenCenter('pixelHp', 'x')
    setObjectCamera('pixelHp', 'hud')
    updateHitbox('pixelHp')

    local boyfriendColors = string.gsub(rgbToHex(getProperty('boyfriend.healthColorArray')), "0X", "")

    makeLuaSprite('pixelBfHp', 'pixelBarFull', getProperty('pixelHp.x') + 2, getProperty('pixelHp.y') + 34.5)
    scaleObject('pixelBfHp', 2.4, 2.4)
    setObjectCamera('pixelBfHp', 'hud')
    setProperty('pixelBfHp.color', getColorFromHex(boyfriendColors))
    updateHitbox('pixelBfHp')
    addLuaSprite('pixelBfHp')

    local dadColors = string.gsub(rgbToHex(getProperty('dad.healthColorArray')), "0X", "")

    makeLuaSprite('pixelDadHp', 'pixelBarFull', getProperty('pixelHp.x') + 2, getProperty('pixelHp.y') + 34.5)
    scaleObject('pixelDadHp', 2.4, 2.4)
    setObjectCamera('pixelDadHp', 'hud')
    setProperty('pixelDadHp.color', getColorFromHex(dadColors))
    updateHitbox('pixelDadHp')
    addLuaSprite('pixelDadHp')

    addLuaSprite('pixelHp')
    setProperty('pixelDadHp._frame.frame.width', (2 - getProperty('health')) * getProperty('pixelDadHp.width') / 2)
    
    function MoveMode()
        scaleObject('act',4.5,4.5)
        doTweenX("BopX", "act.scale",4, 0.67, "bounceOut")
        doTweenY("BopY", "act.scale",4, 0.67, "bounceOut")
    
        scaleObject('fight',4.5,4.5)
        doTweenX("BopX2", "fight.scale",4, 0.67, "bounceOut")
        doTweenY("BopY2", "fight.scale",4, 0.67, "bounceOut")

        scaleObject('mercy',4.5,4.5)
        doTweenX("BopX3", "mercy.scale",4, 0.67, "bounceOut")
        doTweenY("BopY3", "mercy.scale",4, 0.67, "bounceOut")
    
        scaleObject('item',4.5,4.5)
        doTweenX("BopX4", "item.scale",4, 0.67, "bounceOut")
        doTweenY("BopY4", "item.scale",4, 0.67, "bounceOut")
    end
    for i = 1, #pixelArray do setProperty(pixelArray[i]..'.antialiasing', false) end
end

function onEvent(n, v1, v2)
    if n == '' then
        if v1 == 'k' then    
            setProperty('yeah.alpha',1)
            doTweenAlpha('yeahf', 'yeah', 0, 1, 'linear')
            removeLuaSprite('red')
            setProperty('bg.alpha',0)
            setProperty('camZoomingMult', 0)
            runHaxeCode('FlxTween.tween(dad, {alpha: 0},2, {ease: FlxEase.sineOut,startDelay: 0.45});')
        elseif v1 == 'first' then    
            setProperty('dad.alpha', 1)
            triggerEvent('Change Character', 'bf', 'sansmad') 
            triggerEvent('Change Character', 'dad', 'papsmad')  
            cameraFlash('d', '#ffffff', 0.7, true)
            setProperty('red.alpha',1) 
            setProperty('bg.alpha',1)
            doTweenAlpha('do', 'bg2', 1, 1.3, 'linear')
            doTweenAlpha('do2', 'bg', 0, 1.3, 'linear')
            setProperty('red2.alpha', 1)
            doTweenY('do5', 'fya', -200, 1.6, 'bounceInOut')     
            setProperty('camZoomingMult', 0.47)
        elseif v1 == 'goin' then    
            runHaxeCode([[
                FlxTween.tween(FlxG.camera, {zoom: FlxG.camera.zoom + 2},0.5, {ease: FlxEase.cubeInOut});
            ]]);
        elseif v1 == 'pixel' then     
            triggerEvent('Add Camera Zoom', 0.012, 0)  
            triggerEvent('Change Character', 'dad', 'exepap')  
            triggerEvent('Change Character', 'bf', 'sansmad') 
            setProperty('dad.x', 550)setProperty('dad.y', 400) 
            cameraFlash('d', '#ffffff', 0.7, true)
            setProperty('health', 1.06) setProperty('boyfriend.visible', false) setProperty('healthGain', 2)
            for i = 1, #okayArray do setProperty(okayArray[i]..'.visible', false) end 
            removeLuaScript("characters/sturmtimer")

            pixelMode();
        elseif v1 == 'thefire' then   
            runHaxeCode([[
                FlxG.camera.flash(FlxColor.RED,0.5);
            ]]); 
            cameraShake('camGame', shake, 50)
            cameraShake('camHUD', shake, 50)
        elseif v1 == 'in' then     
            runHaxeCode([[
                FlxTween.tween(FlxG.camera, {zoom: FlxG.camera.zoom + 4},2, {ease: FlxEase.quadInOut});
                FlxTween.tween(FlxG.camera, {y: FlxG.camera.y + 200}, 2, {ease: FlxEase.quadInOut, onComplete: function(twn:FlxTween)
                {
                    FlxTween.tween(FlxG.camera, {y: FlxG.camera.y - 200},2, {ease: FlxEase.quadInOut});
                }});
            ]]);
        elseif v1 == 'hud' then doTweenAlpha('zzzzzzzz', 'camHUD', 0, 1.2, 'linear') 
        elseif v1 == 'sure' then doTweenAlpha('shtrsthgavaave', 'camHUD', 1, 1, 'linear') 
        elseif v1 == 'game' then doTweenAlpha('ascas', 'camGame', 0, 0.72, 'linear')  
        elseif v1 == 'd' then   
            final = true 
            pause = true
            cameraFlash('other', '#000000', 0.3, true) 
            setProperty('camGame.visible', false)
            scaleObject('final',0.33,0.33)
            doTweenX("dfa", "final.scale",0.5, 26, "quadInOut")
            doTweenY("adsf", "final.scale",0.5, 26, "quadInOut")
        elseif v1 == 'z' then
            pause = false    
            cameraFlash('other', '#ffffff', 2.4, true) 
            removeLuaSprite('final')
        elseif v1 == 'g' then    
            hm = true
            f = false
            setProperty('dad.visible', true)   
            setProperty('boyfriend.visible', true) 
            triggerEvent('Change Character', 'bf', 'sans') 
            triggerEvent('Change Character', 'dad', 'paps') 
            setProperty('camGame.visible', true)
            doTweenAlpha('yeahf', 'yeah', 1, 1.3, 'linear')
            doTweenColor('ahah', 'boyfriend', '000000', 0.000001, 'linear')
            doTweenColor('haha', 'dad', '000000', 0.000001, 'linear')
            runHaxeCode([[
                FlxG.camera.fade(FlxColor.BLACK,1.7,true);
                FlxTween.tween(FlxG.camera, {zoom: FlxG.camera.zoom + 4}, 0.1, {ease: FlxEase.quadInOut, onComplete: function(twn:FlxTween)
                {
                    FlxTween.tween(FlxG.camera, {zoom: FlxG.camera.zoom - 4},3.2, {ease: FlxEase.quadInOut});
                }});
            ]]);
        elseif v1 == 'm' then    
            doTweenAlpha('yeahf', 'yeah', 0, 0.8, 'linear')
            runHaxeCode([[
                FlxTween.tween(FlxG.camera, {zoom: FlxG.camera.zoom + 4},3.6, {ease: FlxEase.quadInOut, onComplete: function(twn:FlxTween)
                {
                  game.camGame.visible = false;
                  FlxG.camera.flash(0000000000, 1.2);
                }});
            ]]);
        elseif v1 == 'goodbye' then    
            for i = 1, #overArray do 
                setProperty(overArray[i]..'.visible', false) 
            end 
        end 
    elseif n == 'note' then    
        if v1 == 'UTnotes' then
            changeNoteskin(v1, (v2 == 'true'))
            runHaxeCode([[
                for (i in notes.members) {
                    i.rgbShader.enabled = false;
                }
                for (i in unspawnNotes) {
                    i.rgbShader.enabled = false;
                }
            ]])
        else
            runHaxeCode([[
                for (i in notes.members) {
                    i.rgbShader.enabled = true;
                }
                for (i in unspawnNotes) {
                    i.rgbShader.enabled = true;
                }
            ]])
        end
    end
end

function onTweenCompleted(t)
    if t == 'ascas' then     
        for i = 1, #pixelArray do setProperty(pixelArray[i]..'.visible', false) end
    end
end

function onStepHit()
    if final == true then
        setProperty('final.alpha', 1)
        if getProperty('boyfriend.animation.curAnim.name') == 'singLEFT' then
    	    playAnim('final','left')
        end
        if getProperty('boyfriend.animation.curAnim.name') == 'singRIGHT' then
            playAnim('final','right')
        end
        if getProperty('boyfriend.animation.curAnim.name') == 'singUP' then
            playAnim('final','up')
        end
        if getProperty('boyfriend.animation.curAnim.name') == 'singDOWN' then
            playAnim('final','down')
        end
	    if getProperty('boyfriend.animation.curAnim.name') == 'idle' then
            playAnim('final','idle')
        end
    end
end

function onBeatHit()
	if curBeat % 4 == 0 and dadName == 'exepap' then
     MoveMode();
     --cameraFlash("game", "#ffffff", 0.7)
	end
end

function goodNoteHit(i, d, t, s)
	if not s then
		callMethod('playerStrums.members['..d..'].playAnim', {'static', true});
		callMethod('playerStrums.members['..d..'].playAnim', {'confirm'});
    end
    
	if s then
		setProperty('boyfriend.holdTimer', 0);
		if getProperty("playerStrums.animation.curAnim") == nil and "" or getProperty("playerStrums.animation.curAnim.name") == "static" then
			setProperty('playerStrums.members['..d..'].animation.curAnim.curFrame', 3);
		end
		
		if(stringStartsWith(getAnimationName("boyfriend"), "sing")) then	
			return;
		end
	end
end

function getAnimationName(char)
    return getProperty(char .. ".animation.curAnim") == nil and "" or getProperty(char ..".animation.curAnim.name");
end

function getStrumAnimationName()
   return getProperty("playerStrums.animation.curAnim") == nil and "" or getProperty("playerStrums.animation.curAnim.name");
end

function onPause()
    if pause == true then    
     return Function_Stop
    end
end

--https://gist.github.com/marceloCodget/3862929
function rgbToHex(rgb)
	local hexadecimal = '0X'

	for key, value in pairs(rgb) do
		local hex = ''

		while(value > 0)do
			local index = math.fmod(value, 16) + 1
			value = math.floor(value / 16)
			hex = string.sub('0123456789ABCDEF', index, index) .. hex			
		end

		if(string.len(hex) == 0)then
			hex = '00'

		elseif(string.len(hex) == 1)then
			hex = '0' .. hex
		end

		hexadecimal = hexadecimal .. hex
	end

	return hexadecimal
end