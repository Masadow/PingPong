package state ;

import flixel.addons.display.shapes.FlxShapeCircle;
import flixel.effects.particles.FlxEmitter;
import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.math.FlxAngle;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;
import flixel.FlxObject;
import flixel.util.FlxPath;
import openfl.Assets;
import flixel.math.FlxPoint;
import flixel.input.keyboard.FlxKey;

/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends FlxState
{
    
    var ping : Pong;
    var pong : Pong;
    
    var missiles : FlxTypedGroup<Missile>;
    
    public static var sincos = FlxAngle.sinCosGenerator();
    public static var emitters : FlxTypedGroup<FlxEmitter>;
    
    private var enemies : FlxTypedGroup<Circle>;

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

        emitters = new FlxTypedGroup<FlxEmitter>(25);

        for (_ in 0...25) {
            //Create 10 missiles that will be instantly killed
            var e = new FlxEmitter();
            e.kill();
            emitters.add(e);
        }

        missiles = new FlxTypedGroup<Missile>(20);

        for (_ in 0...20) {
            //Create 10 missiles that will be instantly killed
            var m = new Missile(0, 0, 0);
            m.kill();
            missiles.add(m);
        }
        
        add(missiles);
        
        add((ping = new Pong("left", {
            up: FlxKey.Q,
            down: FlxKey.S
        })));
        add((pong = new Pong("right", {
            up: FlxKey.I,
            down: FlxKey.J
        })));
        
        enemies = new FlxTypedGroup<Circle>();
        enemies.add(new Circle(FlxG.width / 2 - 40, FlxG.height / 2 - 40, missiles));
        
        add(enemies);
        
        add(emitters);
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
        missiles.forEachAlive(function (m : Missile) {
            if (m.overlaps(ping) && ping.canReflect(m)) {
                ping.reflectMissile(m);
            }
            else if (m.overlaps(pong) && pong.canReflect(m)) {
                pong.reflectMissile(m);
            }
        });
        
        for (i in 0...missiles.length - 1) {
            var m1 = missiles.members[i];
            if (m1.alive) {
                for (j in (i + 1)...missiles.length) {
                    var m2 = missiles.members[j];
                    if (m2.alive && m1.overlaps(m2)) {
                        m2.explode();
                        m1.explode();
                        break ;
                    }
                }
            }
        }
        
        if (enemies.countLiving() == 0) {
            missiles.forEachAlive(function (m : Missile) {
                m.kill();
            });
            
            if (enemies.length == 1) {
                enemies.recycle().y = 200;
                enemies.add(new Circle(FlxG.width / 2 - 40, FlxG.height - 280, missiles));
            }
            else if (enemies.length == 2) {
                enemies.recycle().y = 100;
                enemies.recycle().y = FlxG.height - 180;
                enemies.add(new Circle(FlxG.width / 2 - 40, FlxG.height / 2 - 40, missiles));
            }
            else {
                FlxG.switchState(new GameOver(true));
            }
        }
        
		super.update(elapsed);
    }
	
}
