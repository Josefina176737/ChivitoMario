package gameObjects;

import com.gEngine.helper.RectangleDisplay;
import com.collision.platformer.CollisionBox;
import com.TimeManager;
import com.gEngine.display.Sprite;
import com.framework.utils.Entity;
import kha.math.FastVector2;
import paths.Bezier;
import paths.PathWalker;


class CannonBall extends Entity
{

	
	
	//var shadow:Shadow = new Shadow();
	var display:Sprite;
	var collision:CollisionBox;
	
	public function new() 
	{
		super();

		display = new RectangleDisplay();
		GameData.simulationLayer.addChild(display);
		display.x = 50;
		display.y = 50;
		/*
		display = new Sprite("explosion_52x65_19f");
		display.timeline.playAnimation("ball");
		display.offsetX=-24;
		display.offsetY=-50;
		display.pivotX=24.5;
		display.pivotY=51;
		GameData.simulationLayer.addChild(display);
		*/
		
		
		collision=new CollisionBox();
		collision.width=40;
		collision.height=40;
	}
	
	public function shoot(startX:Float,startY:Float,endX:Float,endY:Float):Void
	{
		
		//display.timeline.playAnimation("ball");
		GameData.simulationLayer.addChild(display);
	}
	override function limboStart() {
		display.removeFromParent();
	}
	override public function update(dt:Float):Void 
	{
		if(!display.timeline.playing){
			die();
		}else if(display.timeline.currentAnimation!="explode"){
			display.rotation=TimeManager.time*0.5;
			
		}
		else
		//if (pathWalker.finish()&&display.timeline.currentAnimation!="explode")
		{
			display.rotation=0;
			display.timeline.playAnimation("explode",false);
			//collision.x = pathWalker.x-collision.width*0.5;
			//collision.y = pathWalker.y-collision.height*0.5;
			GameData.explosionGroup.add(collision);
		}
		
		
		super.update(dt);
	}
}