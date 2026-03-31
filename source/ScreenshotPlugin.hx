package util.plugins;

import flixel.FlxBasic;
#if SCREENSHOT_PLUGIN
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.util.FlxTimer;
import openfl.display.BitmapData;
import openfl.display.PNGEncoderOptions;
import openfl.utils.ByteArray;
#end

/**
	A plugin that allows the player to take screenshots.

	Base Code yoinked from WTFEngine: https://github.com/VirtuGuy/WTF-Engine/blob/main/source/funkin/util/plugins/ScreenshotPlugin.hx
 */
class ScreenshotPlugin extends FlxBasic
{
	var tookScreenshot:Bool = false;

	public static function init()
	{
		#if SCREENSHOT_PLUGIN
		#if sys
		if (!sys.FileSystem.exists(Constants.FOLDER_SCREENSHOTS))
			sys.FileSystem.createDirectory(Constants.FOLDER_SCREENSHOTS);
		#end

		FlxG.plugins.addPlugin(new ScreenshotPlugin());
		#end
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		#if SCREENSHOT_PLUGIN
		if (FlxG.keys.justPressed.F3 && !tookScreenshot)
		{
			tookScreenshot = true;

			#if sys
			final screenshot:BitmapData = BitmapData.fromImage(FlxG.stage.window.readPixels());
			final bytes:ByteArray = screenshot.encode(screenshot.rect, new PNGEncoderOptions());

			final path = '${Constants.FOLDER_SCREENSHOTS}/screenshot_${Date.now().getTime() / 1000}.png';

			sys.io.File.saveBytes(path, bytes);
			trace('Saved screenshot to $path');

			FlxG.camera.flash(FlxColor.WHITE, .5);
			#else
			trace('Cannot screenshot on this platform');
			#end

			FlxTimer.wait(1, () ->
			{
				tookScreenshot = false;
				trace('Can screenshot again');
			});
		}
		#end
	}
}
