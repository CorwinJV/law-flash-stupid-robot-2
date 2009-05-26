package code 
{
	import code.enums.tileEnums;
	import code.structs.Switch;
	
	/**
	 * ...
	 * @author David Moss
	 */
	public class switchManager 
	{
		private var switchList:Array =  new Array();
		
		private var lastSwitchAddedTargets:int;
		private var lastSwitchAddedTargetsAdded:int;
		
		private var targetsToProcess:int;
		private var targetsProcessed:int;
		private var stillProcessing:Boolean;
		
		public function switchManager() 
		{
			lastSwitchAddedTargets = 0;
			lastSwitchAddedTargetsAdded = 0;
		}
		
		public function clearSwitchList()
		{
			switchList = new Array();
		}
		
		public function addSwitch(mapXPos:int, mapYPos:int, numTargets:int)
		{
			if (lastSwitchAddedTargets != lastSwitchAddedTargetsAdded)
			{
				trace("MAP ERROR: A switch was added without a full target list");
			}
			var tempSwitch:Switch = new Switch(mapXPos, mapYPos, 0);
			lastSwitchAddedTargets = numTargets;
			lastSwitchAddedTargetsAdded = 0;
			switchList.push(tempSwitch);			
			//trace ("Adding switch with ", numTargets, " targets");
		}
		
		public function addTargetToLastSwitch(targetX:int, targetY:int)
		{
			//trace("Adding target to position ", switchList.length - 1);
			switchList[switchList.length-1].addTarget(targetX, targetY);
			lastSwitchAddedTargetsAdded++;
		}
		
		public function addTargetToLastSwitchD(targetX:int, targetY:int, nType:tileEnums)
		{
			//trace("Adding target to position ", switchList.length - 1);
			switchList[switchList.length - 1].addTargetD(targetX, targetY, nType);
			lastSwitchAddedTargetsAdded++;
		}
		
		////////////////////////////
		// isThereASwitchAt
		public function isThereASwitchAt(mapXPos:int, mapYPos:int):Boolean
		{
			//trace("Checking if there's a switch at ", mapXPos, ", ", mapYPos);
			// lets iterate through the list and see if the requested position has a switch
			for (var x:int = 0; x < switchList.length; x++)
			{
				//trace("checking against a switch with an x/ypos of ", switchList[x].getXPos(), ", ", switchList[x].getYPos());
				if((switchList[x].getXPos() == mapXPos) && (switchList[x].getYPos() == mapYPos))
				{
					//trace("and we found a switch here");
					// we have a match
					return true;
				}
			}
			// oh noes
			return false;
		}
		

		////////////////////////////
		// getNumTargets
		public function getNumTargets(mapXPos:int, mapYPos:int):int
		{
			// lets iterate through the list, see what's at our position and find out how many targets this sucker has
			for (var x:int = 0; x < switchList.length; x++)
			{
				if((switchList[x].getXPos() == mapXPos) && (switchList[x].getYPos() == mapYPos))
				{
					// houston we have a match
					// now lets return the number of targets this puppy has
					return switchList[x].getNumTargets();
				}
			}
			return -1;
		}

		////////////////////////////
		// getCurrentTargetX
		public function getCurrentTargetX(mapXPos:int, mapYPos:int):int
		{
			// lets iterate through the list, see what's at our position and find out it's current targetx
			for (var x:int = 0; x < switchList.length; x++)
			{
				if((switchList[x].getXPos() == mapXPos) && (switchList[x].getYPos() == mapYPos))
				{
					return switchList[x].getTargetX();
				}
			}
			return -1;
		}

		////////////////////////////
		// getCurrentTargetY
		public function getCurrentTargetY(mapXPos:int, mapYPos:int):int
		{
			// lets iterate through the list, see what's at our position and find out it's current targetx
			for (var x:int = 0; x < switchList.length; x++)
			{
				if((switchList[x].getXPos() == mapXPos) && (switchList[x].getYPos() == mapYPos))
				{
					return switchList[x].getTargetY();
				}
			}
			return -1;
		}
		
		////////////////////////////
		// getCurrentTargetType
		public function getCurrentTargetType(mapXPos:int, mapYPos:int):tileEnums
		{
			// lets iterate through the list, see what's at our position and find out it's current targetx
			for (var x:int = 0; x < switchList.length; x++)
			{
				if((switchList[x].getXPos() == mapXPos) && (switchList[x].getYPos() == mapYPos))
				{
					return switchList[x].getTargetType();
				}
			}
			return tileEnums.TEmpty;
		}
		
		

		// management sorta

		////////////////////////////
		// advanceTarget
		public function advanceTarget(mapXPos:int, mapYPos:int)
		{
			// lets iterate through the list, see what's at our position and cycle its targets
			for (var x:int = 0; x < switchList.length; x++)
			{
				if((switchList[x].getXPos() == mapXPos) && (switchList[x].getYPos() == mapYPos))
				{
					switchList[x].cycleTargets();
					targetsProcessed++;
					//std::cout << "targets processed = " << targetsProcessed << " targetstoprocess = " << targetsToProcess << endl;
				}
			}
		}

		////////////////////////////
		// startProcessing
		public function startProcessing(mapXPos:int, mapYPos:int)
		{
			// lets iterate through the list, see what's at our position and find out it's current targets
			

			for (var x:int = 0; x < switchList.length; x++)
			{
				if((switchList[x].getXPos() == mapXPos) && (switchList[x].getYPos() == mapYPos))
				{
					targetsToProcess = switchList[x].getNumTargets();
					targetsProcessed = 0;
					///
					//std::cout << "started processing switch with " << targetsToProcess << " targets" <<endl;
				}
			}
			targetsProcessed = 0;
		}

		////////////////////////////
		// doneProcessing
		public function doneProcessing():Boolean
		{
			if(targetsProcessed >= targetsToProcess)
			{
				return true;
			}
			else
			{
				return false;
			}
		}

		////////////////////////////
		// resetAllSwitches
		public function resetAllSwitches()
		{
			for (var x:int = 0; x < switchList.length; x++)
			{
				switchList[x].reset();
			}
		}

		////////////////////////////
		// rotateLeft
		public function rotateLeft(mapWidth:int, mapHeight:int)
		{
			var tempX:int;
			var tempY:int;
			var tempTargetX:int;
			var tempTargetY:int;
			var numControlled:int;

			for (var x:int = 0; x < switchList.length; x++)
			{
				// rotate the switch
				tempX = switchList[x].getXPos();
				tempY = switchList[x].getYPos();
				switchList[x].setXPos(tempY);
				switchList[x].setYPos(mapWidth-tempX-1);

				numControlled = switchList[x].getNumTargets();
				// now rotate the targets
				for(var y:int = 0; y < numControlled; y++)
				{
					tempTargetX = switchList[x].getTargetX();
					tempTargetY = switchList[x].getTargetY();
					switchList[x].setTargetX(tempTargetY);
					switchList[x].setTargetY(mapWidth-tempTargetX-1);
					switchList[x].cycleTargets();
				}
			}
		}

		////////////////////////////
		// rotateRight
		public function rotateRight(mapWidth:int, mapHeight:int)
		{
			var tempX:int;
			var tempY:int;
			var tempTargetX:int;
			var tempTargetY:int;
			var numControlled:int;

			for (var x:int = 0; x < switchList.length; x++)
			{
				// rotate the switch
				tempX = switchList[x].getXPos();
				tempY = switchList[x].getYPos();
				switchList[x].setXPos(mapHeight - tempY-1);
				switchList[x].setYPos(tempX);

				numControlled = switchList[x].getNumTargets();
				// now rotate the targets
				for(var y:int = 0; y < numControlled; y++)
				{
					tempTargetX = switchList[x].getTargetX();
					tempTargetY = switchList[x].getTargetY();
					switchList[x].setTargetX(mapHeight - tempTargetY - 1);
					switchList[x].setTargetY(tempTargetX);
					switchList[x].cycleTargets();
				}
			}
		}
	}
}