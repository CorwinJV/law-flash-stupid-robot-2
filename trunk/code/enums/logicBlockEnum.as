package code.enums
{
	public final class logicBlockEnum
	{
		private var _value:int;
		
		public static const BS_INACTIVE				:logicBlockEnum = new logicBlockEnum(0);
		public static const BS_ACTIVE			    :logicBlockEnum = new logicBlockEnum(1);
		public static const BS_HIGHLIGHTED			:logicBlockEnum = new logicBlockEnum(2);
		
		public function logicBlockEnum(val:int)
		{
			_value = val;
		}
		
		public function toInt():int
		{
			return _value;
		}
	}
}