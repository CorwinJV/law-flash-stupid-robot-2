package code.enums
{
	public final class ClickOKEnum
	{
		private var _value:int;
		
		public static const SELECTED			:GameStateEnum = new GameStateEnum(0);
		public static const DELETED			    :GameStateEnum = new GameStateEnum(1);
		public static const CREATED				:GameStateEnum = new GameStateEnum(2);
		public static const NOPROFILE			:GameStateEnum = new GameStateEnum(3);
		public static const SAVED			    :GameStateEnum = new GameStateEnum(4);
		public static const REPROGRAM			:GameStateEnum = new GameStateEnum(5);
		
		public function ClickOKEnum(val:int)
		{
			_value = val;
		}
		
		public function toInt():int
		{
			return _value;
		}
	}
}
