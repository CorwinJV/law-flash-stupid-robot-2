package code
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import code.GameState;
	import code.enums.GameStateEnum;
	import code.main;
	
	public class GameStateManager
	{
		var stateList:Array;
		var statesToAdd:Array;
		var rootContainer:DisplayObjectContainer;
		var debugInt:int = 0;
		
		public function GameStateManager(container:DisplayObjectContainer)
		{
			rootContainer = container;
			stateList = new Array();
			statesToAdd = new Array();
		}
		
		public function Update()
		{
			var i:int = 0;
			
			debugInt++;
			if (debugInt > 10)
			{
				debugInt = 0;
				// lets output the current statelist
				for (var x:int = 0; x < stateList.length; x++)
				{
					//trace("State #", x, " is of type ", stateList[x].getStateName(), " is set to status ", stateList[x].getStatus().toInt());
				}
			}
			
			// Add states-in-waiting to the real list.
			for(i = 0; i < statesToAdd.length; i++)
			{
				rootContainer.addChild(statesToAdd[i]);
				statesToAdd[i].initMouse();
				stateList.push(statesToAdd[i]);
			}
			
			var arrayLength:int = statesToAdd.length;
			
			for(i = 0; i < arrayLength; i++)
			{
				statesToAdd.pop();
			}
			
			// Main state updating
			for(i = 0; i < stateList.length; i++)
			{
				if(stateList[i].getStatus().toInt() == GameStateEnum.ACTIVE.toInt())
				{
					stateList[i].Update();
				}
			}
			
			// Collect Garbage
			setTopStateToActive();
			collectGarbage();
		}
		
		public function hasGameState(str:String):Boolean
		{
			var b:Boolean = false;
			
			var length:int = stateList.length;
			for (var i:int = 0; i < length; i++)
			{
				if (stateList[i].getStateName() == str)
				{
					b = true;
				}
			}
			
			return b;
		}
		
		public function deleteAllGameStatesWithName(str:String)
		{
			var length:int = stateList.length;
			for (var i:int = 0; i < length; i++)
			{
				if (stateList[i].getStateName() == str)
				{
					//trace("Deleting game state of type: " + str);
					stateList[i].setStatus(GameStateEnum.DELETE_ME);
				}
			}
		}
		
		public function deleteAllButTopState()
		{
			for (var x:int  = 0; x < stateList.length - 1; x++)
			{
				stateList[x].setStatus(GameStateEnum.DELETE_ME);
			}
		}
		
		private function setTopStateToActive()
		{
			//trace("we currently have ", stateList.length, " elements in statelist, we're going to index to statelist[", stateList.length - 1, "]");
			if ((stateList[stateList.length-1].getStatus().toInt() == GameStateEnum.PASSIVE.toInt()))
			{
				//trace("State #", stateList.length-1, " is of type ", stateList[stateList.length-1].getStateName(), " is set to status ", stateList[stateList.length-1].getStatus().toInt(), "so i'm going to set it back to active");
				stateList[stateList.length-1].setStatus(GameStateEnum.ACTIVE);
			}
		}
		
		public function setTopStateToDeleteMe()
		{
			stateList[stateList.length - 1].setStatus(GameStateEnum.DELETE_ME);
		}
		
		public function addGameState(tmpState:GameState)
		{
			statesToAdd.push(tmpState);
		}
		
		public function collectGarbage()
		{
			for(var i:int; i < stateList.length; i++)
			{
				if(stateList[i].getStatus().toInt() == GameStateEnum.DELETE_ME.toInt())
				{
					//trace("State #", i, " is of type ", stateList[i].getStateName(), " is set to status ", stateList[i].getStatus().toInt(), "and i'm going to go ahead and try to delete it");
					stateList[i].destruct();
					rootContainer.removeChild(stateList[i]);
					//trace("about to delete " + stateList[i]);
					delete(stateList[i]);
					//trace("finished deleting (should say undefined) " + stateList[i]);
					stateList.splice(i, 1);
				}
			}
		}
	}
}