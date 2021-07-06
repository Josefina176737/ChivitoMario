package states;

import gameObjects.Bullet;
import gameObjects.Paragoomba;
import gameObjects.PowerUp;
import gameObjects.Star;
import com.gEngine.display.StaticLayer;
import gameObjects.Flower;
import com.gEngine.display.Text;
import com.gEngine.helper.Screen;
import com.loading.basicResources.FontLoader;
import com.collision.platformer.ICollider;
import com.loading.basicResources.ImageLoader;
import com.collision.platformer.CollisionGroup;
import gameObjects.GameData;
import gameObjects.Goomba;
import com.collision.platformer.CollisionBox;
import helpers.Tray;
import com.gEngine.display.extra.TileMapDisplay;
import gameObjects.LevelPositions;
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
	var goomba:Goomba;
	var paragoomba:Paragoomba;
	//var powerUp:PowerUp;
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
	var powerUpText:Text;

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
		atlas.add(new SpriteSheetLoader("paragoomba", 47, 32, 0, [
			new Sequence("walk", [0, 1]),
			new Sequence("death", [2])
		]));
		atlas.add(new SpriteSheetLoader("flower", 50, 50, 0, [
			new Sequence("idle", [0, 1, 2, 3])
		]));
		atlas.add(new ImageLoader("star"));
		atlas.add(new ImageLoader("Bullet"));
        atlas.add(new SpriteSheetLoader("explosion_52x65_19f",51,64,0,[Sequence.at("ball",0,0),Sequence.at("explode",1,19)]));
        atlas.add(new SpriteSheetLoader("enemy_40x34_80f",40,34,0,[Sequence.at("walkSide",0,21),Sequence.at("walkUp",22,43),Sequence.at("walkDown",44,65),Sequence.at("death",66,79)]));
		resources.add(atlas);
	}

	override function init() {
		GameData.PWACollisions=new CollisionGroup();
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

		GameData.map = worldMap;

		playerPointsText();
		worldText();

		stage.defaultCamera().limits(0, 0, worldMap.widthIntTiles * 32 * 1, worldMap.heightInTiles * 32 * 1);

		createTouchJoystick();

		GameData.simulationLayer=new Layer();
		GameData.bulletCollisions=new CollisionGroup();

		var init:FastVector2;
		var end:FastVector2;
		GameData.goombaCollisions=new CollisionGroup();

		var goombaPosList:List<FastVector2> = LevelPositions.getGoombaPoints();
		var goombaCount = Math.floor(goombaPosList.length/2);

		for(i in 0...goombaCount){

			init = goombaPosList.pop();
			end = goombaPosList.pop();

			goomba = new Goomba(init.x, init.y, simulationLayer, GameData.goombaCollisions, init, end);
			GameData.goombas.add(goomba);
			addChild(goomba);
		}

		stage.addChild(GameData.simulationLayer);

		GameData.paragoombaCollisions=new CollisionGroup();
		var paragoombaPosList:List<FastVector2> = LevelPositions.getParagoombaPoints();
		var paragoombaCount = Math.floor(paragoombaPosList.length/4);

		var c1:FastVector2;
		var c2:FastVector2;

		for(i in 0...paragoombaCount){

			init = paragoombaPosList.pop();
			c1 = paragoombaPosList.pop();
			c2 = paragoombaPosList.pop();
			end = paragoombaPosList.pop();

			paragoomba = new Paragoomba(init.x, init.y, simulationLayer, GameData.paragoombaCollisions, init, c1, c2, end);
			GameData.paragoombas.add(paragoomba);
			addChild(paragoomba);
		}
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

	private function powerUpScreenText(){
		powerUpText = new Text(fontType);
		powerUpText.x = Screen.getWidth()*0.5;
		powerUpText.y = 30;
        powerUpText.text = "Power up!";
        hudLayer.addChild(powerUpText);
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
			/*
			powerUp = new Flower(object.x, object.y, simulationLayer, GameData.PWACollisions);
			GameData.powerUps.add(powerUp);
			addChild(powerUp);
			*/
		}else
		if(compareName(object, "starPosition")){
			star = new Star(object.x, object.y, simulationLayer);
			addChild(star);
			/*
			powerUp = new Star(object.x, object.y, simulationLayer, GameData.PWACollisions);
			GameData.powerUps.add(powerUp);
			addChild(powerUp);
			*/
		}else
		if(compareName(object, "winZone")){
			winZone = new CollisionBox();
			winZone.x = object.x;
			winZone.y = object.y;
			winZone.width = object.width;
			winZone.height = object.height;
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

	function bulletVSGoomba(bulletC:ICollider, invaderC:ICollider) {
        var enemy:Goomba = cast invaderC.userData;
        var bullet:Bullet = cast bulletC.userData;
        
		
        if(!(bullet.isDead())){
            enemy.die();
            enemyCount++;
			score.text = "Score: " + enemyCount;
            bullet.die();
        }
		
    }

	function bulletVSParagoomba(bulletC:ICollider, invaderC:ICollider) {
        var enemy:Paragoomba = cast invaderC.userData;
        var bullet:Bullet = cast bulletC.userData;
        
        if(!(bullet.isDead())){
            enemy.die();
            enemyCount++;
			score.text = "Score: " + enemyCount;
            bullet.die();
        }
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

	function chivitoVsParagoomba(playerC:ICollider, invaderC:ICollider) {
		if((!(star == null)) && (star.isActive())){
			for(paragoomba in GameData.paragoombas){
				if(!(paragoomba.isDead())){
					paragoomba.damage();
					paragoomba.die();
					enemyCount++;
					score.text = "Score: " + enemyCount;
				}
			}
		}else{
			for(paragoomba in GameData.paragoombas){
				if(!(paragoomba.isDead())){
					chivito.die();
					changeState(new EndGame(false, 1));
				}
			}
		}
	}
	

	function flowerPowerUp(playerC:ICollider, invaderC:ICollider) {
		powerUpScreenText();
		//TODO: Hacer que chivito empiece a disparar balas
		flower.powerUpUsed();
		chivito.setFireMode();
	}

	function starPowerUp(playerC:ICollider, invaderC:ICollider) {
		powerUpScreenText();
		star.activate();
		star.powerUpUsed();
	}

	/*
	function activatePowerUps(playerC:ICollider, invaderC:ICollider) {
		powerUpScreenText();

		for(powerUp in GameData.powerUps){
			if(powerUp.collision == invaderC){ //Esto nunca va a andar
				if(powerUp.powerUpType == 'FLOWER'){
					chivito.setFireMode();
				}
				if(powerUp.powerUpType == 'STAR'){
					chivito.setStarChivito();
				}
				powerUp.activate();
				powerUp.powerUpUsed();
			}
		}
		
	}
	*/

	override function update(dt:Float) {
		super.update(dt);

		stage.defaultCamera().setTarget(chivito.collision.x, chivito.collision.y);

		CollisionEngine.collide(chivito.collision,worldMap.collision);
		
		CollisionEngine.collide(GameData.goombaCollisions,worldMap.collision);

		CollisionEngine.collide(GameData.paragoombaCollisions,worldMap.collision);

		/*
		for(powerUp in GameData.powerUps){
			CollisionEngine.collide(powerUp.collision,worldMap.collision);
		}
		*/

		if(!(flower == null)){
			CollisionEngine.collide(flower.collision,worldMap.collision);
		}

		if(!(star == null)){
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

		CollisionEngine.overlap(chivito.collision, GameData.paragoombaCollisions, chivitoVsParagoomba);

		CollisionEngine.overlap(GameData.bulletCollisions, GameData.goombaCollisions, bulletVSGoomba);

		CollisionEngine.overlap(GameData.bulletCollisions, GameData.paragoombaCollisions, bulletVSParagoomba);
		
		//CollisionEngine.overlap(chivito.collision, GameData.PWACollisions, activatePowerUps);
		
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