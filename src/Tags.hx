//
// A container for all the tags
//

class Tags { 

	// The array of all tags
	static var _tags : Array<Tag>;

	public function new() {
		_tags = new Array();
	}

	public static function addTag(t:Tag) {
		_tags.push(t);
	}
	
	public static function getAllTags():Array<Tag> {
		return _tags;
	}
}


