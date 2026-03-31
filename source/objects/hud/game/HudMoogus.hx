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
import objects.hud.HealthIcon;
import states.PlayState;
import flixel.util.FlxStringUtil;

class HudMoogus extends HudClass
{
	public var infoTxt:FlxText;
	public var timeTxt:FlxText;
	
	var botplaySin:Float = 0;
	var botplayTxt:FlxText;
	var badScoreTxt:FlxText;

	// health bar
	public var healthBar:DoidoBar;
	public var iconP1:HealthIcon;
	public var iconP2:HealthIcon;
	
	// time bar
	var timer1:FlxSprite;
	var timer2:FlxSprite;
	var timer3:FlxSprite;
	var timer4:FlxSprite;
	var songNameTxt:FlxText;

	public function new()
	{
		super("moogus");
		add(ratingGrp);
		healthBar = new DoidoBar("hud/base/healthBar", "hud/base/healthBarBorder");
		add(healthBar);
		
		final SONG = PlayState.SONG;
		iconP1 = new HealthIcon();
		changeIcon(SONG.player1, PLAYER);
		add(iconP1);

		iconP2 = new HealthIcon();
		changeIcon(SONG.player2, ENEMY);
		add(iconP2);
		
		infoTxt = new FlxText(0, 0, 0, "hi there! i am using whatsapp");
		infoTxt.setFormat(Main.gFont, 20, HealthIcon.getColor("susbo"), CENTER);
		infoTxt.setBorderStyle(OUTLINE, FlxColor.BLACK, 1.5);
		add(infoTxt);
		
		timeTxt = new FlxText(0, 0, 0, "nuts / balls even");
		timeTxt.setFormat(Main.gFont, 32, 0xFFFFFFFF, CENTER);
		timeTxt.setBorderStyle(OUTLINE, FlxColor.BLACK, 1.5);
		enableTimeTxt(SaveData.data.get('Song Timer'));
		add(timeTxt);
		
		var yOffset:Float = downscroll ? 670 : 0; 
		
		timer1 = new FlxSprite(118.5, 22.5 + yOffset).loadGraphic(Paths.image('hud/gagbo/timer/1'));
		timer2 = new FlxSprite(115, 20 + yOffset).loadGraphic(Paths.image('hud/gagbo/timer/2'));
		timer3 = new FlxSprite(122, 24.25 + yOffset).loadGraphic(Paths.image('hud/gagbo/timer/3'));
		timer4 = new FlxSprite(122, 24.25 + yOffset).loadGraphic(Paths.image('hud/gagbo/timer/4'));
		
		songNameTxt = new FlxText(124, 19.3 + yOffset, 0, PlayState.SONG.song, 15);
		songNameTxt.alignment = LEFT;
		
		timer1.scale.set(1.185, 0.045);
		timer1.updateHitbox();
		
		timer2.scale.set(1.21, 0.065);
		timer2.updateHitbox();
		
		timer3.scale.set(1.165, 0.035);
		timer3.updateHitbox();
		
		timer4.scale.set(1.165, 0.035);
		timer4.updateHitbox();

		add(timer2);
		add(timer1);
		add(timer4);
		add(timer3);
		add(songNameTxt);
		
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
		
		infoTxt.text += 			'Score: '		+ FlxStringUtil.formatMoney(Timings.score, false, true);
		infoTxt.text += separator + 'Accuracy: '	+ Timings.accuracy + "%" + ' [${Timings.getRank()}]';
		infoTxt.text += separator + 'Misses: '		+ Timings.misses;

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
		var healthBarPos = FlxPoint.get(
			healthBar.x + FlxMath.lerp(healthBar.border.width, 0, healthBar.percent / 100),
			healthBar.y - (healthBar.border.height / 2)
		);

		iconP1.y = healthBarPos.y - (iconP1.height / 2);
		iconP2.y = healthBarPos.y - (iconP2.height / 2);

		iconP1.x = healthBarPos.x - 20;
		iconP2.x = healthBarPos.x - iconP2.width + 32;
	}

	override function updatePositions()
	{
		super.updatePositions();
		healthBar.x = (FlxG.width / 2) - (healthBar.border.width / 2);
		healthBar.y = (downscroll ? 70 : FlxG.height - healthBar.border.height - 50);
		
		updateInfoTxt();
		infoTxt.y = healthBar.y + healthBar.border.height + 4;
		
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
		
		timeTxt.visible = false;
		
		var songPercent:Float = Conductor.songPos / PlayState.songLength - 0.02;
		
		timer3.scale.set(1.168 * songPercent, 0.035);
		timer3.updateHitbox();
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
		if(curBeat % 2 == 0)
		{
			for(icon in [iconP1, iconP2])
			{
				icon.scale.set(1.3,1.3);
				icon.updateHitbox();
				updateIconPos();
			}
		}
	}
}