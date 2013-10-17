//
// Holds an individual Song
//
// A Song contains a number of Clips
//

class Song { 

	var _clips : Array<Clip>;

	var _title : String;  // The title of the song
	var _artist : String;  // The artist of the song

	public function new (title_:String,artist_:String) {
		_title = title_;
		_artist = artist_;
		_clips = new Array();
	}

	public function getTitle():String { 
		return _title;
	}

	public function getArtist():String { 
		return _artist;
	}

	public function getPrettyTitle():String { 
		// Return the first two words
		//  		return StringTools.replace(_title,' ','\n').substr(0,15);
		// Find the first space
		var first_space:Int = _title.indexOf(" ",1);
		var second_space:Int = _title.indexOf(" ",first_space+1);
		var linebreak_title = _title.substr(0,second_space+1);
// 		trace("t=" + _title + " f=" + first_space + " s=" + second_space + " l=" + linebreak_title);
		return StringTools.replace(linebreak_title,' ','\n');
	}

	public function addClip(clip:Clip) {
		_clips.push(clip);
	}

	public function getClips():Array<Clip> {
		return _clips;
	}

	public function getFirstClip():Clip {
		return _clips[0];
	}


}