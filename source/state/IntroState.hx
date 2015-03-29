package state;

import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.math.FlxAngle;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;
import flixel.FlxObject;
import flixel.util.FlxPath;
import openfl.Assets;
import flixel.math.FlxPoint;
import flixel.input.keyboard.FlxKey;
import flixel.util.FlxColor;

/**
 * A FlxState which can be used for the actual gameplay.
 */
class IntroState extends FlxState
{
    var step = 0;
    var elapsed = 0.5;
    
    var ping : Pong;
    var pong : Pong;
    
    var bg : FlxSprite;

	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		var sincos = FlxAngle.sinCosGenerator();
		
		// Set a background color
		FlxG.cameras.bgColor = 0xff000000;
		// Show the mouse (in case it hasn't been disabled)
		#if !FLX_NO_MOUSE
		FlxG.mouse.visible = true;
		#end
        
		super.create();
        
        bg = new FlxSprite(0, 0);
        bg.makeGraphic(FlxG.width, FlxG.height, FlxColor.WHITE);
        bg.color = FlxColor.BLACK;
        add(bg);
        
        add((ping = new Pong("left", {
            up: -1,
            down: -1
        })));
        add((pong = new Pong("right", {
            up: -1,
            down: -1
        })));
    }

	/**
	 * Function that is called when this state is destroyed - you might want to 
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy():Void
	{
		super.destroy();
	}
	
	override public function draw():Void
	{
		super.draw();
	}
    
	/**
	 * Function that is called once every frame.
	 */
	override public function update(elapsed:Float):Void
	{
        if (FlxG.keys.justPressed.ESCAPE) {
            FlxG.switchState(new PlayState());
        }
        
        if (!ping.isTalking() && !pong.isTalking())
            this.elapsed += elapsed;
        
        if (this.elapsed >= 1) {
            this.elapsed = 0;

            switch (++step) {
                case 1:
                    ping.say("?!");
                case 2:
                    ping.say("");
                    pong.say("?!");
                case 3:
                    ping.say("Where is the ball ?");
                    pong.say("");
                case 4:
                    ping.say("");
                    pong.say("I don't know !");
                case 5:
                    pong.say("");
//                    ping.move(FlxG.width / 2 - ping.width - 10, null, 1);
//                    pong.move(FlxG.width / 2 + 10, null, 1);
//                    elapsed = -1.5;
                    elapsed = 1; //skip this step for now
                case 6:
                    FlxG.sound.play("sounds/bigexplosion.wav");
                    FlxG.camera.shake(0.05, 1.5);
                    ping.say("Oh no ! Circles are attacking !");
                case 7:
                    FlxTween.color(bg, 0.5, FlxColor.BLACK, FlxColor.WHITE);
                case 8:
                    FlxG.switchState(new PlayState());
            }
        }
        
		super.update(elapsed);
    }
	
}
