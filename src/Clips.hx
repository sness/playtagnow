//
// A container for all the clips
//

class Clips { 

	// The array of all clips
	static var _clips : Hash<Clip>;

	public function new() {
		_clips = new Hash();
	}

	public static function addClip(clip_id_:String, track_number_:String, title_:String, artist_:String, album_:String, url_:String, segment_start_:String, segment_end_:String, original_url_:String, mp3_path_:String):Void {
 		var clip = new Clip(clip_id_, track_number_, title_, artist_, album_, url_, segment_start_, segment_end_, original_url_, mp3_path_);
 		_clips.set(clip_id_,clip);
	}

	public static function getClip(clip_id:String):Clip {
		return _clips.get(clip_id);
	}

	public static function getAllClips():Hash<Clip> {
		return _clips;
	}

	public static function getAllClipIDs():Array<String> {
		var out : Array<String> = [];
		for (n in _clips.keys()) {
			out.push(n);
		}
		return out;
	}

	public static function clipContainsTag(clip_id:String, tag:Tag):Bool {
		var clip : Clip = _clips.get(clip_id);
		return clip.containsTag(tag);
	}

	public static function getClipTags(clip_id:String):Array<Tag> {
		return _clips.get(clip_id).getTags();
	}

	public static function setClipXY(clip_id_:String, grid_x_:Int, grid_y_:Int) {
		var a : Clip;
		a = _clips.get(clip_id_);
		a.setGridXY(grid_x_,grid_y_);
	}

	public static function getClipIndicesAtXY(x_:Int, y_:Int):Array<String> {
		var out : Array<String> = new Array();
		var a : Clip;
		for(n in _clips.keys()) {
			a = _clips.get(n);
			if ((a.getGridX() == x_) && (a.getGridY() == y_)) {
				out.push(n);
			}
		}
		return out;
	}

	public static function getNumClipsXY(x_:Int, y_:Int):Int {
		var num:Int = 0;

		for(n in _clips.keys()) {
			num += 1;
		}
			
		return num;
	}

	//
	// Return the most popular artist at this grid location
	//
	public static function getMostPopularArtistAtXY(x_:Int, y_:Int):String {
		var artist_amounts : Hash<Int> = new Hash();
		var clip : Clip;
		var artist : String;

		for(n in _clips.keys()) {
			clip = _clips.get(n);
			if ((clip.getGridX() == x_) && (clip.getGridY() == y_)) {
				artist = clip.getArtist();
				if (artist_amounts.exists(artist)) {
					var num : Int;
					num = artist_amounts.get(artist);
					num += 1;
					artist_amounts.set(artist,num);
				} else {
					artist_amounts.set(artist,1);
				}
			}
		}

		var most_popular_artist : String = "";
		var most_popular_num : Int = 0;

		for(n in artist_amounts.keys()) {
			var amount:Int = artist_amounts.get(n);
			if (amount > most_popular_num) {
				most_popular_artist = n;
				most_popular_num = amount;
			}
		}

		return most_popular_artist;
	}

	//
	// Return all the grid locations that this artist can be found at
	//
	public static function getAllGridLocationsForMostPopularArtistAtXY(x_:Int, y_:Int):Array<GridLocation> {
		var artist : String = getMostPopularArtistAtXY(x_, y_);
		var grid_locations : Array<GridLocation> = new Array();
		var clip : Clip;

		// Find all the grid locations that this artist can be found at
		for (n in _clips.keys()) {
			clip = _clips.get(n);
			if (clip.getArtist() == artist) {
				var x:Int = clip.getGridX();
				var y:Int = clip.getGridY();
				var found : Bool = false;

				// Check to make sure that we haven't already added this grid location
				for (m in grid_locations) {
					if ((m.getGridX() == x) && (m.getGridY() == y)) {
						found = true;
					}
				}
				if (!found) {
					var g : GridLocation = new GridLocation(x,y);
					grid_locations.push(g);
				}
			}
		}
		

		return grid_locations;
	}

	public static function getAllClipIndicesFromArtist(artist:String):Array<String> {
		var clip_indices : Array<String> = new Array();
		var clip : Clip;
		for(n in _clips.keys()) {
			clip = _clips.get(n);
			if (clip.getArtist() == artist) {
				clip_indices.push(n);
			}
		}
		return clip_indices;
	}

	public static function getAllClipsFromArtist(artist:String):Array<Clip> {
		var clips : Array<Clip> = new Array();
		var clip : Clip;
		for(n in _clips.keys()) {
			clip = _clips.get(n);
			if (clip.getArtist() == artist) {
				clips.push(clip);
			}
		}
		return clips;
	}

	public static function getAllUniqueSongsFromArtist(artist:String):Array<Clip> {
		var clips : Array<Clip> = new Array();
		var clip : Clip;
		for(n in _clips.keys()) {
			clip = _clips.get(n);
			if (clip.getArtist() == artist) {
				var found : Bool = false;
			    for (m in clips) {
					if (clip.sameSong(m)) {
						found = true;
					}
				}
				if (found == false) {
					clips.push(clip);
				}
			}
		}
		return clips;
	}

	public static function getAllSongs():Hash<Song> {
		var songs : Hash<Song> = new Hash();
		var clip : Clip;
		var song : Song;
		for(n in _clips.keys()) {
			clip = _clips.get(n);
			var title : String = clip.getTitle();
			var artist : String = clip.getArtist();
			song = songs.get(title);
 			if (song == null) {
 				song = new Song(title,artist);
 				songs.set(title,song);
 			}
 			song.addClip(clip);
		}
		return songs;
	}

	public static function getAllArtists():Hash<Artist> {
		var artists : Hash<Artist> = new Hash();
		var clip : Clip;
		var artist : Artist;
		for(n in _clips.keys()) {
			clip = _clips.get(n);
			var title : String = clip.getArtist();
			artist = artists.get(title);
 			if (artist == null) {
 				artist = new Artist(title);
 				artists.set(title,artist);
 			}
 			artist.addClip(clip);
		}
		return artists;
	}

	public static function addTagToClip(clip_id:String, tag:Tag) {
		var clip = _clips.get(clip_id);
		clip.addTag(tag);
	}

	public static function trace():Void {
		var a : Clip;
		for(n in _clips.keys()) {
			a = _clips.get(n);
			trace(a.getClipID() + " " + a.getGridX() + " " + a.getGridY());
		}
	}


}