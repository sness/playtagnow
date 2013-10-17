//
// Holds an individual Tag
//
// A Tag contains a number of Clips
//

class Tag { 

	var _name : String;  // The name of the tag

	public function new (name_:String) {
		_name = name_;
	}

	public function getName():String { 
		return _name;
	}

	public function getPrettyName():String { 
 		return StringTools.replace(_name,' ','\n').substr(0,15);
	}

}
