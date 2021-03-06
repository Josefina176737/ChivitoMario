package gameObjects;

import com.soundLib.SoundManager;
import com.loading.Resources;
import com.framework.utils.Input;
import com.collision.platformer.Sides;
import com.framework.utils.XboxJoystick;
import com.gEngine.display.Layer;
import com.collision.platformer.CollisionBox;
import com.gEngine.display.Sprite;
import com.framework.utils.Entity;
import kha.input.KeyCode;
import kha.math.FastVector2;

class ChivitoBoy extends Entity {
	public var display:Sprite;
	public var collision:CollisionBox;
	private var starActivated:Bool;
	private var fireModeActivated:Bool;
	var facingDir:FastVector2 = new FastVector2(2, 1);

	var maxSpeed = 200;

	var lastWallGrabing:Float=0;
	var sideTouching:Int;
	var layerDisplay:Layer;

	public function new(x:Float,y:Float,layer:Layer,resources:Resources) {
		super();
		display = new Sprite("hero");
		display.smooth = false;
		this.layerDisplay = layer;
		layer.addChild(display);
		collision = new CollisionBox();
		collision.width = display.width();
		collision.height = display.height()*0.5;
		display.pivotX=display.width()*0.5;
		display.offsetY = -display.height()*0.5;
		
		display.scaleX = display.scaleY = 1;
		collision.x=x;
		collision.y=y;

		collision.userData = this;

		collision.accelerationY = 2000;
		collision.maxVelocityX = 500;
		collision.maxVelocityY = 800;
		collision.dragX = 0.9;

		fireModeActivated = false;
	}

    function updateFacingDir() {      
        if(Input.i.isKeyCodeDown(KeyCode.Left)){
            facingDir.x += -1;
        }
        if(Input.i.isKeyCodeDown(KeyCode.Right)){
            facingDir.x += 1;
        }
		if(Input.i.isKeyCodeDown(KeyCode.Up)){
            facingDir.y += -1;
        }

        if(Input.i.isKeyCodeDown(KeyCode.Down)){
            facingDir.y += 1;
        }
    }

	override function update(dt:Float) {
		if(isWallGrabing()){
			lastWallGrabing=0;
			if(collision.isTouching(Sides.LEFT)){
				sideTouching=Sides.LEFT;
			}else{
				sideTouching=Sides.RIGHT;
			}
		}else{
			lastWallGrabing+=dt;
		}

		updateFacingDir();

		if((Input.i.isKeyCodePressed(KeyCode.X)) && fireModeActivated){
            SM.playFx("fireball");
			var bullet:Bullet = new Bullet(collision.x, collision.y, layerDisplay, facingDir, GameData.bulletCollisions);
            addChild(bullet);
        }

		super.update(dt);
		collision.update(dt);

	}
	override function render() {
		super.render();
		var s = Math.abs(collision.velocityX / collision.maxVelocityX);
		display.timeline.frameRate = (1 / 24) * s + (1 - s) * (1 / 10);
		if (isWallGrabing()) {
			display.timeline.playAnimation("wallGrab");
		} else if (collision.isTouching(Sides.BOTTOM) && collision.velocityX * collision.accelerationX < 0) {
			display.timeline.playAnimation("slide");
		} else if (collision.isTouching(Sides.BOTTOM) && collision.velocityX == 0) {
			display.timeline.playAnimation("idle");
		} else if (collision.isTouching(Sides.BOTTOM) && collision.velocityX != 0) {
			display.timeline.playAnimation("run");
		} else if (!collision.isTouching(Sides.BOTTOM) && collision.velocityY > 0) {
			display.timeline.playAnimation("fall");
		} else if (!collision.isTouching(Sides.BOTTOM) && collision.velocityY < 0) {
			display.timeline.playAnimation("jump");
		}
		display.x = collision.x;
		display.y = collision.y;
		
	}

	

	public function onButtonChange(id:Int, value:Float) {
		if (id == XboxJoystick.LEFT_DPAD) {
			if (value == 1) {
				collision.accelerationX = -maxSpeed * 4;
				display.scaleX = Math.abs(display.scaleX);
			} else {
				if (collision.accelerationX < 0) {
					collision.accelerationX = 0;
				}
			}
		}
		if (id == XboxJoystick.RIGHT_DPAD) {
			if (value == 1) {
				collision.accelerationX = maxSpeed * 4;
				display.scaleX = -Math.abs(display.scaleX);
			} else {
				if (collision.accelerationX > 0) {
					collision.accelerationX = 0;
				}
			}
		}
		if (id == XboxJoystick.A) {
			if (value == 1) {
				SM.playFx("jump");
				if (collision.isTouching(Sides.BOTTOM)) {
					collision.velocityY = -1000;
				} else if (isWallGrabing() || lastWallGrabing < 0.2) {
					if (sideTouching== Sides.LEFT) {
						collision.velocityX = 500;
					} else {
						collision.velocityX = -500;
					}
					collision.velocityY = -1000;
				}
			}
		}
		
	}

	public function setFireMode(){
		fireModeActivated = true;
	}

	public function setStarChivito(){
		starActivated = true;
	}

	public function isStarActivated() {
		return starActivated;
	}

	inline function isWallGrabing():Bool {
		return !collision.isTouching(Sides.BOTTOM) && (collision.isTouching(Sides.LEFT) || collision.isTouching(Sides.RIGHT));
	}

	public function onAxisChange(id:Int, value:Float) {

	}
}
