package code.enums
{
	public final class GameStateEnum
	{
		private var _value:int;
		
		public static const ACTIVE				:GameStateEnum = new GameStateEnum(0);
		public static const PASSIVE			    :GameStateEnum = new GameStateEnum(1);
		public static const DELETE_ME			:GameStateEnum = new GameStateEnum(2);
		
		public function GameStateEnum(val:int)
		{
			_value = val;
		}
		
		public function toInt():int
		{
			return _value;
		}
	}
}