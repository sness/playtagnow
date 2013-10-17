import flash.events.MouseEvent;
import flash.events.Event;
import flash.events.ProgressEvent;
import flash.events.IOErrorEvent;
import flash.display.Stage;
import flash.display.Sprite;
import flash.display.Shape;
import flash.display.SimpleButton;
import flash.media.Sound;
import flash.media.SoundChannel;
import flash.net.URLRequest;

class Visualization extends Sprite {

	var _well : Sprite;
	var _background : Shape;
	var _light_up : Shape;

	var _width  : Float;
	var _height : Float;

	var _grid_size_x : Int;
	var _grid_size_y : Int;

	var _grid_x : Int;
	var _grid_y : Int;

	static var _currently_playing_clip_index:Int;
	static var _currently_playing_x:Int;
	static var _currently_playing_y:Int;

	public function new (x_:Int, y_:Int, width_:Int, height_:Int) {
		super();

		x = x_;
		y = y_;
		_width = width_;
		_height = height_;

		_currently_playing_clip_index = -1;
		_currently_playing_x = -1;
		_currently_playing_y = -1;

		// Get properties from GlobalSettings
		_grid_size_x = GlobalSettings.getGridSizeX();
		_grid_size_y = GlobalSettings.getGridSizeY();

		// Well to hold everything
		_well = new Sprite();
		this.addChild(_well);

		// Create the background
 		_background = new Shape();
   		_background.graphics.beginFill(0xFFFFFF,1);
		_background.graphics.lineStyle(1,0x333333);
   		_background.graphics.moveTo(0,0);
   		_background.graphics.lineTo(_width,0);
   		_background.graphics.lineTo(_width,_height);
   		_background.graphics.lineTo(0,_height);
   		_background.graphics.lineTo(0,0);
 		_well.addChild(_background);

		// Create the background
 		_light_up = new Shape();
 		_well.addChild(_light_up);

		addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveListener);
		addEventListener(MouseEvent.MOUSE_DOWN, mouseDownListener);
	}

 	function mouseMoveListener(e:MouseEvent):Void {
		determineGridPosition(e.localX,e.localY);
		lightUpPopularArtistGridLocations();
	}

 	function mouseDownListener(e:MouseEvent):Void {
		determineGridPosition(e.localX,e.localY);
		var most_popular_artist = Clips.getMostPopularArtistAtXY(_grid_x,_grid_y);
		SongList.populateWithArtist(most_popular_artist);

		changeToNextClip();
	}

	// Change the song to the next clip in this grid location
	//
	// The next clip can either be by just the most popular artist in this
	// grid location, or 
	function changeToNextClip():Void {

		var num_clips = Clips.getNumClipsXY(_grid_x,_grid_y);

		// Has the user clicked on a different square?
		if ((_grid_x != _currently_playing_x) && (_grid_y != _currently_playing_y)) {
			_currently_playing_clip_index = 0;
			_currently_playing_x = _grid_x;
			_currently_playing_y = _grid_y;
		} else {
			_currently_playing_clip_index += 1;
			_currently_playing_clip_index %= 1;
		}

// 		CurrentSong.changeSong(_clip);

	}

	function determineGridPosition(x_:Float, y_:Float) {
		// Determine which grid location we are pointing at
		_grid_x = Std.int((x_ / _width) * _grid_size_x);
		_grid_y = Std.int((y_ / _width) * _grid_size_y);

		// Handle the edge case of when we are at the far edges of the object
		if (_grid_x >= _grid_size_x) {
			_grid_x = _grid_size_x - 1;
		}

		if (_grid_y >= _grid_size_y) {
			_grid_y = _grid_size_y - 1;
		}

	}

	//
	// Draw a rectangle for each grid location that has the same artist as the
	// most popular artist in this grid location
	//
	function lightUpPopularArtistGridLocations() {

		var a : Array<GridLocation> = Clips.getAllGridLocationsForMostPopularArtistAtXY(_grid_x,_grid_y);
		
		_light_up.graphics.clear();
   		_light_up.graphics.beginFill(0xFF0000,1);

		for (n in a) {
			var x_ : Float = (n.getGridX() / _grid_size_x) * _width;
			var y_ : Float = (n.getGridY() / _grid_size_y) * _width;
			var w_ : Float = _width / _grid_size_x;
			var h_ : Float = _width / _grid_size_y;

			_light_up.graphics.moveTo(x_,y_);
			_light_up.graphics.lineTo(x_+w_,y_);
			_light_up.graphics.lineTo(x_+w_,y_+h_);
			_light_up.graphics.lineTo(x_,y_+h_);
			_light_up.graphics.lineTo(x_,y_);
		}
	}

	function tracer():Void {
// 		var a:Array<String> = Clips.getClipIndicesAtXY(_grid_x,_grid_y);
// 		trace(a);

// 		trace(Clips.getMostPopularArtistAtXY(_grid_x,_grid_y));
// 		var a : Array<GridLocation> = Clips.getAllGridLocationsForMostPopularArtistAtXY(_grid_x,_grid_y);
// 		for (n in a) {
// 			trace(n.getGridX() + " " + n.getGridY());
// 		}
		
	}
	

}