//
// Holds an individual clip
//

class Clip { 

	var _clip_id : String;
	var _track_number : String;
	var _title : String;
	var _artist : String;
	var _album : String;
	var _url : String;
	var _segment_start : String;
	var _segment_end : String;
	var _original_url : String;
	var _mp3_path : String;
	var _grid_x : Int;
	var _grid_y : Int;

	var _local_song_mp3_path : String;

	var _tags : Array<Tag>;

	public function new (clip_id_:String, track_number_:String, title_:String, artist_:String, album_:String, url_:String, segment_start_:String, segment_end_:String, original_url_:String, mp3_path_:String, ?grid_x_:Int = 0, ?grid_y_:Int = 0) {

		_clip_id = clip_id_;
		_track_number = track_number_;
		_title = title_;
		_artist = artist_;
		_album = album_;
		_url = url_;
		_segment_start = segment_start_;
		_segment_end = segment_end_;
		_original_url = original_url_;
		_mp3_path = mp3_path_;
		_grid_x = grid_x_;
		_grid_y = grid_y_;
		
		_tags = [];

		// Determine the local path of the MP3 of the whole song
		_local_song_mp3_path = "full_mp3" + _original_url.substr(_original_url.lastIndexOf("/"));
	}

	public function getLocalSongMP3Path():String { 
		return _local_song_mp3_path;
	}

	public function getClipID():String { 
		return _clip_id;
	}

	public function getTrackNumber():String { 
		return _track_number;
	}

	public function getTitle():String { 
		return _title;
	}

	public function getArtist():String { 
		return _artist;
	}

	public function getAlbum():String { 
		return _album;
	}

	public function getURL():String { 
		return _url;
	}

	public function getSegmentStart():String { 
		return _segment_start;
	}

	public function getSegmentEnd():String { 
		return _segment_end;
	}

	public function getOriginalUrl():String { 
		return _original_url;
	}

	public function getMP3Path():String { 
		return _mp3_path;
	}

	public function getGridX():Int { 
		return _grid_x;
	}

	public function getGridY():Int { 
		return _grid_y;
	}

	public function setGridXY(x:Int, y:Int) {
		_grid_x = x;
		_grid_y = y;
	}

	public function sameSong(c:Clip):Bool {
		if ((getArtist() == c.getArtist()) && (getTitle() == c.getTitle())) {
			return true;
		} else {
			return false;
		}
	}

	public function addTag(tag:Tag) {
		_tags.push(tag);
	}

	public function getTags():Array<Tag> {
		return _tags;
	}

	public function containsTag(tag:Tag):Bool {
		for (n in _tags) {
			if (tag.getName() == n.getName()) {
				return true;
			}
		}
		return false;
	}

}