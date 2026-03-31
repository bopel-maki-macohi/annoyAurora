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

		closeCallback = onClose;

		add(shopBoard);
		shopBoard.screenCenter();
		shopBoard.x = FlxG.width + shopBoard.width;

		add(shopItems);

		var changeGender:ShopItem = new ShopItem('changeGender', SaveManager.hasItem('changeGener'), 10, 10);
		changeGender.overlapUpdate.add(() -> setSIText('Change Gender'));
		changeGender.onClick.add(function()
		{
			if (!SaveManager.hasItem('changeGener'))
			{
				SaveManager.buyItem('changeGender');
				changeGender.bought = true;
			}
		});
		shopItems.add(changeGender);

		FlxTween.tween(shopBoard, {x: 48}, Constants.TRANSITION_SPEED, {
			ease: FlxEase.sineIn
		});

		shopItemText.size = 16;
		shopItemText.setBorderStyle(OUTLINE, FlxColor.BLACK, 2);
		add(shopItemText);
	}

	public function onClose()
	{
		FlxTween.tween(shopBoard, {x: FlxG.width + shopBoard.width}, Constants.TRANSITION_SPEED, {
			ease: FlxEase.sineOut,
			onComplete: function(t)
			{
				this.destroy();
			}
		});
	}

	override function update(elapsed:Float)
	{
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
}
