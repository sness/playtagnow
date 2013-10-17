import flash.display.Loader;
import flash.display.Sprite;
import flash.display.Bitmap;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.net.URLLoader;
import flash.net.URLRequest;
import flash.net.URLRequestMethod;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.xml.XML;


class GridLoader extends Sprite {

 	public static var DONE_LOADING_EVENT:String = "DONE_LOADING_EVENT";

	var _loader:URLLoader;

	var _loading : Bool;
	var _loaded : Bool;

	public function new() {
		super();

		_loaded = false;
		_loading = false;

		_loader = new URLLoader();

	}

	public function load(url:String) {
		if (!_loading) {
			_loading = true;
			// Get the text file for the predictions
			var request:URLRequest = new URLRequest(url);
			_loader.load(request);
			_loader.addEventListener(Event.COMPLETE, loaderCompleteHandler);
		}
	}

	private function loaderCompleteHandler(event:Event):Void {
 		var elements:Array<String> = new Array();
 		var lines:Array<String> = _loader.data.split('\n');

 		// Split the input data file into lines and fill up the _image_urls data
 		// structure with URLs for the different zoom levels
 		for (i in 2...lines.length) {
 			if (lines[i].charAt(0) != "#") {
  				elements = lines[i].split(',');
				if (elements[0] != "") {
					var clip_id_:String = elements[0];
					var grid_x_:Int = Std.parseInt(elements[1]);
					var grid_y_:Int = Std.parseInt(elements[2]);
					Clips.setClipXY(clip_id_,grid_x_,grid_y_);
				}
			}
		}
		_loaded = true;
 		this.dispatchEvent(new Event(GridLoader.DONE_LOADING_EVENT, true));
	}

	public function getLoaded():Bool {
		return _loaded;
	}



}
