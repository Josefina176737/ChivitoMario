package gameObjects;

import com.collision.platformer.CollisionEngine;
import com.gEngine.display.Layer;
import com.gEngine.display.Sprite;
import com.collision.platformer.CollisionGroup;
import kha.math.FastVector2;
import com.collision.platformer.CollisionBox;
import com.framework.utils.Entity;
import gameObjects.GameData;

class Bullet extends Entity {
    public var display:Sprite;
    var collision:CollisionBox;
    var speed:Float = 10;
    var time:Float = 0;

    public function new(x:Float, y:Float, layer:Layer, dir:FastVector2, collisionGroup:CollisionGroup, bulletImage:Sprite) {
        super();

        display = new Sprite("flower");
		display.smooth = false;
		layer.addChild(display);
		collision = new CollisionBox();
		collision.width = display.width();
		collision.height = display.height()*0.5;
		display.pivotX=display.width()*0.5;
		display.offsetY = -display.height()*0.5;

        collision.x = x;
        collision.y = y;
        collision.userData = this;
        collision.velocityX = dir.x * speed;
        collision.velocityY = dir.y * speed;

        collisionGroup.add(collision);
        collision.userData = this;
    }

    override function update(dt:Float) {
        time+=dt;
        super.update(dt);
        
        CollisionEngine.collide(collision,GameData.map.collision);
        
        collision.update(dt);

        if(time > 2){
            die();
        }
    }

    override function render() {
        super.render();
        display.x = collision.x;
        display.y = collision.y;
    }

    override function destroy() {
        super.destroy();
        display.removeFromParent();
    }
}