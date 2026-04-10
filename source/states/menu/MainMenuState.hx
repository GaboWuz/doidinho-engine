package states.menu;

import backend.song.SongData;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;

using StringTools;

class MainMenuState extends MusicBeatState
{
	var optionShit:Array<String> = ["story", "freeplay", "creds", "options"];
	static var curSelected:Int = 0;
	
	var grpOptions:FlxTypedGroup<FlxSprite>;
	
	var bg:FlxSprite;
	var bgMag:FlxSprite;
	var bgPosY:Float = 0;
	
	var flickMag:Float = 1;
	var flickBtn:Float = 1;
	
	override function create()
	{
		super.create();
		CoolUtil.playMusic("mainmenu");
		
		DiscordIO.changePresence("In the Main Menu");

		bg = new FlxSprite().loadGraphic(Paths.image('menu/backgrounds/menuBG'));
		bg.scale.set(1.2,1.2);
		bg.updateHitbox();
		bg.screenCenter(X);
		add(bg);
		
		bgMag = new FlxSprite().loadGraphic(Paths.image('menu/backgrounds/menuBGMagenta'));
		bgMag.scale.set(bg.scale.x, bg.scale.y);
		bgMag.updateHitbox();
		bgMag.visible = false;
		add(bgMag);
		
		var gabo = new FlxSprite(0, 0);
		gabo.frames = Paths.getSparrowAtlas('menu/mainmenu/personaxey');
		gabo.animation.addByPrefix('idle', "gagbis", 24, true);
		gabo.animation.play('idle');
		gabo.x = FlxG.width - gabo.width + 60;
		add(gabo);
		
		grpOptions = new FlxTypedGroup<FlxSprite>();
		add(grpOptions);
		
		var optionSize:Float = 0.9;
		if(optionShit.length > 4)
		{
			for(i in 0...(optionShit.length - 4))
				optionSize -= 0.04;
		}
		
		for(i in 0...optionShit.length)
		{
			var item = new FlxSprite();
			item.frames = Paths.getSparrowAtlas('menu/mainmenu/menus');
			item.animation.addByPrefix('idle',  optionShit[i] + "_normal", 2, true);
			item.animation.addByPrefix('hover', optionShit[i] + "_selected", 2, true);
			item.animation.play('idle');
			grpOptions.add(item);
			
			item.scale.set(optionSize, optionSize);
			item.updateHitbox();
			
			var itemSize:Float = (90 * optionSize);
			
			var minY:Float = 40 + itemSize;
			var maxY:Float = FlxG.height - itemSize - 40;
			
			if(optionShit.length < 4)
			for(i in 0...(4 - optionShit.length))
			{
				minY += itemSize;
				maxY -= itemSize;
			}
			
			item.x = FlxG.width / 2;
			item.y = FlxMath.lerp(
				minY, // gets min Y
				maxY, // gets max Y
				i / (optionShit.length - 1) // sorts it according to its ID
			);
			
			item.ID = i;
		}
		
		grpOptions.members[0].x -= 460;
		grpOptions.members[0].y += 50;
		grpOptions.members[1].x -= 170;
		grpOptions.members[1].y += 90;
		grpOptions.members[3].x -= 560;
		grpOptions.members[3].y += 30;
		grpOptions.members[2].x = grpOptions.members[3].x + 110;
		grpOptions.members[2].y = grpOptions.members[3].y;
		
		var doidoSplash:String = 'Doidinho Engine ${lime.app.Application.current.meta.get('version')}';
		var funkySplash:String = 'Vs Gabin\' V2';

		var splashTxt = new FlxText(0, 0, FlxG.width, '$doidoSplash\n$funkySplash');
		splashTxt.setFormat(Main.gFont, 18, 0xFFFFFFFF, RIGHT);
		splashTxt.setBorderStyle(OUTLINE, 0xFF000000, 1.5);	
		splashTxt.y = FlxG.height - splashTxt.height - 4;
		add(splashTxt);

		changeSelection();
		bg.y = bgPosY;

		#if TOUCH_CONTROLS
		createPad("back");
		#end
	}
	
	var selectedSum:Bool = false;

	override function update(elapsed:Float)
	{
	    super.update(elapsed);
	
	    #if debug
	    // Crash the game. For CrashHandler test purposes
	    if(FlxG.keys.justPressed.R)
	        null.draw();
	    #end
	
	    if(FlxG.keys.justPressed.V)
	    {
	        persistentUpdate = false;
	        openSubState(new subStates.video.VideoPlayerSubState("test"));
	    }
	
	    if(FlxG.keys.justPressed.EIGHT)
	    {
	        FlxG.sound.play(Paths.sound("menu/cancelMenu"));
	        Main.switchState(new states.editors.CharacterEditorState("bf", false));
	    }
	    
	    if(!selectedSum)
	    {
	        if(Controls.justPressed(BACK)) Main.switchState(new TitleState());
	        
	        var accepted:Bool = Controls.justPressed(ACCEPT);
	        var isHoveringSomething:Bool = false;
	
	        for (item in grpOptions.members)
	        {
	            if (FlxG.mouse.overlaps(item))
	            {
	                isHoveringSomething = true;
	
	                #if mobile
	                if (FlxG.mouse.justPressed)
	                {
	                    if (curSelected != item.ID) {
	                        changeSelection(item.ID - curSelected);
	                    } else {
	                        accepted = true;
	                    }
	                }
	                #else
	                if (curSelected != item.ID) {
	                    changeSelection(item.ID - curSelected);
	                }
	                
	                if (FlxG.mouse.justPressed) {
	                    accepted = true;
	                }
	                #end
	            }
	        }
	
	        #if !mobile
	        if (isHoveringSomething) {
	            openfl.ui.Mouse.cursor = openfl.ui.MouseCursor.BUTTON;
	        } else {
	            openfl.ui.Mouse.cursor = openfl.ui.MouseCursor.ARROW;
	        }
	        #end
	
	        if(accepted)
	        {
	            if(["donate"].contains(optionShit[curSelected]))
	            {
	                CoolUtil.openURL("https://ninja-muffin24.itch.io/funkin");
	            }
	            else
	            {
	                selectedSum = true;
	                FlxG.sound.play(Paths.sound('menu/confirmMenu'));
	                
	                #if !mobile
	                openfl.ui.Mouse.cursor = openfl.ui.MouseCursor.ARROW;
	                #end
	                
	                for(item in grpOptions.members)
	                {
	                    if(item.ID != curSelected)
	                        FlxTween.tween(item, {alpha: 0}, 0.4, {ease: FlxEase.cubeOut});
	                }
	                
	                new FlxTimer().start(1.5, function(tmr:FlxTimer)
	                {
	                    switch(optionShit[curSelected])
	                    {
	                        case "story":
	                            Main.switchState(new StoryMenuState());
	                    
	                        case "freeplay":
	                            Main.switchState(new FreeplayState());
	                        
	                        case "creds":
	                            Main.switchState(new CreditsState());
	
	                        case "options":
	                            Main.switchState(new OptionsState());
	
	                        default: // avoids freezing
	                            Main.resetState();
	                    }
	                });
	            }
	        }
	    }
	    else
	    {
	        if(SaveData.data.get('Flashing Lights') != "OFF")
	        {
	            if(SaveData.data.get('Flashing Lights') != "REDUCED")
	            {
	                flickMag += elapsed;
	                if(flickMag >= 0.15)
	                {
	                    flickMag = 0;
	                    bgMag.visible = !bgMag.visible;
	                }
	            }
	            
	            flickBtn += elapsed;
	            if(flickBtn >= 0.15 / 2)
	            {
	                flickBtn = 0;
	                for(item in grpOptions.members)
	                    if(item.ID == curSelected)
	                        item.visible = !item.visible;
	            }
	        }
	    }
	    
	    //bg.y = FlxMath.lerp(bg.y, bgPosY, elapsed * 6);
	    bgMag.setPosition(bg.x, bg.y);
	}

	public function changeSelection(change:Int = 0)
	{
		if(change != 0) FlxG.sound.play(Paths.sound('menu/scrollMenu'));
		
		curSelected += change;
		curSelected = FlxMath.wrap(curSelected, 0, optionShit.length - 1);
		
		//bgPosY = FlxMath.lerp(0, -(bg.height - FlxG.height), curSelected / (optionShit.length - 1));
		
		for(item in grpOptions.members)
		{
			item.animation.play('idle');
			if(curSelected == item.ID)
				item.animation.play('hover');
			
			item.updateHitbox();
			// makes it offset to its middle point
			item.offset.x += (item.frameWidth * item.scale.x) / 2;
			item.offset.y += (item.frameHeight* item.scale.y) / 2;
		}
	}
}
