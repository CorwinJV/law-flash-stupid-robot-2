package code
{
	import code.states.CreditsState;
	import flash.display.MovieClip;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.ui.Keyboard;
	import code.GameStateManager;
	import code.Key;
	import code.GameVars;
	import code.structs.levelInfo;
	import code.structs.playerInfo;

	// state includes here
	public class profileManager extends MovieClip
	{
		//=========================
		// Private Data Members
		var allPlayerInfo:Array = new Array();
		var tempPlayerInfo:playerInfo = new playerInfo();
		var currentRecord:int;
		var maxLevel:int;
		
		//=========================
		// Constructor
		public function profileManager(newMaxLevel:int)
		{
			currentRecord = -1;
			maxLevel = newMaxLevel;
			tempPlayerInfo = new playerInfo(maxLevel);
			loadAllProfiles();
		}
		
		public function saveProfile():void
		{
			//ofstream saveFile;
			var tempName:String;
			var tempInt:int;
			var highScore:int;

			//saveFile.open("savedGames\\savefile.txt");

			//saveFile << maxLevel << endl;
			//saveFile << allPlayerInfo.size() << endl;

			for (var i:int = 0; i < allPlayerInfo.length(); i++)
			{
				tempName = allPlayerInfo[i].getPlayerName();
				//saveFile << tempName << endl;
				
				tempInt = allPlayerInfo[i].getPlayerHighestLevel();
				//saveFile << tempInt << endl;

				tempInt = allPlayerInfo[i].getPlayerCurrentLevel();
				//saveFile << tempInt << endl;

				for (var j:int = 0; j < maxLevel; j++)
				{
					tempInt = allPlayerInfo[i].getPlayerLevel(j);
					highScore = allPlayerInfo[i].getPlayerLevelScore(j);
					//saveFile << tempInt << " ";
					//saveFile << highScore << endl;
				}
			}
			//saveFile.close();
		}
		
		public function selectProfile(name:String):Boolean
		{
			var tempName:string = name;

			if(allPlayerInfo.length() > 0)
			{
				for(var i:int = 0; i < allPlayerInfo.length; i++)
				{
					if(tempName == allPlayerInfo[i].getPlayerName())
					{
						currentRecord = i;
						return true;
					}
				}
			}	

			return false;
		}
		
		public function deleteProfile(name:String):Boolean
		{
			var tempName:String = name;

			if(allPlayerInfo.length() > 0)
			{
				for(var i:int = 0; i < allPlayerInfo.length(); i++)
				{
					if(tempName == allPlayerInfo[i].getPlayerName())
					{
						currentRecord = i;
						return true;
					}
				}
			}
	
			return false;
		}
		
		public function createProfile():Boolean
		{
			var tempName:String = name;

			if(name == "")
				return false;

			for(var i:int = 0; i < allPlayerInfo.length(); i++)
			{
				if(name == allPlayerInfo[i].getPlayerName())
				{
					return false;
				}
			}

			var tempPlayerInfo:playerInfo = new playerInfo(maxLevel);
			tempPlayerInfo.setPlayerName(tempName);
			allPlayerInfo.push(tempPlayerInfo);
			currentRecord = (allPlayerInfo.length() - 1);
			saveProfile();

			return true;
		}
		
		public function loadAllProfiles():void
		{
			var tempPlayerInfo:playerInfo = new playerInfo();

			//ifstream saveFile;
			//ofstream createSaveFile;
			var tempName:String;
			var tempInt:int;
			var highScore:int;
			var numRecords:int;

			// **********************
			// yaaa, this shit needs to be figured out
			// **********************
			//saveFile.open("savedGames\\savefile.txt");

			//if(!saveFile)
			//{
				//saveFile.close();
				//createSaveFile.open("savedGames\\savefile.txt");

				//createSaveFile << maxLevel << endl;
				//createSaveFile << allPlayerInfo.size() << endl;
				//createSaveFile.close();
				//saveFile.open("savedGames\\savefile.txt");
			//}

			//saveFile >> maxLevel;
			//saveFile >> numRecords;

			//allPlayerInfo.clear();

			for(var i:int = 0; i < numRecords; i++)
			{
				var tempPlayerInfo:playerInfo = new playerInfo(maxLevel);

				//saveFile >> tempName;
				tempPlayerInfo.setPlayerName(tempName);

				//saveFile >> tempInt;
				tempPlayerInfo.setPlayerHighestLevel(tempInt);

				//saveFile >> tempInt;
				tempPlayerInfo.setPlayerCurrentLevel(tempInt);

				for (var j:int = 0; j < maxLevel; j++)
				{
					//saveFile >> j;
					//saveFile >> highScore;
					tempPlayerInfo.setPlayerLevelInfo(j, highScore)
				}
				allPlayerInfo.push(tempPlayerInfo);
			}
			//saveFile.close();
		}

		public function setCurrentRecord(record:int):void
		{
			currentRecord = record;
		}
		
		public function getPlayerName():String
		{
			return allPlayerInfo[currentRecord].getPlayerName();
		}

		public function getPlayerHighestLevel():int
		{
			return allPlayerInfo[currentRecord].getPlayerHighestLevel();
		}
	
		public function getPlayerCurrentLevel():int
		{
			return allPlayerInfo[currentRecord].getPlayerCurrentLevel();
		}
	
		public function getPlayerLevelScore(level:int):int
		{
			return allPlayerInfo[currentRecord].getPlayerLevelScore(level);
		}
	
		public function setPlayerName(name:String):void
		{
			allPlayerInfo[currentRecord].setPlayerName(name);
		}
		
		public function setPlayerHighestLevel(level:int):void
		{
			allPlayerInfo[currentRecord].setPlayerHighestLevel(level);
		}

		public function setPlayerCurrentLevel(level:int):void
		{
			allPlayerInfo[currentRecord].setPlayerCurrentLevel(level);
		}
	
		public function setPlayerLevelInfo(level:int, score: int)
		{
			allPlayerInfo[currentRecord].setPlayerLevelInfo(level, score);
		}
	
		public function setPlayerLevelScore(level:int, score:int):void
		{
			allPlayerInfo[currentRecord].setPlayerLevelScore(level, score);
		}
		
		public function getMaxRecords():int
		{
			return allPlayerInfo.length(); 
		}
	
		public function getPlayerTotalScore():int
		{
			var max:int;
			var score:int = 0;
			var levelScore:int = 0;
			max = allPlayerInfo[currentRecord].getPlayerHighestLevel();

			for(var i:int = 0; i < max; i++)
			{
				levelScore = allPlayerInfo[currentRecord].getPlayerLevelScore(i);
				if(levelScore > 0)
				{
					score += allPlayerInfo[currentRecord].getPlayerLevelScore(i);
				}
			}

			return score;
		}

	}
}