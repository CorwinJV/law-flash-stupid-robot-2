package code 
{
	import flash.display.MovieClip;
	import code.enums.logicBlockEnum;
	import code.enums.AiInstructionsEnum;
	import flash.net.registerClassAlias;
	import flash.utils.ByteArray;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getDefinitionByName;
	import flash.net.registerClassAlias;
	
	/**
	 * ...
	 * @author Corwin VanHook
	 */
	
	 
	public class logicBlock extends MovieClip
	{
		var blockDescription:String;
		
		var blockTexture:MovieClip;
		var blockTextureActive:MovieClip;
		var blockTextureInactive:MovieClip;
		var blockTextureHighlighted:MovieClip;
		
		var byteCost:int;
		var enumInstruction:AiInstructionsEnum = new AiInstructionsEnum(0);
		var curButtonState:logicBlockEnum = new logicBlockEnum(0);
		var isUsable:Boolean;
		var isCurrentlyUsable:Boolean;
		

		
		public function setButtonState(newState:logicBlockEnum, parentMC:MovieClip)
		{
			var lastX:int = blockTexture.x;
			var lastY:int = blockTexture.y;
			var lastW:int = blockTexture.width;
			var lastH:int = blockTexture.height;
			
			curButtonState = newState;
		
			switch(curButtonState.toInt())
			{
				case logicBlockEnum.BS_ACTIVE.toInt():
				{
					var reAdd:Boolean = false;
					if (parentMC.contains(blockTexture))
					{
						parentMC.removeChild(blockTexture);
						reAdd = true;
					}
					blockTexture = blockTextureActive;
					
					if (reAdd)
					{
						parentMC.addChild(blockTexture);
					}
					break;
				}
				case logicBlockEnum.BS_INACTIVE.toInt():
				{
					var reAdd2:Boolean = false;
					if (parentMC.contains(blockTexture))
					{
						parentMC.removeChild(blockTexture);
						reAdd2 = true;
					}
					blockTexture = blockTextureInactive
					
					if (reAdd2)
					{
						parentMC.addChild(blockTexture);
					}
					break;
				}
				case logicBlockEnum.BS_HIGHLIGHTED.toInt():
				{
					var reAdd3:Boolean = false;
					if (parentMC.contains(blockTexture))
					{
						parentMC.removeChild(blockTexture);
						reAdd3 = true;
					}
					blockTexture = blockTextureHighlighted;
					
					if (reAdd3)
					{
						parentMC.addChild(blockTexture);
					}
					break;
				}
			}
			blockTexture.x = lastX;
			blockTexture.y = lastY;
			blockTexture.width = lastW;
			blockTexture.height = lastH;
		}
		
		
		public function logicBlock(activeBlockMC:MovieClip, inactiveBlockMC:MovieClip, highlightBlockMC:MovieClip, width:int, height:int, description:String, byteCost:int, enumInstruction:AiInstructionsEnum)
		{
			this.blockTextureActive = activeBlockMC;
			this.blockTextureInactive = inactiveBlockMC;
			this.blockTextureHighlighted = highlightBlockMC;
			
			this.blockDescription = description;
			
			this.byteCost = byteCost;
			this.enumInstruction = enumInstruction;
			this.curButtonState = logicBlockEnum.BS_INACTIVE;
			this.isUsable = true;
			this.isCurrentlyUsable = true;
			
			this.blockTexture = blockTextureInactive;
			this.addChild(blockTexture);
		}
		
		public function clone():logicBlock
		{
			var clone:logicBlock;
			
			
			switch(this.enumInstruction.toInt())
			{
				case AiInstructionsEnum.ACTIVATE.toInt():
				{
					clone = new logicBlock(new ActivateABG(), new ActivateIBG(), new ActivateHBG(), 50, 50, this.blockDescription, this.byteCost, this.enumInstruction);
					break;
				}
				case AiInstructionsEnum.CLIMB.toInt():
				{
					clone = new logicBlock(new climbABG(), new climbIBG(), new climbHBG(), 50, 50, this.blockDescription, this.byteCost, this.enumInstruction);
					break;
				}
				case AiInstructionsEnum.CROUCH.toInt():
				{
					clone = new logicBlock(new crouchABG(), new crouchIBG(), new crouchHBG(), 50, 50, this.blockDescription, this.byteCost, this.enumInstruction);
					break;
				}
				case AiInstructionsEnum.JUMP.toInt():
				{
					clone = new logicBlock(new jumpABG(), new jumpIBG(), new jumpHBG(), 50, 50, this.blockDescription, this.byteCost, this.enumInstruction);
					break;
				}
				case AiInstructionsEnum.MOVE_FORWARD_UNTIL_UNABLE.toInt():
				{
					clone = new logicBlock(new moveforwarduntilunableABG(), new moveforwarduntilunableIBG(), new moveforwarduntilunableHBG(), 50, 50, this.blockDescription, this.byteCost, this.enumInstruction);

					break;
				}
				case AiInstructionsEnum.MOVE_FORWARD1.toInt():
				{
					clone = new logicBlock(new moveforwardABG(), new moveforwardIBG(), new moveforwardHBG(), 50, 50, this.blockDescription, this.byteCost, this.enumInstruction);
					break;
				}
				case AiInstructionsEnum.PUNCH.toInt():
				{
					clone = new logicBlock(new punchABG(), new punchIBG(), new punchHBG(), 50, 50, this.blockDescription, this.byteCost, this.enumInstruction);
					break;
				}
				case AiInstructionsEnum.STOP.toInt():
				{
					clone = new logicBlock(new stopABG(), new stopIBG(), new stopHBG(), 50, 50, this.blockDescription, this.byteCost, this.enumInstruction);
					break;
				}
				case AiInstructionsEnum.SUBR1.toInt():
				{
					clone = new logicBlock(new sub1ABG(), new sub1IBG(), new sub1HBG(), 50, 50, this.blockDescription, this.byteCost, this.enumInstruction);					break;
					break;
				}
				case AiInstructionsEnum.SUBR2.toInt():
				{
					clone = new logicBlock(new sub2ABG(), new sub2IBG(), new sub2HBG(), 50, 50, this.blockDescription, this.byteCost, this.enumInstruction);					break;
					break;
				}
				case AiInstructionsEnum.TURN_LEFT1.toInt():
				{
					clone = new logicBlock(new turnleftABG(), new turnleftIBG(), new turnleftHBG(), 50, 50, this.blockDescription, this.byteCost, this.enumInstruction);					break;
					break;
				}
				case AiInstructionsEnum.TURN_RIGHT1.toInt():
				{
					clone = new logicBlock(new turnrightABG(), new turnrightIBG(), new turnrightHBG(), 50, 50, this.blockDescription, this.byteCost, this.enumInstruction);					break;
					break;
				}
				case AiInstructionsEnum.DO_NOT_PROCESS.toInt():
				{
					clone = new logicBlock(new place_new_instructionABG(), new place_new_instructionIBG(), new place_new_instructionHBG(), 50, 50, this.blockDescription, this.byteCost, this.enumInstruction);
					break;
				}
			}					
			return clone;
		}
		
		public function checkInBounds(x:int, y:int, widthBound:int, heightBound:int):Boolean
		{
			if ((( x > this.x) && (x < (this.x + widthBound))) &&
				((y > this.y) && (y < this.y + heightBound)))
			{
				return true;
			}
			else
			{
				return false;
			}
		}
	}
}