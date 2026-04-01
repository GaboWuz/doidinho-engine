package objects.hud;

import flixel.FlxSprite;
import flixel.util.FlxColor;
import backend.utils.CharacterUtil;

class HealthIcon extends FlxSprite
{
	public function new()
	{
		super();
	}

	public var isPlayer:Bool = false;
	public var curIcon:String = "";
	public var maxFrames:Int = 0;

	public function setIcon(curIcon:String = "face", isPlayer:Bool = false):HealthIcon
	{
		this.curIcon = curIcon;
		if(!Paths.fileExists('images/icons/icon-${curIcon}.png'))
		{
			if(curIcon.contains('-'))
				return setIcon(CharacterUtil.formatChar(curIcon), isPlayer);
			else
				return setIcon("face", isPlayer);
		}

		var iconGraphic = Paths.image("icons/icon-" + curIcon);

		maxFrames = Math.floor(iconGraphic.width / 150);

		loadGraphic(iconGraphic, true, Math.floor(iconGraphic.width / maxFrames), iconGraphic.height);

		antialiasing = FlxSprite.defaultAntialiasing;
		isPixelSprite = false;
		if(curIcon.contains('pixel'))
		{
			antialiasing = false;
			isPixelSprite = true;
		}

		animation.add("icon", [for(i in 0...maxFrames) i], 0, false);
		animation.play("icon");

		this.isPlayer = isPlayer;
		flipX = isPlayer;

		return this;
	}

	public function setAnim(health:Float = 1)
	{
		health /= 2;
		var daFrame:Int = 0;

		if(health < 0.3)
			daFrame = 1;

		if(health > 0.7)
			daFrame = 2;

		if(daFrame >= maxFrames)
			daFrame = 0;

		animation.curAnim.curFrame = daFrame;
	}

	public static function getColor(char:String = ""):FlxColor
	{
		var colorMap:Map<String, FlxColor> = [
			"face" 		=> 0xFFA1A1A1,
			"bf" 		=> 0xFF73BCE8,
			"bf-old"	=> 0xFFE9FF48,
			"bf-cool"	=> 0xFF5FB6F1,
			"gf"		=> 0xFFA5004D,
			"dad"		=> 0xFFAF66CE,
			// do mod legacy
			"gabos"		=> 0xFF8249FA,
			"faker"		=> 0xFFB9B1EF,
			// do mod
			"gabo"		=> 0xFF8668FF,
			"luka"		=> 0xFFE45D9E,
			"boof"		=> 0xFF78ACE1,
			// primeiro de abril
			"susbo"		=> 0xFF8F83E1,
			"kyzu"		=> 0xFFEAE7FF,
			"gagbis"		=> 0xFF8F83E1,
			"mortonaofala"		=> 0xFFEAE7FF,
		];

		function loopMap()
		{
			if(!colorMap.exists(char))
			{
				if(char.contains('-'))
				{
					char = CharacterUtil.formatChar(char);
					loopMap();
				}
				else
					char = "face";
			}
		}
		loopMap();

		return colorMap.get(char);
	}
}
