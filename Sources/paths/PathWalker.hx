package paths;
import kha.math.FastVector2;

 enum PlayMode
 {
	 Loop;
	 Pong;
	 None;
 }
class PathWalker
{
	private var path:Path;
	private var totalTime:Float;
	private var time:Float=0;
	private var playMode:PlayMode;
	
	public var x(get, null):Float;
	public var y(get, null):Float;
	
	private var direction:Int = 1;
	
	private var position:FastVector2;
	
	public static function fromSpeed(path:Path, speed:Float, playMode:PlayMode):PathWalker
	{
		throw "not implemented";
	}
	public function new(path:Path,totalTime:Float,playMode:PlayMode) 
	{
		this.path = path;
		this.totalTime = totalTime;
		this.playMode = playMode;
		position = new FastVector2();
	}
	public function update(dt:Float):Void
	{
		time += dt*direction;
		var s = time / totalTime;
		if(s > 1){ //
			time = totalTime;
			if(playMode == PlayMode.None){
				s = 1;
			}else
			if(playMode == PlayMode.Loop){
				time = totalTime - time; //0
				s = (s - 1); //0
			}else
			if(playMode == PlayMode.Pong){
				direction = -1;
				s = 1 - (s - 1);
			}
		}
			
		if(s < 0){
			if(playMode == PlayMode.Pong){
				direction = 1;
				s = -s;
			}
		}
		trace(s);
		var currentPosition = path.getPos(s);
		trace(currentPosition.x);
		position.x = currentPosition.x;
		position.y = currentPosition.y;
	}
	private function nextPosition(dt:Float):Float
	{
		return 0;
	}
	private function get_x():Float
	{
		return position.x;
	}
	private function get_y():Float
	{
		return position.y;
	}
	public function finish():Bool
	{
		return time >= totalTime && playMode == PlayMode.None;
	}
	public function reset():Void
	{
	
	}
}