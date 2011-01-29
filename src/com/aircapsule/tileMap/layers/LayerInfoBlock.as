package com.aircapsule.tileMap.layers
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	import mx.core.UIComponent;
	
	import nl.demonsters.debugger.MonsterDebugger;
	

	public class LayerInfoBlock extends UIComponent
	{
		public var index:uint;
		
		protected var _layer:Layer;
		
		public var label:String;
		
		public function LayerInfoBlock($layer:Layer)
		{
			super();
			
			_layer = $layer;
			
			this.graphics.beginFill(0xFF0000, 0.8);
			this.graphics.drawRect(0, 0, 100, 50);
			this.graphics.endFill();
			
			this.height = 50;
			this.percentWidth = 100;
		}
		
		public function get layer():Layer{
			return _layer;
		}
		
		public override function get visible():Boolean{
			return super.visible;
		}
		
		public override function set visible($flag:Boolean):void{
			super.visible = $flag;
		}
	}
}