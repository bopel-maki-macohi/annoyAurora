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

	override public function new(item:String, ?x:Float, ?y:Float)
	{
		super(x, y, 'assets/shop/$item.png');
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.mouse.overlaps(this))
		{
			overlapUpdate.dispatch(this);

			Constants.setSpriteCT(this, Constants.SPRITE_HOVER_BRIGHTNESSVAL - ((bought) ? Constants.SHOPITEM_BOUGHT_BRIGHTNESSVALOFFSET : 0));

			if (FlxG.mouse.justPressed && !bought)
				onClick.dispatch(this);
		}
		else
		{
			nonoverlapUpdate.dispatch(this);

			Constants.setSpriteCT(this, 1 - ((bought) ? Constants.SHOPITEM_BOUGHT_BRIGHTNESSVALOFFSET : 0));
		}
	}
}
