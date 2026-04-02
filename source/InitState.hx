import flixel.util.FlxSave;
import haxe.Serializer;
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

		SaveManager.dataSave.bind('AnnoyAurora', 'Maki');

		if (SaveManager.dataSave.data.lastVersion != null)
		{
			trace('Legacy Save');

			final legacySave:FlxSave = new FlxSave();
			legacySave.bind('AnnoyAurora-Legacy', 'Maki');
			legacySave.mergeDataFrom('AnnoyAurora', 'Maki');

			FlxG.save.bind('AnnoyAurora', 'Maki');
			FlxG.save.data.lastVersion = null;
			FlxG.save.close();

			SaveManager.saveSuffix = 'Legacy';
		}
		else
		{
			trace('Save : ${SaveManager.dataSave.data.saveSuffix}');
			SaveManager.saveSuffix = SaveManager.dataSave.data.saveSuffix;
		}

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
		UpdateUtil.latestVersion = Main.currentVersion;
		#end

		proceed();
	}

	public static function proceed()
	{
		if (!OutdatedState.seen)
			if (UpdateUtil.latestVersion != Main.currentVersion)
			{
				FlxG.switchState(() -> new OutdatedState());
				return;
			}

		#if WINSTATE
		FlxG.switchState(() -> new WinState(true));
		#elseif PLAYSTATE
		FlxG.switchState(() -> new PlayState());
		#else
		FlxG.switchState(() -> new SavePageState());
		#end
	}

	function postUpdate()
	{
		if (FlxG.keys.pressed.F3)
			if (FlxG.keys.justPressed.C)
				throw 'Debug Crash';
	}
}
