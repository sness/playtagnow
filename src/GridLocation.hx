//
// Holds a single grid location
//

class GridLocation { 

	var _grid_x : Int;
	var _grid_y : Int;

	public function new (?grid_x_:Int = 0, ?grid_y_:Int = 0) {
		_grid_x = grid_x_;
		_grid_y = grid_y_;
	}

	public function getGridX():Int { 
		return _grid_x;
	}

	public function getGridY():Int { 
		return _grid_y;
	}

	public function setGridXY(x:Int, y:Int) {
		_grid_x = x;
		_grid_y = y;
	}

}