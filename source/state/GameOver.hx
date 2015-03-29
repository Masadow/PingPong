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
class GameOver extends FlxState
{
    private var _win : Bool;
    
    public function new(win = false) {
        super();
        _win = win;
    }

	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		// Set a background color
		FlxG.cameras.bgColor = 0xff000000;
		// Show the mouse (in case it hasn't been disabled)
		#if !FLX_NO_MOUSE
		FlxG.mouse.visible = true;
		#end
        
		super.create();

        var txt = new FlxText(0, 0, 0, _win ? "You win !" : "You lose !", 32);
        txt.x = FlxG.width / 2 - txt.width / 2;
        txt.y = FlxG.height / 2 - txt.height / 2;
        add(txt);
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
		super.update(elapsed);
        
        if (FlxG.keys.anyJustPressed([FlxKey.ESCAPE, FlxKey.SPACE, FlxKey.ENTER]))
            FlxG.switchState(new IntroState());
    }
	
}
