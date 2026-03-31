import flixel.FlxObject;
import flixel.math.FlxPoint;
import flixel.FlxG;
import flixel.FlxBasic;

class MouseManager extends FlxBasic
{
	public static var instance:MouseManager;

	override public function new()
	{
		super();

		#if (MOBILE_BUILD && !MOBILE_TEST)
		FlxG.mouse.cursor.alpha = 1 / 100;
		#end
	}

	public function reset()
		setMouseAsset('regular', FlxPoint.get(-32, -32));

	public function hover()
		setMouseAsset('hover', FlxPoint.get(-32, -32));

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		FlxG.mouse.visible = visible;
	}

	var mouseAsset:String = '';

	public function setMouseAsset(asset:String, offsets:FlxPoint)
	{
		if (mouseAsset == asset)
			return;

		FlxG.mouse.load('assets/cursor/$asset.png', 1, Math.round(offsets.x), Math.round(offsets.y));
	}

	public function overlaps(obj:FlxObject)
	{
		final overlapz = FlxG.mouse.overlaps(obj);

		return overlapz;
	}

	public var x(get, never):Float;

	function get_x():Float
		return FlxG.mouse.x;

	public var y(get, never):Float;

	function get_y():Float
		return FlxG.mouse.y;

	public var justPressed(get, never):Bool;

	function get_justPressed():Bool
		return FlxG.mouse.justPressed;

	public var justReleased(get, never):Bool;

	function get_justReleased():Bool
		return FlxG.mouse.justReleased;
}
