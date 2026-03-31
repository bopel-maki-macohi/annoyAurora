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
	public var auroraTickOffBarMaxTarget:Float = 100;

	public var shopBtn:FlxSprite = new FlxSprite();
	public var inShop:Bool = false;

	public var transitioning:Bool = false;
	public var transitionOverlay:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);

	public var passedSeconds:Float = 0;
	public var secondsPasser:FlxTimer = new FlxTimer();

	public var clickTick:Int = 0;

	// Anti-autoClicker
	public var ticksSinceLastClick:Int = 0;
	public var lastAnnoyanceTick:Int = 0;
	public var autoClickFlags:Float = 1.0;

	override public function create()
	{
		super.create();

		passedSeconds = SaveManager.instance.passedSeconds;
		secondsPasser.start(Constants.PASSEDSECONDS_INCREMENT, t ->
		{
			passedSeconds += Constants.PASSEDSECONDS_INCREMENT;
			SaveManager.instance.passedSeconds = passedSeconds;
		}, 0);

		FlxG.camera.bgColor = FlxColor.WHITE;

		persistentDraw = true;
		persistentUpdate = true;

		// aurora.makeGraphic(256, 512, FlxColor.LIME);
		// aurora.makeGraphic(256, 512, FlxColor.RED);
		aurora.loadGraphic('assets/aurora.png');

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

	public function setAuroraScale(x:Float, y:Float)
	{
		aurora.scale.x = x;
		aurora.scale.y = y;
		aurora.updateHitbox();

		aurora.screenCenter();
		aurora.y = FlxG.height - aurora.height;
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		auroraTickOffBarMaxTarget = 100;

		if (SaveManager.hasItem('changeGender'))
			auroraTickOffBarMaxTarget += 50;
		if (SaveManager.hasItem('beer'))
			auroraTickOffBarMaxTarget += Math.round((100 * SaveManager.countBoughtItem('beer')) + SaveManager.instance.beerTicks * 1 / 60);

		auroraTickOffBar.setRange(0, FlxMath.lerp(auroraTickOffBar.max, auroraTickOffBarMaxTarget, .1));

		if (!transitioning)
		{
			if (SaveManager.instance.beerTicks > 0)
				SaveManager.instance.beerTicks -= 0.25;

			for (field in [
				'auroraTickOffBarMaxTarget',
				'clickTick',
				'ticksSinceLastClick',
				'autoClickFlags',
				'lastAnnoyanceTick'
			])
				FlxG.watch.addQuick(field, Reflect.field(this, field));

			setAuroraScale(FlxMath.lerp(aurora.scale.x, 1, 1 / 32), FlxMath.lerp(aurora.scale.y, 1, 1 / 32));

			clickTick++;
			ticksSinceLastClick = clickTick - lastAnnoyanceTick;

			auroraTicked = FlxMath.lerp(auroraTicked, 0, auroraTickedLerpRatio());

			if (autoClickFlags > 0)
				autoClickFlags -= 0.1;

			if (autoClickFlags < 0)
				autoClickFlags = 0;

			if (Math.round(autoClickFlags) >= Constants.ANTI_AUTOCLICK_MAX_VIOLATIONS)
				FlxG.switchState(() -> new AntiAutoClickState());

			if (FlxG.mouse.overlaps(aurora))
			{
				if (!FlxColorTransformUtil.hasRGBAMultipliers(aurora.colorTransform))
					Constants.setSpriteCT(aurora, Constants.SPRITE_HOVER_BRIGHTNESSVAL - .4);

				if (FlxG.mouse.justPressed)
				{
					trace('ticksSinceLastClick: $ticksSinceLastClick');

					if (ticksSinceLastClick >= Constants.ANTI_AUTOCLICK_VIOLATION_TICK)
					{
						lastAnnoyanceTick = clickTick;
						addAuroraTick();

						setAuroraScale(1.05, 0.95);
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

		if (SaveManager.hasItem('beer'))
			auroraTicked += FlxG.random.float(10, 15) * SaveManager.countBoughtItem('beer') + SaveManager.instance.beerTicks * 1 / 60;

		auroraTicked += FlxG.random.float(2, 10);
	}

	public function auroraTickedLerpRatio():Float
	{
		var denominator = 32;

		if (SaveManager.hasItem('changeGender'))
			denominator += 2;

		if (SaveManager.hasItem('beer'))
			denominator += 8;

		return 1 / denominator;
	}
}
