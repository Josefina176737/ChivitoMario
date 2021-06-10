package gameObjects;

import kha.math.FastVector2;

class LevelPositions
{
	public static function getGoombaPoints():List<FastVector2>
	{
		var goombaPosList:List<FastVector2> = new List<FastVector2>();
		//2nd goomba
		goombaPosList.push(new FastVector2(880, 650));
		goombaPosList.push(new FastVector2(600, 650));
		
		//1st goomba
		goombaPosList.push(new FastVector2(980, 650));
		goombaPosList.push(new FastVector2(500, 650));

		return goombaPosList;
	}
}
