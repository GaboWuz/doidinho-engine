package objects;

// text here
import backend.song.*;
import backend.song.SongData.SwagSong;
import backend.song.SongData.SwagSection;

import crowplexus.iris.Iris;
import flixel.FlxSprite;
import flixel.addons.display.FlxBackdrop;
import flixel.group.FlxGroup;
import flixel.math.FlxPoint;
import states.PlayState;
import openfl.display.BlendMode;

import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;

class Stage extends FlxGroup
{
	public static var instance:Stage;

	public var curStage:String = "";
	public var gfVersion:String = "no-gf";
	public var camZoom:Float = 1;
	public var curSong:String = "";

	// things to help your stage get better
	public var bfPos:FlxPoint  = new FlxPoint();
	public var dadPos:FlxPoint = new FlxPoint();
	public var gfPos:FlxPoint  = new FlxPoint();

	public var bfCam:FlxPoint  = new FlxPoint();
	public var dadCam:FlxPoint = new FlxPoint();
	public var gfCam:FlxPoint  = new FlxPoint();

	public var foreground:FlxGroup;

	var loadedScripts:Array<Iris> = [];
	var scripted:Array<String> = [];

	var lowQuality:Bool = false;

	var gfSong:String = "stage-set";

  var stSkr:String = "stages/";
  var stageSkr:String = "";
	
	// coisas públicas
	var staticSpr:FlxSprite;

	public function new() {
		super();
		foreground = new FlxGroup();
		instance = this;
	}

	public function reloadStageFromSong(song:String = "test", gfSong:String = "stage-set"):Void
	{
		var stageList:Array<String> = [];
		
		stageList = switch(song)
		{
			default: ["stage"];
			
			case "sixxey": ["picnic"];
      case "faker-self": ["semstage"];
			case "redkid": ["stageg"];
			
			case "lapoluz": ["daylegacy"];
			case "faker-identity": ["nightlegacy"];
			
			case "moogusxey": ["legacymoogus"];
      case "gagbis": ["picnic"]; //sem stage por enquanto
			
			//case "template": ["preload1", "preload2", "starting-stage"];
		};

		//this stops you from fucking stuff up by changing this mid song
		lowQuality = SaveData.data.get("Low Quality");

		this.gfSong = gfSong;

		/*
		*	makes changing stages easier by preloading
		*	a bunch of stages at the create function
		*	(remember to put the starting stage at the last spot of the array)
		*/
		for(i in stageList) {
			preloadScript(i);
			reloadStage(i);
		}
	}

	public function reloadStage(curStage:String = "")
	{
		this.clear();
		foreground.clear();
		this.curStage = curStage;
		
		gfPos.set(660, 580);
		dadPos.set(260, 700);
		bfPos.set(1100, 700);
		
		if(scripted.contains(curStage))
			callScript("create");
		else
			loadCode(curStage);

		PlayState.defaultCamZoom = camZoom;
	}

	public function preloadScript(stage:String = "")
	{
		var path:String = 'images/stages/_scripts/$stage';
		
		if(Paths.fileExists('$path.hxc'))
			path += '.hxc';
		else if(Paths.fileExists('$path.hx'))
			path += '.hx';
		else
			return;

		var newScript:Iris = new Iris(Paths.script('$path'), {name: path, autoRun: false, autoPreset: true});

		// variables to be used inside the scripts
		newScript.set("FlxSprite", FlxSprite);
		newScript.set("Paths", Paths);
		newScript.set("this", instance);

		newScript.set("add", add);
		newScript.set("foreground", foreground);

		newScript.set("bfPos", bfPos);
		newScript.set("dadPos", dadPos);
		newScript.set("gfPos", gfPos);

		newScript.set("bfCam", bfCam);
		newScript.set("dadCam", dadCam);
		newScript.set("gfCam", gfCam);

		newScript.set("lowQuality", lowQuality);

		newScript.execute();

		loadedScripts.push(newScript);
		scripted.push(stage);
	}

	// Hardcode your stages here!
	public function loadCode(curStage:String = "")
	{
		gfVersion = getGfVersion(curStage);
    stageSkr = stSkr + curStage + '/';
		switch(curStage)
		{
			default:
				this.curStage = "stage";
				camZoom = 0.9;
				
				var bg = new FlxSprite(-600, -600).loadGraphic(Paths.image("stages/stage/stageback"));
				bg.scrollFactor.set(0.6,0.6);
				add(bg);
				
				var front = new FlxSprite(-580, 440);
				front.loadGraphic(Paths.image("stages/stage/stagefront"));
				add(front);
				
				if(!lowQuality) {
					var curtains = new FlxSprite(-600, -400).loadGraphic(Paths.image("stages/stage/stagecurtains"));
					curtains.scrollFactor.set(1.4,1.4);
					foreground.add(curtains);
				}
				
			case "picnic":
			  this.curStage = "picnic";
			  camZoom = 0.657;
			
				gfPos.set(-750, 920);
    		dadPos.set(500, 760);
				bfPos.set(1512, 770);
			
				bfCam.x = -300;
				dadCam.x = 100;
			
			  var sky:FlxSprite = new FlxSprite(-500, -500).makeGraphic(Std.int(FlxG.width * 2), Std.int(FlxG.height * 2), 0xFFcef1ff);
        sky.scrollFactor.set(0.1, 0.1);
        sky.updateHitbox();
        add(sky);
        
        var nuul = new FlxBackdrop(Paths.image(stageSkr + 'nuvens'), X);
        nuul.setGraphicSize(Std.int(nuul.height * 2.12));
        nuul.scrollFactor.set(0.4, 0.4);
        nuul.velocity.x = 20;
        nuul.y = 200;
        nuul.x = -480;
        nuul.updateHitbox();
        add(nuul);
        
        var caac:FlxSprite = new FlxSprite(-300, -235).loadGraphic(Paths.image(stageSkr + 'casa'));
        caac.setGraphicSize(Std.int(caac.height * 1.3));
        caac.scrollFactor.set(0.57, 0.57);
        caac.updateHitbox();
        add(caac);
        
        var saas:FlxSprite = new FlxSprite(1285, -165).loadGraphic(Paths.image(stageSkr + 'casa2'));
        saas.setGraphicSize(Std.int(saas.height * 1.7));
        saas.scrollFactor.set(0.62, 0.62);
        saas.updateHitbox();
        add(saas);
        
        var cerc:FlxSprite = new FlxSprite(-300, 95).loadGraphic(Paths.image(stageSkr + 'cerca'));
        cerc.setGraphicSize(Std.int(cerc.height * 2.2));
        cerc.scrollFactor.set(0.7, 0.7);
        cerc.updateHitbox();
        add(cerc);
        
        var ground:FlxSprite = new FlxSprite(-500, 167).loadGraphic(Paths.image(stageSkr + 'ground'));
        ground.setGraphicSize(Std.int(ground.height * 2.3));
        ground.updateHitbox();
        add(ground);
        
        var it:FlxSprite = new FlxSprite(-100, 390).loadGraphic(Paths.image(stageSkr + 'item'));
        it.setGraphicSize(Std.int(it.height * 1.6));
        it.updateHitbox();
        add(it);
        
        var it2:FlxSprite = new FlxSprite(846, 450).loadGraphic(Paths.image(stageSkr + 'item2'));
        it2.setGraphicSize(Std.int(it.height * 2));
        it2.updateHitbox();
        add(it2);
        
        var gag:FlxSprite = new FlxSprite(-350, 520).loadGraphic(Paths.image(stageSkr + 'Gangorra'));
        gag.updateHitbox();
        foreground.add(gag);
        
        var kr:FlxSprite = new FlxSprite(1800, 420).loadGraphic(Paths.image(stageSkr + 'balanco'));
        kr.setGraphicSize(Std.int(kr.height * 1.010));
        kr.updateHitbox();
        foreground.add(kr);
        
        var skr:FlxSprite = new FlxSprite(-600, -600).loadGraphic(Paths.image(stageSkr + 'shad'));
        skr.setGraphicSize(Std.int(skr.height * 2.4));
        skr.alpha = 0.56;
        skr.updateHitbox();
        foreground.add(skr);
				
			case "stageg":
			  this.curStage = "stageg";
        stageSkr = stSkr + 'luke/';
			  camZoom = 0.7;
			
			  bfPos.x += 200;
				dadPos.x += 350;
				bfPos.y += 100;
				dadPos.y += 130;
				
				dadCam.y -= 20;
				bfCam.x -= 25;

			  var back = new FlxSprite(0, -700).loadGraphic(Paths.image(stageSkr + 'back'));
				back.setGraphicSize(Std.int(back.width * 2.67));
				back.updateHitbox();
				back.scrollFactor.set(0.1, 0.1);
				back.screenCenter(X);
				add(back);
				
				var grand = new FlxSprite(-110, -100).loadGraphic(Paths.image(stageSkr + 'pqtemumamontanhanostage'));
				grand.setGraphicSize(Std.int(grand.width * 1.5));
				grand.updateHitbox();
				grand.scrollFactor.set(0.25, 0.25);
				add(grand);
				
				var lu = new FlxSprite(-500, -300).loadGraphic(Paths.image(stageSkr + 'light'));
				lu.setGraphicSize(Std.int(lu.width * 1.5));
				lu.updateHitbox();
				lu.flipX = true;
				lu.scrollFactor.set(0.3, 0.3);
				foreground.add(lu);
				
				var cur = new FlxSprite(-300, -190).loadGraphic(Paths.image(stageSkr + 'cur1'));
				cur.setGraphicSize(Std.int(cur.width * 1.57));
				cur.updateHitbox();
				cur.scrollFactor.set(0.35, 0.35);
				add(cur);
				
				var cur2 = new FlxSprite(-300, -200).loadGraphic(Paths.image(stageSkr + 'cur2'));
				cur2.setGraphicSize(Std.int(cur2.width * 1.60));
				cur2.updateHitbox();
				cur2.scrollFactor.set(0.48, 0.48);
				add(cur2);
				
				var cur3 = new FlxSprite(-300, -210).loadGraphic(Paths.image(stageSkr + 'cur3'));
				cur3.setGraphicSize(Std.int(cur3.width * 1.65));
				cur3.updateHitbox();
				cur3.scrollFactor.set(0.63, 0.63);
				add(cur3);
				
				var ll = new FlxSprite(-300, -150).loadGraphic(Paths.image(stageSkr + 'lightfront'));
				ll.setGraphicSize(Std.int(ll.width * 1.5));
				ll.updateHitbox();
				ll.scrollFactor.set(0.7, 0.7);
				add(ll);
				
				var stag = new FlxSprite(-300, 520).loadGraphic(Paths.image(stageSkr + 'stagefront'));
				stag.setGraphicSize(Std.int(stag.width * 1.67));
				stag.updateHitbox();
				stag.scrollFactor.set(0.9, 0.9);
				add(stag);
				
				var bola = new FlxSprite(150, 500).loadGraphic(Paths.image(stageSkr + 'vaziodogabo'));
				bola.setGraphicSize(Std.int(bola.width * 1.4));
				bola.updateHitbox();
				bola.scrollFactor.set(0.9, 0.9);
				add(bola);
				
				staticSpr = new FlxSprite(1195, 70);
				staticSpr.frames = Paths.getSparrowAtlas(stageSkr + 'flocus_bg');
				staticSpr.animation.addByPrefix('idle', 'bendy', 24, false);
				staticSpr.setGraphicSize(Std.int(staticSpr.width * 1.1));
				staticSpr.updateHitbox();
				staticSpr.scrollFactor.set(0.9, 0.9);
				add(staticSpr);
				
				var tang = new FlxSprite(1200, 730).loadGraphic(Paths.image(stageSkr + 'umestante'));
				tang.setGraphicSize(Std.int(tang.width * 1.4));
				tang.updateHitbox();
				tang.scrollFactor.set(0.95, 0.95);
				foreground.add(tang);
				
				var eh = new FlxSprite(-165, -100).loadGraphic(Paths.image(stageSkr + 'eh'));
				eh.setGraphicSize(Std.int(eh.width * 1.4));
				eh.updateHitbox();
				eh.scrollFactor.set(1, 1);
				foreground.add(eh);
				
			case "daylegacy":
        stageSkr = stSkr + 'legacy/';
				camZoom = 0.675;
				
				bfPos.x = 1470;
				dadPos.x = 800;
				gfPos.x = 1150;
				bfPos.y += 850;
				dadPos.y += 900;
				gfPos.y += 790;
				
				bfCam.x -= 85;
				dadCam.x += 75;
				
				var fundo = new FlxSprite(-200, -200).loadGraphic(Paths.image(stageSkr + "gabofundotarde0009"));
				fundo.setGraphicSize(Std.int(fundo.width * 2));
				fundo.scrollFactor.set(0.1,0.1);
				add(fundo);
				
				var coisa = new FlxSprite(-25, 600).loadGraphic(Paths.image(stageSkr + "gabofundotarde0008"));
				coisa.setGraphicSize(Std.int(coisa.width * 1.9));
				coisa.scrollFactor.set(0.78,0.85);
				add(coisa);
				
				var nuvens = new FlxSprite(-120, 570).loadGraphic(Paths.image(stageSkr + "gabofundotarde0006"));
				nuvens.setGraphicSize(Std.int(nuvens.width * 2.167));
				nuvens.scrollFactor.set(0.85,0.87);
				add(nuvens);
				
				var sol = new FlxSprite(-50, 300).loadGraphic(Paths.image(stageSkr + "gabofundotarde0007"));
				sol.setGraphicSize(Std.int(sol.width * 1.9));
				sol.scrollFactor.set(0.75,0.8);
				add(sol);
				
				var arbuto = new FlxSprite(100, 350).loadGraphic(Paths.image(stageSkr + "gabofundotarde0005"));
				arbuto.setGraphicSize(Std.int(arbuto.width * 2.2));
				arbuto.scrollFactor.set(0.93,0.91);
				add(arbuto);
				
				var predio = new FlxSprite(425, 390).loadGraphic(Paths.image(stageSkr + "gabofundotarde0003"));
				predio.setGraphicSize(Std.int(predio.width * 2.2267));
				predio.scrollFactor.set(0.92,0.9);
				add(predio);
				
				var th = new FlxSprite(210, 390).loadGraphic(Paths.image(stageSkr + "gabofundotarde0004"));
				th.setGraphicSize(Std.int(th.width * 2.067));
				th.scrollFactor.set(0.95,0.95);
				add(th);
				
				var rua = new FlxSprite(210, 340).loadGraphic(Paths.image(stageSkr + "gabofundotarde0002"));
				rua.setGraphicSize(Std.int(rua.width * 2.1267));
				rua.scrollFactor.set(0.9,0.9);
				add(rua);
				
				var chao = new FlxSprite(210, 360).loadGraphic(Paths.image(stageSkr + "gabofundotarde0001"));
				chao.setGraphicSize(Std.int(chao.width * 2.1267));
				chao.scrollFactor.set(0.9,0.9);
				add(chao);
				
				var frente = new FlxSprite(-260, 0).loadGraphic(Paths.image(stageSkr + "gabofundotarde0009"));
				frente.setGraphicSize(Std.int(frente.width * 2.9));
				frente.scrollFactor.set(0.1,0.1);
				frente.alpha = 0.25;
				frente.blend = BlendMode.SCREEN; 
				foreground.add(frente);
				
			case "nightlegacy":
        stageSkr = stSkr + 'legacy/';
				camZoom = 0.767;
				
				bfPos.x = 1470;
				dadPos.x = 800;
				gfPos.x = 1150;
				bfPos.y += 850;
				dadPos.y += 900;
				gfPos.y += 790;
				
				var fundo = new FlxSprite(0, 0).loadGraphic(Paths.image(stageSkr + "gabofundonoite0008"));
				fundo.setGraphicSize(Std.int(fundo.width * 2));
				fundo.scrollFactor.set(0.1,0.1);
				add(fundo);
				
				var nuvens = new FlxSprite(-120, 570).loadGraphic(Paths.image(stageSkr + "gabofundotarde0006"));
				nuvens.setGraphicSize(Std.int(nuvens.width * 2.167));
				nuvens.scrollFactor.set(0.85,0.87);
				add(nuvens);
				
				var sol = new FlxSprite(-50, 650).loadGraphic(Paths.image(stageSkr + "gabofundonoite0007"));
				sol.setGraphicSize(Std.int(sol.width * 1.9));
				sol.scrollFactor.set(0.75,0.8);
				add(sol);
				
				var arbuto = new FlxSprite(100, 350).loadGraphic(Paths.image(stageSkr + "gabofundotarde0005"));
				arbuto.setGraphicSize(Std.int(arbuto.width * 2.2));
				arbuto.scrollFactor.set(0.93,0.91);
				add(arbuto);
				
				var predio = new FlxSprite(425, 390).loadGraphic(Paths.image(stageSkr + "gabofundotarde0003"));
				predio.setGraphicSize(Std.int(predio.width * 2.2267));
				predio.scrollFactor.set(0.92,0.9);
				add(predio);
				
				var th = new FlxSprite(210, 390).loadGraphic(Paths.image(stageSkr + "gabofundotarde0004"));
				th.setGraphicSize(Std.int(th.width * 2.067));
				th.scrollFactor.set(0.95,0.95);
				add(th);
				
				var rua = new FlxSprite(210, 340).loadGraphic(Paths.image(stageSkr + "gabofundotarde0002"));
				rua.setGraphicSize(Std.int(rua.width * 2.1267));
				rua.scrollFactor.set(0.9,0.9);
				add(rua);
				
				var chao = new FlxSprite(210, 360).loadGraphic(Paths.image(stageSkr + "gabofundotarde0001"));
				chao.setGraphicSize(Std.int(chao.width * 2.1267));
				chao.scrollFactor.set(0.9,0.9);
				add(chao);
				
				var frente = new FlxSprite(0, 120).loadGraphic(Paths.image(stageSkr + "gabofundonoite0008"));
				frente.setGraphicSize(Std.int(frente.width * 3.5));
				frente.alpha = 0.35;
				frente.blend = BlendMode.MULTIPLY;
				foreground.add(frente);
				
			case "legacymoogus": //piadas fools
				this.curStage = "legacymoogus";
        stageSkr = stSkr + 'moogus/';
			  camZoom = 0.6;
			
				// uh
			  bfPos.x += 450;
				bfPos.y += 150;
				
				dadPos.x += 450;
				dadPos.y += 210;
				dadCam.x += 150;
				dadCam.y -= 90;
				
				gfPos.x += 467;
				gfPos.y += 200;
				
				var a = new FlxSprite(0, 0).loadGraphic(Paths.image(stageSkr + 'back'));
				a.setGraphicSize(Std.int(a.width * 2.95));
				a.updateHitbox();
				a.scrollFactor.set(0.1, 0.1);
				a.screenCenter(XY);
				add(a);
				
				var b = new FlxSprite(-475, -450).loadGraphic(Paths.image(stageSkr + 'clound'));
				b.setGraphicSize(Std.int(b.width * 2.75));
				b.updateHitbox();
				b.scrollFactor.set(0.32, 0.32);
				add(b);
				
				var mo = new FlxSprite(350, 200).loadGraphic(Paths.image(stageSkr + 'mo'));
				mo.setGraphicSize(Std.int(mo.width * 2.25));
				mo.updateHitbox();
				mo.scrollFactor.set(0.65, 0.65);
				add(mo);
				
				var amo = new FlxSprite(-400, 100).loadGraphic(Paths.image(stageSkr + 'mofront'));
				amo.setGraphicSize(Std.int(amo.width * 2.55));
				amo.updateHitbox();
				amo.scrollFactor.set(0.72, 0.72);
				add(amo);
				
				var ground = new FlxSprite(-500, 470).loadGraphic(Paths.image(stageSkr + 'ground'));
				ground.setGraphicSize(Std.int(ground.width * 2.35));
				ground.updateHitbox();
				ground.scrollFactor.set(0.9, 0.9);
				add(ground);
				
				var ped = new FlxSprite(1670, -220).loadGraphic(Paths.image(stageSkr + 'pedio'));
				ped.setGraphicSize(Std.int(ped.width * 2.5));
				ped.updateHitbox();
				ped.scrollFactor.set(0.9, 0.9);
				add(ped);
		}
	}
	
	private function lapoluzStepHit(curStep:Int):Void
	{
	    switch(curStep)
	    {
	        case 128: tweenCamZoom(1, 5.50, FlxEase.sineInOut);
	        case 256: tweenCamZoom(0.675, 0.453);
	        case 320: tweenCamZoom(0.715, 0.453);
	        case 352: tweenCamZoom(0.915, 0.453);
	        case 356: tweenCamZoom(0.715, 0.453);
	        case 358: tweenCamZoom(0.815, 0.453);
	        case 362: tweenCamZoom(0.715, 0.453);
	        case 364: tweenCamZoom(0.635, 0.453);
	        case 380: tweenCamZoom(0.605, 0.453);
	        case 382: tweenCamZoom(0.635, 0.453);
	        case 384: tweenCamZoom(0.715, 0.453);
	        case 512: tweenCamZoom(1.0, 0.453);
	        case 539: tweenCamZoom(1.25, 0.453);
	        case 544: tweenCamZoom(1.0, 0.453);
	        case 576: tweenCamZoom(1.15, 0.453);
	        case 640: tweenCamZoom(1.0, 0.453);
	        case 667: tweenCamZoom(1.25, 0.453);
	        case 672: tweenCamZoom(1.0, 0.453);
	        case 704: tweenCamZoom(1.15, 0.453);
	        case 768: tweenCamZoom(1.0, 0.453);
	        case 910: tweenCamZoom(0.915, 0.453);
	        case 918: tweenCamZoom(0.815, 0.453);
	        case 960: tweenCamZoom(1.0, 0.453);
	        case 976: tweenCamZoom(0.915, 0.453);
	        case 1008: tweenCamZoom(0.635, 0.453);
	        case 1016: tweenCamZoom(0.605, 0.453);
	        case 1026: tweenCamZoom(0.635, 0.453);
	        case 1068: tweenCamZoom(0.915, 0.453);
	        case 1090: tweenCamZoom(0.815, 0.453);
	        case 1136: tweenCamZoom(0.605, 0.453);
	        case 1152: tweenCamZoom(0.815, 0.453);
	        case 1280: tweenCamZoom(1.15, 0.453);
	        case 1344: tweenCamZoom(1.25, 0.453);
	        case 1408: tweenCamZoom(0.635, 0.453);
	    }
	}
	
	private function tweenCamZoom(zoomAlvo:Float, duracao:Float = 0.95, ?ease:Dynamic):Void
	{
	    FlxTween.cancelTweensOf(PlayState, ["defaultCamZoom"]);
	    
	    if (ease == null) ease = FlxEase.quadInOut;
	    
	    FlxTween.tween(PlayState, {defaultCamZoom: zoomAlvo}, duracao, {
	        ease: ease
	    });
	}

	public function getGfVersion(curStage:String)
	{
		if(gfSong != "stage-set")
			return gfSong;

		return switch(curStage)
		{
			case "mugen": "no-gf";
			case "school"|"school-evil": "gf-pixel";
			default: "gf";
		}
	}
	
	override function update(elapsed:Float)
	{
		super.update(elapsed);
		callScript("update", [elapsed]);
	}
	
	public function stepHit(curStep:Int = -1)
	{
		// beat hit
		// if(curStep % 4 == 0)
		
		if (PlayState.SONG == null) return;

		var songName:String = PlayState.SONG.song.toLowerCase();
	
		switch(songName)
		{
			case "lapoluz":
				lapoluzStepHit(curStep);
			case "faker-identity":
				// nunca teve events
		}

		callScript("stepHit", [curStep]);
	}
	
	public function beatHit(curBeat:Int = -1)
	{
		switch(curStage)
    {
			case "stageg":
			   if (curBeat % 2 == 0)
				   staticSpr.animation.play('idle', true);
		}
	}

	public function callScript(fun:String, ?args:Array<Dynamic>)
	{
		for(i in 0...loadedScripts.length) {
			if(scripted[i] != curStage)
				continue;

			var script:Iris = loadedScripts[i];

			@:privateAccess {
				var ny: Dynamic = script.interp.variables.get(fun);
				try {
					if(ny != null && Reflect.isFunction(ny))
						script.call(fun, args);
				} catch(e) {
					Logs.print('error parsing script: ' + e, ERROR);
				}
			}
		}
	}
}
