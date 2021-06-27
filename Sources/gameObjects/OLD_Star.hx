package gameObjects;

import com.collision.platformer.CollisionGroup;
import com.framework.utils.Entity;
import com.gEngine.display.Sprite;
import com.gEngine.display.Layer;
import com.collision.platformer.CollisionBox;

class Star extends PowerUp
{
    public function new(x:Float,y:Float,layer:Layer,collisionGroup:CollisionGroup) 
    {
        super('STAR');
        display=new Sprite("star");
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
        
        isActivated = false;
    }

    override function update(dt:Float) {
		super.update(dt);
		collision.update(dt);
	}

    override function render() {
		display.x = collision.x;
		display.y = collision.y;	
	}

    override function powerUpUsed() {
        super.destroy();
        display.removeFromParent();
        collision.removeFromParent();
    }
}