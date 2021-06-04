package states;

import com.collision.platformer.CollisionBox;
import helpers.Tray;
import com.gEngine.display.extra.TileMapDisplay;
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

class GameState extends State {
	var worldMap:Tilemap;
	var chivito:ChivitoBoy;
	var simulationLayer:Layer;
	var touchJoystick:VirtualGamepad;
	var tray:helpers.Tray;
	var mayonnaiseMap:TileMapDisplay;
	var winZone:CollisionBox;
	var winZone1:CollisionBox;
	var room:String;
	var roomNbr:Int;
	var tileSet:String;

	public function new(room:String, roomNbr:Int, tileSet:String) {
		super();
		this.room = room;
		this.roomNbr = roomNbr;
		this.tileSet = tileSet;
	}

	override function load(resources:Resources) {
		resources.add(new DataLoader(room));
		var atlas = new JoinAtlas(2048, 2048);

		atlas.add(new TilesheetLoader(tileSet, 32, 32, 0));
		atlas.add(new SpriteSheetLoader("hero", 45, 60, 0, [
			new Sequence("fall", [0]),
			new Sequence("slide", [0]),
			new Sequence("jump", [1]),
			new Sequence("run", [2, 3, 4, 5, 6, 7, 8, 9]),
			new Sequence("idle", [10]),
			new Sequence("wallGrab", [11])
		]));
		resources.add(atlas);
	}

	override function init() {
		stageColor(0.5, .5, 0.5);
		simulationLayer = new Layer();
		stage.addChild(simulationLayer);

		worldMap = new Tilemap(room, tileSet);
		worldMap.init(function(layerTilemap, tileLayer) {
			if (!tileLayer.properties.exists("noCollision")) {
				layerTilemap.createCollisions(tileLayer);
			}
			simulationLayer.addChild(layerTilemap.createDisplay(tileLayer));
			 mayonnaiseMap = layerTilemap.createDisplay(tileLayer);
			 simulationLayer.addChild(mayonnaiseMap);
		}, parseMapObjects);

		//tray = new Tray(mayonnaiseMap);
		//chivito = new ChivitoBoy(250, 200, simulationLayer);
		//addChild(chivito);

		stage.defaultCamera().limits(0, 0, worldMap.widthIntTiles * 32 * 1, worldMap.heightInTiles * 32 * 1);

		createTouchJoystick();
	}

	function parseMapObjects(layerTilemap:Tilemap, object:TmxObject) {
		if(compareName(object, "playerPosition")){
			if(chivito == null){
				chivito = new ChivitoBoy(object.x, object.y, simulationLayer);
				addChild(chivito);
			}	
		}else
		if(compareName(object, "winZone")){
			winZone = new CollisionBox();
			winZone.x = object.x;
			winZone.y = object.y;
			winZone.width = object.width;
			winZone.height = object.height;
		}
		
		/*
		if(compareName(object, "winZone1")){
				winZone1 = new CollisionBox();
				winZone1.x = object.x;
				winZone1.y = object.y;
				winZone1.width = object.width;
				winZone1.height = object.height;
		}
		*/
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

	override function update(dt:Float) {
		super.update(dt);

		stage.defaultCamera().setTarget(chivito.collision.x, chivito.collision.y);

		CollisionEngine.collide(chivito.collision,worldMap.collision);
		if(CollisionEngine.overlap(chivito.collision, winZone)){
			if(!(roomNbr == 3)){
				roomNbr++;
				room = "screen_" + roomNbr + "_tmx";
				tileSet = "tiles" + roomNbr;
				
				changeState(new GameState(room, roomNbr, tileSet));
			}else{
				changeState(new InitState());
			}
		}

		//tray.setContactPosition(chivito.collision.x + chivito.collision.width / 2, chivito.collision.y + chivito.collision.height + 1, Sides.BOTTOM);
		//tray.setContactPosition(chivito.collision.x + chivito.collision.width + 1, chivito.collision.y + chivito.collision.height / 2, Sides.RIGHT);
		//tray.setContactPosition(chivito.collision.x-1, chivito.collision.y+chivito.collision.height/2, Sides.LEFT);
	}

	#if DEBUGDRAW
	override function draw(framebuffer:kha.Canvas) {
		super.draw(framebuffer);
		var camera = stage.defaultCamera();
		CollisionEngine.renderDebug(framebuffer, camera);
	}
	#end
}
