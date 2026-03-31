import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.text.FlxText;
import flixel.FlxState;

class AntiAutoClickState extends FlxState
{
	public var message:FlxText;

	override function create()
	{
		super.create();

		message = new FlxText(0, 0, 0, '', 16);
		add(message);

		message.text = 'Hey!'
			+ '\nThe game has flagged you for autoclicking a bit too much...'
			+ '\n\nYou\'re kinda just here now, so uhm,'
			+ '\nturn off your autoclicker, please.'
			+ '\n\nIf this was a false positive...'
			+ '\nI\'m impressed by your speed, and sorry :(';

        message.color = FlxColor.RED;
		message.alignment = CENTER;
		message.screenCenter();

        FlxG.sound.playMusic('assets/cheater.wav');
	}
}
