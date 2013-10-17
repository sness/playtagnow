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

class Player extends Sprite {

	static var _well : Sprite;
	var _background : Shape;
	
	static var _sound_player : SoundPlayer;
	static var _play_button : PlayButton;
	static var _volume_slider : VolumeSlider;
	static var _time_indicator : TimeIndicator;

	static var _sound_state : Int;

	static var _sound_position : Float; // the current playback position (0.0 - 1.0)
	static var _sound_loaded : Float; // the amount of data that has been loaded (0.0 - 1.0)

	public static var _song_url : String; // The prefix of the filename we are loading

	static var _width  : Float;
	static var _height : Float;

	public function new (x_:Int, y_:Int, width_:Int, height_:Int) {
		super();

		x = x_;
		y = y_;
		_width = width_;
		_height = height_;

		addEventListener(MouseEvent.MOUSE_UP, mainMouseUp);
		addEventListener(MouseEvent.MOUSE_DOWN, mainMouseDown);

		// Figure out the prefix of the filename we are looking at
		if (flash.Lib.current.loaderInfo.parameters._song_url != null) {
			_song_url = flash.Lib.current.loaderInfo.parameters._song_url;
		} else {
			// If is undefined, we are in the standalone player, so just choose
			// a favorite file for debugging.
			_song_url = "/src/assets/a.mp3";
		}

		flash.Lib.current.stage.addEventListener(MouseEvent.MOUSE_UP, mainMouseUp);
		flash.Lib.current.stage.addEventListener(MouseEvent.MOUSE_DOWN, mainMouseDown);

		// Setup the main Timer object to run every 10ms
		var t = new haxe.Timer(100);
		t.run = onTimer;

		// The SoundPlayer that loads and plays the MP3 file
		_sound_player = new SoundPlayer();
		_sound_state = 0;
		_sound_position = 0;
		_sound_loaded = 0;

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

		// The play/pause buttons
		_play_button = new PlayButton(0,1,20,20);
		_play_button.addEventListener(MouseEvent.CLICK, togglePlay);
		_well.addChild(_play_button);

		// The volume slider
		_volume_slider = new VolumeSlider(45,2,100,20);
// 		_well.addChild(_volume_slider);

		// The time indicator
		_time_indicator = new TimeIndicator(190,3,100,20);
		_well.addChild(_time_indicator);
	}

	private function togglePlay(e:Event):Void {
		if (_play_button.getValue() == 1) {
			_play_button.setValue(0);
			stopSound();
		} else {
			_play_button.setValue(1);
			playSound();
		}
		_play_button.redraw();
	}

	static private function mainMouseUp(e:Event):Void {
	}

	static private function mainMouseDown(e:Event):Void {
	}

	public static function changeSong(path:String) {
// 		trace("changeSong");
		SoundPlayer.changeSong(path);
		_sound_state = 1;
		_play_button.setValue(1);
		_play_button.redraw();
	}

	static function playSound():Void {
		SoundPlayer.play(_sound_position * _sound_player.length());
		_sound_state = 1;
		_play_button.setValue(1);
	}

	static function stopSound():Void {
		SoundPlayer.stop();
		_sound_state = 0;
	}

	// The main coordinating function that looks at the status of all the
	// objects and updates the other objects based on the current state.
	static function onTimer() {
		// Current position in the song
		if (_sound_state == 1) {
			_sound_position = _sound_player.getPosition();
		}
		_sound_loaded = _sound_player.getLoaded();

		// Volume
		if (_sound_state == 1) {
			_sound_player.setVolume(_volume_slider.getValue());
		}

		// Time indicator
		_time_indicator.value = _sound_position * _sound_player.length();
		_time_indicator.redraw();

// 		if (_sound_position > 0.99) {
// 			trace("here");
// 			_play_button.setValue(0);
// 			stopSound();
// 			_sound_position = 0.0;
// 		}
	}

}

