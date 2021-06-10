package gameObjects;

import com.collision.platformer.CollisionGroup;
import com.gEngine.display.Layer;
import paths.Path;

class GameData {
	public static var levelPath:Path;
	public static var simulationLayer:Layer;
	public static var HUDLayer:Layer;
	public static var goombaCollisions:CollisionGroup;
	public static var goombas:List<Goomba> = new List();

	public static function clear():Void {
		levelPath = null;
		HUDLayer = null;
		simulationLayer = null;
		goombaCollisions = null;
		goombas = null;
	}
}
