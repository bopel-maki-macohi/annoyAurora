import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.text.FlxText;
import flixel.FlxState;

class AntiAutoClickState extends FlxState
{
	public var message:FlxText;

	public var almostWon:Bool = false;

	override public function new(almostWon = false)
	{
		super();

		this.almostWon = almostWon;
	}

	override function create()
	{
		super.create();

		message = new FlxText(0, 0, 0, '', 16);
		add(message);

		if (!almostWon)
			message.text = 'Hey!' + '\nThe game has flagged you for autoclicking a bit too much...' + '\n\nYou\'re kinda just here now, so uhm,'
		else
			message.text = 'Hey!'
				+ '\nThought you were slick didn\'t you?'
				+ '\n\nHeheh, nope. I still caught you using an autoclicker >:>'
				+ '\n\nSo uh...';

		message.text += '\nturn off your autoclicker, please.' + '\n\nIf this was a false positive...' + '\nI\'m impressed by your speed, and sorry :(';

		message.color = FlxColor.RED;
		message.alignment = CENTER;
		message.screenCenter();

		FlxG.sound.playMusic('assets/cheater.wav');

		MouseManager.instance.visible = false;
	}
}
