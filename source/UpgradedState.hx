import lime.utils.Assets;
import flixel.text.FlxText;
import flixel.FlxG;
import flixel.FlxState;

class UpgradedState extends FlxState
{
	public var lastVersion:String = '0.0.0';

	override public function new(lastVersion:String)
	{
		super();

		this.lastVersion = lastVersion;
        trace('lastVersion: $lastVersion');
	}

	override function create()
	{
		super.create();

		var message = new FlxText(0, 0, 0, '', 16);
		add(message);

		message.text += 'Welcome to version ${FlxG.stage.application.meta.get('version')}!'
			+ '\n'
			+ Assets.getText('assets/upgradedMessages/$lastVersion.txt')
			+ '\n\nPress anything to go to gameplay lol';

		message.alignment = CENTER;
		message.screenCenter();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.keys.justReleased.ANY)
			InitState.proceed();
	}
}
