package;

import flixel.util.FlxTimer;
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

	public var passedSeconds:Int = 0;
	public var secondsPasser:FlxTimer = new FlxTimer();

	public var clickTick:Int = 0;

	// Anti-autoClicker
	public var ticksSinceLastClick:Int = 0;
	public var lastAnnoyanceTick:Int = 0;
	public var autoClickFlags:Float = 1.0;

	override public function create()
	{
		super.create();

		secondsPasser.start(1, t ->
		{
			passedSeconds++;
		}, 0);

		FlxG.camera.bgColor = FlxColor.WHITE;

		FlxG.mouse.load('assets/cursor.png', 1, -32, -32);

		persistentDraw = true;
		persistentUpdate = true;

		SaveManager.instance = new SaveManager();
		FlxG.plugins.addIfUniqueType(SaveManager.instance);

		aurora.makeGraphic(256, 512, FlxColor.LIME);
		// aurora.makeGraphic(256, 512, FlxColor.RED);

		aurora.screenCenter();
		aurora.y = FlxG.height - aurora.height;

		auroraTickOffBar = new FlxBar(0, 10, LEFT_TO_RIGHT, Constants.BAR_WIDTH, Constants.BAR_HEIGHT, this, 'auroraTicked', 0, 100);
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

		for (field in ['clickTick', 'ticksSinceLastClick', 'autoClickFlags', 'lastAnnoyanceTick'])
		{
			FlxG.watch.addQuick(field, Reflect.field(this, field));
		}

		if (!transitioning)
		{
			clickTick++;
			ticksSinceLastClick = clickTick - lastAnnoyanceTick;

			auroraTicked = FlxMath.lerp(auroraTicked, 0, 1 / 32);

			if (autoClickFlags > 0)
				autoClickFlags -= 0.1;

			if (autoClickFlags < 0)
				autoClickFlags = 0;

			if (Math.round(autoClickFlags) >= Constants.ANTI_AUTOCLICK_MAX_VIOLATIONS)
				FlxG.switchState(() -> new AntiAutoClickState());

			if (FlxG.mouse.overlaps(aurora))
			{
				if (!FlxColorTransformUtil.hasRGBAMultipliers(aurora.colorTransform))
					Constants.setSpriteCT(aurora, Constants.SPRITE_HOVER_BRIGHTNESSVAL);

				if (FlxG.mouse.justPressed)
				{
					trace('ticksSinceLastClick: $ticksSinceLastClick');

					if (ticksSinceLastClick >= Constants.ANTI_AUTOCLICK_VIOLATION_TICK)
					{
						lastAnnoyanceTick = clickTick;
						addAuroraTick();
					}
					else
					{
						autoClickFlags += 1.0;
						trace(' | Flagged as auto-clicking (< ${Constants.ANTI_AUTOCLICK_VIOLATION_TICK}) : ${Math.round(autoClickFlags)}');
					}
				}
			}
			else
			{
				if (FlxColorTransformUtil.hasRGBAMultipliers(aurora.colorTransform))
					Constants.setSpriteCT(aurora, 1);
			}
		}

		if (FlxG.mouse.overlaps(shopBtn))
		{
			if (!FlxColorTransformUtil.hasRGBAMultipliers(shopBtn.colorTransform))
				Constants.setSpriteCT(shopBtn, Constants.SPRITE_HOVER_BRIGHTNESSVAL);

			if (FlxG.mouse.justPressed)
			{
				FlxG.sound.play('assets/uiClick.wav');

				if (!inShop)
				{
					inShop = true;
					openSubState(new ShopSubState());
				}
				else
					closeSubState();
			}
		}
		else
		{
			if (FlxColorTransformUtil.hasRGBAMultipliers(shopBtn.colorTransform))
				Constants.setSpriteCT(shopBtn, 1);
		}
	}

	override function openSubState(SubState:FlxSubState)
	{
		transitioning = true;
		secondsPasser.active = false;

		FlxTween.cancelTweensOf(transitionOverlay);
		FlxTween.tween(transitionOverlay, {alpha: Constants.TRANSITION_OVERLAYALPHA}, Constants.TRANSITION_SPEED, {
			ease: FlxEase.sineIn
		});

		if (inShop)
		{
			FlxTween.tween(shopBtn, {x: 0}, Constants.TRANSITION_SPEED, {
				ease: FlxEase.sineIn
			});
		}

		super.openSubState(SubState);
	}

	override function closeSubState()
	{
		transitioning = false;
		secondsPasser.active = true;

		FlxTween.cancelTweensOf(transitionOverlay);
		FlxTween.tween(transitionOverlay, {alpha: 0}, Constants.TRANSITION_SPEED, {
			ease: FlxEase.sineOut
		});

		if (inShop)
		{
			inShop = false;
			FlxTween.tween(shopBtn, {x: FlxG.width - shopBtn.width}, Constants.TRANSITION_SPEED * 0.25, {
				ease: FlxEase.sineOut
			});
		}

		super.closeSubState();
	}

	public function addAuroraTick()
	{
		if (SaveManager.hasItem('changeGender'))
			auroraTicked += FlxG.random.float(4, 6);

		auroraTicked += FlxG.random.float(2, 10);
	}
}
