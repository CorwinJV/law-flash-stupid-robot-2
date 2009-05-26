package code.structs
{
	import code.enums.AiInstructionsEnum;
	import code.enums.logicBlockEnum;
	import code.logicBlock;
	import flash.display.MovieClip;
	
	//import code.states.CreditsState;
	//import flash.display.MovieClip;
	//import flash.display.DisplayObject;
	//import flash.events.Event;
	//import flash.ui.Keyboard;
	//import code.GameStateManager;
	//import code.Key;
	//import code.GameVars;
	

	// state includes here
	public class subroutine extends MovieClip
	{
		var instructionList:Array = new Array();
		var currentInstruction:int;
	
		//default constructors, destructors
		public function subroutine()
		{
			currentInstruction = 0;
		}
		
		public function getCurrentInstructionIndex():int
		{
			return currentInstruction;
		}
		
		public function advanceCommand():Boolean
		{			
			if (instructionList.length <= 0)
			{
				trace ("Tried to advance command with no instructions in list");
				return false;
			}
			currentInstruction++;
			
			if (currentInstruction >= instructionList.length)
			{
				currentInstruction = 0;
				return false;
			}
			return true;
				
		}
	
		public function getNextCommand():AiInstructionsEnum
		{
			if (instructionList.length <= 0)
			{
				trace ("Tried to get next command with no instructions in list");
				return AiInstructionsEnum.DO_NOT_PROCESS;
			}
			return instructionList[currentInstruction];
		}
		
		public function getNextCommandBlock():int
		{
			return currentInstruction;
		}
		
		public function addCommand(newCommand:AiInstructionsEnum)
		{
			//trace("adding command int value of ", newCommand.toInt());
			instructionList.push(newCommand);
		}
		
		public function removeLastCommand():void
		{
			instructionList.pop();
		}
		
		public function clearInstructions()
		{
			instructionList = new Array();
			currentInstruction = 0;
		}
		
		public function coreDump():void
		{
			//vector <logicBlock*>::iterator itr = instructionList.begin();
//
			//std::cout << "Subroutine Core Dump: " << endl;
			//for(;itr < instructionList.end(); itr++)
			//{
				//std::cout << (*itr)->enumInstruction << " ";
			//}
			//std::cout << endl;
			
		}
	
		public function isEmpty():Boolean
		{
			return (instructionList.length == 0);
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