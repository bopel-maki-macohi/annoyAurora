import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;

class ShopSubState extends FlxSubState
{
	public var shopBoard:FlxSprite = new FlxSprite(0, 0, 'assets/shopBoard.png');

	override function create()
	{
		super.create();

		closeCallback = onClose;

		add(shopBoard);
		shopBoard.screenCenter();
		shopBoard.x = FlxG.width + shopBoard.width;

		FlxTween.tween(shopBoard, {x: 48}, Constants.TRANSITION_SPEED, {
			ease: FlxEase.sineIn
		});
	}

	public function onClose()
	{
		FlxTween.tween(shopBoard, {x: FlxG.width + shopBoard.width}, Constants.TRANSITION_SPEED, {
			ease: FlxEase.sineOut,
			onComplete: function(t)
			{
				this.destroy();
			}
		});
	}
}
