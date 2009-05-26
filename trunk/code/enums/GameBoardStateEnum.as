package code.enums 
{
	
	/**
	 * ...
	 * @author David Moss
	 */
	public final class GameBoardStateEnum 
	{	
		private var _value:int;
		
		public static const GB_PREGAME			:GameBoardStateEnum = new GameBoardStateEnum(0);
		public static const GB_VIEWSCORE		:GameBoardStateEnum = new GameBoardStateEnum(1);
		public static const GB_LOGICVIEW		:GameBoardStateEnum = new GameBoardStateEnum(2);
		public static const GB_EXECUTION		:GameBoardStateEnum = new GameBoardStateEnum(3);
		public static const GB_FINISHED			:GameBoardStateEnum = new GameBoardStateEnum(4);
		public static const GB_ROBOTDIED		:GameBoardStateEnum = new GameBoardStateEnum(5);
		public static const GB_YOUWIN			:GameBoardStateEnum = new GameBoardStateEnum(6);
		public static const GB_VICTORYDANCE		:GameBoardStateEnum = new GameBoardStateEnum(7);
		
		public function GameBoardStateEnum(val:int)
		{
			_value = val;
		}
		
		public function toInt():int
		{
			return _value;
		}
		
	}
	
}