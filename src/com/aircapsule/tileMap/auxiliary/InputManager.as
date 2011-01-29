package com.aircapsule.tileMap.auxiliary
{
	import com.aircapsule.tileMap.TilesetManager;
	
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.FileListEvent;
	import flash.events.KeyboardEvent;
	import flash.filesystem.File;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.ui.Keyboard;
	
	import nl.demonsters.debugger.MonsterDebugger;

	public class InputManager
	{
		private static var INSTANCE:InputManager;
		
		private var _stage:Stage;
		
		public function InputManager()
		{
		}
		
		public static function getInstance():InputManager{
			if(INSTANCE == null){
				INSTANCE = new InputManager();
			}
			return INSTANCE;
		}
		
		public function destroy():void{
			_stage.removeEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
		}
		
		public function init($stage:Stage):void{
			_stage = $stage;
			_stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler, false, 0, true);
		}
		
		private function keyDownHandler($e:KeyboardEvent):void{
			if($e.ctrlKey && $e.keyCode == Keyboard.O){
				var file:File = File.applicationDirectory;
				file.addEventListener(FileListEvent.SELECT_MULTIPLE, openFilesHandler);
				var ff:FileFilter = new FileFilter("Tileset", "*.jpg;*.gif;*.png"); 
				file.browseForOpenMultiple("Select tileset image", [ff]);
			}
		}
		
		private function openFilesHandler($e:FileListEvent):void{
			for each(var file:File in $e.files){
				TilesetManager.getInstace().openTileset(file.url);
			}
		}
	}
}