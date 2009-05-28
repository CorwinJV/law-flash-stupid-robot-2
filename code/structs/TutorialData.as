package code.structs 
{
	import code.structs.object
	import code.GameVars;
	/**
	 * ...
	 * @author Corwin VanHook
	 */
	public class TutorialData extends Object
	{
		public var tutorialClipID:int = 0;
		
		public var selfX:int;
		public var selfY:int;
		
		var moveForwardAvail:Boolean = false;
		var moveForwardUntilAvail:Boolean = false;
		var turnLeftAvail:Boolean = false;
		var turnRightAvail:Boolean = false;
		var punchAvail:Boolean = false;
		var climbAvail:Boolean = false;
		var crouchAvail:Boolean = false;
		var jumpAvail:Boolean = false;
		var activateAvail:Boolean = false;
		var sub1Avail:Boolean = false;
		var sub2Avail:Boolean = false;				
		
		public function TutorialData(x:int, y:int, clipID:int, b1:Boolean, b2:Boolean, b3:Boolean, b4:Boolean, b5:Boolean, b6:Boolean, b7:Boolean, b8:Boolean, b9:Boolean, b10:Boolean, b11:Boolean)
		{
			selfX = x;
			selfY = y;
			
			tutorialClipID = clipID;
			
			moveForwardAvail = b1;
			moveForwardUntilAvail = b2;
			turnLeftAvail = b3;
			turnRightAvail = b4;
			punchAvail = b5;
			climbAvail = b6;
			crouchAvail = b7;
			jumpAvail = b8;
			activateAvail = b9;
			sub1Avail = b10;
			sub2Avail = b11;
		}
		
		public function updateGameVarsCommandsAvailable()
		{
			GameVars.getInstance().setCurrentLogicBank(moveForwardAvail, moveForwardUntilAvail, turnLeftAvail, turnRightAvail, punchAvail, climbAvail, crouchAvail, jumpAvail, activateAvail, sub1Avail, sub2Avail);
		}
		
	}
	
}