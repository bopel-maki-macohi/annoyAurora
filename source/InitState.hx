import lime.app.Application;
import flixel.FlxG;
import flixel.FlxState;

class InitState extends FlxState
{
	override function create()
	{
		super.create();

		FlxG.mouse.load('assets/cursor.png', 1, -32, -32);

		SaveManager.instance = new SaveManager();
		FlxG.plugins.addPlugin(SaveManager.instance);

		Application.current.onExit.add(function(l)
		{
			SaveManager.instance.save();
		});

		UpdateUtil.checkForUpdate();

		if (UpdateUtil.latestVersion != Main.currentVersion)
			FlxG.switchState(() -> new OutdatedState());
		else if (SaveManager.instance.lastVersion == Main.currentVersion)
		{
			proceed();
		}
		else
		{
			trace('JUST UPGRADED!');
			FlxG.switchState(() -> new UpgradedState(SaveManager.instance.lastVersion));
		}

		SaveManager.instance.lastVersion = Main.currentVersion;
	}

	public static function proceed()
	{
		#if WINSTATE
		FlxG.switchState(() -> new WinState());
		#else
		FlxG.switchState(() -> new PlayState());
		#end
	}
}
