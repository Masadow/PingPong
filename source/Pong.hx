package ;
import flixel.group.FlxGroup;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.tweens.FlxTween;

typedef KeyMapping  = {
    up: Int,
    down: Int
};

/**
 * ...
 * @author Masadow
 */
class Pong extends FlxTypedGroup<FlxSprite>
{
    
    var keyMapping : KeyMapping;
    var dialog : Dialog;
    var char : FlxSprite;
    var isRight : Bool;
    
    public var width(default, never) = 20;
    public var height(default, never) = 80;

    public function new(location : String, keymapping : KeyMapping) 
    {
        super();
        
        keyMapping = keymapping;
        
        char = new FlxSprite();
        char.makeGraphic(width, height, FlxColor.WHITE, true, "pong");
        
        isRight = location == "right";
        
        char.x = isRight ? FlxG.width - char.width - 40 : 40;
        char.y = FlxG.height / 2 - char.height / 2;

        dialog = new Dialog();

        dialog.x = char.x;
        dialog.y = char.y - 30;
        
        add(char);
        add(dialog);
    }
    
    public function say(text : String) {
        dialog.show(text);
    }

    override public function update(elapsed : Float) 
    {
        if (isRight)
            dialog.x = char.x + char.width - dialog.width;
        else
            dialog.x = char.x;
        
        if (FlxG.keys.anyPressed([keyMapping.up]))
            char.y -= 600 * elapsed;
        else if (FlxG.keys.anyPressed([keyMapping.down]))
            char.y += 600 * elapsed;
            
        if (char.y < 0)
            char.y = 0;
        if (char.y > FlxG.height - height)
            char.y = FlxG.height - height;
        
        super.update(elapsed);
    }
    
    public function isTalking() : Bool {
        return dialog.isDrawing;
    }
    
    public function move(x : Null<Float>, y : Null<Float>, time : Float = 1) : Void {
        if (x == null)
            x = char.x;
        if (y == null)
            y = char.y;
        FlxTween.tween(char, {x: x, y: y}, time);
    }
    
    public function reflectMissile(m : Missile) {
//        var distortion = ((char.y + char.height / 2) - (m.y + m.height / 2)) / (m.height / 2);
//        m.bounce(isRight ? "right" : "left", distortion);
        var halfHeight = char.height / 2;
        var middleMissileY = m.y + m.height / 2;
        var middlePongY = char.y + halfHeight;
        var hitOffset = middlePongY - middleMissileY;
        var nangle = Std.int((hitOffset / halfHeight) * 60);
        if (!isRight)
            nangle *= -1;
        m.angleInt = nangle + (isRight ? 90 : 270);
        m.bounced = true;
    }
    
    //Prevent missiles from beeing reflected multiple times
    public function canReflect(m : Missile) : Bool {
        return m.angleInt > 180 == isRight;
    }
    
}