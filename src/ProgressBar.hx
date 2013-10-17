import flash.display.Loader;
import flash.display.Sprite;
import flash.display.Shape;
import flash.display.Bitmap;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.net.URLRequest;
import flash.filters.ColorMatrixFilter;
import flash.geom.Point;


class ProgressBar extends Sprite {

	public var _well : Sprite;     // A holder for everything
 	private var _slider : Loader;  // The _slider indicator
	var _loaded_background : Shape; // The background of the _loaded bar
	var _loaded_indicator : Shape;  // The progress indicator of the _loaded bar

	public var _position : Float;  // _Position that we are at in the sound file
	public var _loaded : Float;    // Amount of the sound file that is _loaded
	private var _ready : Int;      // Have all the Loaders finished loading?

	public var _mouse_down : Bool; // Is the mouse currently down?
	static var _point : Point;
	static var _local_point : Point;

	static var _selector_height;
	static var _selector_width;

	static var _height : Int;
	static var _width  : Int;
	private var _sound_player : SoundPlayer;

	public function new(x_:Int, y_:Int, width_:Int, height_:Int, sound_player_:SoundPlayer) {
		super();

		_width = width_;
		_height = height_;
		x = x_;
		y = y_;
		_sound_player = sound_player_;

		_selector_height = _height;
		_selector_width = _width;

		_position = 0;
		_loaded = 0;
		_ready = 0;

		// Register mouse events with the main ancestor stage
  		flash.Lib.current.stage.addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
  		flash.Lib.current.stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
  		flash.Lib.current.stage.addEventListener(MouseEvent.MOUSE_UP, mouseUp);

		// _Well to hold everything
		_well = new Sprite();

 		// _Slider
 		_slider = new Loader();
 		_slider.visible = false;
 		_slider.contentLoaderInfo.addEventListener(Event.INIT, initListener);
 		_slider.load(new URLRequest("/src/library/slider.png"));

		// The background of the _loaded bar
		_loaded_background = new Shape();
		_loaded_background.graphics.lineStyle(0);
		_loaded_background.graphics.beginFill(0xAAAAAA,1);
		_loaded_background.graphics.drawRect(0,0,_width,_height);
		_well.addChild(_loaded_background);

		// The indicator of the _loaded bar
		_loaded_indicator = new Shape();
		_loaded_indicator.graphics.lineStyle(0);
		_loaded_indicator.graphics.beginFill(0xAAFFAA,1);
		_loaded_indicator.graphics.drawRect(0,0,1,_height);
		_well.addChild(_loaded_indicator);

		addChild(_well);
	}

	private function initListener (e:Event):Void {
 		_well.addChild(_slider.content);
		_slider.content.x = 0;
		_ready = 1;
		redraw();
 	}

 	function mouseDown (e:MouseEvent):Void {
		if (e.target == _well) {
			_mouse_down = true;
			_position = e.localX / _selector_width;
			redraw();
		}
 	}

 	function mouseUp (e:MouseEvent):Void {
		_mouse_down = false;
 	}

 	function mouseMove (e:MouseEvent):Void {
		if (_mouse_down == true) {
			if (e.target == _well) {
				_position = e.localX / _selector_width;
			}
// 			if (e.target == this.stage) {
// 				_point.x = e.localX;
// 				_point.y = e.localY;
// 				_local_point = _well.globalToLocal(_point);
// 				if (_local_point.x > _selector_width) {
// 					_position = 1.0;
// 				} else if (_local_point.x < 0) {
// 					_position = 0.0;
// 				} else {
// 					_position = _local_point.x / _selector_width;
// 				}
// 			}
			redraw();
		}
	}

	public function redraw():Void {
		if (_ready == 1) {
			_slider.content.x = _position * _width - 8;
		}
 		_loaded_indicator.width = _loaded * _width;
	}

}