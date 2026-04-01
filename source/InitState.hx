import lime.app.Application;
import flixel.FlxG;
import flixel.FlxState;

class InitState extends FlxState
{
	override function create()
	{
		super.create();

		SaveManager.instance = new SaveManager();
		FlxG.plugins.addPlugin(SaveManager.instance);

		ScreenshotPlugin.init();

		MouseManager.instance = new MouseManager();
		FlxG.plugins.addPlugin(MouseManager.instance);

		Application.current.onExit.add(function(l)
		{
			SaveManager.instance.save();
		});

		if (!FlxG.signals.postUpdate.has(postUpdate))
			FlxG.signals.postUpdate.add(postUpdate);

		UpdateUtil.checkForUpdate();

		#if html5
		SaveManager.instance.lastVersion = Main.currentVersion;
		UpdateUtil.latestVersion = Main.currentVersion;
		#end

		final lv = SaveManager.instance.lastVersion;

		if (lv == Main.currentVersion)
			proceed();
		else
		{
			trace('JUST UPGRADED!');
			FlxG.switchState(() -> new UpgradedState(lv));
		}

		SaveManager.instance.lastVersion = Main.currentVersion;
	}

	public static function proceed()
	{
		if (!OutdatedState.seen)
			if (UpdateUtil.latestVersion != SaveManager.instance.lastVersion)
			{
				FlxG.switchState(() -> new OutdatedState());
				return;
			}

		#if WINSTATE
		FlxG.switchState(() -> new WinState(true));
		#else
		FlxG.switchState(() -> new PlayState());
		#end
	}

	function postUpdate()
	{
		if (FlxG.keys.pressed.F3)
			if (FlxG.keys.justPressed.C)
				throw 'Debug Crash';
	}
}
