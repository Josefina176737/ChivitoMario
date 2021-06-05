package gameObjects;

import com.framework.utils.Entity;

class Toadd_EnemySpawner extends Entity
{
	public function new() {
		super();
		pool=true;
	}
	private var mTime:Float=0;
	override public function update(dt:Float):Void 
	{
		/*
		mTime-= dt;
		if (mTime < 0)
		{
			(cast recycle(Goomba)).reset();
			mTime = Math.random()+0.5;
		}
		super.update(dt);
		*/
	}
	
}