import flixel.FlxG;
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

		text.size = 16;

		switch (ending)
		{
			default:
				text.text = 'Congrats! You are... kinda an asshole...';
		}

		text.text += '\n\nPress anything to do it again, you jerk.';

		add(text);
		text.screenCenter();
		text.y = 10;

		if (!SaveManager.hasEnding(ending))
			SaveManager.getEnding(ending);

		FlxG.mouse.visible = false;
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.keys.justReleased.ANY)
		{
            SaveManager.newGame();
			FlxG.switchState(() -> new PlayState());
		}
	}
}
