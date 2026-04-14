package states.menu;

import backend.song.SongData;
import flixel.addons.display.FlxBackdrop;
import flixel.util.FlxAxes;
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
	
	var bgPosY:Float = 0;
	
	var flickMag:Float = 1;
	var flickBtn:Float = 1;
	
	var bg:FlxSprite;
	var oxe:FlxSprite;

	var moth:FlxSprite;
	var mothy:FlxSprite;
	var mothz:FlxSprite;
	
	var cao:FlxBackdrop;
	var shad:FlxSprite;
	
	var coloy:Int = 400;
	
	var issoai:String = '';
	var fuck:String = 'menu/mainmenu/';
	
	override function create()
	{
		super.create();
		CoolUtil.playMusic("mainmenu");
		
		FlxG.mouse.visible = true;
		
		DiscordIO.changePresence("In the Main Menu");
		
		if (FlxG.random.bool(50)){
		oxe = new FlxSprite(0, -500).loadGraphic(Paths.image(fuck + 'que'));
		oxe.screenCenter(X);
		add(oxe);
		
		issoai = 'manha';
		}
		else{
		bg = new FlxSprite(0, 0).loadGraphic(Paths.image(fuck + 'sky'));
		bg.screenCenter();
		add(bg);
		
		moth = new FlxSprite(0, 0).loadGraphic(Paths.image(fuck + 'moun'));
		moth.screenCenter();
		add(moth);
		
		mothy = new FlxSprite(0, 0).loadGraphic(Paths.image(fuck + 'moun2'));
		mothy.screenCenter();
		add(mothy);
		
		mothz = new FlxSprite(0, 0).loadGraphic(Paths.image(fuck + 'moun3'));
		mothz.screenCenter();
		add(mothz);
		
		issoai = 'tadi';
		}
		
		cao = new FlxBackdrop(Paths.image(fuck + 'chao'), FlxAxes.X, -5, 0);
		cao.velocity.set(-10, 0);
		cao.y = coloy;
		add(cao);
		
		var gabo = new FlxSprite(0, 0);
		gabo.frames = Paths.getSparrowAtlas(fuck + 'personaxey');
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
		    item.frames = Paths.getSparrowAtlas(fuck + 'menus');
		    item.animation.addByPrefix('idle',  optionShit[i] + "_normal", 2, true);
		    item.animation.addByPrefix('hover', optionShit[i] + "_selected", 2, true);
		    item.animation.play('idle');
		    item.scrollFactor.set(0, 0);
		    
		    item.scale.set(optionSize, optionSize);
		    item.updateHitbox(); 
		
		    var itemSize:Float = (90 * optionSize);
		    
		    var minY:Float = 20;
		    var maxY:Float = FlxG.height - itemSize - 100;
		    
		    if(optionShit.length < 4) {
		        for(j in 0...(4 - optionShit.length)) {
		            minY += itemSize * 0.5;
		            maxY -= itemSize * 0.5;
		        }
		    }
		    
		    item.screenCenter(X);
		    item.y = FlxMath.lerp(minY, maxY, (optionShit.length > 1) ? (i / (optionShit.length - 1)) : 0.5);
		    
		    item.ID = i;
		    grpOptions.add(item);
		}
		
		if (grpOptions.members.length > 3) {
		    grpOptions.members[0].x -= 460;
		    grpOptions.members[0].y += 40;
		    
		    grpOptions.members[1].x -= 170;
		    grpOptions.members[1].y += 90;
		    
		    grpOptions.members[3].x -= 560;
		    grpOptions.members[3].y += 30;
		    
		    grpOptions.members[2].x = grpOptions.members[3].x + 110;
		    grpOptions.members[2].y = grpOptions.members[3].y + 20;
		}
		
		shad = new FlxSprite(0, 0).loadGraphic(Paths.image(fuck + issoai));
		shad.setGraphicSize(Std.int(shad.width * 1.2));
		shad.screenCenter();
		shad.alpha = 0.17;
		add(shad);
		
		new FlxTimer().start(1.65, function(tmr:FlxTimer)
		{
			if(cao.y == coloy) FlxTween.tween(cao, {y: coloy +20}, 1.65, {ease: FlxEase.quartInOut});
			else FlxTween.tween(cao, {y: coloy}, 1.65, {ease: FlxEase.quartInOut});
		}, 0);
		
		var doidoSplash:String = 'Doidinho Engine ${lime.app.Application.current.meta.get('version')}';
		var funkySplash:String = 'Vs Gabin\' V2';

		var splashTxt = new FlxText(0, 0, FlxG.width, '$doidoSplash\n$funkySplash');
		splashTxt.setFormat(Main.gFont, 18, 0xFFFFFFFF, RIGHT);
		splashTxt.setBorderStyle(OUTLINE, 0xFF000000, 1.5);	
		splashTxt.y = FlxG.height - splashTxt.height - 4;
		add(splashTxt);

		changeSelection();
		if (bg != null) bg.y = bgPosY;

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
	}

	public function changeSelection(change:Int = 0)
	{
	    //if(change != 0) FlxG.sound.play(Paths.sound('menu/scrollMenu'));
	    
	    curSelected += change;
	    curSelected = FlxMath.wrap(curSelected, 0, optionShit.length - 1);
	    
	    for(item in grpOptions.members)
	    {
	        item.animation.play('idle');
	        //item.alpha = 0.6;
	
	        if(curSelected == item.ID)
	        {
	            item.animation.play('hover');
	            //item.alpha = 1;
	        }
	        
	        item.updateHitbox();
	
	        item.centerOffsets(); 
	        item.centerOrigin();
	    }
	}
}
