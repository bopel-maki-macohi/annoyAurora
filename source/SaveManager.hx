import lime.app.Application;
import flixel.FlxG;
import flixel.FlxBasic;

class SaveManager extends FlxBasic
{
	public static var instance:SaveManager = null;

	public var boughtItems:Array<String> = [];

	public var beerTicks:Float = 0;

	public var passedSeconds:Float = 0;

	override public function new()
	{
		super();

		FlxG.save.bind('AnnoyAurora', 'Maki');

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

			switch (f)
			{
				default:
					if (saveField != null) Reflect.setField(this, f, saveField);
			}
		});

		trace('Loaded savedata: ${FlxG.save.data}');
	}

	public function saveData()
	{
		saveFieldFunction(f ->
		{
			switch (f)
			{
				default:
					Reflect.setField(FlxG.save.data, f, Reflect.field(this, f));
			}
		});

		trace('Saved savedata: ${FlxG.save.data}');
	}

	public function saveFieldFunction(f:String->Void)
	{
		for (field in ['boughtItems', 'beerTicks', 'passedSeconds'])
			f(field);
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
