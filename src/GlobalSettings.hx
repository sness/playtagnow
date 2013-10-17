import flash.display.Loader;
import flash.display.Sprite;
import flash.display.Bitmap;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.net.URLRequest;

class GlobalSettings {

	// The size of the grid
	static var _grid_size_x : Int;
	static var _grid_size_y : Int;

	public function new() {
		
		_grid_size_x = 20;
		_grid_size_y = 20;
	}


	public static function getGridSizeX():Int {
		return _grid_size_x;
	}

	public static function getGridSizeY():Int {
		return _grid_size_y;
	}


   

}