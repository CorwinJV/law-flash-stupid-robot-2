package code.structs
{
	public class playerInfo
	{
		public function playerInfo(newMaxLevel:int)
		{
			var maxLevel:int = newMaxLevel;
			var playerName:String = "";
			var playerHighestLevel:int = 1;
			var playerCurrentLevel:int = 1;
			var playerLevelInfo:Array() = new Array();
			
			var tempPlayerLevelInfo:levelInfo;
			tempPlayerLevelInfo = new levelInfo();
			
			for(var i:int = 0; i < maxLevel; i++)
			{
				tempPlayerInfo = new levelInfo();
				tempPlayerLevelInfo.level = i;
				tempPlayerLevelInfo.levelHighScore = -1;
				playerLevelInfo.push(tempPlayerLevelInfo);
			}
		}
			
		public function getPlayerName():String
		{
			return playerName;
		}
		
		public function getPlayerHighestLevel():int
		{
			return playerHighestLevel;
		}
		
		public function getPlayerCurrentLevel():int
		{
			return playerCurrentLevel;
		}

		public function getPlayerLevel(level:int):int
		{
			return playerLevelInfo[level].level;
		}
		
		public function getPlayerLevelScore(level:int):int
		{
			return playerLevelInfo[level].levelHighScore;
		}
		
		public function setPlayerName(name:String):void
		{
			playerName = name;
		}
		
		public function setPlayerHighestLevel(level:int):void
		{
			playerHighestLevel = level;
		}
		
		public function setPlayerCurrentLevel(level:int):void
		{
			playerCurrentLevel = level;
		}

		public function setPlayerLevelInfo(newLevel:int, score:int):void
		{
			playerLevelInfo[newLevel].level = newLevel;
			playerLevelInfo[newLevel].levelHighScore = score;
		}

		public function setPlayerLevelScore(level:int, score:int):void
		{
			playerLevelInfo[level].levelHighScore = score;
		}
	}
}