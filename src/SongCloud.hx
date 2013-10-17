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

class SongCloud extends Sprite {

	var _well : Sprite;
	var _background : Shape;

	static var _width  : Float;
	static var _height : Float;

	static var _song_cloud_tag_container:Sprite;

	static var _nodes : Array<SongCloudTag>;

	// Constants
	var _columb_constant:Float; // Columbic force constant
	var _inertial_distance:Float; // Inertial or resting distance of the springs
	var _springK:Float; // Elasticity coefficient. The larger K is, the stiffer the spring.
	var _energy_loss:Float;

	public function new (x_:Int, y_:Int, width_:Int, height_:Int) {
		super();

		x = x_;
		y = y_;
		_width = width_;
		_height = height_;

		_nodes = new Array();

		// Constants for spring motion
  		_columb_constant = -500000;
//   		_columb_constant = -500000;
		_inertial_distance = 0.0;
		_springK = 1.0;
		_energy_loss = 0.99999;

		// Well to hold everything
		_well = new Sprite();
		this.addChild(_well);

 		// Create the background
 		_background = new Shape();
   		_background.graphics.beginFill(0xFFFFFF,1);
		_background.graphics.lineStyle(1,0x333333);
   		_background.graphics.moveTo(-20,-20);
   		_background.graphics.lineTo(_width+20,-20);
   		_background.graphics.lineTo(_width+20,_height+20);
   		_background.graphics.lineTo(-20,_height+20);
   		_background.graphics.lineTo(-20,-20);
 		_well.addChild(_background);

		// A container for all the songListLines 
		_song_cloud_tag_container = new Sprite();
		_well.addChild(_song_cloud_tag_container);

	}

	//
	// Loop over all songs, and find the clips that corresponds to that song.
	// Remember the locations of all the clips.  Then, after we're done, find
	// the midpoint.
	//
	// Later, we will change this from individual songs into clusters of clips
	// that are close together.
	//
	public function calculateSongPositions():Void {
		
		var songs:Hash<Song> = Clips.getAllSongs();
		
		for (n in songs) {
			var grid_locations : Array<GridLocation> = new Array();
			var total_num : Int = 0;
 			for (m in n.getClips()) {
				var g : GridLocation = new GridLocation(m.getGridX(), m.getGridY());
				grid_locations.push(g);
				total_num += 1;
 			}

 			// Find the center of mass of these grid locations
 			var center_x:Float = 0;
 			var center_y:Float = 0;
 			for (grid_location in grid_locations) {
 				center_x += grid_location.getGridX();
 				center_y += grid_location.getGridY();
 			}
 			center_x = ((center_x / grid_locations.length) / GlobalSettings.getGridSizeX()) * _width;
 			center_y = ((center_y / grid_locations.length) / GlobalSettings.getGridSizeY()) * _height;

 			// Add a SongCloudTag at this location
 			if (total_num > 0) {
 				addTag(center_x,center_y,n,total_num);
 			}

		}

 		// Calculate the final positions of the tags by iterating the calculate
 		// loop a bunch of times
//   		for (i in 0...10) {
//   			calculate();
//   		}

		calculate();
		cycleQuadrants();		
	}

	public function addTag(x_:Float, y_:Float,song_:Song,total_num_:Int) {
		var song_cloud_tag:SongCloudTag = new SongCloudTag(x_,y_,song_,total_num_);
		_nodes.push(song_cloud_tag);
		_song_cloud_tag_container.addChild(song_cloud_tag);
	}
	
	////////////////////////////////////////////////////////////////////////////////
	//
	// Force calculations
	//
	////////////////////////////////////////////////////////////////////////////////

	// Calculate all the forces on each node and their new positions
	public function calculate():Void {

		var timestep:Float = 0.01;
		// Compute internal forces on the springs
 		for (n in _nodes) {
			// Compute the spring force between this node and its origin
			var f:Vector = computeSpringForce(n);

 			// Compute the electrostatic force between this node and all other nodes
 			var e:Vector = computeElectrostaticForce(n);
 			f.add(e);

  			// Compute the wall force between this node and all the walls
  			var w:Vector = computeWallForce(n);
  			f.add(w);

			f.mult(timestep);
			var v:Vector = n.getVelocity();
			v.add(f);
			n.setVelocity(v);

			v.mult(timestep);
			var p:Vector = n.getPosition();
			p.add(v);
			n.setPosition(p);
 		}
	}

	function computeSpringForce(a:SongCloudTag):Vector {
		var force = new Vector();

		var b:Vector = new Vector(a.getOrigX(),a.getOrigY());

		if (a.getPosition().equals(b)) {
			return force;
		}

		var apos:Vector = a.getPosition();
		var displacement:Vector = b.subtract(apos);

		var k:Float = 10.0;

		force = displacement.mult(k);

		return force;
	}


	function computeElectrostaticForce(a:SongCloudTag):Vector {
		var f:Vector = new Vector();
		for (n in _nodes) {
// 			trace("comparing " + a.getTag() + " with " + n.getTag());
			if (n != a) {
				var apos:Vector = a.getPosition();
				var npos:Vector = n.getPosition();
				var r:Float = apos.distance(n.getPosition());
				var numerator:Vector = npos.subtract(apos);
				numerator.mult(_columb_constant);
				var total:Vector = numerator.divide(r * r * r);
// 				if (a.overlapsWith(n)) {
// // 					trace("overlap " + a.getTag() + " " + n.getTag());
// 					total.mult(100000);
// 				}
				f.add(total);
			}
		}
		return f;
	}

	function computeWallForce(a:SongCloudTag):Vector {
 		var force = new Vector();
		
		if (a.getLeftEdge() < 0) {
			force.x = a.getLeftEdge() * -100;
		}

		if (a.getRightEdge() > _width) {
			force.x = (a.getRightEdge() - _width) * -100;
		}

		if (a.getTopEdge() < 0) {
			force.y = a.getTopEdge() * -100;
		}

		if (a.getBottomEdge() > _width) {
			force.y = (a.getBottomEdge() - _height) * -100;
		}

// 		var apos:Vector = a.getPosition();
// 		var displacement:Vector = b.subtract(apos);

// 		var k:Float = 10.0;

// 		force = displacement.mult(k);

 		force.mult(5);

		return force;
	}


	////////////////////////////////////////////////////////////////////////////////
	//
	// Just show one tag per quadrant
	//
	////////////////////////////////////////////////////////////////////////////////

	public static function cycleQuadrants():Void {
		for (n in _nodes) {
 			n.visible = false;
			n.setColor(0x000000);
		}

		// Loop over all quadrants and choose one _node randomly in that quadrant
		// to display
		//
		// sness - This is a place that we could speed things up if we assumed
		// that all the nodes were static.  We could just precalculate these lists
		var quadrants : Array<Array<SongCloudTag>> = new Array();
		var divisions:Int = 5;
		var cell_width:Float = _width / divisions;
		var cell_height:Float = _height / divisions;
		for (x in 0...divisions) {
			for (y in 0...divisions) {
				var quadrant : Array<SongCloudTag> = new Array();
				var min_x:Float = x * cell_width;
				var max_x:Float = (x * cell_width) + cell_width;
				var min_y:Float = y * cell_height;
				var max_y:Float = (y * cell_height) + cell_height;
				for (n in _nodes) {
// 					if (n.getSelected() == true) {
						var nx:Float = n.getX();
						var ny:Float = n.getY();
						if (nx > min_x && nx < max_x && ny > min_y && ny < max_y) {
							quadrant.push(n);
						}
// 					}
				}
				quadrants.push(quadrant);
			}
		}


		// Loop over all quadrants and choose a random member from each quadrant
		for (quadrant in quadrants) {
			var num:Int = quadrant.length;
			if (num > 0) {
				var rand:Int = Std.int(Math.random() * num);
 				quadrant[rand].visible = true;
			}
		}

		for (n in _nodes) {
			if (n.getSelected() == true) {  
				n.visible = true;
				n.setColor(0xFF7700);
			}
		}
	}

	public static function unselectAll():Void {
		for (n in _nodes) {
			n.setSelected(false);
			n.setColor(0x000000);
		}
	}

	////////////////////////////////////////////////////////////////////////////////
	//
	// Regenerate the currently selected songs
	//
	////////////////////////////////////////////////////////////////////////////////

	// Find which Songs should be selected based on the items that are in
	// CurrentArtists and CurrentTags
	public static function regenerateSelected():Void {
// 		trace("regenerateSelected");
		var current_artists : Array<Artist> = CurrentArtists.getArtists();
		var current_tags : Array<Tag> = CurrentTags.getTags();
		
// 		trace(current_tags);

		for (n in _nodes) {
			n.setSelected(false);
		}

		if (current_artists.length == 0 && current_tags.length == 0) { 
			cycleQuadrants();
			return;
		}

		for (n in _nodes) {
			var matches_one_artist : Bool = false;
			var matches_one_tag : Bool = false;
			
			// Check to see if our query artist matches any artist we are given
			if (current_artists.length > 0) {
				for (artist in current_artists) {
					if (n.getSong().getArtist() == artist.getName()) {
						matches_one_artist = true;
					}
				}
			} else {
				matches_one_artist = true;
			}

			// Check to see if our query tag matches any tag we are given
			if (current_tags.length > 0) {
				for (song_tag in n.getSong().getFirstClip().getTags()) {
					for (tag in current_tags) {
						if (song_tag.getName() == tag.getName()) {
							matches_one_tag = true;
						}
					}
				}
			} else {
				matches_one_tag = true;
			}

// 			// Make a hash of all the tags that all the clips for this song
// 			// contains
// 			//
// 			// sness - Actually just do the first clip for now
// 			var clip_tags:Array<Tag> = n.getSong().getFirstClip().getTags();
// 			for (tag in current_tags) {
// // 				trace("matching tag=" + tag.getName());
// 				var match:Bool = false;
// 				for (clip_tag in clip_tags) {
// 					if (tag.getName() == clip_tag.getName()) {
// 						match = true;
// 						break;
// 					}
// 				}
// 				// If one of the matches is false, then the AND condition is also false
// 				if (match == false) {
// 					matches_all_tags = false;
// 					break;
// 				}
// 			}
			

			if (matches_one_artist && matches_one_tag) {
				n.setSelected(true);
			}
					
		}

		cycleQuadrants();
	}


	////////////////////////////////////////////////////////////////////////////////
	//
	// Change sorting order
	//
	////////////////////////////////////////////////////////////////////////////////

	public function randomOrder():Void {
		for (n in _nodes) {
			n.randomOrder();
		}
		calculate();
		cycleQuadrants();		
	}

	public function somOrder():Void {
		for (n in _nodes) {
			n.somOrder();
		}
		calculate();
		cycleQuadrants();		
	}

	public function alphabeticOrder():Void {
		var grid_edge:Int = Std.int(Math.sqrt(_nodes.length) + 1);
// 		trace("nodes=" + _nodes.length + " grid_edge=" + grid_edge);
		var sorted_nodes:Array<SongCloudTag> = _nodes;
		sorted_nodes.sort(alphabeticalSort);
		var x_index:Int = 0;
		var curr_x:Float = 0;
		var curr_y:Float = 0;
		var x_increment:Float = _width / grid_edge;
		var y_increment:Float = _height / grid_edge;
		for (n in sorted_nodes) {
// 			trace("setting " + n.getSongName() + " to " + curr_x + " " + curr_y);
			n.setOrigXY(curr_x,curr_y);
			curr_x += x_increment;
			x_index += 1;
			if (x_index > grid_edge) {
				curr_x = 0;
				curr_y += y_increment;
				x_index = 0;
			}
		}
		calculate();
		cycleQuadrants();		
	}


	function alphabeticalSort(a:SongCloudTag, b:SongCloudTag) {
 		if (a.getSongName() == b.getSongName()) 
			return 0;
		else if (a.getSongName() < b.getSongName())
			return -1;
		else
			return 1;
	}

	public static function getWidth():Float {
		return _width;
	}

	public static function getHeight():Float {
		return _height;
	}


	////////////////////////////////////////////////////////////////////////////////
	//
	// Utility functions
	//
	////////////////////////////////////////////////////////////////////////////////
	
	// A "r"easonable number of decimal points for trace()
	public function r(f:Float):Float {
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

	public static function playASelectedSongByArtist(artist:Artist) {
		for (n in _nodes) {
			if (n.getSelected()) {
				if (n.getSong().getArtist() == artist.getName()) {
					CurrentSong.changeSong(n.getSong().getFirstClip());
					return;
				}
			}
		}
	}

	public static function playASelectedSongByTag(tag:Tag) {
		for (n in _nodes) {
			if (n.getSelected()) {
				for (m in n.getSong().getFirstClip().getTags()) {
					if (m.getName() == tag.getName()) {
						CurrentSong.changeSong(n.getSong().getFirstClip());
						return;
					}
				}
			}
		}
	}

	public static function playASelectedSong() {
		for (n in _nodes) {
			if (n.getSelected()) {
				CurrentSong.changeSong(n.getSong().getFirstClip());
				return;
			}
		}

	}
}