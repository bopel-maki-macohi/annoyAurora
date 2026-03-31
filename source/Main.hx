package;

import flixel.FlxG;
import flixel.FlxGame;
import openfl.display.Sprite;

class Main extends Sprite
{
	public function new()
	{
		super();

		SaveManager.instance = new SaveManager();
		FlxG.plugins.addPlugin(SaveManager.instance);
		
		addChild(new FlxGame(0, 0, PlayState));
	}
}
