package objects;

import crowplexus.iris.Iris;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.math.FlxPoint;
import states.PlayState;
import openfl.display.BlendMode;

class Stage extends FlxGroup
{
	public static var instance:Stage;

	public var curStage:String = "";
	public var gfVersion:String = "no-gf";
	public var camZoom:Float = 1;

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
				
			case "daylegacy":
				camZoom = 0.675;
				
				bfPos.x = 1070;
				dadPos.x = 400;
				gfPos.x = 750;
				bfPos.y += 500;
				dadPos.y += 550;
				gfPos.y += 450;
				
				fundo = new FlxSprite(0, -400).loadGraphic(Paths.image("stages/legacy/gabofundotarde0009"));
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
				
				chao = new FlxSprite(210, 360).loadGraphic(Paths.image("stages/legacy/gabofundotarde0002"));
				chao.setGraphicSize(Std.int(chao.width * 2.1267));
				chao.scrollFactor.set(0.9,0.9);
				add(chao);
				
				frente = new FlxSprite(0, 0).loadGraphic(Paths.image("stages/legacy/gabofundotarde0009"));
				frente.setGraphicSize(Std.int(frente.width * 2));
				frente.scrollFactor.set(0.1,0.1);
				frente.alpha = 0.25;
				frente.blend = BlendMode.SCREEN; 
				add(frente);
				
			case "nightlegacy":
				camZoom = 0.767;
				
				bfPos.x = 1070;
				dadPos.x = 400;
				gfPos.x = 750;
				bfPos.y += 500;
				dadPos.y += 550;
				gfPos.y += 450;
				
				fundo = new FlxSprite(0, -400).loadGraphic(Paths.image("stages/legacy/gabofundonoite0008"));
				fundo.setGraphicSize(Std.int(fundo.width * 2));
				fundo.scrollFactor.set(0.1,0.1);
				add(fundo);
				
				nuvens = new FlxSprite(-120, 570).loadGraphic(Paths.image("stages/legacy/gabofundotarde0006"));
				nuvens.setGraphicSize(Std.int(nuvens.width * 2.167));
				nuvens.scrollFactor.set(0.85,0.87);
				add(nuvens);
				
				sol = new FlxSprite(-50, 300).loadGraphic(Paths.image("stages/legacy/gabofundonoite0007"));
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
				
				chao = new FlxSprite(210, 360).loadGraphic(Paths.image("stages/legacy/gabofundotarde0002"));
				chao.setGraphicSize(Std.int(chao.width * 2.1267));
				chao.scrollFactor.set(0.9,0.9);
				add(chao);
				
				frente = new FlxSprite(0, 0).loadGraphic(Paths.image("stages/legacy/gabofundotarde0009"));
				frente.setGraphicSize(Std.int(frente.width * 2));
				frente.scrollFactor.set(0.1,0.1);
				frente.alpha = 0.25;
				frente.blend = BlendMode.MULTIPLY;
				add(frente);
		}
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
