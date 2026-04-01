import flixel.FlxG;
import flixel.text.FlxText;
import flixel.FlxSprite;
import flixel.FlxState;

using StringTools;

class WinState extends FlxState
{
	public var sprite:FlxSprite = new FlxSprite();

	public var text:FlxText = new FlxText();

	public var earnedIt:Bool = false;

	override public function new(earnedIt:Bool)
	{
		super();

		this.earnedIt = earnedIt;
	}

	override function create()
	{
		super.create();

		var ending:String = 'normal';

		function winstateDefineRandom():Bool
		{
			#if WINSTATE
			return FlxG.random.bool();
			#end

			return false;
		}

		if (SaveManager.hasItem('beer') || winstateDefineRandom())
			ending = 'drunk';

		if (SaveManager.hasItem('bonkingBat') || winstateDefineRandom())
			ending = 'abuse';

		if (SaveManager.hasItem('deage') || winstateDefineRandom())
		{
			ending = 'young';

			if (SaveManager.hasItem('beer') || winstateDefineRandom())
				ending += '-drunk';
		}

		if (SaveManager.hasItem('changeGender') || winstateDefineRandom())
			if (ending == 'normal')
				ending = 'female';
			else
				ending += '-female';

		if (ending.startsWith('young') && !ending.contains('-drunk'))
			if (!SaveManager.hasEnding('young') && !SaveManager.hasEnding('young-female'))
				if (!SaveManager.hasEnding('young-drunk') && !SaveManager.hasEnding('young-drunk-female'))
				{
					if (!SaveManager.hasEnding('young-first') && !SaveManager.hasEnding('young-female-first'))
						ending += '-first';
				}
				else
					ending += '-thehardway';

		sprite.loadGraphic('assets/endings/$ending.png');
		add(sprite);

		text.size = 16;

		text.text = 'Congrats!\nYou won in ${SaveManager.instance.passedSeconds} seconds!\n\n';
		switch (ending)
		{
			case 'young-drunk':
				text.text += '<aurora>"I hate how touchy you are when drunk..."<aurora>';
			case 'young-drunk-female':
				text.text += '<aurora>"I HATE how touchy you are when drunk..."<aurora>';

			case 'young-first', 'young-female-first':
				text.text += 'Does this count as a good ending? She can\'t do anything...';

			case 'young-thehardway', 'young-female-thehardway':
				text.text += 'I think you made it worse...';
				sprite.loadGraphic('assets/endings/${ending.replace('-thehardway', '')}.png');

			case 'young', 'young-female':
				text.text += 'SHE\'S FERAL NOW';

			case 'abuse-female':
				sprite.scale.set(.5, .5);
				sprite.updateHitbox();

				if (FlxG.random.bool(15))
				{
					sprite.y += sprite.height / 12;
					text.text += 'In the nicest way possible.\nI wish you die single.';
				}
				else if (FlxG.random.bool(8))
					text.text += 'I wish you a miscarriage.';
				else if (FlxG.random.bool(1))
					text.text += '<nicom>"Ow."<nicom>';
				else
				{
					if (SaveManager.hasEnding('drunk') && SaveManager.hasItem('beer'))
						text.text += 'GIRL. I WAS JOKIN\'.\nWHAT THE FUCK';
					else
						text.text += 'Girl you got problems.';
				}

			case 'abuse':
				sprite.scale.set(.5, .5);
				sprite.updateHitbox();

				if (SaveManager.hasEnding('drunk') && SaveManager.hasItem('beer'))
					text.text += 'I WAS JOKING DUDE. WHAT THE FUCK';
				else
					text.text += 'You are the reason searching up\n"My boyfriend is abusing me"\nleads to a hotline on google.';

			case 'female':
				text.text += 'You are now an asshole transgender.';

			case 'drunk-female':
				text.text += 'You are now a drunk transgender jerk.';

			case 'drunk':
				text.text += 'You are now another drunk asshole boyfriend that no one likes.';

			default:
				text.text += 'You\'re... kinda just an asshole now...';
		}

		text.text += '\n\nPress ENTER (or press the screen) it to do it again';

		var notajerk = [
			'young',
			'young-female',

			'young-thehardway',
			'young-female-thehardway',

			'young-first',
			'young-female-first',
		];

		if (!notajerk.contains(ending))
			text.text += ', you jerk';
		text.text += '.';

		if (!earnedIt)
			text.text += '\nAnd this time, don\'t cheat.';

		sprite.screenCenter();
		sprite.y += sprite.height / 4;

		add(text);
		text.alignment = CENTER;
		text.screenCenter();
		text.y = 10;

		text.applyMarkup(text.text, [
			new FlxTextFormatMarkerPair(new FlxTextFormat(0x32825E), '<nicom>'),
			new FlxTextFormatMarkerPair(new FlxTextFormat(0x63FFBA), '<aurora>'),
		]);

		if (!SaveManager.hasEnding(ending) && earnedIt)
			SaveManager.getEnding(ending);

		MouseManager.instance.visible = false;

		SaveManager.newGame();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.keys.justReleased.ENTER || MouseManager.instance.justPressed)
			FlxG.switchState(() -> new PlayState());
	}
}
