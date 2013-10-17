import flash.display.Sprite;
import flash.media.Sound;
import flash.media.SoundChannel;
import flash.media.SoundTransform;
import flash.net.URLRequest;

class SoundPlayer extends Sprite {
	static private var url:String;
	static var s:Sound;
	static var sc:SoundChannel;
	static var st:SoundTransform;

	static var playing : Bool;
	
	public function new() {
		super();

		var request:URLRequest = new URLRequest(Player._song_url);

		s = new Sound();
		s.load(request);

		st = new SoundTransform();
		
		playing = false;
	}

	public static function changeSong(path:String) {
// 		trace("changeSong");
		var request:URLRequest = new URLRequest(path);

// 		stop();

		s = new Sound();
		s.load(request);

		st = new SoundTransform();

		play(5000);
	}

	public function getLoaded():Float {
		return s.bytesLoaded / s.bytesTotal;
	}

	// The length of the sound file
	public function length():Float {
		return s.length;
	}

	// The position that we are playing in the sound file
	public function getPosition():Float {
		return sc.position / s.length;
	}

	//
	// Transport controls
	//
	public static function play(position:Float):Void {
// 		trace("play");
		if (playing == true) {
			sc.stop();
		}
		sc = s.play(position);
		playing = true;
	}

	public static function stop():Void {
		if (playing == true) {
			sc.stop();
		}
		playing = false;
	}

	//
	// Volume
	//
	public function getVolume():Float {
		return sc.soundTransform.volume;
	}

	public function setVolume(v:Float):Void {
		st.volume = v;
		sc.soundTransform = st;
	}

}
