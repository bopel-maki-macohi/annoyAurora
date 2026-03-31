import lime.utils.Assets;
import flixel.text.FlxText;
import flixel.FlxG;
import flixel.FlxState;

class OutdatedState extends FlxState
{
	public static var seen:Bool = false;

	override function create()
	{
		super.create();

		var message = new FlxText(0, 0, 0, '', 16);
		add(message);

		message.text += 'Hey... There\'s a new update out!' + '\n' + UpdateUtil.latestVersion + '!' + '\n\nYou can press ESCAPE to say "I DON\'T CARE!"'
			+ '\nENTER to go to the github';

		message.alignment = CENTER;
		message.screenCenter();

		MouseManager.instance.visible = false;

		seen = true;
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.keys.justReleased.ESCAPE)
			InitState.proceed();

		if (FlxG.keys.justReleased.ENTER)
		{
			FlxG.openURL('https://github.com/bopel-maki-macohi/annoyAurora/releases');
			InitState.proceed();
		}
	}
}
