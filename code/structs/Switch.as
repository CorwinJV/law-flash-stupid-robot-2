package code.structs 
{
	import code.enums.tileEnums;
	
	/**
	 * ...
	 * @author David Moss
	 */
	public class Switch extends object
	{
		var targetList:Array = new Array();
		var targetX:Array = new Array();
		var targetY:Array = new Array();
		var xTargetNum:int;
		var yTargetNum:int;
		var dTargetNum:int;
		var numTargets:int;
		var targetType:Array = new Array();
		
		public function Switch(x:int, y:int, newDirection:int) 
		{
			super(x, y, newDirection);
			numTargets = 0;
			clearTargets();
			xTargetNum = 0;
			yTargetNum = 0;
		}
		
		private function clearTargets()
		{
			if (targetX.length > 0)
			{
				for (var x:int = 0; x < numTargets; x++)
				{
					targetX.pop();					
				}
			}
			if (targetY.length > 0)
			{
				for (var y:int = 0; y < numTargets; y++)
				{
					targetY.pop();
				}
			}
			
			if (targetType.length > 0)
			{
				for (var z:int = 0; z < numTargets; z++)
				{
					targetType.pop();
				}
			}
		}
		
		public function addTarget(x:int, y:int)
		{
			targetX.push(x);
			targetY.push(y);
			numTargets++;
			xTargetNum = 0;
			yTargetNum = 0;
		}
		
		public function addTargetD(x:int, y:int, nType:tileEnums)
		{
			//trace("inside the actual switch, adding target at ", x, ", ", y, " with new target type of ", nType.toInt());
			targetX.push(x);
			targetY.push(y);
			targetType.push(nType);
			numTargets++;
			xTargetNum = 0;
			yTargetNum = 0;
			dTargetNum = 0;
		}
		
		public function getNumTargets():int
		{
			return numTargets;
		}
		
		public function getNextX():int
		{
			var tempX:int;
			tempX = targetX[xTargetNum];
			xTargetNum++;
			if (xTargetNum > numTargets)
			{
				xTargetNum = 0;
			}
			return tempX;
		}
		
		public function getNextY():int
		{
			var tempY:int;
			tempY = targetY[yTargetNum];
			yTargetNum++;
			if (yTargetNum > numTargets)
			{
				yTargetNum = 0;
			}
			return tempY;
		}
		
		public function getNextType():tileEnums
		{
			var tempType:tileEnums;
			
			return tileEnums.TBreakable;
		}
		
		public function getTargetX():int
		{
			return targetX[xTargetNum];
		}
		
		public function getTargetY():int
		{
			return targetY[yTargetNum];
		}
		
		public function getTargetType():tileEnums
		{
			return targetType[dTargetNum];
		}
		
		public function setTargetX(newX:int)
		{
			targetX[xTargetNum] = newX;
		}
		
		public function setTargetY(newY:int)
		{
			targetY[yTargetNum] = newY;
		}
		
		public function setTargetType(newType:tileEnums)
		{
			targetType[dTargetNum] = newType;
		}
		
		public function cycleTargets()
		{
			xTargetNum++;
			if (xTargetNum >= numTargets)
			{
				//trace("resetting a switch x list");
				xTargetNum = 0;
			}
			
			yTargetNum++;
			if(yTargetNum >= numTargets)
			{
				//trace("resetting a switch y list");
				yTargetNum = 0;			
			}
			
			dTargetNum++;
			if (dTargetNum >= numTargets)
			{
				//trace("resetting a switch dtarget list");
				dTargetNum = 0;
			}
		}
		
		public override function reset()
		{
			xTargetNum = 0;
			yTargetNum = 0;
			dTargetNum = 0;
		}
		
		
		
		
		
	}
	
}