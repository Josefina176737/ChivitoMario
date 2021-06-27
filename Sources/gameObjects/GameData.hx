package gameObjects;

import com.collision.platformer.CollisionGroup;
import com.gEngine.display.Layer;
import paths.Path;

class GameData {
	public static var levelPath:Path;
	public static var simulationLayer:Layer;
	public static var HUDLayer:Layer;
	public static var goombaCollisions:CollisionGroup;
	public static var paragoombaCollisions:CollisionGroup;
	public static var PWACollisions:CollisionGroup;
	public static var goombas:List<Goomba> = new List();
	public static var paragoombas:List<Paragoomba> = new List();
	public static var powerUps:List<PowerUp> = new List();

	public static function clear():Void {
		levelPath = null;
		HUDLayer = null;
		simulationLayer = null;
		goombaCollisions = null;
		PWACollisions = null;
		goombas = null;
		paragoombas = null;
		powerUps = null;
	}
}
