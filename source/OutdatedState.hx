import lime.utils.Assets;
import flixel.text.FlxText;
import flixel.FlxG;
import flixel.FlxState;

class OutdatedState extends FlxState
{
	override function create()
	{
		super.create();

		var message = new FlxText(0, 0, 0, '', 16);
		add(message);

		message.text += 'Hey... There\'s a new update out!' + '\n' + UpdateUtil.latestVersion + '!' + '\n\nYou can press ESCAPE to say "I DON\'T CARE!"'
			+ '\nAnything else to go to the github';

		message.alignment = CENTER;
		message.screenCenter();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.keys.justReleased.ANY)
		{
			if (FlxG.keys.justReleased.ESCAPE)
				FlxG.openURL('https://github.com/bopel-maki-macohi/annoyAurora/releases');
			
			InitState.proceed();
		}
	}
}
