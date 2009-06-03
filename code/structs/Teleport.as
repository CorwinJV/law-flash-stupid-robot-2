package code.structs 
{
	import code.structs.object
	/**
	 * ...
	 * @author David Moss
	 */
	public class Teleport extends object
	{
		var targetX:int;
		var targetY:int;
		var selfX:int;
		var selfY:int;
		
		public function Teleport(x:int, y:int, newDirection:int)
		{
			super(x, y, newDirection);
			selfX = x;
			selfY = y;			
		}
		
		public function setPosition(x:int, y:int)
		{
			selfX = x;
			selfY = y;
		}
		
		public function setTarget(x:int, y:int)
		{
			targetX = x;
			targetY = y;
		}
		
		public function getSelfX():int
		{
			return selfX;
		}
		
		public function getSelfY():int
		{
			return selfY;
		}
		
		public function getTargetX():int
		{
			return targetX;
		}
		
		public function getTargetY():int
		{
			return targetY;
		}
		
		
	}
	
}