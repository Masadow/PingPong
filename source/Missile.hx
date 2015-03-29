package ;

import flixel.effects.particles.FlxEmitter;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxRandom;
import flixel.util.FlxColor;
import state.PlayState;

/**
 * ...
 * @author Masadow
 */
class Missile extends FlxSprite
{

    //In degrees
    public var angleInt(default, set) : Int;
    public var bounced : Bool;
    private var _emitter : FlxEmitter;
    private var speed : Float;
    
    public function new(x : Float, y : Float, direction : Int) 
    {
        super(x, y);
        
        makeGraphic(4, 16, FlxColor.WHITE, true, "missile" );
        angleInt = direction;
        
        //Explode effect
		_emitter = PlayState.emitters.recycle();
		_emitter.makeParticles(2, 2, FlxColor.WHITE, 16);
        
        init();
    }
    
    public function set_angleInt(angle : Int) : Int {
        while (angle < 0)
            angle += 360; //Workaround for broken negative modulo
        angle %= 360;
        this.angle = angle;
        angleInt = Std.int(angle);
        return angle;
    }
    
    private function init() {
        speed = 300;
    }
    
    override public function revive():Void 
    {
        super.revive();
        init();
    }

    override public function update(elapsed:Float):Void 
    {
        speed -= 10 * elapsed;
        velocity.x = -state.PlayState.sincos.sin[angleInt] * speed;
        velocity.y = state.PlayState.sincos.cos[angleInt] * speed;
        
        if (speed < 200) {
            explode();
        }
        
        if (x < -width || x > FlxG.width) {
            kill();
            FlxG.switchState(new state.GameOver());
        }
        else if (y < -height && angleInt > 90 && angleInt < 270) {
            bounce("down");
        }
        else if (y > FlxG.height && (angleInt < 90 || angleInt > 270)) {
            bounce("up");
        }
        
        

        super.update(elapsed);
    }
    
    public function explode() {
        FlxG.sound.play("sounds/hit.wav");
        _emitter.x = x + width / 2;
        _emitter.y = y + height / 2;
        _emitter.start();
        kill();
    }
    
    public function bounce(direction : String, distortion : Float = 0) {
        switch (direction) {
            case "right":
                angleInt = -(angleInt - 90) + 270 + Std.int(90 * distortion);
            case "down":
                angleInt = -(angleInt - 180) + Std.int(90 * distortion);
            case "left":
                angleInt = -(angleInt - 270) + 90 + Std.int(90 * distortion);
            case "up":
                angleInt = -angleInt + 180 + Std.int(90 * distortion);
        }
    }
}