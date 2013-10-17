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
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;

class TagCloudTag extends Sprite {

	var _well : Sprite;
	var _background : Shape;

	var _text_name:TextField;
	var _format:TextFormat;

	var _width  : Float;
	var _height : Float;

	var _tag : Tag;
	var _total_num : Int;
	
	var _orig_x : Float;
	var _orig_y : Float;

	var _som_x : Float;
	var _som_y : Float;


	// Force calculations
	var _position : Vector;
	var _velocity : Vector;
	var _force : Vector;
	var _mass : Float;

	public function new (x_:Float, y_:Float, tag_:Tag, total_num_:Int) {
		super();

		x = x_;
		y = y_;
		_orig_x = x_;
		_orig_y = y_;
		_som_x = x_;
		_som_y = y_;
		_tag = tag_;
		_total_num = total_num_;

		// sness - Need to change this later to reflect actual text properties
		_width = 200;
		_height = 20;

		// Force calculations
		_position = new Vector(x,y);
		_velocity = new Vector();
		_force = new Vector();
		_mass = 1.0;

		// Well to hold everything
		_well = new Sprite();
		this.addChild(_well);

		_text_name = new TextField();
		// 		_text_name.width = _width; 
		_text_name.selectable = false;
		_text_name.text = _tag.getName();
		// 		_text_name.border = true;
		_text_name.autoSize = TextFieldAutoSize.CENTER;

		_format = new TextFormat();
		_format.font = "Arial";
		_format.size = (total_num_/10) + 10;
		_format.bold = true;
		_format.align = TextFormatAlign.CENTER;
		
		_text_name.setTextFormat(_format);

		_well.addChild(_text_name);

		// 		// sness - For testing
		//  		_background = new Shape();
		//    		_background.graphics.beginFill(0xFF0000,1);
		// 		_background.graphics.lineStyle(1,0x333333);
		//    		_background.graphics.moveTo(0,0);
		//    		_background.graphics.lineTo(3,0);
		//    		_background.graphics.lineTo(3,3);
		//    		_background.graphics.lineTo(0,3);
		//    		_background.graphics.lineTo(0,0);
		//  		_well.addChild(_background);

		addEventListener(MouseEvent.MOUSE_DOWN, mouseDownListener);		
	}

 	function mouseDownListener(e:MouseEvent):Void {
// 		trace("down=" + _tag.getName());
		if (e.shiftKey) {
			CurrentTags.toggleTag(_tag);
		} else {
			CurrentArtists.unselectAll();
			CurrentTags.selectTag(_tag);
		}
	}

	public function getTag():Tag {
		return _tag;
	}

	////////////////////////////////////////////////////////////////////////////////
	//
	// Force calculations
	//
	////////////////////////////////////////////////////////////////////////////////

	public function getOrigX():Float {
		return _orig_x;
	}

	public function getOrigY():Float {
		return _orig_y;
	}


	public function getPosition():Vector {
// 		trace("gp x=" + x + " y=" + y);
 		_position.x = x;
 		_position.y = y;
		return _position;
	}

	public function getX():Float {
		return x;
	}

	public function getY():Float {
		return y;
	}

	public function getLeftEdge():Float {
// 		trace("gle " + _tag + " px=" + rr(_position.x) + " tw2=" + rr(_text_name.width / 2.0) + " ret=" + rr(_position.x - (_text_name.width / 2.0)));
		return _position.x - (_text_name.width / 2.0);
	}

	public function getRightEdge():Float {
// 		trace("gre " + _tag + " px=" + rr(_position.x) + " tw2=" + rr(_text_name.width / 2.0) + " ret=" + rr(_position.x + (_text_name.width / 2.0)));
		return _position.x + (_text_name.width / 2.0);
	}

	public function getTopEdge():Float {
// 		trace("gte " + _tag + " py=" + rr(_position.y) + " tw2=" + rr(_text_name.height / 2.0) + " ret=" + rr(_position.y - (_text_name.height / 2.0)));
		return _position.y - (_text_name.height / 2.0);
	}

	public function getBottomEdge():Float {
// 		trace("gbe " + _tag + " py=" + rr(_position.y) + " tw2=" + rr(_text_name.height / 2.0) + " ret=" + rr(_position.y + (_text_name.height / 2.0)));
		return _position.y + (_text_name.height / 2.0);
	}
	
	public function setPosition(f:Vector) {
		_position = f;

		// 		if (_position.x < 0) {
		// 			_position.x = 0;
		// 		}
		// 		if (_position.x > 300) {
		// 			_position.x = 300;
		// 		}

		// 		if (_position.y < 0) {
		// 			_position.y = 0;
		// 		}
		// 		if (_position.y > 300) {
		// 			_position.y = 300;
		// 		}

		// 		x = _position.x - (width / 2);
		// 		y = _position.y - (height / 2);

 		x = _position.x;
 		y = _position.y;

 		_text_name.x = -1 * (width / 2);
 		_text_name.y = -1 * (height / 2);

		//  		trace("x=" + _position.x + " y=" + _position.y + "w=" + width + " h=" + height);

	}

	public function getVelocity():Vector {
		return _velocity;
	}

	public function setVelocity(f:Vector) {
		_velocity = f;
	}

	public function getForce():Vector {
		return _force;
	}

	public function setForce(f:Vector) {
		_force = f;
	}

	public function getMass():Float {
		return _mass;
	}

	public function setMass(f:Float) {
		_mass = f;
	}

	public function getArea():Float {
		return width * height;
	}

	public function overlapsWith(other:TagCloudTag) {

		var this_area:Float = getArea();
		var other_area:Float = other.getArea();

// 		trace("ta=" + this_area + " oa=" + other_area);

// 		trace("width=" + width + " _text_name.width=" + _text_name.width);
// 		trace("height=" + height + " _text_name.height=" + _text_name.height);

		var a_top:Float;
		var a_left:Float;
		var a_bottom:Float;
		var a_right:Float;

		var b_top:Float;
		var b_left:Float;
		var b_bottom:Float;
		var b_right:Float;

		//rect 'a' can never lie completely 'inside' rect 'b'		
		if (this_area > other_area) {
			a_top = getTopEdge();
			a_left = getLeftEdge();
			a_bottom = getBottomEdge();
			a_right = getRightEdge();

			b_top = other.getTopEdge();
			b_left = other.getLeftEdge();
			b_bottom = other.getBottomEdge();
			b_right = other.getRightEdge();
// 			trace("normal");
		} else {
			b_top = getTopEdge();
			b_left = getLeftEdge();
			b_bottom = getBottomEdge();
			b_right = getRightEdge();

			a_top = other.getTopEdge();
			a_left = other.getLeftEdge();
			a_bottom = other.getBottomEdge();
			a_right = other.getRightEdge();
// 			trace("swap");
		}

// 		trace("px=" + _position.x + " py=" + _position.y);
// 		trace("at=" + rr(a_top) + " ab=" + rr(a_bottom) + " al=" + rr(a_left) + " ar=" + rr(a_right));
// 		trace("bt=" + rr(b_top) + " bb=" + rr(b_bottom) + " bl=" + rr(b_left) + " br=" + rr(b_right));

		//check top-left point
		if( b_top >= a_top && b_top <= a_bottom ) {
			if( b_left >= a_left && b_left <= a_right ) {
				return true;
			}
		}

		//check top-right point
		if( b_top >= a_top && b_top <= a_bottom ) {
			if( b_right >= a_left && b_right <= a_right ) {
				return true;
			}
		}

		//check bottom-left point
		if( b_bottom >= a_top && b_bottom <= a_bottom ) {
			if( b_left >= a_left && b_left <= a_right ) {
				return true;
			}
		}

		//check bottom-right point
		if( b_bottom >= a_top && b_bottom <= a_bottom ) {
			if( b_right >= a_left && b_right <= a_right ) {
				return true;
			}
		}

		return false;

	}

	////////////////////////////////////////////////////////////////////////////////
	//
	// Change sorting order
	//
	////////////////////////////////////////////////////////////////////////////////

	public function randomOrder():Void {
		setOrigXY(Math.random() * TagCloud.getWidth(), Math.random() * TagCloud.getHeight());
// 		_orig_x = Math.random() * TagCloud.getWidth();
// 		_orig_y = Math.random() * TagCloud.getHeight();
	}

	public function somOrder():Void {
		setOrigXY(_som_x,_som_y);
// 		_orig_x = _som_x;	
// 		_orig_y = _som_y;	
	}

	public function alphabeticOrder():Void {
	}

	public function getTagName():String {
		return _tag.getName();
	}
	
	public function setOrigXY(x_:Float, y_:Float) {
		_orig_x = x_;
		_orig_y = y_;
 		_position.x = x_;
 		_position.y = y_;
		x = x_;
		y = y_;
	}

	////////////////////////////////////////////////////////////////////////////////
	//
	// Utility functions
	//
	////////////////////////////////////////////////////////////////////////////////
	
	// A "r"easonable number of decimal points for trace()
	public function rr(f:Float):Float {
		var d:Float = 10000;
		var n:Int = Std.int(f * d);
		return n / d;
	}
	
	// Change a Float to an Int for trace()
	public function ii(f:Float):Int {
		return Std.int(f);
	}

	////////////////////////////////////////////////////////////////////////////////
	//
	// New stuff
	//
	////////////////////////////////////////////////////////////////////////////////

	public function setColor(i:Int) {
		_text_name.textColor = i;
	}

}
