package;

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

	public var startTime:Date;

	override public function create()
	{
		super.create();

		startTime = Date.now();

		FlxG.camera.bgColor = FlxColor.WHITE;

		FlxG.mouse.load('assets/cursor.png', 1, -32, -32);

		aurora.makeGraphic(256, 512, FlxColor.LIME);

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

		add(aurora);
		add(shopBtn);
		add(auroraTickOffBar);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		auroraTicked = FlxMath.lerp(auroraTicked, 0, 1 / 32);

		if (FlxG.mouse.overlaps(aurora) && FlxG.mouse.justPressed)
		{
			auroraTicked += FlxG.random.float(2, 10);
		}
	}
}
