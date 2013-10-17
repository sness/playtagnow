class Vector {

	public var x:Float;
	public var y:Float;

	public function new(?x_:Float = 0.0, ?y_:Float = 0.0) {
		x = x_;
		y = y_;
	}

	public function set(x_:Float, y_:Float) {
		x = x_;
		y = y_;
	}

	public function length():Float {
		return Math.sqrt(x * x + y * y);
	}

	public function mult(f:Float):Vector {
		x = x * f;
		y = y * f;
		return this;
	}

	public function add(f:Vector):Vector {
		x = x + f.x;
		y = y + f.y;
		return this;
	}

	public function subtract(f:Vector):Vector {
		x = x - f.x;
		y = y - f.y;
		return this;
	}
	
	public function divide(f:Float):Vector {
		x = x / f;
		y = y / f;
		return this;
	}

	public function normalize():Vector {
		var invr:Float = 1.0 / this.length();
		return this.mult(invr);
	}

	public function toString() {
		return "(" + Std.string(x) + "," + Std.string(y) + ")";
	}

	public function distance(f:Vector):Float {
		return Math.sqrt(
			Math.pow((x - f.x),2) + 
			Math.pow((y - f.y),2));
	}

	public function equals(f:Vector):Bool {
		var delta:Float = 0.000001;
		if ((Math.abs(x - f.x) < delta) && (Math.abs(y - f.y) < delta)) {
			return true;
		} else {
			return false;
		}
	}
}
