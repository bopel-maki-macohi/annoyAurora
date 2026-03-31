package;

import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;

class PlayState extends FlxState
{
	public var aurora:FlxSprite = new FlxSprite();

	override public function create()
	{
		super.create();

		aurora.makeGraphic(256, 512, FlxColor.LIME);
		add(aurora);

		aurora.screenCenter();
		aurora.y = FlxG.height - aurora.height;
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
