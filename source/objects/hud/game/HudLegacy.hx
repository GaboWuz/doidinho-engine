package objects.hud.game;

import flixel.math.FlxPoint;
import backend.song.Conductor;
import backend.song.Timings;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import objects.hud.HudClass.IconChange;
import states.PlayState;
import flixel.util.FlxStringUtil;

class HudLegacy extends HudClass
{
	public var infoTxt:FlxText;
	public var timeTxt:FlxText;
	
	var botplaySin:Float = 0;
	var botplayTxt:FlxText;
	var badScoreTxt:FlxText;

	// health bar
	public var healthBar:DoidoBar;
	public var vidar:FlxSprite;
	public var iconP1:HealthIcon;
	public var iconP2:HealthIcon;

	public function new()
	{
		super("doido");
		add(ratingGrp);
	
		healthBar = new DoidoBar("hud/base/bar_mas_sem_preto");
		add(healthBar);
	    healthBar.scale.set(0.65, 5.60);
	    healthBar.updateHitbox();
	
    	vidar = new FlxSprite(335, 0);
	    vidar.frames = Paths.getSparrowAtlas('hud/base/health_do_grau');
	    vidar.animation.addByPrefix('health', 'bah', 12, true);
	    vidar.animation.play('health');
	    vidar.scale.set(1.25, 1.25);
	    vidar.updateHitbox();
	    add(vidar);
		
		final SONG = PlayState.SONG;
		iconP1 = new HealthIcon();
		changeIcon(SONG.player1, PLAYER);
		add(iconP1);

		iconP2 = new HealthIcon();
		changeIcon(SONG.player2, ENEMY);
		add(iconP2);
		
		infoTxt = new FlxText(0, 0, 0, "hi there! i am using whatsapp");
		infoTxt.setFormat(Main.gFont, 20, 0xFFFFFFFF, CENTER);
		infoTxt.setBorderStyle(OUTLINE, FlxColor.BLACK, 1.5);
		add(infoTxt);
		
		timeTxt = new FlxText(0, 0, 0, "nuts / balls even");
		timeTxt.setFormat(Main.gFont, 32, 0xFFFFFFFF, CENTER);
		timeTxt.setBorderStyle(OUTLINE, FlxColor.BLACK, 1.5);
		enableTimeTxt(SaveData.data.get('Song Timer'));
		add(timeTxt);
		
		badScoreTxt = new FlxText(0,0,0,"SCORE WILL NOT BE SAVED");
		badScoreTxt.setFormat(Main.gFont, 26, 0xFFFF0000, CENTER);
		badScoreTxt.setBorderStyle(OUTLINE, FlxColor.BLACK, 1.5);
		badScoreTxt.screenCenter(X);
		badScoreTxt.visible = false;
		add(badScoreTxt);
		
		botplayTxt = new FlxText(0,0,0,"[BOTPLAY]");
		botplayTxt.setFormat(Main.gFont, 40, 0xFFFFFFFF, CENTER);
		botplayTxt.setBorderStyle(OUTLINE, FlxColor.BLACK, 1.5);
		botplayTxt.screenCenter();
		botplayTxt.visible = false;
		add(botplayTxt);
		

		updatePositions();
		for(i in [
			infoTxt,
			timeTxt,
			vidar,
			healthBar,
			iconP1,
			iconP2,
		])
			alphaList.push(i);
	}

	override function updateInfoTxt()
	{
		super.updateInfoTxt();
		infoTxt.text = "";
		
		infoTxt.text += 			'Score: '		+ Timings.score;
		infoTxt.text += separator + 'Misses: '		+ Timings.misses;
		infoTxt.text += separator + 'Accuracy: '	+ Timings.accuracy + "%" + ' [${Timings.getRank()}]';

		infoTxt.screenCenter(X);
	}
	
	override function updateTimeTxt()
	{
		super.updateTimeTxt();
		if(!timeTxt.visible) return;

		var hasMil:Bool = (SaveData.data.get('Song Timer Style') == "MIN'SEC\"MIL");
		switch(SaveData.data.get('Song Timer Info'))
		{
			case "ELAPSED TIME": 
				timeTxt.text = CoolUtil.posToTimer(songTime, hasMil);
			case "TIME LEFT":
				timeTxt.text = CoolUtil.posToTimer(PlayState.songLength - songTime, hasMil);
			case "FULL TIMER":
				timeTxt.text
				= CoolUtil.posToTimer(songTime, hasMil)
				+ ' / '
				+ CoolUtil.posToTimer(PlayState.songLength, hasMil);
		}
		
		timeTxt.screenCenter(X);
	}

	override function enableTimeTxt(enabled:Bool)
	{
		timeTxt.visible = enabled;
		updateTimeTxt();
	}

	public function updateIconPos()
	{	
		iconP1.y = (downscroll ? 100 - 70 : 100 + 450);
		iconP2.y = (downscroll ? 100 - 70 : 100 + 450);

		iconP1.x = 345 + 445;
		iconP2.x = 345;
	}

	override function updatePositions()
	{
		super.updatePositions();
		healthBar.x = (FlxG.width / 2) - (healthBar.border.width / 2) - 200;
		healthBar.y = (downscroll ? 70 - 57 : FlxG.height - healthBar.border.height - 50 - 118);
		vidar.y = (downscroll ? 100 - 70 : 100 + 450);
		
		updateInfoTxt();
		infoTxt.y = (downscroll ? healthBar.y + healthBar.border.height - 15 : healthBar.y + healthBar.border.height + 130);
		
		badScoreTxt.y = healthBar.y - badScoreTxt.height - 4;
		
		updateTimeTxt();
		timeTxt.y = downscroll ? (FlxG.height - timeTxt.height - 8) : (8);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		healthBar.percent = (health * 50);
		
		botplayTxt.visible = PlayState.botplay;
		badScoreTxt.visible = !PlayState.validScore;
		if(botplayTxt.visible)
		{
			botplaySin += elapsed * Math.PI;
			botplayTxt.alpha = 0.5 + Math.sin(botplaySin) * 0.8;
		}

		for(icon in [iconP1, iconP2])
		{
			icon.scale.set(
				FlxMath.lerp(icon.scale.x, 1, FlxG.elapsed * 6),
				FlxMath.lerp(icon.scale.y, 1, FlxG.elapsed * 6)
			);
			if(!icon.isPlayer)
				icon.setAnim(2 - health);
			else
				icon.setAnim(health);

			icon.updateHitbox();
		}
		updateIconPos();
	}

	override function addRating(rating:Rating)
    {
        super.addRating(rating);
		var daX:Float = (FlxG.width / 2);
		if(SaveData.data.get("Middlescroll"))
			daX -= FlxG.width / 4;

		rating.ratingScale = 0.7;
		rating.numberScale = 0.7;
		rating.setPos(daX, SaveData.data.get('Downscroll') ? FlxG.height - 100 : 100);
		rating.playRating();
    }

	override function changeIcon(newIcon:String = "face", type:IconChange = ENEMY)
	{
		super.changeIcon(newIcon, type);
		var isPlayer:Bool = (type == PLAYER);
		var icon = (isPlayer ? iconP1 : iconP2);
		icon.setIcon(newIcon, isPlayer);

		(isPlayer ? healthBar.sideR : healthBar.sideL).color = HealthIcon.getColor(newIcon);
	}

	override function beatHit(curBeat:Int = 0)
	{
		super.beatHit(curBeat);
		for(icon in [iconP1, iconP2])
		{
			icon.scale.set(1.2, 1.2);
			icon.updateHitbox();
			updateIconPos();
		}
	}
}