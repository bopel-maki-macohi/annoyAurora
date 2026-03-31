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

		function winstateDefineRandom():Bool
		{
			#if WINSTATE
			return FlxG.random.bool();
			#end

			return false;
		}

		if (SaveManager.hasItem('beer') || winstateDefineRandom())
			ending = 'drunk';

		if (SaveManager.hasItem('changeGender') || winstateDefineRandom())
			if (ending == 'normal')
				ending = 'female';
			else
				ending += '-female';

		sprite.loadGraphic('assets/endings/$ending.png');
		sprite.screenCenter();
		add(sprite);

		text.size = 16;

		text.text = 'Congrats!\n';
		switch (ending)
		{
			case 'female':
				text.text += 'You are an asshole transgender.';

			case 'drunk-female':
				text.text += 'You\'re a drunk transgender jerk.';

			case 'drunk':
				text.text += 'You are now another drunk asshole boyfriend that no one likes.';

			default:
				text.text += 'You are...\nkinda just an asshole now...';
		}

		text.text += '\n\nPress ENTER to do it again, you jerk.';

		add(text);
		text.alignment = CENTER;
		text.screenCenter();
		text.y = 10;

		if (!SaveManager.hasEnding(ending))
			SaveManager.getEnding(ending);

		FlxG.mouse.visible = false;
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.keys.justReleased.ENTER)
		{
			SaveManager.newGame();
			FlxG.switchState(() -> new PlayState());
		}
	}
}
