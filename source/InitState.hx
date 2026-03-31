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

		FlxG.switchState(() -> new PlayState());
	}
}
