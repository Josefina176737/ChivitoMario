package states;

import gameObjects.Goomba;
import com.collision.platformer.ICollider;
import com.framework.utils.Entity;
import com.collision.platformer.CollisionEngine;
import com.collision.platformer.CollisionGroup;
import com.gEngine.display.Layer;
import gameObjects.LevelPositions;
import gameObjects.GameData;
import com.loading.basicResources.SpriteSheetLoader;
import com.gEngine.display.Sprite;
import com.loading.basicResources.ImageLoader;
import com.gEngine.display.IAnimation;
import com.loading.basicResources.JoinAtlas;
import com.loading.Resources;
import kha.math.FastVector2;
import paths.Path;
import paths.Linear;
import paths.Complex;
import paths.Bezier;
import com.framework.utils.State;
//import gameObjects.EnemySpawner;
import gameObjects.Cannon;

class Kingdom extends State {

    var time:Float=0;
    var totalTime:Float=4;
    var path:Path;
    override function load(resources:Resources) {
        var atlas:JoinAtlas = new JoinAtlas(1024,1024);
        atlas.add(new ImageLoader("background"));
        atlas.add(new ImageLoader("cannon"));
        atlas.add(new SpriteSheetLoader("explosion_52x65_19f",51,64,0,[Sequence.at("ball",0,0),Sequence.at("explode",1,19)]));
        atlas.add(new SpriteSheetLoader("enemy_40x34_80f",40,34,0,[Sequence.at("walkSide",0,21),Sequence.at("walkUp",22,43),Sequence.at("walkDown",44,65),Sequence.at("death",66,79)]));
        resources.add(atlas);
    }
    public function new() {
        super();
    }    
    override function init() {
       stage.addChild(new Sprite("background"));
       var points = LevelPositions.getLevelPathPoints();
       var levelPathPoints:Array<Path> = new Array();
       for(i in 0...(points.length-1)){
            levelPathPoints.push(new Linear(points[i],points[i+1]));
       }
       GameData.levelPath = new Complex(levelPathPoints);
       GameData.simulationLayer=new Layer();
       GameData.explosionGroup=new CollisionGroup();
       GameData.enemyCollisions=new CollisionGroup();

       var cannonsPositions=LevelPositions.getCannonPoints();
       for(pos in cannonsPositions){
           addChild(new Cannon(pos.x,pos.y));
       }

       stage.addChild(GameData.simulationLayer);
       //addChild(new EnemySpawner());
    }
    override function update(dt:Float) {
        super.update(dt);

        CollisionEngine.overlap(GameData.enemyCollisions,GameData.explosionGroup,enemyVsExplosion);
        GameData.explosionGroup.colliders.splice(0,GameData.explosionGroup.colliders.length);
    }
    function enemyVsExplosion(enemyCollider:ICollider,explosionCollider:ICollider) {
        var enemy:Goomba=cast enemyCollider.userData;
        //enemy.damage();
    }
    #if DEBUGDRAW
    override function draw(framebuffer:kha.Canvas) {
        super.draw(framebuffer);
        var camera=stage.defaultCamera();
        CollisionEngine.renderDebug(framebuffer,camera);
    }
    #end
}
