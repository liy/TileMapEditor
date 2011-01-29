package com.aircapsule.tileMap.history
{
	public interface IHistory
	{
		function destroy():void;
		function undo():void;
		function redo():void;
	}
}