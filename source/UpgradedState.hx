import lime.utils.Assets;
import flixel.text.FlxText;
import flixel.FlxG;
import flixel.FlxState;

using StringTools;

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

		message.text += 'Welcome to version %version%!'
			+ '\n\n'
			+ upgradeMessage
			+ '\n\nPress ENTER to go to gameplay lol';

		message.text = message.text.replace('%version%', Main.currentVersion);

		message.alignment = CENTER;
		message.screenCenter();
		
		MouseManager.instance.visible = false;
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.keys.justReleased.ENTER)
			InitState.proceed();
	}
}
