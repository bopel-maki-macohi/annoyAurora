import flixel.util.FlxSave;
import lime.app.Application;
import flixel.FlxG;
import flixel.FlxBasic;

class SaveManager extends FlxBasic
{
	public static var dataSave:FlxSave = new FlxSave();

	public static var instance:SaveManager = null;

	public static var saveSuffix(default, set):String = '';

	static function set_saveSuffix(newSS:String):String
	{
		if (instance == null)
		{
			dataSave.data.saveSuffix = saveSuffix;
			return saveSuffix;
		}

		dataSave.data.saveSuffix = newSS;
		instance.loadSave(newSS);
		return newSS;
	}

	public var boughtItems:Array<String> = [];
	public var beerTicks:Float = 0;
	public var passedSeconds:Float = 0;
	public var endings:Array<String> = [];
	public var auroraTolerance:Float = 0;

	public var saveName:String = '';

	override public function new()
	{
		super();
	}

	public function loadSave(saveSuffix:String)
	{
		saveName = 'AnnoyAurora';
		if (saveSuffix.length == 0 || saveSuffix == null)
			trace('Blank save suffix... wtf?');
		else
			saveName += '-$saveSuffix';

		#if !CLEAR_SAVE
		loadData();
		#end
	}

	public function save()
	{
		saveData();

		SaveManager.dataSave.flush();
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

		trace('Loaded savedata from "$saveName": ${FlxG.save.data}');
	}

	public function saveData()
	{
		saveFieldFunction(f ->
		{
			Reflect.setField(FlxG.save.data, f, Reflect.field(this, f));
		});

		if (saveName.length > 0 && saveName != null)
			trace('Saved savedata to "$saveName": ${FlxG.save.data}');
	}

	public function saveFieldFunction(f:String->Void)
	{
		for (field in ['boughtItems', 'beerTicks', 'passedSeconds', 'endings', 'auroraTolerance'])
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
