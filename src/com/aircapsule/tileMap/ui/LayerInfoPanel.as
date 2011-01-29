package com.aircapsule.tileMap.ui
{
	import com.aircapsule.tileMap.layers.LayerInfoBlock;
	
	import flash.events.MouseEvent;
	
	import mx.core.IVisualElement;
	
	import nl.demonsters.debugger.MonsterDebugger;
	
	import spark.components.Group;
	import spark.components.VGroup;

	public class LayerInfoPanel extends VGroup
	{
		protected var _parentGroup:Group;
		
		protected var _infoBlocks:Vector.<LayerInfoBlock>;
		
		public function LayerInfoPanel($parentGroup:Group)
		{
			super();
			_parentGroup = $parentGroup;
				
			this.graphics.beginFill(0x00FF00, 0.6);
			this.graphics.drawRect(0,0,_parentGroup.width, _parentGroup.height);
			this.graphics.endFill();
			
			this.percentWidth = 100;
			this.percentHeight = 100;
			
			_infoBlocks = new Vector.<LayerInfoBlock>();
		}
		
		public override function addElement(element:IVisualElement):IVisualElement{
			super.addElement(element);
			
			
			element.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler, false, 0, true);
			element.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler, false, 0, true);
			_infoBlocks.push(element);
			
			return element;
		}
		
		public override function removeElement(element:IVisualElement):IVisualElement{
			var index:int = _infoBlocks.indexOf(element);
			if(index != -1){
				_infoBlocks.splice(index, 1);
			}
			return super.removeElement(element);
		}
		
		protected function mouseDownHandler($e:MouseEvent):void{
			var infoBlock:LayerInfoBlock = ($e.target as LayerInfoBlock);
			infoBlock.startDrag();
			_infoBlocks.splice(infoBlock.index, 1);
		}
		
		protected function mouseUpHandler($e:MouseEvent):void{
			($e.target as LayerInfoBlock).stopDrag();
		}
	}
}