import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;

class ShopSubState extends FlxSubState
{
	public var overlay:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);

	override function create()
	{
		super.create();

		add(overlay);
		overlay.alpha = 0;

		FlxTween.tween(overlay, {alpha: 1}, 1, {
			ease: FlxEase.sineInOut
		});
	}
}
