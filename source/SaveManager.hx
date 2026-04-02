import flixel.util.FlxSave;
import lime.app.Application;
import flixel.FlxG;
import flixel.FlxBasic;

class SaveManager extends FlxBasic
{
	public static var legacySave:FlxSave = new FlxSave();

	public static var instance:SaveManager = null;

	public static var saveSuffix(default, set):String = '';

	static function set_saveSuffix(newSS:String):String
	{
		if (instance == null)
		{
			legacySave.data.saveSuffix = saveSuffix;
			return saveSuffix;
		}

		legacySave.data.saveSuffix = newSS;
		instance.loadSave(newSS);
		return newSS;
	}

	public var boughtItems:Array<String> = [];
	public var beerTicks:Float = 0;
	public var passedSeconds:Float = 0;
	public var endings:Array<String> = [];
	public var auroraTolerance:Float = 0;

	override public function new()
	{
		super();
	}

	public function loadSave(saveSuffix:String)
	{
		if (saveSuffix.length == 0 || saveSuffix == null)
		{
			trace('Blank save suffix... wtf?');
			FlxG.save.bind('AnnoyAurora', 'Maki');
		}
		else
			FlxG.save.bind('AnnoyAurora-$saveSuffix', 'Maki');

		#if !CLEAR_SAVE
		loadData();
		#end
	}

	public function save()
	{
		saveData();

		FlxG.save.flush();
	}

	public function loadData()
	{
		saveFieldFunction(f ->
		{
			final saveField = Reflect.field(FlxG.save.data, f);

			if (saveField != null)
				Reflect.setField(this, f, saveField);
		});

		trace('Loaded savedata: ${FlxG.save.data}');
	}

	public function saveData()
	{
		saveFieldFunction(f ->
		{
			Reflect.setField(FlxG.save.data, f, Reflect.field(this, f));
		});

		trace('Saved savedata: ${FlxG.save.data}');
	}

	public function saveFieldFunction(f:String->Void)
	{
		for (field in [
			'boughtItems',
			'beerTicks',
			'passedSeconds',
			'endings',
			'auroraTolerance',
			'lastVersion'
		])
			f(field);
	}

	public static function newGame()
	{
		if (instance == null)
			return;

		instance.boughtItems = [];
		instance.beerTicks = 0;
		instance.passedSeconds = 0;
		instance.auroraTolerance = 0;
	}

	public static function getEnding(ending:String)
	{
		if (instance == null)
			return;

		instance.endings.push(ending);
	}

	public static function hasEnding(ending:String):Bool
	{
		if (instance == null)
			return false;

		return instance.endings.contains(ending);
	}

	public static function sellItem(item:String)
	{
		if (instance == null)
			return;

		instance.boughtItems.remove(item);
	}

	public static function hasItem(item:String):Bool
		return countBoughtItem(item) > 0;

	public static function countBoughtItem(item:String):Int
	{
		if (instance == null)
			return 0;

		if (!instance.boughtItems.contains(item))
			return 0;
		else
			return instance.boughtItems.filter(f -> return f == item).length;
	}

	public static function buyItem(item:String)
	{
		if (instance == null)
			return;

		instance.boughtItems.push(item);
	}
}
