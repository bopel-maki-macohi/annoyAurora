import flixel.FlxG;

class Constants
{
	public static final TRANSITION_SPEED:Float = .5;
	public static final TRANSITION_OVERLAYALPHA:Float = .3;

	public static var BAR_WIDTH(get, never):Int;
	public static var BAR_HEIGHT(get, never):Int;

	static function get_BAR_WIDTH():Int
		return Math.round(FlxG.width * 0.8);

	static function get_BAR_HEIGHT():Int
		return Math.round(FlxG.width * 0.05);

	public static final SPRITE_HOVER_BRIGHTNESSVAL:Float = 1.5;
}
