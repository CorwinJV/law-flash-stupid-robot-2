package code.enums
{
	public final class AiInstructionsEnum
	{
		private var _value:int;
		
		public static const MOVE_FORWARD1					:AiInstructionsEnum = new AiInstructionsEnum(0);
		public static const TURN_LEFT1			    		:AiInstructionsEnum = new AiInstructionsEnum(1);
		public static const TURN_RIGHT1						:AiInstructionsEnum = new AiInstructionsEnum(2);
		public static const CROUCH							:AiInstructionsEnum = new AiInstructionsEnum(3);
		public static const CLIMB			    			:AiInstructionsEnum = new AiInstructionsEnum(4);
		public static const JUMP							:AiInstructionsEnum = new AiInstructionsEnum(5);
		public static const PUNCH							:AiInstructionsEnum = new AiInstructionsEnum(6);
		public static const MOVE_FORWARD_UNTIL_UNABLE		:AiInstructionsEnum = new AiInstructionsEnum(7);
		public static const SUB								:AiInstructionsEnum = new AiInstructionsEnum(8);
		public static const LOOP							:AiInstructionsEnum = new AiInstructionsEnum(9);
		public static const ACTIVATE			    		:AiInstructionsEnum = new AiInstructionsEnum(10);
		public static const SUBR1							:AiInstructionsEnum = new AiInstructionsEnum(11);
		public static const SUBR2							:AiInstructionsEnum = new AiInstructionsEnum(12);
		public static const STOP							:AiInstructionsEnum = new AiInstructionsEnum(13);
		public static const DO_NOT_PROCESS			    	:AiInstructionsEnum = new AiInstructionsEnum(14);

		public function AiInstructionsEnum(val:int)
		{
			_value = val;
		}
		
		public function toInt():int
		{
			return _value;
		}
	}
}