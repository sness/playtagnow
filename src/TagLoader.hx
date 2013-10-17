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


class TagLoader extends Sprite {

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

		// The first line of the tags file is the list of all the tags
		var tags:Array<String> = lines[0].split('\t');
		for (i in 1...tags.length) {
			var tag:Tag = new Tag(tags[i]);
			Tags.addTag(tag);
		}

 		// Split the input data file into lines and fill up the _image_urls data
 		// structure with URLs for the different zoom levels
 		for (i in 1...lines.length) {
 			if (lines[i].charAt(0) != "#") {
  				elements = lines[i].split('\t');
				if (elements[0] != "") {
					var clip_id:String = elements[0];
					for (j in 1...elements.length) {
						if (elements[j] == "1") {
							var tag:Tag = new Tag(tags[j]);
							Clips.addTagToClip(clip_id,tag);
						} 
					}
				}
			}
		}
		_loaded = true;
 		this.dispatchEvent(new Event(TagLoader.DONE_LOADING_EVENT, true));
	}

	public function getLoaded():Bool {
		return _loaded;
	}




}
