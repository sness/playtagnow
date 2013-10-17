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

class CurrentArtistsLine extends Sprite {

	var _well : Sprite;
	var _background : Shape;

	var t:TextField;
	var format:TextFormat;

	var _width  : Float;
	var _height : Float;

	var _artist : Artist;

	public function new (artist_:Artist) {
		super();

// 		x = x_;
// 		y = y_;
// 		_width = width_;
// 		_height = height_;
		_artist = artist_;

		// Well to hold everything
		_well = new Sprite();
		this.addChild(_well);

		t = new TextField();
		t.width = _width; 
		t.selectable = false;
		t.text = _artist.getName();
// 		t.textColor = 0xAAAAAA;

		format = new TextFormat();
		format.font = "Arial";
		format.size = 10;
		format.bold = true;
		
		t.setTextFormat(format);

		_well.addChild(t);

		addEventListener(MouseEvent.MOUSE_DOWN, mouseDownListener);		
	}

	public function setXY(x_:Float, y_:Float):Void {
		x = x_;
		y = y_;
	}

 	function mouseDownListener(e:MouseEvent):Void {
		CurrentArtists.deleteArtist(e.target.parent.parent);
	}

	public function getArtist():Artist {
		return _artist;
	}
}
