import openfl.Lib;
import objects.AwesomeVideo;
import backend.ClientPrefs;
import backend.MusicBeatState;
import objects.Note;
import objects.StrumNote;
import psychlua.CustomSubstate;
import substates.PauseSubState;
import flixel.math.FlxMath;

var v:AwesomeVideo;
var time = 1.4;
var canExit:Bool = false;
var black:FlxSprite;

var redStuff;
var redStuff2;
var redStuff3;
var redStuff4;

function onCreate(){
    v = new AwesomeVideo();
    v.addCallback('onFormat',()->{
        v.setGraphicSize(1700);
        v.updateHitbox();
        v.screenCenter();
        v.cameras = [camGame];
    });

    v.addCallback('onEnd',()->{
        v.destroy();
    });

    v.load(Paths.video('v'),[AwesomeVideo.muted]);
    AwesomeVideo.cacheVid(Paths.video('v'));
    v.antialiasing = ClientPrefs.data.antialiasing;
    add(v);

    //awesome code
    redStuff = new FlxEmitter();
    add(redStuff);
    redStuff.emitting = true;
    redStuff.launchMode = FlxEmitterMode.CIRCLE;
    redStuff.makeParticles(8, 8, 0xFFFFFFFF, 200);
    redStuff.velocity.set(200, 0,-80,-700,0,0);
    redStuff.lifespan.set(3,4);
    redStuff.start(false, 0, 0);
    redStuff.frequency = 0.05;
    redStuff.alpha.set(1,1,0,0);
    redStuff.color.set(FlxColor.BLACK,FlxColor.RED);
    redStuff.width = 70;
    redStuff.visible = false;
    redStuff.solid = true;

    redStuff2 = new FlxEmitter();
    add(redStuff2);
    redStuff2.emitting = true;
    redStuff2.launchMode = FlxEmitterMode.CIRCLE;
    redStuff2.makeParticles(8, 8, 0xFFFFFFFF, 500);
    redStuff2.velocity.set(200, -100, 200, 100);
    redStuff2.lifespan.set(3,4);
    redStuff2.launchAngle.set(-45, 45);
    redStuff2.acceleration.set(0, 0, 0, 0, 200, 200, 400, 400);
    redStuff2.start(false, 0, 0);
    redStuff2.frequency = 0.05;
    redStuff2.alpha.set(1,1,0,0);
    redStuff2.color.set(FlxColor.BLACK,FlxColor.RED);
    redStuff2.width = 70;
    redStuff2.y -= 10;
    redStuff2.x -= 90;
    redStuff2.acceleration.start.min.y = 800;
    redStuff2.acceleration.start.max.y = 1000;
    redStuff2.acceleration.end.min.y = 800;
    redStuff2.acceleration.end.max.y = 1000;

    redStuff3 = new FlxEmitter();
    add(redStuff3);
    redStuff3.emitting = true;
    redStuff3.launchMode = FlxEmitterMode.CIRCLE;
    redStuff3.makeParticles(8, 8, 0xFFFFFFFF, 500);
    redStuff3.velocity.set(-500, 200, 100, 200);
    redStuff3.lifespan.set(3,4);
    redStuff3.launchAngle.set(-45, 45);
    redStuff3.acceleration.set(0, 0, 0, 0, 200, 200, 400, 400);
    redStuff3.start(false, 0, 0);
    redStuff3.frequency = 0.05;
    redStuff3.alpha.set(1,1,0,0);
    redStuff3.color.set(FlxColor.BLACK,FlxColor.RED);
    redStuff3.width = 70;
    redStuff3.y -= 10;
    redStuff3.x += 1500;
    redStuff3.acceleration.start.min.y = 1000;
    redStuff3.acceleration.start.max.y = 800;
    redStuff3.acceleration.end.min.y = 1000;
    redStuff3.acceleration.end.max.y = 800;

    redStuff4 = new FlxEmitter();
    add(redStuff4);
    redStuff4.emitting = true;
    redStuff4.launchMode = FlxEmitterMode.CIRCLE;
    redStuff4.makeParticles(8, 8, 0xFFFFFFFF, 200);
    redStuff4.velocity.set(50, 40, 60, 80, -400, -600, 400, 600);
    redStuff4.lifespan.set(3,4);
    redStuff4.start(false, 0, 0);
    redStuff4.frequency = 0.05;
    redStuff4.alpha.set(1,1,0,0);
    redStuff4.color.set(FlxColor.BLACK,FlxColor.RED);
    redStuff4.width = 70;

    for (i in [redStuff,redStuff2,redStuff3,redStuff4]) {
        i.visible = false;
    }
}

function onEvent(ev,v1,v2) {
    if (ev == '') {
        switch(v1){
            case 'pixel':
                for (i in 0...game.playerStrums.length) {
	
                    var note:StrumNote = game.playerStrums.members[i];
                    note.x = -278;
                    note.x += Note.swagWidth * i;
                    note.x += 50;
                    note.x += (FlxG.width/2);
                }
            case 'thefire': red();
            case 'v':
                v.play();
                game.camGame.alpha = 1;
                dad.visible = false;
            case 'd': if (v != null) v.destroy();
        }
    }
}

function red() {
    for (i in [redStuff,redStuff2,redStuff3,redStuff4]) {
        i.solid = i.visible = true;
    }
}

function onUpdatePost(elapsed) {
    if (redStuff.visible) {
        redStuff.x = dad.x + (dad.width - redStuff.width)/2 - 300;
        redStuff.y = dad.y + dad.height + 90;
    }
}

function onGameOver() {
    CustomSubstate.openCustomSubstate('g', true);
    return Function_Stop;
}

function onCustomSubstateCreate(name)
{
    if (name == 'g') {
        for (i in [game.camGame, game.camHUD, game.camOther]) i.visible = false;
        var gameover = new FlxSprite().loadGraphic(Paths.image('gameover'));
        gameover.screenCenter();
        gameover.alpha = 0;
        add(gameover);

        black = new FlxSprite().makeGraphic(1280, 720);
        black.color = FlxColor.BLACK;
        black.alpha = 0;
        add(black);

        for (i in [gameover, black]) i.cameras = [game.camDeath];

        new FlxTimer().start(time,Void->{
            FlxG.sound.playMusic(Paths.music('goodbye'));
            FlxTween.tween(gameover, {alpha: 1}, time, {ease: FlxEase.quadOut, onComplete: function(twn:FlxTween)
            {
                canExit = true;
            }});      
        });
    }
}

function onCustomSubstateUpdatePost(name, elapsed) {
    if (name == 'g') {
        if (canExit) {
            if (controls.ACCEPT) {
                canExit = false;
                FlxG.sound.music.fadeOut(1.5, 0);
                FlxTween.tween(black, {alpha: 1}, time + 0.3, {ease: FlxEase.quadOut, onComplete:Void ->{
                    new FlxTimer().start(0.6, (tmr:FlxTimer) -> {
                        PauseSubState.restartSong(false);
                    });
                }});
            }
        }
    }
}