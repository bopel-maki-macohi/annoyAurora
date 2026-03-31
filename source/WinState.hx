import flixel.text.FlxText;
import flixel.FlxSprite;
import flixel.FlxState;

class WinState extends FlxState
{
	public var sprite:FlxSprite = new FlxSprite();

    public var text:FlxText = new FlxText();

	override function create()
	{
		super.create();

		var ending:String = 'normal';

		sprite.loadGraphic('assets/endings/$ending.png');
		sprite.screenCenter();
		add(sprite);

        text.size = 32;
        text.text = 'Congrats! You are... kinda an asshole...';
        add(text);
        text.screenCenter();
        text.y = 10;
	}
}
