package states;

import com.loading.basicResources.SoundLoader;
import com.soundLib.SoundManager;
import com.gEngine.helper.Screen;
import kha.input.KeyCode;
import com.framework.utils.Input;
import com.gEngine.display.Text;
import com.loading.basicResources.JoinAtlas;
import com.loading.basicResources.FontLoader;
import com.loading.Resources;
import com.framework.utils.State;

class EndGame extends State {
    var winState:Bool;
    var enemyKillCount:Int;
    var fontType:String = "AmaticB";

    public function new(winState:Bool, enemyKillCount:Int) {
        this.winState = winState;
        this.enemyKillCount = enemyKillCount;
        super();
    }

    override function load(resources:Resources) {
        var atlas = new JoinAtlas(512, 512);
        atlas.add(new FontLoader(fontType,50));
        resources.add(atlas);
        resources.add(new SoundLoader("smb_mariodie", false));
    }

    override function init() {
        var text = new Text(fontType);
        text.x = Screen.getWidth()*0.5-250;
        text.y = Screen.getHeight()*0.5-200;

        var textTotalPoints = new Text(fontType);
        textTotalPoints.x = Screen.getWidth()*0.5-250;
        textTotalPoints.y = Screen.getHeight()*0.5-100;

        var textRestart = new Text(fontType);
        textRestart.x = Screen.getWidth()*0.5-350;
        textRestart.y = Screen.getHeight()*0.5+180;


        if(!winState){
            SM.playMusic("smb_mariodie", false);
            text.text = "Y o u    l o s t !";
            textTotalPoints.text = "#Kill: " + enemyKillCount;
            textRestart.text = "P r e s s  s p a c e b a r  t o  r e s t a r t";
        }

        stage.addChild(text);
        stage.addChild(textTotalPoints);
        stage.addChild(textRestart);
    }

    override function update(dt:Float) {
        super.update(dt);
        if(Input.i.isKeyCodePressed(KeyCode.Space)){
            this.changeState(new GameState("screen_1_tmx",1,"tiles1",0));
        }
    }
}