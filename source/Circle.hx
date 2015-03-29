package ;
import flixel.effects.particles.FlxEmitter;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxAngle;
import flixel.math.FlxRandom;
import flixel.util.FlxSpriteUtil;
import flixel.util.FlxColor;
import flixel.group.FlxGroup;
import state.PlayState;

/**
 * ...
 * @author Masadow
 */
class Circle extends FlxSprite
{
    
    var missiles : FlxTypedGroup<Missile>;
    var elapsed = 3.;
    var direction = "left";
    private static var r = new FlxRandom();
    private var _life : Int;
    private var _blink : Int;
    private var _nextBlink : Float;
    private var _emitter : FlxEmitter;

    public function new(x : Float, y : Float, missilePool : FlxTypedGroup<Missile>) 
    {
        super(x, y);
        
        makeGraphic(80, 80, 0);
        
        FlxSpriteUtil.drawCircle(this, -1, -1, 38, 0xff000000, {
            thickness: 3,
            color: FlxColor.WHITE
        });
        
        missiles = missilePool;

		_emitter = PlayState.emitters.recycle();
		_emitter.makeParticles(2, 2, FlxColor.WHITE, 64);
        _emitter.width = 80;
        _emitter.height = 80;
        
        init();
    }
    
    private function init() {
        _life = 3;
    }
    
    override public function revive():Void 
    {
        super.revive();
        init();
    }
    
    override public function update(elapsed:Float):Void 
    {
        this.elapsed += elapsed;
        if (this.elapsed > 4) {
            this.elapsed = 0;
            shoot(direction);
            direction = direction == "left" ? "right" : "left";
        }
        
        missiles.forEachAlive(function (m : Missile) {
            if (m.bounced && pixelsOverlapPoint(m.getMidpoint())) {
                m.explode();
                _life--;
                if (_life > 0) {
                    _blink += 5;
                    _nextBlink = 0.1;
                }
                else {
                    _emitter.x = x;
                    _emitter.y = y;
                    _emitter.start();
                    kill();
                }
            }
        });
        
        _nextBlink -= elapsed;
        if (_nextBlink < 0 && _blink > 0 && --_blink > 0) {
            _nextBlink = 0.1;
            color = color == FlxColor.RED ? FlxColor.WHITE : FlxColor.RED;
        }

        super.update(elapsed);
    }
    
    public function shoot(direction : String) {
        var m = missiles.recycle();
        m.revive();
        m.x = x + width / 2;
        m.y = y + height / 2;

        var cx = x + width / 2;
        var cy = y + height / 2;
        var minAngle = Std.int(-FlxAngle.asDegrees(Math.atan(cy / (FlxG.width - cx))));
        var maxAngle = Std.int(FlxAngle.asDegrees(Math.atan((FlxG.height - cy) / (FlxG.width - cx))));

        if (direction == "left")
            m.angleInt = r.int(minAngle, maxAngle) + 270;
        else
            m.angleInt = r.int(minAngle, maxAngle) + 90;
        
        m.bounced = false;
            
        FlxG.sound.play("sounds/laser.wav");
    }
    
}