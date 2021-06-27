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

	public static function getParagoombaPoints():List<FastVector2>
		{
			var paragoombaPosList:List<FastVector2> = new List<FastVector2>();
			//1st paragoomba
			paragoombaPosList.push(new FastVector2(1100, 590));
			paragoombaPosList.push(new FastVector2(1000, 400));
			paragoombaPosList.push(new FastVector2(800, 450));
			paragoombaPosList.push(new FastVector2(600, 650));

			return paragoombaPosList;
		}
}
