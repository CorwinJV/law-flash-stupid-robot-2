package code.structs 
{
	import flash.display.MovieClip;
	import code.enums.AiInstructionsEnum;
	import code.enums.logicBlockEnum;
	import code.GameVars;
	
	/**
	 * ...
	 * @author David Moss
	 */
	public class object extends MovieClip
	{
		private var xPos:int;
		private var yPos:int;
		private var direction:int;
		private var active:Boolean;
		private var startXPos:int;
		private var startYPos:int;
		private var startDirection:int;
		private var startActive:Boolean;
		private var image:MovieClip;
		private var instructionList:Array = new Array();
		private var currentInstruction:int;
		private var maxInstruction:int;
		private var alive:Boolean;
		
		public function object(x:int, y:int, newDirection:int) 
		{
			setXPos(x);
			setYPos(y);
			direction = newDirection;
			active = true;
			startXPos = x;
			startYPos = y;
			startDirection = newDirection;
			startActive = true;
			currentInstruction = 0;
			alive = true;
		}
		
		public function getCurrentInstructionIndex():int
		{
			return currentInstruction;
		}
		
		public function getActive():Boolean
		{
			return active;
		}
		
		public function getDirection():int
		{
			return direction;
		}
		
		public function getXPos():int
		{
			return xPos;
		}
		
		public function getYPos():int
		{
			return yPos;
		}
		
		public function setActive(activate:Boolean):void
		{
			active = activate;
		}
		
		public function toggleActive():void
		{
			if (active == true)
			{
				active == false;
			}
			else
			{
				active == true;
			}
		}
		
		public function rotate(rotation:int):void
		{
			direction += rotation;
			
			if (direction < 0)
			{
				direction = 3;
			}
			if (direction > 3)
			{
				direction = 0;
			}
		}
		
		public function setXPos(x:int)
		{
			xPos = x;
		}
		
		public function setYPos(y:int)
		{
			yPos = y;
		}
		
		public function advanceCommand()
		{
			if (instructionList.length <= 0)
			{
				trace ("Tried to advance command with no instructions in list");
				return;
			}
			currentInstruction++;
			if(currentInstruction >= instructionList.length)
				currentInstruction = 0;
		}
		
		public function getNextCommand():AiInstructionsEnum
		{
			if (instructionList.length <= 0)
			{
				trace ("Tried to get next command with no instructions in list");
				return AiInstructionsEnum.DO_NOT_PROCESS;
			}
			return instructionList[currentInstruction];
			//return (*currentInstruction)->enumInstruction;
		}

		public function getNextCommandBlock():void//logicBlockEnum
		{
			//return (*currentInstruction);
		}
		
		public function startOver()
		{
			xPos = startXPos;
			yPos = startYPos;
			direction = startDirection;
			active = startActive;
		}
		
		public function addCommand(newCommand:AiInstructionsEnum)
		{
			//trace("adding command int value of ", newCommand.toInt());
			instructionList.push(newCommand);
		}
		
		public function removeLastCommand()
		{
			instructionList.pop();
		}

		public function clearInstructions()
		{
			instructionList = new Array();
			currentInstruction = 0;
		}

		public function coreDump()
		{
			trace ("Core Dump: ", instructionList.length, " items in list");
			//for(;itr < instructionList.end(); itr++)
			for (var x:int = 0; x < instructionList.length; x++)
			{
				trace (instructionList[x].toInt());
			}
		}

		public function setAlive(status:Boolean)
		{
			alive = status;
		}
		
		public function getAlive():Boolean
		{
			return alive;
		}

		public function reset()
		{
			xPos = startXPos;
			yPos = startYPos;
			direction = startDirection;
		}

		public function setDefaults(direction:int, x:int, y:int)
		{
			startXPos = x;
			startYPos = y;
			startDirection = direction;
		}	
		
		public function isOnFirstCommand():Boolean
		{
			if (currentInstruction == 0)
			{
				return true;
			}
			else
			{
				return false;
			}
		}
	}	
}