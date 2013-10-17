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
import flash.text.TextField;
import flash.text.TextFormat;

class CurrentSong extends Sprite {

	var _well : Sprite;
	var _background : Shape;

	static var _width  : Float;
	static var _height : Float;
	static var _player : Player;

	static var song_title:TextField;
	static var song_artist:TextField;
	static var song_album:TextField;
	static var song_track_number:TextField;

	static var format:TextFormat;

	public function new (x_:Int, y_:Int, width_:Int, height_:Int) {
		super();

		x = x_;
		y = y_;
		_width = width_;
		_height = height_;

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


		format = new TextFormat();
		format.font = "Arial";
		format.size = 10;
		format.bold = true;

		// Song title
		song_title = new TextField();
		song_title.width = _width; 
		song_title.selectable = false;
		song_title.setTextFormat(format);
		song_title.x = 10;
		song_title.y = 10;
		_well.addChild(song_title);

		// Song album
		song_album = new TextField();
		song_album.width = _width; 
		song_album.selectable = false;
		song_album.setTextFormat(format);
		song_album.x = 10;
		song_album.y = 30;
		_well.addChild(song_album);

		// Song artist
		song_artist = new TextField();
		song_artist.width = _width; 
		song_artist.selectable = false;
		song_artist.setTextFormat(format);
		song_artist.x = 10;
		song_artist.y = 50;
		_well.addChild(song_artist);

		// Song track
		song_track_number = new TextField();
		song_track_number.width = _width; 
		song_track_number.selectable = false;
		song_track_number.setTextFormat(format);
		song_track_number.x = 10;
		song_track_number.y = 70;
		_well.addChild(song_track_number);

		// The Player
		_player = new Player(0,177,340,23);
		_well.addChild(_player);

	}

	public static function changeSong(clip:Clip) {
// 		trace("changing song to " + clip.getTitle());
 		Player.changeSong(clip.getLocalSongMP3Path());

 		song_title.text = clip.getTitle();
		song_title.setTextFormat(format);

 		song_artist.text = clip.getArtist();
		song_artist.setTextFormat(format);

 		song_album.text = clip.getAlbum();
		song_album.setTextFormat(format);

  		song_track_number.text = clip.getTrackNumber();
		song_track_number.setTextFormat(format);
	}


}