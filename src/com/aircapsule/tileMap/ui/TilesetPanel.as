package com.aircapsule.tileMap.ui
{
	import com.aircapsule.tileMap.TilesetManager;
	import com.aircapsule.tileMap.display.Tileset;
	
	import flash.events.Event;
	
	import mx.core.UIComponent;
	
	import spark.components.DropDownList;
	import spark.components.Group;

	public class TilesetPanel extends UIComponent
	{
		protected var _parentGroup:Group;
		
		protected var _dropDown:DropDownList;
		
		protected var _tileset:Tileset;
		
		public function TilesetPanel($parentGroup:Group, $dropDown:DropDownList)
		{
			_parentGroup = $parentGroup;
			_dropDown = $dropDown;
			
			this.graphics.beginFill(0xCCCCCC, 0.6);
			this.graphics.drawRect(0,0,_parentGroup.width, _parentGroup.height-_dropDown.height);
			this.graphics.endFill();
			
			//TODO: resize handler!
			this.addEventListener(Event.ADDED_TO_STAGE, onStageHandler);
		}
		
		private function onStageHandler($e:Event):void{
			this.stage.nativeWindow.addEventListener(Event.RESIZE, resizeHandler);
		}
		
		private function resizeHandler($e:Event):void{
			resize();
		}
		
		private function resize(){
			// reset tiles scale to original, ready to update scale
			_tileset.scaleX = 1;
			_tileset.scaleY = 1;
			
			var ratioX:Number = _parentGroup.width/_tileset.width;
			var ratioY:Number = (_parentGroup.height-_dropDown.height)/_tileset.height;
			var ratio = ratioX;
			if(ratioY < ratioX){
				ratio = ratioY;
			}
			_tileset.scaleX = ratio;
			_tileset.scaleY = ratio;
		}
		
		public function displayTileset($tileset:Tileset):void{
			_tileset = $tileset;
			this.addChild(_tileset);
			
			resize();
		}
	}
}