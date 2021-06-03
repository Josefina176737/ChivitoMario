package states;

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

class InitState extends State {
    var winState:Bool;
    var enemyKillCount:Int;
    var fontType:String = "AmaticB";

    public function new() {
        super();
    }

    override function load(resources:Resources) {
        var atlas = new JoinAtlas(1024, 1024);
        atlas.add(new FontLoader(fontType,70));
        atlas.add(new ImageLoader("TitleScreen"));
        resources.add(atlas);     

    }

    override function init() {
        var text = new Text(fontType);
        text.x = Screen.getWidth()*0.5+150;
        text.y = Screen.getHeight()*0.5-120;

        var textRestart = new Text(fontType);
        textRestart.x = Screen.getWidth()*0.5-200;
        textRestart.y = Screen.getHeight()*0.5+200;

        var image = new Sprite("TitleScreen");
        image.x = Screen.getWidth()*0.5-200;
        image.y = Screen.getHeight()*0.5-200;
        
        text.text = "... like";
        textRestart.text = "Press spacebar to start";
        
        stage.addChild(image);
        stage.addChild(text);
        stage.addChild(textRestart);
    }

    override function update(dt:Float) {
        super.update(dt);
        if(Input.i.isKeyCodePressed(KeyCode.Space)){
            this.changeState(new GameState("screen_1_tmx",1,"tiles1"));
        }
    }
}