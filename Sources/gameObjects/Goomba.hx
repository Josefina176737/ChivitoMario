package gameObjects;

import com.collision.platformer.Sides;
import com.gEngine.display.Layer;
import paths.Complex;
import paths.Bezier;
import paths.Linear;
import com.gEngine.helper.RectangleDisplay;
import com.collision.platformer.CollisionGroup;
import kha.math.FastVector2;
import com.collision.platformer.CollisionBox;
import com.gEngine.display.Sprite;
import paths.PathWalker;
import com.framework.utils.Entity;

class Goomba extends Entity
{
	private var pathWalker:PathWalker;
	public var display:Sprite;
	public var collision:CollisionBox;
	var dying:Bool;
	var dir:FastVector2;
	
	public function new(x:Float,y:Float,layer:Layer, collisionGroup:CollisionGroup) 
	{
		super();
		display=new Sprite("goomba");
		display.smooth = false;
		layer.addChild(display);
		collision = new CollisionBox();
		collision.width = display.width();
		collision.height = display.height();
		display.pivotX=display.width()*0.5;
		
		display.scaleX = display.scaleY = 1;
		collision.x=x;
		collision.y=y;

		collision.userData = this;
		 
		collision.accelerationY = 2000;
		collision.maxVelocityX = 500;
		collision.maxVelocityY = 800;
		collision.dragX = 0.9;
		collisionGroup.add(collision);

		//pathWalker = new PathWalker(GameData.levelPath,10,PlayMode.None); //Hay algo de aca que esta en nulo, el level path probablemente
		var goombaPosList:Array<FastVector2> = LevelPositions.getGoombaPoints();
		var init:FastVector2 = goombaPosList.pop();
		var end:FastVector2 = goombaPosList.pop();

		//var linearPath = new Linear(new FastVector2(500,613),new FastVector2(980,613));
		
		var linearPath = new Linear(init, end);
        pathWalker = new PathWalker(linearPath, 10, PlayMode.Pong);
		///---------------------------------------------------------
		//reset();
	}
	
	override public function update(dt:Float):Void 
	{
		if (dying)
		{
			if (!display.timeline.playing) {
				display.removeFromParent();
				die();
			}
		}else
		{
			pathWalker.update(dt);
			collision.x = pathWalker.x;
			collision.y = pathWalker.y;
			collision.update(dt);
			
			//dir.x = collision.x - collision.lastX;
			//dir.y = collision.y - collision.lastY;
			
			collision.update(dt);
			//if(pathWalker.finish()){
			//	die();
			//}
		}
		super.update(dt);
	}
	
	override function limboStart() {
		display.removeFromParent();
		collision.removeFromParent();
	}

	override function render() {
		var s = Math.abs(collision.velocityX / collision.maxVelocityX);
		display.timeline.frameRate = (1 / 24) * s + (1 - s) * (1 / 10);
		if (!dying)
		{
			display.timeline.playAnimation("walk");
		}

		display.x=collision.x;
		display.y=collision.y;
		super.render();
		
	}
	public function reset():Void 
	{
		//dying = false;
 	    //GameData.simulationLayer.addChild(display);
		//GameData.enemyCollisions.add(collision);
		//display.timeline.playAnimation("walkSide");
	}
	
	private var mDeath:Bool;
	
	public function damage():Void
	{
		display.timeline.playAnimation("death",false);
		collision.removeFromParent(); // ya no le puedo disparar
		dying = true;
	}
}