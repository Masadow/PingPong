package ;
import flixel.FlxG;
import flixel.text.FlxText;

/**
 * ...
 * @author Masadow
 */
class Dialog extends FlxText
{

    public var isDrawing(default, null) : Bool; //Optimization, avoid unecessary string comparison each updates
    var final : String;
    var lastDraw : Float;
    // Seconds between each characters drawing
    var speed : Float;
    
    public function new()
    {
        super();
        
        final = "";
        isDrawing = false;
        size = 22;
    }
    
    public function show(txt : String, speed : Float = 0.1) {
        text = "";
        final = txt;
        lastDraw = speed;
        isDrawing = true;
        this.speed = speed;
    }

    override public function update(elapsed:Float):Void 
    {
        super.update(elapsed);

        if (isDrawing) {
            lastDraw += elapsed;
            
            if (text.length == final.length)
                isDrawing = false;
            else if (lastDraw > speed && final != text) {
                lastDraw = 0;
                text += final.charAt(text.length);
                FlxG.sound.play("sounds/text.wav");
            }
        }
    }
    
}