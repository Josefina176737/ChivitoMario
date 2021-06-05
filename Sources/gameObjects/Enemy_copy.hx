package gameObjects;

import kha.math.FastVector2;
import com.collision.platformer.CollisionBox;
import com.gEngine.display.Sprite;
import paths.PathWalker;
import com.framework.utils.Entity;

class Enemy_copy extends Entity
{
	private var pathWalker:PathWalker;
	var display:Sprite;
	var collision:CollisionBox;
	var dying:Bool;
	var dir:FastVector2;
	
	public function new() 
	{
		super();
		
		collision=new CollisionBox();
		collision.userData=this;
		collision.width=20;
		collision.height=10;
		display=new Sprite("enemy_40x34_80f");
		display.timeline.playAnimation("walkSide");
		display.pivotX=25;
		display.pivotY=28;
		display.offsetX=-15;
		display.offsetY=-20;
		dir = new FastVector2(1,0);

		pathWalker = new PathWalker(GameData.levelPath,10,PlayMode.None);
		reset();
	}
	
	override public function update(dt:Float):Void 
	{
		if (dying)
		{
			if (!display.timeline.playing) {
				die();
			}
		}else
		{
			pathWalker.update(dt);
			
			collision.x = pathWalker.x;
			collision.y = pathWalker.y;
			
			dir.x = collision.x - collision.lastX;
			dir.y = collision.y - collision.lastY;
			
			collision.update(dt);
			if(pathWalker.finish()){
				die();
			}
		}
		super.update(dt);
	
	}
	override function limboStart() {
		display.removeFromParent();
		collision.removeFromParent();
	}
	override function render() {

		if (Math.abs(dir.x) >= Math.abs(dir.y))
			{	
				display.timeline.playAnimation("walkSide");
				if (dir.x > 0) 	
				{
					display.scaleX=1;
				}else {
					display.scaleX=-1;
				}
			}else {
				if (dir.y > 0)
				{
					display.timeline.playAnimation("walkDown");
				}else {
					display.timeline.playAnimation("walkUp");
				}
			}
		display.x=collision.x;
		display.y=collision.y;
		super.render();
		
	}
	public function reset():Void 
	{
		
		dying = false;
		GameData.simulationLayer.addChild(display);
		GameData.enemyCollisions.add(collision);
		display.timeline.playAnimation("walkSide");
	}
	
	private var mDeath:Bool;
	
	public function damage():Void
	{
		display.timeline.playAnimation("death",false);
		collision.removeFromParent(); // ya no le puedo disparar
		dying = true;
	}
}