all: ../playtagnow.swf

install: ../playtagnow.swf
	cp ../playtagnow.swf ../staging-playtagnow.swf

../playtagnow.swf: PlayTagNow.hx Player.hx SoundPlayer.hx PlayButton.hx VolumeSlider.hx VolumeButton.hx TimeIndicator.hx Visualization.hx CurrentSong.hx CurrentTags.hx TagCloud.hx TagCloudTag.hx ArtistCloud.hx ArtistCloudTag.hx SongCloud.hx SongCloudTag.hx ClipInfoLoader.hx GridLoader.hx TagLoader.hx GlobalSettings.hx Clips.hx Clip.hx Song.hx Artist.hx Tag.hx CurrentArtists.hx CurrentArtistsLine.hx TagLoader.hx playtagnow.hxml
	haxe playtagnow.hxml

swflib.swf: swflib.xml
	/usr/sness/haxe/bin/swfmill simple swflib.xml swflib.swf
