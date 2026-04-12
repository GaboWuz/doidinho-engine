package states.menu;

import flixel.FlxSprite;
import flixel.FlxObject;
import flixel.group.FlxGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.addons.display.FlxBackdrop;
import flixel.util.FlxAxes;
import flixel.util.FlxTimer;
import flixel.util.FlxColor;
import backend.song.Highscore;
import backend.song.Highscore.ScoreData;
import backend.song.SongData;
import objects.menu.AlphabetMenu;
import objects.hud.HealthIcon;
import states.*;
import states.editors.ChartingState;
import subStates.menu.DeleteScoreSubState;
import backend.song.Timings;
import flixel.util.FlxStringUtil;

using StringTools;

typedef FreeplaySong = {
	var name:String;
	var icon:String;
	var diffs:Array<String>;
	var color:FlxColor;
}
class FreeplayState extends MusicBeatState
{
	var songList:Array<FreeplaySong> = [];
	
	function addSong(name:String, icon:String, diffs:Array<String>)
	{
		songList.push({
			name: name,
			icon: icon,
			diffs: diffs,
			color: HealthIcon.getColor(icon),
		});
	}

	static var curSelected:Int = 0;
	static var curDiff:Int = 1;

	var bg:FlxSprite;
	var bgTween:FlxTween;
	var ohTween:FlxTween;
	var dohTween:FlxTween;
	var grpItems:FlxGroup;
	
	var ponto:FlxBackdrop;
	var oh:FlxBackdrop;
	var doh:FlxBackdrop;
	var freet:FlxSprite;
	
	var fuck:String = 'menu/freeplay/';
	var issoai:String = '';

	var scoreCounter:ScoreCounter;

	override function create()
	{
		super.create();
		CoolUtil.playMusic("mainmenu");
		
		FlxG.mouse.visible = false;

		DiscordIO.changePresence("Freeplay - Choosin' a track");

		bg = new FlxSprite().loadGraphic(Paths.image('menu/backgrounds/menuDesat'));
		bg.scale.set(1.2,1.2); bg.updateHitbox();
		bg.alpha = 0.65;
		bg.screenCenter();
		add(bg);
		
		ponto = new FlxBackdrop(Paths.image(fuck + 'backdrd'), FlxAxes.XY, 0, 0);
		ponto.setGraphicSize(Std.int(ponto.height * 1.2));
		ponto.velocity.set(20, 20);
		add(ponto);
		
		oh = new FlxBackdrop(Paths.image(fuck + 'yil'), FlxAxes.X, 0, 0);
		oh.scale.set(1, 4);
		oh.y = -35;
		oh.velocity.set(20, 0);
		add(oh);
		
		doh = new FlxBackdrop(Paths.image(fuck + 'yil'), FlxAxes.X, 0, 0);
		doh.scale.set(1, 4);
		doh.velocity.set(20, 0);
		doh.y = 700;
		add(doh);
		
		issoai = 'idle';
		freet = new FlxSprite(-65, 100);
		freet.frames = Paths.getSparrowAtlas(fuck + 'gjrkskscmfkkdkakakskdcm');
		freet.animation.addByPrefix('idle', "idles", 24, true);
		freet.animation.addByPrefix('ohyeah', "sherek", 24, false);
		freet.animation.play(issoai);
		add(freet);
		
		// adding songs
		for(i in 0...SongData.weeks.length)
		{
			var week = SongData.getWeek(i);
			if(week.storyModeOnly) continue;

			for(song in week.songs)
				addSong(song[0], song[1], week.diffs);
		}

		var extraSongs = CoolUtil.parseTxt('extra-songs');
		for(line in extraSongs)
		{
			if(line.startsWith("//")) continue;

			// if the line is empty then skip it
			var diffArray:Array<String> = line.split(' ');
			if(diffArray.length < 1) continue;

			// separating the song name from the difficulties
			var songName:String = diffArray.shift();

			// if theres no difficulties, add easy normal and hard
			if(diffArray.length < 1) diffArray = SongData.defaultDiffs;

			// finally adding the song
			addSong(songName, "face", diffArray);
		}

		grpItems = new FlxGroup();
		add(grpItems);

		for(i in 0...songList.length)
		{
			var label:String = songList[i].name;
			//label = label.replace("-", " ");

			var item = new AlphabetMenu(0, 0, label, true);
			item.align = CENTER;
			grpItems.add(item);

			var icon = new HealthIcon();
			icon.setIcon(songList[i].icon);
			grpItems.add(icon);

			item.icon = icon;
			item.ID = i;
			icon.ID = i;

			item.focusY = i - curSelected;
			item.updatePos();

			item.x = FlxG.width + 200;
		}

		scoreCounter = new ScoreCounter();
		add(scoreCounter);

		#if TOUCH_CONTROLS
		createPad("reset");
		#else
		var resetTxt = new FlxText(0, 0, 0, "PRESS RESET TO DELETE SONG SCORE");
		resetTxt.setFormat(Main.gFont, 28, 0xFFFFFFFF, RIGHT);
		var resetBg = new FlxSprite().makeGraphic(
			Math.floor(FlxG.width * 1.5),
			Math.floor(resetTxt.height+ 8),
			0xFF000000
		);
		resetBg.alpha = 0.4;
		resetBg.screenCenter(X);
		resetBg.y = FlxG.height- resetBg.height;
		resetTxt.screenCenter(X);
		resetTxt.y = resetBg.y + 4;
		add(resetBg);
		add(resetTxt);
		#end
		
		FlxTween.angle(freet, freet.angle, -2, 1, {ease: FlxEase.quartInOut});
		new FlxTimer().start(1, function(tmr:FlxTimer)
		{
		if(oh.y == -35) FlxTween.tween(oh, {y: -25}, 1, {ease: FlxEase.quartInOut});
		else FlxTween.tween(oh, {y: -35}, 1, {ease: FlxEase.quartInOut});
		
		if(bg.alpha == 0.65) FlxTween.tween(bg, {alpha: 0.75}, 1, {ease: FlxEase.quartInOut});
		else FlxTween.tween(bg, {alpha: 0.65}, 1, {ease: FlxEase.quartInOut});
		
		if(freet.angle == -2) FlxTween.angle(freet, freet.angle, 2, 1, {ease: FlxEase.quartInOut});
		else FlxTween.angle(freet, freet.angle, -2, 1, {ease: FlxEase.quartInOut});
		
		if(doh.y == 700) FlxTween.tween(doh, {y: 690}, 1, {ease: FlxEase.quartInOut});
		else FlxTween.tween(doh, {y: 700}, 1, {ease: FlxEase.quartInOut});
		}, 0);

		changeSelection();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		if(Controls.justPressed(UI_UP))
			changeSelection(-1);
		if(Controls.justPressed(UI_DOWN))
			changeSelection(1);
		if(Controls.justPressed(UI_LEFT))
			changeDiff(-1);
		if(Controls.justPressed(UI_RIGHT))
			changeDiff(1);

		if(Controls.justPressed(RESET)) {
			var curSong = songList[curSelected];
			openSubState(new DeleteScoreSubState(curSong.name, curSong.diffs[curDiff]));
		}

		if(DeleteScoreSubState.deletedScore)
		{
			DeleteScoreSubState.deletedScore = false;
			updateScoreCount();
		}
		
		var toChartEditor:Bool = FlxG.keys.justPressed.SEVEN;
		if(Controls.justPressed(ACCEPT) || toChartEditor)
		{
			try
			{
				issoai = 'ohyeah';
				FlxG.sound.play(Paths.sound('menu/confirmMenu'));
				new FlxTimer().start(1.5, function(tmr:FlxTimer)
	            {
				var curSong = songList[curSelected];
				PlayState.playList = [];
				PlayState.songDiff = curSong.diffs[curDiff];
				PlayState.loadSong(curSong.name);
				
				if(!toChartEditor)
					Main.switchState(new LoadingState());
				else
				{
					if(ChartingState.SONG.song != PlayState.SONG.song)
						ChartingState.curSection = 0;

					ChartingState.songDiff = PlayState.songDiff;
					ChartingState.SONG   = PlayState.SONG;
					ChartingState.EVENTS = PlayState.EVENTS;
		
					Main.switchState(new ChartingState());
				}
				});
			}
			catch(e)
			{
				FlxG.sound.play(Paths.sound('menu/cancelMenu'));
			}
		}
		
		if(Controls.justPressed(BACK))
		{
			FlxG.sound.play(Paths.sound('menu/cancelMenu'));
			Main.switchState(new MainMenuState());
		}

		for(rawItem in grpItems.members)
		{
			if(Std.isOfType(rawItem, AlphabetMenu))
			{
				var item = cast(rawItem, AlphabetMenu);
				item.icon.x = item.x + item.width;
				item.icon.y = item.y - item.icon.height / 6;
				item.icon.alpha = item.alpha;
			}
		}
	}
	
	public function changeDiff(change:Int = 0)
	{
		curDiff += change;

		var maxDiff:Int = songList[curSelected].diffs.length - 1;
		if(change == 0)
			curDiff = Math.floor(FlxMath.bound(curDiff, 0, maxDiff));
		else
			curDiff = FlxMath.wrap(curDiff, 0, maxDiff);
		
		updateScoreCount();
	}

	public function changeSelection(?change:Int = 0)
	{
		curSelected += change;
		curSelected = FlxMath.wrap(curSelected, 0, songList.length - 1);
		changeDiff();
		
		for(rawItem in grpItems.members)
		{
			if(Std.isOfType(rawItem, AlphabetMenu))
			{
				var item = cast(rawItem, AlphabetMenu);
				item.focusY = item.ID - curSelected;

				item.alpha = 0.4;
				if(item.ID == curSelected)
					item.alpha = 1;
			}
		}
		
		if(bgTween != null) bgTween.cancel();
		bgTween = FlxTween.color(bg, 0.4, bg.color, songList[curSelected].color);
		
		if(ohTween != null) ohTween.cancel();
		ohTween = FlxTween.color(oh, 0.4, oh.color, songList[curSelected].color);
		
		if(dohTween != null) dohTween.cancel();
		dohTween = FlxTween.color(doh, 0.4, doh.color, songList[curSelected].color);

		if(change != 0)
			FlxG.sound.play(Paths.sound("menu/scrollMenu"));
		
		updateScoreCount();
	}
	
	public function updateScoreCount()
	{
		var curSong = songList[curSelected];
		scoreCounter.updateDisplay(curSong.name, curSong.diffs[curDiff]);
	}
}

/*
*	instead of it being separate objects in FreeplayState
*	its just a bunch of stuff inside an FlxGroup
*/
class ScoreCounter extends FlxGroup
{
	public var bg:FlxSprite;

	public var text:FlxText;
	public var diffTxt:FlxText;

	public var realValues:ScoreData;
	public var lerpValues:ScoreData;
	var rank:String = "N/A";

	public function new()
	{
		super();
		bg = new FlxSprite().makeGraphic(32, 32, 0xFF000000);
		bg.alpha = 0.4;
		add(bg);
		
		var txtSize:Int = 28; // 36

		text = new FlxText(0, 0, 0, "");
		text.setFormat(Main.gFont, txtSize, 0xFFFFFFFF, LEFT);
		//text.setBorderStyle(OUTLINE, FlxColor.BLACK, 1.5);
		add(text);
		
		diffTxt = new FlxText(0,0,0,"< DURO >");
		diffTxt.setFormat(Main.gFont, txtSize, 0xFFFFFFFF, LEFT);
		add(diffTxt);

		realValues = {score: 0, accuracy: 0, misses: 0};
		lerpValues = {score: 0, accuracy: 0, misses: 0};
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		text.text = "";

		text.text +=   "HIGHSCORE: " + FlxStringUtil.formatMoney(Math.floor(lerpValues.score), false, true);
		text.text += "\nACCURACY:  " +(Math.floor(lerpValues.accuracy * 100) / 100) + "%" + ' [$rank]';
		text.text += "\nMISSES:    " + Math.floor(lerpValues.misses);

		lerpValues.score 	= FlxMath.lerp(lerpValues.score, 	realValues.score, 	 elapsed * 8);
		lerpValues.accuracy = FlxMath.lerp(lerpValues.accuracy, realValues.accuracy, elapsed * 8);
		lerpValues.misses 	= FlxMath.lerp(lerpValues.misses, 	realValues.misses, 	 elapsed * 8);

		rank = Timings.getRank(
			lerpValues.accuracy,
			Math.floor(lerpValues.misses),
			false,
			lerpValues.accuracy == realValues.accuracy
		);

		if(Math.abs(lerpValues.score - realValues.score) <= 10)
			lerpValues.score = realValues.score;
		if(Math.abs(lerpValues.accuracy - realValues.accuracy) <= 0.4)
			lerpValues.accuracy = realValues.accuracy;
		if(Math.abs(lerpValues.misses - realValues.misses) <= 0.4)
			lerpValues.misses = realValues.misses;

		bg.scale.x = ((text.width + 8) / 32);
		bg.scale.y = ((text.height + diffTxt.height + 8) / 32);
		bg.updateHitbox();

		#if TOUCH_CONTROLS
		bg.y = FlxG.height - bg.height;
		#end

		bg.x = FlxG.width - bg.width;

		text.x = FlxG.width - text.width - 4;
		text.y = bg.y + 4;
		
		diffTxt.x = bg.x + bg.width / 2 - diffTxt.width / 2;
		diffTxt.y = text.y + text.height;
	}

	public function updateDisplay(song:String, diff:String)
	{
		realValues = Highscore.getScore('${song}-${diff}');
		diffTxt.text = '< ${diff.toUpperCase()} >';
		update(0);
	}
}
