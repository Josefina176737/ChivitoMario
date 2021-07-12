package gameObjects;

import com.framework.utils.Entity;
import com.gEngine.display.Sprite;
import com.gEngine.display.Layer;
import com.collision.platformer.CollisionBox;

class Star extends Entity
{
    public var display:Sprite;
    public var collision:CollisionBox;
    var isActivated:Bool;

    public function new(x:Float,y:Float,layer:Layer) 
    {
        super();
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

    public function activate(){
        isActivated = true;
    }

    public function deactivate(){
        isActivated = false;
    }

    public function isActive():Bool{
        return isActivated;
    }

    public function powerUpUsed() {
        super.destroy();
        display.removeFromParent();
        collision.removeFromParent();
    }
}