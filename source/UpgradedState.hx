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

		var upgradeMessage:String = 'Have fun!';
		final upgradeMessagePath = 'assets/upgradedMessages/$lastVersion.txt';

		if (Assets.exists(upgradeMessagePath))
			upgradeMessage = Assets.getText(upgradeMessagePath);

		var message = new FlxText(0, 0, 0, '', 16);
		add(message);

		message.text += 'Welcome to version ${FlxG.stage.application.meta.get('version')}!'
			+ '\n\n'
			+ upgradeMessage
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
