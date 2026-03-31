import flixel.util.FlxColor;
import flixel.text.FlxText;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;

class ShopSubState extends FlxSubState
{
	public var shopBoard:FlxSprite = new FlxSprite(0, 0, 'assets/shopBoard.png');

	public var shopItems:FlxTypedSpriteGroup<ShopItem> = new FlxTypedSpriteGroup<ShopItem>();

	public var shopItemText:FlxText = new FlxText();

	override function create()
	{
		super.create();

		add(shopBoard);
		shopBoard.screenCenter();
		shopBoard.x = FlxG.width + shopBoard.width;

		add(shopItems);

		addItems();

		shopItemText.size = 16;
		shopItemText.setBorderStyle(OUTLINE, FlxColor.BLACK, 2);
		add(shopItemText);
	}

	override function update(elapsed:Float)
	{
		shopBoard.x = PlayState.shopBtn.x + PlayState.shopBtn.width;

		setSIText('');

		super.update(elapsed);

		shopItems.x = shopBoard.x + 20;
		shopItems.y = shopBoard.y + 20;

		shopItemText.x = (FlxG.mouse.x + 20);

		if (shopItemText.x + shopItemText.width > FlxG.width)
			shopItemText.x -= 40 + shopItemText.width;

		shopItemText.y = (FlxG.mouse.y - 40);

		if (shopItemText.y + shopItemText.height < (shopItemText.height / 2))
			shopItemText.y += 60 + shopItemText.height;
	}

	public function setSIText(text:String)
	{
		shopItemText.text = text;
	}

	public function addItems()
	{
		var changeGender:ShopItem = new ShopItem('changeGender', 10, 10);
		changeGender.overlapUpdate.add(item -> setSIText('Change Gender to: ' + ((item.bought) ? 'Male' : 'Female')));
		changeGender.onClick.add(function(item)
		{
			if (!SaveManager.hasItem('changeGender'))
			{
				SaveManager.buyItem('changeGender');
				item.bought = true;
			}
			else
			{
				SaveManager.sellItem('changeGender');
				item.bought = false;
			}
		});
		changeGender.bought = SaveManager.hasItem('changeGender');
		changeGender.disabledWhenBought = false;
		shopItems.add(changeGender);

		var beer:ShopItem = new ShopItem('beer', changeGender.x + (changeGender.width * 2), changeGender.y);
		beer.overlapUpdate.add(item -> setSIText('BEER! (${2 - SaveManager.countBoughtItem('beer')} left in stock)'));
		beer.onClick.add(function(item)
		{
			if (SaveManager.countBoughtItem('beer') < 2)
			{
				SaveManager.instance.beerTicks += 300;
				SaveManager.buyItem('beer');
				item.bought = SaveManager.countBoughtItem('beer') >= 2;
			}
		});
		beer.bought = SaveManager.hasItem('beer');
		shopItems.add(beer);
	}
}
