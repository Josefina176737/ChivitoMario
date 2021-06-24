package states;

import gameObjects.Star;
import com.gEngine.display.StaticLayer;
import gameObjects.Flower;
import com.gEngine.display.Text;
import com.gEngine.helper.Screen;
import com.loading.basicResources.FontLoader;
import com.collision.platformer.ICollider;
import com.loading.basicResources.ImageLoader;
import paths.Complex;
import paths.Bezier;
import kha.math.FastVector2;
import paths.Linear;
import paths.PathWalker;
import com.framework.utils.State;
import com.collision.platformer.CollisionGroup;
import gameObjects.GameData;
import gameObjects.Goomba;
import com.collision.platformer.CollisionBox;
import helpers.Tray;
import com.gEngine.display.extra.TileMapDisplay;
import gameObjects.LevelPositions;
import paths.Path;
import paths.Linear;
import paths.Complex;
import paths.Bezier;
import com.collision.platformer.Sides;
import com.framework.utils.XboxJoystick;
import com.framework.utils.VirtualGamepad;
import format.tmx.Data.TmxObject;
import kha.input.KeyCode;
import com.framework.utils.Input;
import com.collision.platformer.CollisionEngine;
import gameObjects.ChivitoBoy;
import com.loading.basicResources.TilesheetLoader;
import com.loading.basicResources.SpriteSheetLoader;
import com.gEngine.display.Layer;
import com.loading.basicResources.DataLoader;
import com.collision.platformer.Tilemap;
import com.loading.basicResources.JoinAtlas;
import com.loading.Resources;
import com.framework.utils.State;
import kha.math.FastVector2;

class GameState extends State {
	var worldMap:Tilemap;
	var chivito:ChivitoBoy;
	var goomba:Goomba; //ver si esto no hay que agruparlo
	var flower:Flower;
	var star:Star;
	var simulationLayer:Layer;
	var hudLayer:StaticLayer;
	var touchJoystick:VirtualGamepad;
	var tray:helpers.Tray;
	var mayonnaiseMap:TileMapDisplay;
	var winZone:CollisionBox;
	var winZone1:CollisionBox;
	var room:String;
	var roomNbr:Int;
	var tileSet:String;
	var enemyCount:Int;
	var fontType:String = "AmaticB";
	var score:Text;
	var world:Text;
	var powerUp:Text;

	public function new(room:String, roomNbr:Int, tileSet:String, enemyCount:Int) {
		super();
		this.room = room;
		this.roomNbr = roomNbr;
		this.tileSet = tileSet;
		this.enemyCount = enemyCount;
	}

	override function load(resources:Resources) {
		resources.add(new DataLoader(room));
		var atlas = new JoinAtlas(2048, 2048);
		atlas.add(new FontLoader(fontType,50));
		atlas.add(new TilesheetLoader(tileSet, 32, 32, 0));
		atlas.add(new SpriteSheetLoader("hero", 45, 60, 0, [
			new Sequence("fall", [0]),
			new Sequence("slide", [0]),
			new Sequence("jump", [1]),
			new Sequence("run", [2, 3, 4, 5, 6, 7, 8, 9]),
			new Sequence("idle", [10]),
			new Sequence("wallGrab", [11])
		]));
		atlas.add(new SpriteSheetLoader("hero_red", 45, 60, 0, [
			new Sequence("fall", [0]),
			new Sequence("slide", [0]),
			new Sequence("jump", [1]),
			new Sequence("run", [2, 3, 4, 5, 6, 7, 8, 9]),
			new Sequence("idle", [10]),
			new Sequence("wallGrab", [11])
		]));
		atlas.add(new SpriteSheetLoader("goomba", 32, 32, 0, [
			new Sequence("walk", [0, 1]),
			new Sequence("death", [2])
		]));
		atlas.add(new SpriteSheetLoader("flower", 50, 50, 0, [
			new Sequence("idle", [0, 1, 2, 3])
		]));
		atlas.add(new ImageLoader("star"));
		atlas.add(new ImageLoader("background"));
        atlas.add(new ImageLoader("cannon"));
        atlas.add(new SpriteSheetLoader("explosion_52x65_19f",51,64,0,[Sequence.at("ball",0,0),Sequence.at("explode",1,19)]));
        atlas.add(new SpriteSheetLoader("enemy_40x34_80f",40,34,0,[Sequence.at("walkSide",0,21),Sequence.at("walkUp",22,43),Sequence.at("walkDown",44,65),Sequence.at("death",66,79)]));
		resources.add(atlas);
	}

	override function init() {
		stageColor(0.5, .5, 0.5);
		simulationLayer = new Layer();
		hudLayer = new StaticLayer();
		stage.addChild(simulationLayer);
		stage.addChild(hudLayer);

		worldMap = new Tilemap(room, tileSet);
		worldMap.init(function(layerTilemap, tileLayer) {
			if (!tileLayer.properties.exists("noCollision")) {
				layerTilemap.createCollisions(tileLayer);
			}
			simulationLayer.addChild(layerTilemap.createDisplay(tileLayer));
			 mayonnaiseMap = layerTilemap.createDisplay(tileLayer);
			 simulationLayer.addChild(mayonnaiseMap);
		}, parseMapObjects);

		playerPointsText();
		worldText();

		stage.defaultCamera().limits(0, 0, worldMap.widthIntTiles * 32 * 1, worldMap.heightInTiles * 32 * 1);

		createTouchJoystick();

		GameData.simulationLayer=new Layer();
		GameData.goombaCollisions=new CollisionGroup();

		var goombaPosList:List<FastVector2> = LevelPositions.getGoombaPoints();
		var goombaCount = Math.floor(goombaPosList.length/2);
		var init:FastVector2;
		var end:FastVector2;

		for(i in 0...goombaCount){

			init = goombaPosList.pop();
			end = goombaPosList.pop();

			goomba = new Goomba(init.x, init.y, simulationLayer, GameData.goombaCollisions, init, end);
			addChild(goomba);
		}

		stage.addChild(GameData.simulationLayer);
	}

	private function playerPointsText() {
        score = new Text(fontType);
        score.x = Screen.getWidth()-200;
        score.y = 30;
        score.text = "Score: " + enemyCount;
        hudLayer.addChild(score);
    }

	private function worldText() {
		world = new Text(fontType);
        world.x = Screen.getWidth()-1200;
        world.y = 30;
        world.text = "World " + roomNbr;
        hudLayer.addChild(world);
	}

	private function powerUpText(){
		powerUp = new Text(fontType);
		powerUp.x = Screen.getWidth()*0.5;
		powerUp.y = 30;
        powerUp.text = "Power up!";
        hudLayer.addChild(powerUp);
	}

	function parseMapObjects(layerTilemap:Tilemap, object:TmxObject) {
		if(compareName(object, "playerPosition")){
			if(chivito == null){
				chivito = new ChivitoBoy(object.x, object.y, simulationLayer);
				addChild(chivito);
			}
		}else
		if(compareName(object, "flowerPosition")){
			flower = new Flower(object.x, object.y, simulationLayer);
			addChild(flower);
		}else
		if(compareName(object, "starPosition")){
			star = new Star(object.x, object.y, simulationLayer);
			addChild(star);
		}else
		if(compareName(object, "winZone")){
			winZone = new CollisionBox();
			winZone.x = object.x;
			winZone.y = object.y;
			winZone.width = object.width;
			winZone.height = object.height;
		}

		//Checkear
		if(compareName(object, "winZone1")){
				winZone1 = new CollisionBox();
				winZone1.x = object.x;
				winZone1.y = object.y;
				winZone1.width = object.width;
				winZone1.height = object.height;
		}
	}
	
	inline function compareName(object:TmxObject, name:String) {
		return object.name.toLowerCase() == name.toLowerCase();
	}

	function createTouchJoystick() {
		touchJoystick = new VirtualGamepad();
		touchJoystick.addKeyButton(XboxJoystick.LEFT_DPAD, KeyCode.Left);
		touchJoystick.addKeyButton(XboxJoystick.RIGHT_DPAD, KeyCode.Right);
		touchJoystick.addKeyButton(XboxJoystick.UP_DPAD, KeyCode.Up);
		touchJoystick.addKeyButton(XboxJoystick.A, KeyCode.Space);
		touchJoystick.addKeyButton(XboxJoystick.X, KeyCode.X);
		
		touchJoystick.notify(chivito.onAxisChange, chivito.onButtonChange);

		var gamepad = Input.i.getGamepad(0);
		gamepad.notify(chivito.onAxisChange, chivito.onButtonChange);
	}

	function chivitoVsGoomba(playerC:ICollider, invaderC:ICollider) {
		if((!(star == null)) && (star.isActive())){
			for(goomba in GameData.goombas){
				if(!(goomba.isDead())){
					goomba.damage();
					goomba.die();
					enemyCount++;
					score.text = "Score: " + enemyCount;
				}
			}
		}else{
			for(goomba in GameData.goombas){
				if(!(goomba.isDead())){
					chivito.die();
					changeState(new EndGame(false, 1));
				}
			}
		}
	}

	function flowerPowerUp(playerC:ICollider, invaderC:ICollider) {
		powerUpText();
		//TODO: Hacer que chivito empiece a disparar balas
		flower.powerUpUsed();
	}

	function starPowerUp(playerC:ICollider, invaderC:ICollider) {
		powerUpText();
		star.activate();
		star.powerUpUsed();
	}

	override function update(dt:Float) {
		super.update(dt);

		stage.defaultCamera().setTarget(chivito.collision.x, chivito.collision.y);

		CollisionEngine.collide(chivito.collision,worldMap.collision);
		
		CollisionEngine.collide(GameData.goombaCollisions,worldMap.collision);

		if(!(flower == null)){
			CollisionEngine.collide(flower.collision,worldMap.collision);
		}

		if(!(flower == null)){
			CollisionEngine.collide(star.collision,worldMap.collision);
		}
		
		if(CollisionEngine.overlap(chivito.collision, winZone)){
			if(!(roomNbr == 3)){
				roomNbr++;
				room = "screen_" + roomNbr + "_tmx";
				tileSet = "tiles" + roomNbr;
				
				changeState(new GameState(room, roomNbr, tileSet, enemyCount));
			}else{
				changeState(new InitState());
			}
		}
		
		CollisionEngine.overlap(chivito.collision, GameData.goombaCollisions, chivitoVsGoomba);
		
		if(!(flower == null)){
			CollisionEngine.overlap(chivito.collision, flower.collision, flowerPowerUp);
		}

		if(!(star == null)){
			CollisionEngine.overlap(chivito.collision, star.collision, starPowerUp);
		}
	}

	#if DEBUGDRAW
	override function draw(framebuffer:kha.Canvas) {
		super.draw(framebuffer);
		var camera = stage.defaultCamera();
		CollisionEngine.renderDebug(framebuffer, camera);
	}
	#end
}