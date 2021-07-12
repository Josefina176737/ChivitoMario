package gameObjects;

import com.framework.utils.Entity;
import com.gEngine.display.Sprite;
import com.collision.platformer.CollisionBox;

class PowerUp extends Entity
{
    public var collision:CollisionBox; 
    public var powerUpType:String;
    public var isActivated:Bool;
    public var display:Sprite;

    public function new(powerUpType:String) 
    {
        super();
        this.powerUpType = powerUpType;
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
    }
}