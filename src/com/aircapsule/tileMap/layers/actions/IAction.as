package com.aircapsule.tileMap.layers.actions
{
	import com.aircapsule.tileMap.layers.Layer;
	
	import flash.events.MouseEvent;

	public interface IAction
	{
		function enableEvents($layer:Layer):void;
		
		function disableEvents($layer:Layer):void;
		
		function mouseDownHandler($e:MouseEvent):void;
		
		function mouseUpHandler($e:MouseEvent):void;
		
		function mouseInHandler($e:MouseEvent):void;
		
		function mouseOutHandler($e:MouseEvent):void;
		
		function mouseMoveHandler($e:MouseEvent):void;
		
		function rightMouseClickHandler($e:MouseEvent):void;
	}
}