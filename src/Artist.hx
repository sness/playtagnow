//
// Holds an individual Artist
//
// A Artist contains a number of Clips
//

class Artist { 

	var _clips : Array<Clip>;

	var _name : String;  // The name of the artist

	public function new (name_:String) {
		_name = name_;
		_clips = new Array();
	}

	public function getName():String { 
		return _name;
	}

	public function getPrettyName():String { 
//  		return StringTools.replace(_name,' ','\n').substr(0,15);
		var first_space:Int = _name.indexOf(" ",1);
		var second_space:Int = _name.indexOf(" ",first_space+1);
		var linebreak_name = _name.substr(0,second_space+1);
		if (second_space == -1) {
			return StringTools.replace(_name,' ','\n');
		} else {
			return StringTools.replace(linebreak_name,' ','\n');
		}
	}

	public function addClip(clip:Clip) {
		_clips.push(clip);
	}

	public function getClips():Array<Clip> {
		return _clips;
	}


}
