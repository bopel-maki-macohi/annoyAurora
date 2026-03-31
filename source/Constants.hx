import flixel.FlxSprite;
import flixel.FlxG;

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
	
	public static final SHOPITEM_BOUGHT_BRIGHTNESSVALOFFSET:Float = .25;

	public static final PASSEDSECONDS_INCREMENT:Float = .1;
}
