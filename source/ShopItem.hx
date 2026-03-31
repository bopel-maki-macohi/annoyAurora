import flixel.FlxG;
import flixel.util.FlxColorTransformUtil;
import flixel.util.FlxSignal;
import flixel.FlxSprite;

class ShopItem extends FlxSprite
{
	public var onClick:FlxTypedSignal<ShopItem->Void> = new FlxTypedSignal<ShopItem->Void>();

	public var overlapUpdate:FlxTypedSignal<ShopItem->Void> = new FlxTypedSignal<ShopItem->Void>();
	public var nonoverlapUpdate:FlxTypedSignal<ShopItem->Void> = new FlxTypedSignal<ShopItem->Void>();

	public var bought:Bool = false;
	public var disabledWhenBought:Bool = true;

	override public function new(item:String, ?x:Float, ?y:Float)
	{
		super(x, y, 'assets/shop/$item.png');
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		final disabled:Bool = (bought && disabledWhenBought);
		final brightnessModif:Float = ((disabled) ? Constants.SHOPITEM_BOUGHT_BRIGHTNESSVALOFFSET : 0);

		if (FlxG.mouse.overlaps(this))
		{
			overlapUpdate.dispatch(this);

			Constants.setSpriteCT(this, Constants.SPRITE_HOVER_BRIGHTNESSVAL - brightnessModif);

			if (FlxG.mouse.justPressed && !disabled)
			{
				FlxG.sound.play('assets/shopItem.wav');
				onClick.dispatch(this);
			}
		}
		else
		{
			nonoverlapUpdate.dispatch(this);

			Constants.setSpriteCT(this, 1 - brightnessModif);
		}
	}
}
