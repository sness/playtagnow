import flash.display.Loader;
import flash.display.Sprite;
import flash.display.Bitmap;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.net.URLRequest;


class PlayButton extends Sprite {

	private var playbutton_loader:Loader;
	private var pausebutton_loader:Loader;

	public var state:Int;

	static var _width  : Int;
	static var _height : Int;

	public function new(x_:Int, y_:Int, width_:Int, height_:Int) {
		super();

		x = x_;
		y = y_;
		_width = width_;
		_height = height_;

		state = 0;

		// Play High
		playbutton_loader = new Loader();
		playbutton_loader.visible = false;
		playbutton_loader.contentLoaderInfo.addEventListener(Event.INIT, initListener);
		playbutton_loader.load(new URLRequest("/src/library/play.png"));

		// Play Muted
		pausebutton_loader = new Loader();
		pausebutton_loader.visible = false;
		pausebutton_loader.contentLoaderInfo.addEventListener(Event.INIT, initListener);
		pausebutton_loader.load(new URLRequest("/src/library/pause.png"));

	}

	private function initListener (e:Event):Void {
		addChild(playbutton_loader.content);
		addChild(pausebutton_loader.content);
		redraw();
	}

	public function redraw ():Void {
		if (state == 1) {
			playbutton_loader.content.visible = true;
			pausebutton_loader.content.visible = false;
		} else {
			playbutton_loader.content.visible = false;
			pausebutton_loader.content.visible = true;
		}
	}

	public function getValue():Int {
		return state;
	}

	public function setValue(n:Int):Void {
		state = n;
		redraw();
	}

}