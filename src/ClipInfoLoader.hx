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


class ClipInfoLoader extends Sprite {

 	public static var DONE_LOADING_EVENT:String = "DONE_LOADING_EVENT";

	var _loader:URLLoader;

	var _loaded : Bool;
	public function new(url:String) {
		super();

 		// Get the text file for the predictions
		_loader = new URLLoader();
		var request:URLRequest = new URLRequest(url);
		_loader.load(request);
		_loader.addEventListener(Event.COMPLETE, loaderCompleteHandler);

		_loaded = false;
	}


	private function loaderCompleteHandler(event:Event):Void {
 		var elements:Array<String> = new Array();
 		var lines:Array<String> = _loader.data.split('\n');
		
 		// Split the input data file into lines and fill up the _image_urls data
 		// structure with URLs for the different zoom levels
 		for (i in 1...lines.length) {
 			if (lines[i].charAt(0) != "#") {
  				elements = lines[i].split('\t');
				if (elements[0] != "") {
					var clip_id_:String = elements[0];
					var track_number_ = elements[1];
					var title_ = elements[2];
					var artist_ = elements[3];
					var album_ = elements[4];
					var url_ = elements[5];
					var segment_start_ = elements[6];
					var segment_end_ = elements[7];
					var original_url_ = elements[8];
					var mp3_path_ = elements[9];
 					Clips.addClip(clip_id_, track_number_, title_, artist_, album_, url_, segment_start_, segment_end_, original_url_, mp3_path_);
				}
			}
		}
		_loaded = true;
 		this.dispatchEvent(new Event(ClipInfoLoader.DONE_LOADING_EVENT, true));
	}

	public function getLoaded():Bool {
		return _loaded;
	}


}
