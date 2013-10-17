//
// Play Tag Now!
// 
// Copyright 2009 - sness@sness.net - GPL V3
//


import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.events.KeyboardEvent;
import flash.events.ProgressEvent;
import flash.events.IOErrorEvent;
import flash.media.Sound;
import flash.media.SoundChannel;
import flash.net.URLRequest;
import flash.external.ExternalInterface;
import flash.events.MouseEvent;
import flash.events.Event;
import flash.events.ProgressEvent;
import flash.events.IOErrorEvent;
import flash.display.Stage;
import flash.display.Sprite;
import flash.display.SimpleButton;
import flash.media.Sound;
import flash.media.SoundChannel;
import flash.net.URLRequest;

class PlayTagNow
{
	static var r : PlayTagNow;
	
	static var _well : Sprite;

	// The three clouds of data
	static var _song_cloud : SongCloud;
	static var _artist_cloud : ArtistCloud;
	static var _tag_cloud : TagCloud;

	// The current songs, tags and playing song
	static var _current_song : CurrentSong;
	static var _current_artists : CurrentArtists;
	static var _current_tags : CurrentTags;

	static var _shake_songs_button : PushButton;
	static var _shake_artists_button : PushButton;
	static var _shake_tags_button : PushButton;

	static var _random_button : PushButton;
	static var _som_button : PushButton;
	static var _alphabetic_button : PushButton;

	static var _clip_info_loader : ClipInfoLoader;
	static var _grid_loader : GridLoader;
	static var _tag_loader : TagLoader;

	static var _clips : Clips;
	static var _tags : Tags;

	static var _global_settings : GlobalSettings;

	private static var _now:Int;
	private static var _then:Int;

	static var _step : Int;

	static var _ready : Bool;

	function new() {
	}

	static function main ()
	{
		// Instantiate a GlobalSettings object
		// sness - We need to do this in order to call the new() method
		_global_settings = new GlobalSettings();
		_clips = new Clips();
		_tags = new Tags();

		// Listen to events on the stage
		flash.Lib.current.stage.addEventListener(MouseEvent.MOUSE_DOWN, mainMouseDown);
		flash.Lib.current.stage.addEventListener(MouseEvent.MOUSE_UP, mainMouseUp);
		flash.Lib.current.stage.addEventListener(KeyboardEvent.KEY_DOWN, mainKeyDown);

 		// Setup the main Timer object 
  		var t = new haxe.Timer(5);
  		t.run = onTimer;

		// Setup the now and then times
		_then = flash.Lib.getTimer();
		_now = _then;
		_step = 0;

		// Is everything loaded?
		_ready = false;

		// Well to hold everything
		_well = new Sprite();

		////////////////////////////////////////////////////////////////////////////////
		// The SongCloud
// 		_song_cloud = new SongCloud(30,0,300,300);
 		_song_cloud = new SongCloud(30,130,300,300);
		_well.addChild(_song_cloud);

		// The Currently selected song
// 		_current_song = new CurrentSong(10,360,340,200);
 		_current_song = new CurrentSong(10,460,340,200);
		_well.addChild(_current_song);
		////////////////////////////////////////////////////////////////////////////////

		////////////////////////////////////////////////////////////////////////////////
		// The Song Cloud
// 		_artist_cloud = new ArtistCloud(380,30,300,300);
 		_artist_cloud = new ArtistCloud(380,130,300,300);
		_well.addChild(_artist_cloud);

		// The Currently selected songs
// 		_current_artists = new CurrentArtists(360,360,340,200);
 		_current_artists = new CurrentArtists(360,460,340,200);
		_well.addChild(_current_artists);
		////////////////////////////////////////////////////////////////////////////////

		////////////////////////////////////////////////////////////////////////////////
		// The Tag Cloud
// 		_tag_cloud = new TagCloud(730,30,300,300);
 		_tag_cloud = new TagCloud(730,130,300,300);
		_well.addChild(_tag_cloud);

		// The Currently selected tags
// 		_current_tags = new CurrentTags(710,360,340,200);
 		_current_tags = new CurrentTags(710,460,340,200);
		_well.addChild(_current_tags);
		////////////////////////////////////////////////////////////////////////////////

		// The shake songs button
// 		_shake_songs_button = new PushButton(160,10,200,20,"shake");
 		_shake_songs_button = new PushButton(160,80,200,20,"shake");
  		_shake_songs_button.addEventListener(PushButtonEvent.PUSHBUTTON,shakeSongsListener);
		_well.addChild(_shake_songs_button);

		// The shake artists button
// 		_shake_artists_button = new PushButton(510,10,200,20,"shake");
 		_shake_artists_button = new PushButton(510,80,200,20,"shake");
// 		_shake_artists_button = new PushButton(510,80,200,20,"shake");
  		_shake_artists_button.addEventListener(PushButtonEvent.PUSHBUTTON,shakeArtistsListener);
		_well.addChild(_shake_artists_button);

		// The shake tags button
// 		_shake_tags_button = new PushButton(860,10,200,20,"shake");
 		_shake_tags_button = new PushButton(860,80,200,20,"shake");
  		_shake_tags_button.addEventListener(PushButtonEvent.PUSHBUTTON,shakeTagsListener);
		_well.addChild(_shake_tags_button);

		// The random button
//  		_random_button = new PushButton(110,580,200,20,"random");
 		_random_button = new PushButton(110,680,200,20,"random");
  		_random_button.addEventListener(PushButtonEvent.PUSHBUTTON,randomListener);
		_well.addChild(_random_button);

		// The som button
// 		_som_button = new PushButton(310,580,200,20,"som");
 		_som_button = new PushButton(310,680,200,20,"som");
  		_som_button.addEventListener(PushButtonEvent.PUSHBUTTON,somListener);
		_well.addChild(_som_button);

		// The alphabetic button
		_alphabetic_button = new PushButton(510,680,200,20,"alphabetic");
  		_alphabetic_button.addEventListener(PushButtonEvent.PUSHBUTTON,alphabeticListener);
		_well.addChild(_alphabetic_button);

// 		// The List of songs that the user has selected
// 		_song_list = new SongList(930,10,200,510);
// 		_well.addChild(_song_list);

		// Load data files
		//
		// sness - The GridLoader and TagLoader depend on data from the
		// ClipInfoLoader, so load them after the ClipInfoLoader is done
//  		_clip_info_loader = new ClipInfoLoader("tiny_clip_info_final.csv");
  		_clip_info_loader = new ClipInfoLoader("out_clip_info.csv");
		_grid_loader = new GridLoader();
		_tag_loader = new TagLoader();

		// Listen for done loading events
		_clip_info_loader.addEventListener(ClipInfoLoader.DONE_LOADING_EVENT,clipLoadedListener);
		_grid_loader.addEventListener(GridLoader.DONE_LOADING_EVENT,calculateTagPositions);
		_tag_loader.addEventListener(TagLoader.DONE_LOADING_EVENT,calculateTagPositions);

		flash.Lib.current.stage.addChild(_well);
	}

	static private function mainMouseDown(e:Event):Void {
	}

	static private function mainMouseUp(e:Event):Void {
	}

	static private function mainKeyDown(e:KeyboardEvent):Void {
//  		_artist_cloud.calculate();
// 		_tag_cloud.calculate();

//   		ArtistCloud.cycleQuadrants();

	}


	static private function clipLoadedListener(e:Event):Void {
 		_grid_loader.load("out_grid.txt");
 		_tag_loader.load("out_annotations.csv");
// 		_grid_loader.load("tiny_grid.csv");
// 		_tag_loader.load("tiny_annotations_final.csv");
	}

	static private function calculateTagPositions(e:Event):Void {

		if (_clip_info_loader.getLoaded() && _grid_loader.getLoaded() && _tag_loader.getLoaded()) {
			_artist_cloud.calculateArtistPositions();
  			_tag_cloud.calculateTagPositions();
  			_song_cloud.calculateSongPositions();
			_ready = true;
		}
	}

	static function onTimer() {
 		// Update times
 		_then = _now;
 		_now = flash.Lib.getTimer();

// 		trace(_step);
 		_step += 1;

		if (_step % 2 == 0 && _step < 100) {
			_artist_cloud.calculate();
 			_tag_cloud.calculate();
		}

// 		if (_ready) {
// 			if (_step % 200 == 0) {
// 				_artist_cloud.cycleQuadrants();
// 				_tag_cloud.cycleQuadrants();
// 				_song_cloud.cycleQuadrants();
// 			}
// 		}

	}

	static private function shakeSongsListener(e:Event):Void {
 		if (_ready) {
			SongCloud.cycleQuadrants();
		}
	}

	static private function shakeArtistsListener(e:Event):Void {
 		if (_ready) {
			ArtistCloud.cycleQuadrants();
		}
	}

	static private function shakeTagsListener(e:Event):Void {
 		if (_ready) {
			TagCloud.cycleQuadrants();
		}
	}

	static private function randomListener(e:Event):Void {
 		_song_cloud.randomOrder();
		_artist_cloud.randomOrder();
		_tag_cloud.randomOrder();
		_step = 0;
	}

	static private function somListener(e:Event):Void {
 		_song_cloud.somOrder();
		_artist_cloud.somOrder();
		_tag_cloud.somOrder();
		_step = 0;
	}

	static private function alphabeticListener(e:Event):Void {
 		_song_cloud.alphabeticOrder();
		_artist_cloud.alphabeticOrder();
		_tag_cloud.alphabeticOrder();
		_step = 0;
	}

}

