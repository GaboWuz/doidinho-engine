package objects;

// text here
import backend.song.*;
import backend.song.SongData.SwagSong;
import backend.song.SongData.SwagSection;

import crowplexus.iris.Iris;
import flixel.FlxSprite;
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
	
	var fundo:FlxSprite;
	var coisa:FlxSprite;
	var nuvens:FlxSprite;
	var sol:FlxSprite;
	var arbuto:FlxSprite;
	var predio:FlxSprite;
	var th:FlxSprite;
	var rua:FlxSprite;
	var chao:FlxSprite;
	var frente:FlxSprite;

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
			
			case "lapoluz": ["daylegacy"];
			case "faker-identity": ["nightlegacy"];
			
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
			    // nada kkkkkk
				
			case "daylegacy":
				camZoom = 0.675;
				
				bfPos.x = 1470;
				dadPos.x = 800;
				gfPos.x = 1150;
				bfPos.y += 850;
				dadPos.y += 900;
				gfPos.y += 790;
				
				bfCam.x -= 85;
				dadCam.x += 75;
				
				fundo = new FlxSprite(-200, -200).loadGraphic(Paths.image("stages/legacy/gabofundotarde0009"));
				fundo.setGraphicSize(Std.int(fundo.width * 2));
				fundo.scrollFactor.set(0.1,0.1);
				add(fundo);
				
				coisa = new FlxSprite(-25, 600).loadGraphic(Paths.image("stages/legacy/gabofundotarde0008"));
				coisa.setGraphicSize(Std.int(coisa.width * 1.9));
				coisa.scrollFactor.set(0.78,0.85);
				add(coisa);
				
				nuvens = new FlxSprite(-120, 570).loadGraphic(Paths.image("stages/legacy/gabofundotarde0006"));
				nuvens.setGraphicSize(Std.int(nuvens.width * 2.167));
				nuvens.scrollFactor.set(0.85,0.87);
				add(nuvens);
				
				sol = new FlxSprite(-50, 300).loadGraphic(Paths.image("stages/legacy/gabofundotarde0007"));
				sol.setGraphicSize(Std.int(sol.width * 1.9));
				sol.scrollFactor.set(0.75,0.8);
				add(sol);
				
				arbuto = new FlxSprite(100, 350).loadGraphic(Paths.image("stages/legacy/gabofundotarde0005"));
				arbuto.setGraphicSize(Std.int(arbuto.width * 2.2));
				arbuto.scrollFactor.set(0.93,0.91);
				add(arbuto);
				
				predio = new FlxSprite(425, 390).loadGraphic(Paths.image("stages/legacy/gabofundotarde0003"));
				predio.setGraphicSize(Std.int(predio.width * 2.2267));
				predio.scrollFactor.set(0.92,0.9);
				add(predio);
				
				th = new FlxSprite(210, 390).loadGraphic(Paths.image("stages/legacy/gabofundotarde0004"));
				th.setGraphicSize(Std.int(th.width * 2.067));
				th.scrollFactor.set(0.95,0.95);
				add(th);
				
				rua = new FlxSprite(210, 340).loadGraphic(Paths.image("stages/legacy/gabofundotarde0002"));
				rua.setGraphicSize(Std.int(rua.width * 2.1267));
				rua.scrollFactor.set(0.9,0.9);
				add(rua);
				
				chao = new FlxSprite(210, 360).loadGraphic(Paths.image("stages/legacy/gabofundotarde0001"));
				chao.setGraphicSize(Std.int(chao.width * 2.1267));
				chao.scrollFactor.set(0.9,0.9);
				add(chao);
				
				frente = new FlxSprite(-200, 0).loadGraphic(Paths.image("stages/legacy/gabofundotarde0009"));
				frente.setGraphicSize(Std.int(frente.width * 2.9));
				frente.scrollFactor.set(0.1,0.1);
				frente.alpha = 0.25;
				frente.blend = BlendMode.SCREEN; 
				foreground.add(frente);
				
			case "nightlegacy":
				camZoom = 0.767;
				
				bfPos.x = 1470;
				dadPos.x = 800;
				gfPos.x = 1150;
				bfPos.y += 850;
				dadPos.y += 900;
				gfPos.y += 790;
				
				fundo = new FlxSprite(0, 0).loadGraphic(Paths.image("stages/legacy/gabofundonoite0008"));
				fundo.setGraphicSize(Std.int(fundo.width * 2));
				fundo.scrollFactor.set(0.1,0.1);
				add(fundo);
				
				nuvens = new FlxSprite(-120, 570).loadGraphic(Paths.image("stages/legacy/gabofundotarde0006"));
				nuvens.setGraphicSize(Std.int(nuvens.width * 2.167));
				nuvens.scrollFactor.set(0.85,0.87);
				add(nuvens);
				
				sol = new FlxSprite(-50, 650).loadGraphic(Paths.image("stages/legacy/gabofundonoite0007"));
				sol.setGraphicSize(Std.int(sol.width * 1.9));
				sol.scrollFactor.set(0.75,0.8);
				add(sol);
				
				arbuto = new FlxSprite(100, 350).loadGraphic(Paths.image("stages/legacy/gabofundotarde0005"));
				arbuto.setGraphicSize(Std.int(arbuto.width * 2.2));
				arbuto.scrollFactor.set(0.93,0.91);
				add(arbuto);
				
				predio = new FlxSprite(425, 390).loadGraphic(Paths.image("stages/legacy/gabofundotarde0003"));
				predio.setGraphicSize(Std.int(predio.width * 2.2267));
				predio.scrollFactor.set(0.92,0.9);
				add(predio);
				
				th = new FlxSprite(210, 390).loadGraphic(Paths.image("stages/legacy/gabofundotarde0004"));
				th.setGraphicSize(Std.int(th.width * 2.067));
				th.scrollFactor.set(0.95,0.95);
				add(th);
				
				rua = new FlxSprite(210, 340).loadGraphic(Paths.image("stages/legacy/gabofundotarde0002"));
				rua.setGraphicSize(Std.int(rua.width * 2.1267));
				rua.scrollFactor.set(0.9,0.9);
				add(rua);
				
				chao = new FlxSprite(210, 360).loadGraphic(Paths.image("stages/legacy/gabofundotarde0001"));
				chao.setGraphicSize(Std.int(chao.width * 2.1267));
				chao.scrollFactor.set(0.9,0.9);
				add(chao);
				
				frente = new FlxSprite(0, 120).loadGraphic(Paths.image("stages/legacy/gabofundonoite0008"));
				frente.setGraphicSize(Std.int(frente.width * 2.9));
				//frente.scrollFactor.set(0.1,0.1);
				frente.alpha = 0.35;
				frente.blend = BlendMode.MULTIPLY;
				foreground.add(frente);
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
