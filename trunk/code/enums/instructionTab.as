package code.enums
{
	public final class instructionTab
	{
		private var _value:int;
		
		public static const TAB_MAIN				:instructionTab = new instructionTab(0);
		public static const TAB_SUB1			    :instructionTab = new instructionTab(1);
		public static const TAB_SUB2				:instructionTab = new instructionTab(2);
		
		public function instructionTab(val:int)
		{
			_value = val;
		}
		
		public function toInt():int
		{
			return _value;
		}
	}
}