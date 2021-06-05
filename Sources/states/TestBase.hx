package states;

import com.gEngine.helper.RectangleDisplay;
import paths.Complex;
import paths.Bezier;
import kha.math.FastVector2;
import paths.Linear;
import paths.PathWalker;
import com.framework.utils.State;

class TestBase extends State {
    var pathWalker:PathWalker;
    var display:RectangleDisplay;

    override function init() {
        var path = new Linear(new FastVector2(300,200),new FastVector2(400,100));
        var path2 = new Bezier(new FastVector2(100,100),new FastVector2(240,80),new FastVector2(140,220),new FastVector2(300,200));
        var complexPath = new Complex([path2,path]);
        pathWalker = new PathWalker(complexPath, 10, PlayMode.Pong);

        display = new RectangleDisplay();
        display.scaleX = 10;
        display.scaleY = 10;
        display.setColor(255,0,0);
        
        stage.addChild(display);
    }

    override function update(dt:Float) {
        super.update(dt);
        pathWalker.update(dt);
    }

    override function render() {
        super.render();
        display.x = pathWalker.x;
        display.y = pathWalker.y;
    }
}