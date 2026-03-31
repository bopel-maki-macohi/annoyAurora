import flixel.FlxG;
import flixel.util.FlxColorTransformUtil;
import flixel.util.FlxSignal;
import flixel.FlxSprite;

class ShopItem extends FlxSprite
{
	public var onClick:FlxSignal = new FlxSignal();

	public var overlapUpdate:FlxSignal = new FlxSignal();
	public var nonoverlapUpdate:FlxSignal = new FlxSignal();

	public var bought:Bool = false;

	override public function new(item:String, bought:Bool, ?x:Float, ?y:Float)
	{
		super(x, y, 'assets/shop/$item.png');

		this.bought = bought;
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.mouse.overlaps(this))
		{
			overlapUpdate.dispatch();

			if (!FlxColorTransformUtil.hasRGBAMultipliers(colorTransform))
				Constants.setSpriteCT(this, Constants.SPRITE_HOVER_BRIGHTNESSVAL - ((bought) ? Constants.SPRITE_HOVER_BRIGHTNESSVAL : 0));

			if (FlxG.mouse.justPressed && !bought)
				onClick.dispatch();
		}
		else
		{
			nonoverlapUpdate.dispatch();

			if (FlxColorTransformUtil.hasRGBAMultipliers(colorTransform))
				Constants.setSpriteCT(this, 1 - ((bought) ? Constants.SPRITE_HOVER_BRIGHTNESSVAL : 0));
		}
	}
}
