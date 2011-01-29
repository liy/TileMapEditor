package com.aircapsule.tileMap
{
	import com.aircapsule.tileMap.display.Tileset;
	import com.aircapsule.tileMap.ui.TilesetPanel;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	
	import mx.collections.ArrayList;
	
	import nl.demonsters.debugger.MonsterDebugger;
	
	import spark.components.DropDownList;
	

	public class TilesetManager extends EventDispatcher
	{
		private static var INSTANCE:TilesetManager
		
		private var _tilesets:Vector.<Tileset>;
		private var _keys:Vector.<String>;
		
		private var _tileSize:uint = 32;
		
		private var _dropDown:DropDownList;
		
		private var _tilesetPanel:TilesetPanel;
		
		private var _selectedTileset:Tileset;
		
		private var _tilesetList:ArrayList = new ArrayList();
		
		public function TilesetManager()
		{
		}
		
		public static function getInstace():TilesetManager{
			if(INSTANCE == null){
				INSTANCE = new TilesetManager();
			}
			return INSTANCE;
		}
		
		public function init($dropDown:DropDownList, $tilesetPanel:TilesetPanel, $tileSize:uint=32):void{
			_tilesets = new Vector.<Tileset>();
			_keys = new Vector.<String>();
			
			_tileSize = $tileSize;
			
			_dropDown = $dropDown;
			_dropDown.addEventListener(Event.CHANGE, tilesetSelectionHandler, false, 0, true);
			
			_tilesetPanel = $tilesetPanel;
		}
		
		private function tilesetSelectionHandler($e:Event):void{
			if(_selectedTileset != null){
				_tilesetPanel.removeChild(_selectedTileset);
			}
			var index:int = _keys.indexOf($e.target.selectedItem.url);
			_selectedTileset = _tilesets[index];
			// tell panel to display the tileset
			_tilesetPanel.displayTileset(_selectedTileset);
		}
		
		/**
		 * First you have to open a tileset 
		 * @param $url
		 * 
		 */		
		public function openTileset($url:String):void{
			var index:int = _keys.indexOf($url);
			if(index == -1){
				var tileset:Tileset = new Tileset($url);
				tileset.addEventListener(Event.COMPLETE, tilesetLoadedHandler);
				tileset.load();
				MonsterDebugger.trace(this, "load: "+$url);
			}
			
		}
		
		private function tilesetLoadedHandler($e:Event):void{
			var tileset:Tileset = $e.target as Tileset;
			tileset.removeEventListener(Event.COMPLETE, tilesetLoadedHandler);
			
			_keys.push(tileset.url);
			_tilesets.push(tileset);
			
			// add it into the dropdownlist
			_tilesetList.addItem({label:tileset.url, url:tileset.url});
			_dropDown.dataProvider = _tilesetList;
		}
		
		public function removeTileset($url:String):void{
			var index:int = _keys.indexOf($url);
			if(index != -1){
				_keys.splice(index, 1);
				_tilesets[index].destroy();
				_tilesets.splice(index, 1);
			}
		}
		
		public function getTileset($url:String):Tileset{
			var index:int = _keys.indexOf($url);
			if(index != -1){
				return _tilesets[index];
			}
			else{
				return null;
			}
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */		
		public function get selectedTileset():Tileset{
			return _selectedTileset;
		}
		
		public function set tileSize($size:uint):void{
			_tileSize = $size;
		}
		
		public function get tileSize():uint{
			return _tileSize;
		}
	}
}