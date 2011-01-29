package com.aircapsule.tileMap.auxiliary
{
	public class Utils
	{
		public static function nextPowerOf2($v:uint):uint{
			$v |= ($v >> 1);
			$v |= ($v >> 2);
			$v |= ($v >> 4);
			$v |= ($v >> 8);
			$v |= ($v >> 16);
			return $v+1;
		}
	}
}