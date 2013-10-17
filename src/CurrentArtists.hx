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

class CurrentArtists extends Sprite {

	var _well : Sprite;
	var _background : Shape;

	static var _width  : Float;
	static var _height : Float;

	static var _current_artists_line_container:Sprite;

	static var _current_artists_lines : Array<CurrentArtistsLine>;

	static var _last_selected_artist : Artist;

	public function new (x_:Int, y_:Int, width_:Int, height_:Int) {
		super();

		x = x_;
		y = y_;
		_width = width_;
		_height = height_;

		_current_artists_lines = new Array();
		_last_selected_artist = null;

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

		// A container for all the CurrentArtistLines
		_current_artists_line_container = new Sprite();
		_well.addChild(_current_artists_line_container);

	}

	public static function toggleArtist(artist:Artist):Void {
		// Find out if the current artist is in the list
		// If it isn't, add it
		// If it is, delete it

		var found:Bool = false;

		// sness - This next line is a little ugly, we should probably be using
		// the same type in addArtist and deleteArtist
		var found_line:CurrentArtistsLine = null;

		for (line in _current_artists_lines) {
			if (line.getArtist() == artist) {
				found = true;
				found_line = line;
			}
		}
		if (!found) {
			addArtist(artist);
		} else {
			deleteArtist(found_line);
		}
	}
	

	// Deselect all artists and add the selected artist
	public static function selectArtist(artist:Artist):Void {
		unselectAll();
		addArtist(artist);
	}

	public static function unselectAll():Void {
		_current_artists_lines = new Array();
		redrawAllLines();
  		ArtistCloud.unselectColorTags();
	}

	public static function addArtist(artist:Artist):Void {
// 		trace("adding=" + artist);
		for (line in _current_artists_lines) {
			if (line.getArtist() == artist) {
				return;
			}
		}
		var artist_line : CurrentArtistsLine = new CurrentArtistsLine(artist);
		_current_artists_lines.push(artist_line);
		redrawAllLines();

		_last_selected_artist = artist;

		SongCloud.regenerateSelected();
		ArtistCloud.colorSelected();
		SongCloud.playASelectedSongByArtist(artist);
	}

	public static function redrawAllLines():Void {
		// Clear out the _song_list_line_container
		for(i in 0..._current_artists_line_container.numChildren) {
			_current_artists_line_container.removeChildAt(0);
		}

		var _current_y = 0;
		var _line_height = 20;
		for (line in _current_artists_lines) {
			line.setXY(0,_current_y);
			_current_y += _line_height;
			_current_artists_line_container.addChild(line);
		}
	}

	public static function deleteArtist(line:CurrentArtistsLine) {
		_current_artists_lines.remove(line);
		redrawAllLines();

		_last_selected_artist = null;

		SongCloud.regenerateSelected();
		ArtistCloud.colorSelected();
		SongCloud.playASelectedSong();
	}

	public static function getArtists():Array<Artist> {
		var artists : Array<Artist> = new Array();
		for (line in _current_artists_lines) {
			artists.push(line.getArtist());
		}
		return artists;
	}

	public static function getLastSelectedArtist():Artist {
		return _last_selected_artist;
	}

}