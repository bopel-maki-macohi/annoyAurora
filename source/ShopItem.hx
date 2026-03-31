import flixel.FlxG;
import flixel.util.FlxColorTransformUtil;
import flixel.util.FlxSignal;
import flixel.FlxSprite;

class ShopItem extends FlxSprite
{
	public var onClick:FlxSignal = new FlxSignal();
	
	public var overlapUpdate:FlxSignal = new FlxSignal();
	public var nonoverlapUpdate:FlxSignal = new FlxSignal();

	override public function new(item:String, ?x:Float, ?y:Float)
	{
		super(x, y, 'assets/shop/$item.png');
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.mouse.overlaps(this))
		{
			overlapUpdate.dispatch();

			if (!FlxColorTransformUtil.hasRGBAMultipliers(colorTransform))
				Constants.setSpriteCT(this, Constants.SPRITE_HOVER_BRIGHTNESSVAL);

			if (FlxG.mouse.justPressed)
				onClick.dispatch();
		}
		else
		{
			nonoverlapUpdate.dispatch();

			if (FlxColorTransformUtil.hasRGBAMultipliers(colorTransform))
				Constants.setSpriteCT(this, 1);
		}
	}
}
