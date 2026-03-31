import lime.utils.Assets;
import flixel.FlxSprite;
import flixel.FlxG;

using StringTools;

class Constants
{
	public static final TRANSITION_SPEED:Float = .25;
	public static final TRANSITION_OVERLAYALPHA:Float = .3;

	public static var BAR_WIDTH(get, never):Int;
	public static var BAR_HEIGHT(get, never):Int;

	static function get_BAR_WIDTH():Int
		return Math.round(FlxG.width * 0.8);

	static function get_BAR_HEIGHT():Int
		return Math.round(FlxG.height * 0.05);

	public static final SPRITE_HOVER_BRIGHTNESSVAL:Float = 1.5;

	public static function setSpriteCT(sprite:FlxSprite, ctv:Float)
		sprite.setColorTransform(ctv, ctv, ctv);

	public static final ANTI_AUTOCLICK_VIOLATION_TICK:Int = 4;

	public static final ANTI_AUTOCLICK_MAX_VIOLATIONS:Float = 16.0;
	public static final ANTI_AUTOCLICK_MIN_VIOLATIONS:Float = 4.0;

	public static final SHOPITEM_BOUGHT_BRIGHTNESSVALOFFSET:Float = .75;

	public static final PASSEDSECONDS_INCREMENT:Float = .1;

	public static final FOLDER_SCREENSHOTS:String = 'screenshots';

	public static var AUDIO_AURORA_NOISES(get, never):Array<String>;

	static function get_AUDIO_AURORA_NOISES():Array<String>
	{
		return Assets.list().filter(p -> return p.startsWith('assets/auroranoises/'));
	}

	public static function playRandomAuroraNoise()
	{
		FlxG.sound.play(AUDIO_AURORA_NOISES[FlxG.random.int(0, AUDIO_AURORA_NOISES.length - 1)], .25);
	}

	public static var SPRITES_AURORA(get, never):Array<String>;

	static function get_SPRITES_AURORA():Array<String>
	{
		return Assets.list().filter(p -> return p.startsWith('assets/auroras/'));
	}

	public static function getRandomAuroraSprite()
	{
		return SPRITES_AURORA[FlxG.random.int(0, SPRITES_AURORA.length - 1)];
	}
}
