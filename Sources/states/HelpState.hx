package states;

import com.loading.basicResources.SoundLoader;
import com.soundLib.SoundManager;
import com.gEngine.display.Sprite;
import com.loading.basicResources.ImageLoader;
import com.gEngine.helper.Screen;
import kha.input.KeyCode;
import com.framework.utils.Input;
import com.gEngine.display.Text;
import com.loading.basicResources.JoinAtlas;
import com.loading.basicResources.FontLoader;
import com.loading.Resources;
import com.framework.utils.State;

class HelpState extends State {
    var winState:Bool;
    var enemyKillCount:Int;
    var fontType:String = "AmaticB";

    public function new() {
        super();
    }

    override function load(resources:Resources) {
        var atlas = new JoinAtlas(1024, 1024);
        atlas.add(new FontLoader(fontType,70));
        atlas.add(new ImageLoader("Controls"));
        resources.add(atlas);
        resources.add(new SoundLoader("intro", false));
        resources.add(new SoundLoader("jump"));
    }

    override function init() {
        SM.playMusic("intro");

        var image = new Sprite("Controls");
        image.x = Screen.getWidth()*0.5-200;
        image.y = Screen.getHeight()*0.5-300;

        var textRestart = new Text(fontType);
        textRestart.x = Screen.getWidth()*0.5-180;
        textRestart.y = Screen.getHeight()*0.5+200;
        
        textRestart.text = "Press spacebar to start";
        SM.muteSound();

        stage.addChild(image);
        stage.addChild(textRestart);
    }

    override function update(dt:Float) {
        super.update(dt);
        if(Input.i.isKeyCodePressed(KeyCode.Space)){
            SM.unMuteSound();
            this.changeState(new GameState("screen_1_tmx",1,"tiles1", 0));
        }
    }
} 