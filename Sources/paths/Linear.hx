package paths;

import kha.math.FastVector2;

class Linear implements Path {
    var start:FastVector2;
    var end:FastVector2;

    var temp:FastVector2;
    
    public function new(start:FastVector2, end:FastVector2) {
        this.start = start;
        this.end = end;
        this.temp = new FastVector2();        
    }

	public function getPos(s:Float):FastVector2 {
		//var result = start.add(end.sub(start).mult(s)); //hacemos esto para evitar el new (haxe dependiente)
        //temp.setFrom(result);
        //return result;

        temp.x = start.x + (end.x - start.x) * s; //Calculandolo a mano sin usar las funciones de Haxe de vectores.
        temp.y = start.y + (end.y - start.y) * s;
        
        return temp;
	}

	public function getLength():Float {
		//return end.sub(start).length;

        var deltaX = end.x - start.x;
        var deltaY = end.y - start.y;

        return Math.sqrt(deltaX * deltaX + deltaY * deltaY);
	}
}