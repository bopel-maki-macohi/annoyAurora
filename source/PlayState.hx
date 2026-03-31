package;

import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.FlxSubState;
import flixel.util.FlxColorTransformUtil;
import flixel.ui.FlxBar;
import flixel.math.FlxMath;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;

class PlayState extends FlxState
{
	public var aurora:FlxSprite = new FlxSprite();
	public var auroraTicked:Float = 0.0;
	public var auroraTickOffBar:FlxBar;

	public var shopBtn:FlxSprite = new FlxSprite();
	public var inShop:Bool = false;

	public var transitioning:Bool = false;
	public var transitionOverlay:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);

	public var startTime:Date;

	override public function create()
	{
		super.create();

		startTime = Date.now();

		FlxG.camera.bgColor = FlxColor.WHITE;

		FlxG.mouse.load('assets/cursor.png', 1, -32, -32);

		persistentDraw = true;
		persistentUpdate = true;

		aurora.makeGraphic(256, 512, FlxColor.LIME);
		// aurora.makeGraphic(256, 512, FlxColor.RED);

		aurora.screenCenter();
		aurora.y = FlxG.height - aurora.height;

		final barWidth = Math.round(FlxG.width * 0.8);
		final barHeight = Math.round(FlxG.height * 0.05);

		auroraTickOffBar = new FlxBar(0, 10, LEFT_TO_RIGHT, barWidth, barHeight, this, 'auroraTicked', 0, 100);
		auroraTickOffBar.screenCenter(X);
		auroraTickOffBar.createFilledBar(FlxColor.RED, FlxColor.LIME, true, FlxColor.BLACK, 4);

		shopBtn = new FlxSprite(0, 0, 'assets/menuBTN-right.png');
		shopBtn.screenCenter();
		shopBtn.x = FlxG.width - shopBtn.width;

		transitionOverlay.alpha = 0;
		transitionOverlay.screenCenter();

		add(aurora);
		add(auroraTickOffBar);

		add(transitionOverlay);

		add(shopBtn);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		if (!transitioning)
		{
			auroraTicked = FlxMath.lerp(auroraTicked, 0, 1 / 32);

			if (FlxG.mouse.overlaps(aurora))
			{
				if (!FlxColorTransformUtil.hasRGBAMultipliers(aurora.colorTransform))
					aurora.setColorTransform(1.5, 1.5, 1.5);

				if (FlxG.mouse.justPressed)
					auroraTicked += FlxG.random.float(2, 10);
			}
			else
			{
				if (FlxColorTransformUtil.hasRGBAMultipliers(aurora.colorTransform))
					aurora.setColorTransform(1, 1, 1);
			}
		}

		if (FlxG.mouse.overlaps(shopBtn))
		{
			if (!FlxColorTransformUtil.hasRGBAMultipliers(shopBtn.colorTransform))
				shopBtn.setColorTransform(1.5, 1.5, 1.5);

			if (FlxG.mouse.justPressed)
			{
				if (!inShop)
				{
					inShop = true;
					openSubState(new ShopSubState());
				}
				else
				{
					closeSubState();
				}
			}
		}
		else
		{
			if (FlxColorTransformUtil.hasRGBAMultipliers(shopBtn.colorTransform))
				shopBtn.setColorTransform(1, 1, 1);
		}
	}

	override function openSubState(SubState:FlxSubState)
	{
		transitioning = true;

		FlxTween.cancelTweensOf(transitionOverlay);
		FlxTween.tween(transitionOverlay, {alpha: 1}, 1, {
			ease: FlxEase.sineInOut
		});

		if (inShop)
		{
			FlxTween.tween(shopBtn, {x: 0}, 1);
		}

		super.openSubState(SubState);
	}

	override function closeSubState()
	{
		transitioning = false;

		FlxTween.cancelTweensOf(transitionOverlay);
		FlxTween.tween(transitionOverlay, {alpha: 0.6}, 1, {
			ease: FlxEase.sineInOut
		});

		if (inShop)
		{
			inShop = false;
			FlxTween.tween(shopBtn, {x: FlxG.width - shopBtn.width}, 1);
		}

		super.closeSubState();
	}
}
