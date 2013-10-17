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

class CurrentTags extends Sprite {

	var _well : Sprite;
	var _background : Shape;

	static var _width  : Float;
	static var _height : Float;

	static var _current_tags_line_container:Sprite;

	static var _current_tags_lines : Array<CurrentTagsLine>;

	static var _last_selected_tag : Tag;

	public function new (x_:Int, y_:Int, width_:Int, height_:Int) {
		super();

		x = x_;
		y = y_;
		_width = width_;
		_height = height_;

		_current_tags_lines = new Array();
		_last_selected_tag = null;

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

		// A container for all the CurrentTagLines
		_current_tags_line_container = new Sprite();
		_well.addChild(_current_tags_line_container);

	}

	public static function toggleTag(tag:Tag):Void {
		// Find out if the current tag is in the list
		// If it isn't, add it
		// If it is, delete it

		var found:Bool = false;

		// sness - This next line is a little ugly, we should probably be using
		// the same type in addTag and deleteTag
		var found_line:CurrentTagsLine = null;

		for (line in _current_tags_lines) {
			if (line.getTag() == tag) {
				found = true;
				found_line = line;
			}
		}
		if (!found) {
			addTag(tag);
		} else {
			deleteTag(found_line);
		}
	}

	// Deselect all tags and add the selected tag
	public static function selectTag(tag:Tag):Void {
		unselectAll();
		addTag(tag);
	}

	public static function unselectAll():Void {
 		_current_tags_lines = new Array();
		redrawAllLines();
  		TagCloud.unselectColorTags();
	}

	public static function addTag(tag:Tag):Void {
// 		trace("adding=" + tag);
		for (line in _current_tags_lines) {
			if (line.getTag() == tag) {
				return;
			}
		}
		var tag_line : CurrentTagsLine = new CurrentTagsLine(tag);
		_current_tags_lines.push(tag_line);
		redrawAllLines();

		_last_selected_tag = tag;

		SongCloud.regenerateSelected();
		TagCloud.colorSelected();
		SongCloud.playASelectedSongByTag(tag);
	}

	public static function redrawAllLines():Void {
		// Clear out the _song_list_line_container
		for(i in 0..._current_tags_line_container.numChildren) {
			_current_tags_line_container.removeChildAt(0);
		}

		var _current_y = 0;
		var _line_height = 20;
		for (line in _current_tags_lines) {
			line.setXY(0,_current_y);
			_current_y += _line_height;
			_current_tags_line_container.addChild(line);
		}
	}

	public static function deleteTag(line:CurrentTagsLine) {
		_current_tags_lines.remove(line);
		redrawAllLines();

		_last_selected_tag = null;

		SongCloud.regenerateSelected();
		TagCloud.colorSelected();
		SongCloud.playASelectedSong();
	}

	public static function getTags():Array<Tag> {
		var tags : Array<Tag> = new Array();
		for (line in _current_tags_lines) {
			tags.push(line.getTag());
		}
		return tags;
	}

	public static function getLastSelectedTag():Tag {
		return _last_selected_tag;
	}


}