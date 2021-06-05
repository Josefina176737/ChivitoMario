package gameObjects;

import com.gEngine.helper.RectangleDisplay;
import kha.math.FastVector2;
import com.framework.utils.Random;
import com.gEngine.display.Sprite;
import com.collision.platformer.CollisionGroup;
import com.framework.utils.Entity;

class Cannon extends Entity
{
	private var balls:Entity;
	private var mCurrentTime:Float;
	private static inline var MAXTIME:Float = 2;
	private static inline var MINTIME:Float = 1;
	var display:Sprite;

	public function new(x:Float,y:Float) 
	{
		super();
		
		balls = new Entity();
		balls.pool=true;
		addChild(balls);
		display=new RectangleDisplay();
		display.x=x;
		display.y=y;
		//display=new Sprite("cannon");
		GameData.simulationLayer.addChild(display);
		//mCurrentTime = Random.getRandomIn(MINTIME,MAXTIME);
		
	}
	override public function update(dt:Float):Void 
	{
		mCurrentTime-= dt;
		if (mCurrentTime <= 0)
		{
			mCurrentTime=Random.getRandomIn(MINTIME,MAXTIME);
			var cannonBall:CannonBall = cast balls.recycle(CannonBall);
			var end:FastVector2 = GameData.levelPath.getPos(Math.random());
			cannonBall.shoot(display.x + display.width() / 2,display.y, end.x, end.y);
		}
		super.update(dt);
	}
}