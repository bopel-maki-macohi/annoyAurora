package;

import flixel.FlxG;
import flixel.FlxGame;
import openfl.display.Sprite;

class Main extends Sprite
{
	public function new()
	{
		super();

		// Set the current working directory for Android and iOS devices
		#if android
		// On Android use External Files Dir.
		// Sys.setCwd(haxe.io.Path.addTrailingSlash(extension.androidtools.content.Context.getExternalFilesDir()));
		#elseif ios
		// On iOS use Documents Dir.
		Sys.setCwd(haxe.io.Path.addTrailingSlash(lime.system.System.documentsDirectory));
		#end

		addChild(new FlxGame(0, 0, InitState));
	}
}
