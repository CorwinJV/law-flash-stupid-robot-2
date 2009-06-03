
// 200
package code
{
	/**
	 * ...
	 * @author Corwin VanHook
	 */
	import code.enums.logicBlockEnum;
	import code.states.playGameState;
	import code.states.LevelSelectState;
	import code.GameStateManager;
	import code.enums.GameStateEnum;
	//import fl.video.SkinErrorEvent;
	import flash.display.MovieClip;
	import flash.display.DisplayObject;
	import code.enums.instructionTab;
	import code.enums.AiInstructionsEnum;
	import code.GameVars;
	import code.logicBlock;
	import flash.net.registerClassAlias;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.ui.Mouse;
	
	public class LogicInterface extends MovieClip
	{
		// Menu & Buttons
		public var logicInterfaceMC:MovieClip;
		public var hoverTipsMC:MovieClip = new MENU_instructionBlockHoverTipMC();
		public var insertionLine:MovieClip = new black();
		public var skipTutorial:MovieClip;
		public var infoButton:MovieClip;
		
		// Mouse stuff, and function pointer bools
		var functionPointersSet:Boolean = false;
		var mouseHandlersSet:Boolean = false;
		
		// Internal lists
		var logicBank:Array = new Array();
		var executionList:Array = new Array();
		var executionListSub1:Array = new Array();
		var executionListSub2:Array = new Array();
		
		var rightCommandListOffsetX:int = 15;
		var rightCommandListOffsetY:int = 16;
		var leftCommandListOffsetX:int = 15;
		var leftCommandListOffsetY:int = 16;
		
		// Dragging blocks
		var lastMouseX:int = 0;
		var lastMouseY:int = 0;
		var draggedBlockMouseX:int = 0;
		var draggedBlockMouseY:int = 0;
		var isMouseDragging:Boolean = false;
		var draggedBlock:logicBlock = null;
		
		// Score tracking
		var mapByteLimit:int = 0;
		var usedBytes:int = 0;
		
		
		// Instruction List Rendering Stuff
		var instructionListNumColumns:int = 8;
		var instructionListNumRowsOnScreen:int = 3;
		var instructionSpacing:int = 2;
		var instructionBlockW:int = (int)(140 / 3) - 2;
		var instructionBlockH:int = (int)(140 / 3) - 2;
		var logicBankNumColumns:int = 4;
		var logicBankNumRowsOnScreen:int = 3;
		var logicBankYOffset:int = 0;
		var drawInsertionLine:Boolean = false;		
		var insertionLineColumn:int = 0;
		var insertionLineRow:int = 0;
		var currentHoverBlockIndex:int = -1;
		var isExecuting:Boolean = false;
		var isButtonBeingClicked:Boolean = false;
		var tabCoverMC:MovieClip = new tabCovers();
	
		//References to the current execution list
		var curExecutionList:Array = null;
		var curExecutionListYOffset:int = 0;
		var curExecutionListScrolled:int = 0;

		
		// Positional Variables
		var executionListYOffset:int = 0;
		var executionListSub1YOffset:int = 0;
		var executionListSub2YOffset:int = 0;
		// int* curExecutionListYOffset
		
		var executionListScrolled:int = 0;
		var executionListSub1Scrolled:int = 0;
		var executionListSub2Scrolled:int = 0;
		// int* curExecutionListScrolled;
		
		var isProcessingSub:Boolean = false;
		
		var curInstrTab:instructionTab = new instructionTab(0);
		var logicVars:GameVars = GameVars.getInstance();
		
		// This is so that we can store a list
		// of references to the black "unavailable
		// instruction" boxes in order to remove
		// them from the display list every draw
		var blackBoxArray:Array = new Array();
		
		var panDownFiring:Boolean;
		var panDownRightFiring:Boolean;
		var panDownLeftFiring:Boolean;
		var panUpFiring:Boolean;
		var panUpLeftFiring:Boolean;
		var panUpRightFiring:Boolean;
		var panLeftFiring:Boolean;
		var panRightFiring:Boolean;
		var zoomInFiring:Boolean;
		var zoomOutFiring:Boolean;	
				
		public function LogicInterface() 
		{
			var i:int = 0;
			// Initialize the logic interface movie clip
			logicInterfaceMC = new MENU_logicInterface();
			this.addChild(logicInterfaceMC);
			skipTutorial = new MENU_SkipThisTutorial();
			infoButton = new infoButtonMC();
			
			panDownFiring = false;
			panDownRightFiring = false;
			panDownLeftFiring = false;
			panUpFiring = false;
			panUpLeftFiring = false;
			panUpRightFiring = false;
			panLeftFiring = false;
			panRightFiring = false;
			zoomInFiring = false;
			zoomOutFiring = false;
			
			// Set up all of the button callbacks
			logicInterfaceMC.executeBtn.addEventListener(MouseEvent.MOUSE_UP, ExecutionButtonClick, false, 0, true);
			logicInterfaceMC.abortBtn.addEventListener(MouseEvent.MOUSE_UP, AbortButtonClick, false, 0, true);
			logicInterfaceMC.resetBtn.addEventListener(MouseEvent.MOUSE_UP, ResetButtonClick, false, 0, true);
			logicInterfaceMC.clearBtn.addEventListener(MouseEvent.MOUSE_UP, ClearButtonClick, false, 0, true);
			logicInterfaceMC.helpBtn.addEventListener(MouseEvent.MOUSE_UP, launchHelpState, false, 0, true);
			logicInterfaceMC.speedUpArrow.addEventListener(MouseEvent.MOUSE_UP, speedUpButtonClick, false, 0, true);
			logicInterfaceMC.speedDownArrow.addEventListener(MouseEvent.MOUSE_UP, slowDownButtonClick, false, 0, true);
			logicInterfaceMC.optionsBtn.addEventListener(MouseEvent.MOUSE_UP, optionsButtonClick, false, 0, true);
			
			// Sub Routine Buttons
			logicInterfaceMC.tab_main_btn.addEventListener(MouseEvent.MOUSE_UP, MainTabButtonClick, false, 0, true);
			logicInterfaceMC.tab_main_btn_dark_inst.addEventListener(MouseEvent.MOUSE_UP, MainTabButtonClick, false, 0, true);
			logicInterfaceMC.tab_sub1_btn.addEventListener(MouseEvent.MOUSE_UP, Sub1TabButtonClick, false, 0, true);
			logicInterfaceMC.tab_sub1_btn_dark_inst.addEventListener(MouseEvent.MOUSE_UP, Sub1TabButtonClick, false, 0, true);
			logicInterfaceMC.tab_sub2_btn.addEventListener(MouseEvent.MOUSE_UP, Sub2TabButtonClick, false, 0, true);
			logicInterfaceMC.tab_sub2_btn_dark_inst.addEventListener(MouseEvent.MOUSE_UP, Sub2TabButtonClick, false, 0, true);
			
			// compass callbacks
			logicInterfaceMC.compass.south.addEventListener(MouseEvent.MOUSE_UP, panDownButtonClick, false, 0, true);
			logicInterfaceMC.compass.southEast.addEventListener(MouseEvent.MOUSE_UP, panDownRightButtonClick, false, 0, true);
			logicInterfaceMC.compass.southWest.addEventListener(MouseEvent.MOUSE_UP, panDownLeftButtonClick, false, 0, true);
			logicInterfaceMC.compass.north.addEventListener(MouseEvent.MOUSE_UP, panUpButtonClick, false, 0, true);
			logicInterfaceMC.compass.northWest.addEventListener(MouseEvent.MOUSE_UP, panUpLeftButtonClick, false, 0, true);
			logicInterfaceMC.compass.northEast.addEventListener(MouseEvent.MOUSE_UP, panUpRightButtonClick, false, 0, true);
			logicInterfaceMC.compass.west.addEventListener(MouseEvent.MOUSE_UP, panLeftButtonClick, false, 0, true);
			logicInterfaceMC.compass.east.addEventListener(MouseEvent.MOUSE_UP, panRightButtonClick, false, 0, true);
			logicInterfaceMC.compass.center.addEventListener(MouseEvent.MOUSE_UP, centerButtonClick, false, 0, true);
			
			logicInterfaceMC.compass.south.addEventListener(MouseEvent.MOUSE_DOWN, startFiringPanDown, false, 0, true);
			logicInterfaceMC.compass.southEast.addEventListener(MouseEvent.MOUSE_DOWN, startFiringPanDownRight, false, 0, true);
			logicInterfaceMC.compass.southWest.addEventListener(MouseEvent.MOUSE_DOWN, startFiringPanDownLeft, false, 0, true);
			logicInterfaceMC.compass.north.addEventListener(MouseEvent.MOUSE_DOWN, startFiringPanUp, false, 0, true);
			logicInterfaceMC.compass.northWest.addEventListener(MouseEvent.MOUSE_DOWN, startFiringPanUpLeft, false, 0, true);
			logicInterfaceMC.compass.northEast.addEventListener(MouseEvent.MOUSE_DOWN, startFiringPanUpRight, false, 0, true);
			logicInterfaceMC.compass.west.addEventListener(MouseEvent.MOUSE_DOWN, startFiringPanLeft, false, 0, true);
			logicInterfaceMC.compass.east.addEventListener(MouseEvent.MOUSE_DOWN, startFiringPanRight, false, 0, true);
			logicInterfaceMC.zoomIn.addEventListener(MouseEvent.MOUSE_DOWN, startFiringZoomIn, false, 0, true);
			logicInterfaceMC.zoomOut.addEventListener(MouseEvent.MOUSE_DOWN, startFiringZoomOut, false, 0, true);
			
			logicInterfaceMC.compass.south.addEventListener(MouseEvent.MOUSE_OUT, stopFiringPanDown, false, 0, true);
			logicInterfaceMC.compass.southEast.addEventListener(MouseEvent.MOUSE_OUT, stopFiringPanDownRight, false, 0, true);
			logicInterfaceMC.compass.southWest.addEventListener(MouseEvent.MOUSE_OUT, stopFiringPanDownLeft, false, 0, true);
			logicInterfaceMC.compass.north.addEventListener(MouseEvent.MOUSE_OUT, stopFiringPanUp, false, 0, true);
			logicInterfaceMC.compass.northWest.addEventListener(MouseEvent.MOUSE_OUT, stopFiringPanUpLeft, false, 0, true);
			logicInterfaceMC.compass.northEast.addEventListener(MouseEvent.MOUSE_OUT, stopFiringPanUpRight, false, 0, true);
			logicInterfaceMC.compass.west.addEventListener(MouseEvent.MOUSE_OUT, stopFiringPanLeft, false, 0, true);
			logicInterfaceMC.compass.east.addEventListener(MouseEvent.MOUSE_OUT, stopFiringPanRight, false, 0, true);
			logicInterfaceMC.zoomIn.addEventListener(MouseEvent.MOUSE_OUT, stopFiringZoomIn, false, 0, true);
			logicInterfaceMC.zoomOut.addEventListener(MouseEvent.MOUSE_OUT, stopFiringZoomOut, false, 0, true);
			
			logicInterfaceMC.zoomIn.addEventListener(MouseEvent.MOUSE_UP, zoomInButtonClick, false, 0, true);
			logicInterfaceMC.zoomOut.addEventListener(MouseEvent.MOUSE_UP, zoomOutButtonClick, false, 0, true);
			logicInterfaceMC.rotateRight.addEventListener(MouseEvent.MOUSE_UP, rotateRightButtonClick, false, 0, true);
			logicInterfaceMC.rotateLeft.addEventListener(MouseEvent.MOUSE_UP, rotateLeftButtonClick, false, 0, true);
			
			// Scroll arrow button callbacks
			logicInterfaceMC.scrollBtnUp.addEventListener(MouseEvent.MOUSE_UP, executionListUpArrowButtonClick, false, 0, true);
			logicInterfaceMC.scrollBtnDown.addEventListener(MouseEvent.MOUSE_UP, executionListDownArrowButtonClick, false, 0, true);
			
			// Skip tutorial button callback
			skipTutorial.skipButton.addEventListener(MouseEvent.MOUSE_UP, skipTutorialButtonClick, false, 0, true);
			skipTutorial.skipButton.x = 25;
			skipTutorial.skipButton.y = 538;
			skipTutorial.skipButton.width = 216;
			skipTutorial.skipButton.height = 50;
			
			// info button callback
			infoButton.infoBtn.addEventListener(MouseEvent.MOUSE_UP, infoButtonClick, false, 0, true);
			infoButton.x = 239;
			infoButton.y = 726;
			infoButton.width = 72;
			infoButton.height = 36;
			
			// skip level callback - abcxyz
			logicInterfaceMC.skipBtn.addEventListener(MouseEvent.MOUSE_UP, skipLevelButtonClick, false, 0, true);

			// insertionLine dimensions because black() is square by default
			if (insertionLine != null)
			{
				insertionLine.width = 2;
				insertionLine.height = instructionBlockH;
			}
			
			// Load in the logic blocks...
			for (i = 0; i < logicBank.length; i++)
			{
				if (this.contains(logicBank[i].blockTexture))
				{
					this.removeChild(logicBank[i].blockTexture);
				}
			}
			logicBank = GameVars.getInstance().GetCurrentMapLogicBank();
			
			executionList.push(GameVars.getInstance().getPlaceInstructionBlock().clone());
			executionList[executionList.length - 1].setButtonState(logicBlockEnum.BS_ACTIVE, this);
			executionListSub1.push(GameVars.getInstance().getPlaceInstructionBlock().clone());
			executionListSub1[executionListSub1.length - 1].setButtonState(logicBlockEnum.BS_ACTIVE, this);
			executionListSub2.push(GameVars.getInstance().getPlaceInstructionBlock().clone());
			executionListSub2[executionListSub2.length - 1].setButtonState(logicBlockEnum.BS_ACTIVE, this);


			// Adding the logicBank, and all 3 execution lists to the current display list
			for (i = 0; i < logicBank.length; i++)
			{
				this.addChild(logicBank[i].blockTexture);
			}
			for (i = 0; i < executionList.length; i++)
			{
				this.addChild(executionList[i].blockTexture);
			}
		}
		
		// Because when the constructor fires, this class isn't technically
		// associated with the stage... we can't set up mouse input.
		// So, this function MUST get called after LogicInterface is instantiated.
		public function initEventListeners()
		{	
			if (mouseHandlersSet == false)
			{
				stage.addEventListener(MouseEvent.MOUSE_DOWN, processMouseDOWN, false, 0, true);
				stage.addEventListener(MouseEvent.MOUSE_UP, processMouseUP, false, 0, true);
			}
			
			if (functionPointersSet == false)
			{
				stage.addEventListener("commandAdvanced", CommandAdvanced, false, 0, true);
				stage.addEventListener("reprogramReached", ReprogramReached, false, 0, true);
				stage.addEventListener("clearExecutionList", ClearExecutionListFP, false, 0, true);
				stage.addEventListener("logicInterfaceAbort", manualAbort, false, 0, true);
			
			}
		}

		public function Update()
		{
			var i:int = 0;
			//=====================================
			// Normal Update Stuff
	
			// Toggle whether or not a logic instruction is usable
			// based on whether or not bytes are available for it
			for (i = 0; i < logicBank.length; i++)
			{
				var bytesLeft:int = mapByteLimit - usedBytes;
				if (logicBank[i].byteCost > bytesLeft)
				{
					logicBank[i].isCurrentlyUsable = false;
				}
				else if (curInstrTab.toInt() == instructionTab.TAB_SUB1.toInt()
						&& (logicBank[i].enumInstruction.toInt() == AiInstructionsEnum.SUBR1.toInt() 
						|| logicBank[i].enumInstruction.toInt() == AiInstructionsEnum.SUBR2.toInt()))
				{
					logicBank[i].isCurrentlyUsable = false;
				}
				else if (curInstrTab.toInt() == instructionTab.TAB_SUB2.toInt()
						&& (logicBank[i].enumInstruction.toInt() == AiInstructionsEnum.SUBR1.toInt()
						|| logicBank[i].enumInstruction.toInt() == AiInstructionsEnum.SUBR2.toInt()))
				{
					logicBank[i].isCurrentlyUsable = false;
				}
				else
				{
					logicBank[i].isCurrentlyUsable = true;
				}
			}
			
			
			// Calculating the bytes left
				//  I think there's a loop deficiency
				//  Nothin' sexier than algorithmic efficiency
				//  I want you to iterate
				//  Cus when I see i++, I salivate!
				// -Corwin VanHook, March 09, 2009
			
			var tmpByteCount:int = 0;
			for (i = 0; i < executionList.length; i++)
			{
				tmpByteCount += executionList[i].byteCost;
			}
			for (i = 0; i < executionListSub1.length; i++)
			{
				tmpByteCount += executionListSub1[i].byteCost;
			}
			for (i = 0; i < executionListSub2.length; i++)
			{
				tmpByteCount += executionListSub2[i].byteCost;
			}
			usedBytes = tmpByteCount;
			GameVars.getInstance().setBytesUsed(usedBytes);

			for (i = 0; i < executionList.length; i++)
			{
				if (executionList[i].enumInstruction.toInt() == AiInstructionsEnum.DO_NOT_PROCESS.toInt())
				{
					if (usedBytes == mapByteLimit)
					{
						executionList[i].curButtonState = logicBlockEnum.BS_INACTIVE;
					}
					else
					{
						executionList[i].curButtonState = logicBlockEnum.BS_ACTIVE;
					}
				}
			}

			for (i = 0; i < executionListSub1.length; i++)
			{
				if (executionListSub1[i].enumInstruction.toInt() == AiInstructionsEnum.DO_NOT_PROCESS.toInt())
				{
					if (usedBytes == mapByteLimit)
					{
						executionListSub1[i].curButtonState = logicBlockEnum.BS_INACTIVE;
					}
					else
					{
						executionListSub1[i].curButtonState = logicBlockEnum.BS_ACTIVE;
					}
				}
			}

			
			for (i = 0; i < executionListSub2.length; i++)
			{
				if (executionListSub2[i].enumInstruction.toInt() == AiInstructionsEnum.DO_NOT_PROCESS.toInt())
				{
					if (usedBytes == mapByteLimit)
					{
						executionListSub2[i].curButtonState = logicBlockEnum.BS_INACTIVE;
					}
					else
					{
						executionListSub2[i].curButtonState = logicBlockEnum.BS_ACTIVE;
					}
				}
			}
			
			//=====================================
			// Process mouse stuff!
			processMouse()
			
			// *************************************************************************
			// *************************************************************************
			// remove the skip button if it exists
			//
			// following 2 if statements need to be reimplemented once we're done debugging
			//
			//if (this.contains(skipTutorial))
				//{
					//this.removeChild(skipTutorial);
				//}
				
			// only add the skip tutorial button should only display during tutorial levels
			if (logicVars.getCurrentLevel() <= (logicVars.getNumTutorialLevels() ))
			{
				this.addChild(skipTutorial);
				this.addChild(infoButton);
			}
			
			
			//=====================================
			// Update the positions of all of the 
			// logic blocks on the screen because 
			// we're about to draw!
			Draw();
			
			//=====================================
			// Hover tips... I believe this
			// has to go after the draw function
			// due to positioning
			currentHoverBlockIndex = -1;
			if (logicBank != null)
			{
				for (i = 0; i < logicBank.length; i++)
				{
					if(logicBank[i].blockTexture.hitTestPoint(mouseX, mouseY))
					{
						//trace("You're hovering over index " + i);
						// You're hovering over, YAY! LOLZ
						currentHoverBlockIndex = i;
					}
				}
			}
			
			// draggedBlock z index
			if (draggedBlock != null)
			{
				if (this.contains(draggedBlock.blockTexture))
				{
					this.setChildIndex(draggedBlock.blockTexture, this.numChildren - 1);
				}
			}
			
			processAutoFires();			
		}
	
		public function Draw()
		{
			var i:int = 0;
						
			// Execute / Abort button being drawn
			var abortBtnIndex:int = logicInterfaceMC.getChildIndex(logicInterfaceMC.abortBtn);
			var executeBtnIndex:int = logicInterfaceMC.getChildIndex(logicInterfaceMC.executeBtn);
			
			if (isExecuting)
			{
				// If we're executing and the execution button is showing
				// switch it to the abort button
				if (abortBtnIndex < executeBtnIndex)
				{
					logicInterfaceMC.swapChildren(logicInterfaceMC.abortBtn, logicInterfaceMC.executeBtn);
				}
			}
			else // Not executing
			{
				// If we're executing and the abort button is showing
				// switch it to the execution button
				if (abortBtnIndex > executeBtnIndex)
				{
					logicInterfaceMC.swapChildren(logicInterfaceMC.abortBtn, logicInterfaceMC.executeBtn);
				}
			}

			
			// Remove all instructions from the display list in case of an instruction list change
			for (i = 0; i < executionList.length; i++)
			{
				if (this.contains(executionList[i].blockTexture))
				{
					this.removeChild(executionList[i].blockTexture);
				}
			}
			for (i = 0; i < executionListSub1.length; i++)
			{
				if (this.contains(executionListSub1[i].blockTexture))
				{
					this.removeChild(executionListSub1[i].blockTexture);
				}
			}
			for (i = 0; i < executionListSub2.length; i++)
			{
				if (this.contains(executionListSub2[i].blockTexture))
				{
					this.removeChild(executionListSub2[i].blockTexture);
				}
			}

			var tempBlackThing:MovieClip = new black();
			tempBlackThing.x = 760;
			tempBlackThing.y = logicBank.y - 60;
			tempBlackThing.width = 225;
			tempBlackThing.height = 75;
			
			if (curInstrTab.toInt() == instructionTab.TAB_MAIN.toInt())
			{
				curExecutionList = executionList;
				curExecutionListYOffset = executionListYOffset;
			}
			else if (curInstrTab.toInt() == instructionTab.TAB_SUB1.toInt())
			{
				curExecutionList = executionListSub1;
				curExecutionListYOffset = executionListSub1YOffset;
			}
			else if (curInstrTab.toInt() == instructionTab.TAB_SUB2.toInt())
			{
				curExecutionList = executionListSub2;
				curExecutionListYOffset = executionListSub2YOffset;
			}

			//=============================================
			// Robot Instructions
			var rowCount:int = 0;
			var columnIndex:int = 0;
			for (i = 0; i < curExecutionList.length; i++)
			{
				if ((i % instructionListNumColumns) == 0
					&& (i > 0))
				{
					rowCount++;
				}
				// Flash specific code.. remove the logic block from our display list
				if(this.contains(curExecutionList[i].blockTexture))
				{
					this.removeChild(curExecutionList[i].blockTexture);
				}
				// so we can re-add it after we determine if its position is drawable
				curExecutionList[i].blockTexture.x = rightCommandListOffsetX + logicInterfaceMC.rightCommandList.x + (instructionSpacing * columnIndex) + (instructionBlockW * columnIndex);
				curExecutionList[i].blockTexture.y = rightCommandListOffsetY + curExecutionListYOffset + ((logicInterfaceMC.rightCommandList.y + instructionSpacing) + (rowCount * instructionBlockH) + (rowCount * instructionSpacing));
				curExecutionList[i].blockTexture.width = instructionBlockW;
				curExecutionList[i].blockTexture.height = instructionBlockH;
				
				if (curExecutionList[i].blockTexture.y >= logicInterfaceMC.rightCommandList.y
					&& curExecutionList[i].blockTexture.y <= logicInterfaceMC.rightCommandList.y + logicInterfaceMC.rightCommandList.height - (instructionSpacing + instructionBlockH))
				{
					this.addChild(curExecutionList[i].blockTexture);
				}
				columnIndex++;
				if (columnIndex >= instructionListNumColumns)
				{
					columnIndex = 0;
				}
			}
			

			//=============================================
			// Reset the black boxes used for showing
			// which logic blocks are unavailable.
			for (i = 0; i < blackBoxArray.length; i++)
			{
				if (this.contains(blackBoxArray[i]))
				{
					this.removeChild(blackBoxArray[i]);
				}
			}
			blackBoxArray = new Array();
			//=============================================
			// LogicBank Instructions (bottom bar)
			rowCount = 0;
			columnIndex = 0;
			if (logicBank != null)
			{
				for (i = 0; i < logicBank.length; i++)
				{
					if ((i % logicBankNumColumns) == 0
						&& (i > 0))
					{
						rowCount++;
					}
					
					logicBank[i].blockTexture.width = instructionBlockW;
					logicBank[i].blockTexture.height = instructionBlockH;
					logicBank[i].blockTexture.x = leftCommandListOffsetX + (instructionSpacing) + logicInterfaceMC.leftCommandList.x + (instructionSpacing * columnIndex) + (instructionBlockW * columnIndex);
					logicBank[i].blockTexture.y = leftCommandListOffsetY + (instructionSpacing) + logicBankYOffset + ((logicInterfaceMC.leftCommandList.y + instructionSpacing) + (rowCount * instructionBlockH) + (rowCount * instructionSpacing));
			
					if (!this.contains(logicBank[i].blockTexture))
					{
						this.addChild(logicBank[i].blockTexture);
					}
					
					// Drawing is handled automatically for anything on the display list.
					
					// If an instruction is not usable, draw a box over it
					if(!(logicBank[i].isUsable)
						|| !(logicBank[i].isCurrentlyUsable))
					{
						var tmpMCWee:MovieClip = new black();
						tmpMCWee.x = logicBank[i].blockTexture.x;
						tmpMCWee.y = logicBank[i].blockTexture.y;
						tmpMCWee.width = instructionBlockW;
						tmpMCWee.height = instructionBlockH;
						tmpMCWee.alpha = .50;
						blackBoxArray.push(tmpMCWee);
					}
					
					
					columnIndex++;
					if(columnIndex >= logicBankNumColumns)
						columnIndex = 0;
				}
			}

			//=============================================
			// Add the black boxes to the display list.
			for (i = 0; i < blackBoxArray.length; i++)
			{
				this.addChild(blackBoxArray[i])
			}
	
	
			//=============================================
			// Menu Buttons (For scrolling and shizz)
			//resetMenu->Draw();
			//alwaysActiveMenu->Draw();
			//myMenu->Draw();
			//if(isExecuting == true)
				//executingMenu->Draw();

			//=============================================
			// Byte Limit Stuff
			var s:String = usedBytes.toString() + " of " + mapByteLimit.toString() + " BYTES used. ";
			logicInterfaceMC.bytesDisplay.text = s;
			s = "\n" + (mapByteLimit - usedBytes).toString() + " BYTES remaining.";
			logicInterfaceMC.bytesDisplay.text += s;


			if (drawInsertionLine == true)
			{
				if (curInstrTab.toInt() == instructionTab.TAB_MAIN.toInt())
				{
					curExecutionList = executionList;
					curExecutionListYOffset = executionListYOffset;
				}
				else if (curInstrTab.toInt() == instructionTab.TAB_SUB1.toInt())
				{
					curExecutionList = executionListSub1;
					curExecutionListYOffset = executionListSub1YOffset;
				}
				else if (curInstrTab.toInt() == instructionTab.TAB_SUB2.toInt())
				{
					curExecutionList = executionListSub2;
					curExecutionListYOffset = executionListSub2YOffset;
				}
			
				var rowOffset:int = curExecutionListYOffset / (instructionSpacing + instructionBlockH);
				var vectorSize:int = curExecutionList.length;
				
				var lastBlockRow:int = vectorSize / instructionListNumColumns;
				var lastBlockColumn:int = vectorSize % instructionListNumColumns;
				
				lastBlockRow += rowOffset;
				
				if (lastBlockColumn != 0)
				{
					lastBlockColumn--;
				}
				else
				{
					lastBlockColumn = instructionListNumColumns - 1;
					lastBlockRow--;
				}
				
				// ==================================
				// Insertion Line Stuff
				if (this.contains(insertionLine))
				{
					this.removeChild(insertionLine);
				}
						
				if (((insertionLineColumn > lastBlockColumn) && (insertionLineRow > lastBlockRow))
					|| ((insertionLineColumn > lastBlockColumn) && (insertionLineRow == lastBlockRow))
					|| ((insertionLineRow > lastBlockRow)))
				{
					//trace("Drawing insertionLine 1");
					insertionLine.x = rightCommandListOffsetX + logicInterfaceMC.rightCommandList.x + (lastBlockColumn * (instructionSpacing + instructionBlockW)) - 2;
					insertionLine.y = rightCommandListOffsetY + logicInterfaceMC.rightCommandList.y + (lastBlockRow * (instructionSpacing + instructionBlockH)) + 4;
					this.addChild(insertionLine);
				}
				else
				{
					//trace("Drawing insertionLine 2");
					insertionLine.x = rightCommandListOffsetX + logicInterfaceMC.rightCommandList.x + (insertionLineColumn * (instructionSpacing + instructionBlockW)) - 2;
					insertionLine.y = rightCommandListOffsetY + logicInterfaceMC.rightCommandList.y + (insertionLineRow * (instructionSpacing + instructionBlockH)) + 4;
					this.addChild(insertionLine);
				}
			}

			//=============================================
			// Tab Covers (Showing which tab is currently
			// selected	
			switch(curInstrTab.toInt())
			{
				case instructionTab.TAB_MAIN.toInt():
				{
					logicInterfaceMC.setChildIndex(logicInterfaceMC.tab_main_btn, logicInterfaceMC.numChildren - 1);
					logicInterfaceMC.setChildIndex(logicInterfaceMC.tab_sub1_btn_dark_inst, logicInterfaceMC.numChildren - 1);
					logicInterfaceMC.setChildIndex(logicInterfaceMC.tab_sub2_btn_dark_inst, logicInterfaceMC.numChildren - 1);
					//logicInterfaceMC.tab_main_btn_dark_inst.alpha = 1.0;
					//logicInterfaceMC.tab_sub1_btn_dark_inst.alpha = 0.0;
					//logicInterfaceMC.tab_sub2_btn_dark_inst.alpha = 0.0;
					break;
				}
				case instructionTab.TAB_SUB1.toInt():
				{
					logicInterfaceMC.setChildIndex(logicInterfaceMC.tab_main_btn_dark_inst, logicInterfaceMC.numChildren - 1);
					logicInterfaceMC.setChildIndex(logicInterfaceMC.tab_sub1_btn, logicInterfaceMC.numChildren - 1);
					logicInterfaceMC.setChildIndex(logicInterfaceMC.tab_sub2_btn_dark_inst, logicInterfaceMC.numChildren - 1);					break;
				}
				case instructionTab.TAB_SUB2.toInt():
				{
					logicInterfaceMC.setChildIndex(logicInterfaceMC.tab_main_btn_dark_inst, logicInterfaceMC.numChildren - 1);
					logicInterfaceMC.setChildIndex(logicInterfaceMC.tab_sub1_btn_dark_inst, logicInterfaceMC.numChildren - 1);
					logicInterfaceMC.setChildIndex(logicInterfaceMC.tab_sub2_btn, logicInterfaceMC.numChildren - 1);					break;
					break;
				}
			}
			
			
			//if (!this.contains(tabCoverMC))
			//{
				//this.addChild(tabCoverMC);
			//}

			//if (logicInterfaceMC != null)
			//{			trace("Current instruction tab: " + curInstrTab.toInt())
				//switch (curInstrTab.toInt())
				//{
					//case instructionTab.TAB_MAIN.toInt():
					//{
						//if((tabCoverMC.x != logicInterfaceMC.tab_main_btn.x) 
						//&& (tabCoverMC.x != logicInterfaceMC.tab_main_btn.y))
						//{
							//if (!logicInterfaceMC.tab_main_btn.contains(tabCoverMC))
							//{
								//var w:int = logicInterfaceMC.tab_main_btn.width;
								//var h:int = logicInterfaceMC.tab_main_btn.height;
								//logicInterfaceMC.tab_main_btn.addChild(tabCoverMC);
								//tabCoverMC.width = w;
								//tabCoverMC.height = h;
							//}
							//tabCoverMC.x = logicInterfaceMC.tab_main_btn.x;
							//tabCoverMC.y = logicInterfaceMC.tab_main_btn.y;
							//tabCoverMC.width = logicInterfaceMC.tab_main_btn.width;
							//tabCoverMC.height = logicInterfaceMC.tab_main_btn.height;
						//}
						//break;
					//}
					//case instructionTab.TAB_SUB1.toInt():
					//{
						//if (this.contains(tabCoverMC) 
						//&& ((tabCoverMC.x != logicInterfaceMC.tab_sub1_btn.x) 
						//&& (tabCoverMC.x != logicInterfaceMC.tab_sub1_btn.btn.y)))
						//{
							//tabCoverMC.x = logicInterfaceMC.tab_sub1_btn.x;
							//tabCoverMC.y = logicInterfaceMC.tab_sub1_btn.y;
							//tabCoverMC.width = logicInterfaceMC.tab_sub1_btn.width;
							//tabCoverMC.height = logicInterfaceMC.tab_sub1_btn.height;	
						//}
						//break;
					//}
					//case instructionTab.TAB_SUB2.toInt():
					//{
						//if (this.contains(tabCoverMC) 
						//&& ((tabCoverMC.x != logicInterfaceMC.tab_sub2_btn.x) 
						//&& (tabCoverMC.x != logicInterfaceMC.tab_sub2_btn.btn.y)))
						//{
							//tabCoverMC.x = logicInterfaceMC.tab_sub2_btn.x;
							//tabCoverMC.y = logicInterfaceMC.tab_sub2_btn.y;
							//tabCoverMC.width = logicInterfaceMC.tab_sub2_btn.width;
							//tabCoverMC.height = logicInterfaceMC.tab_sub2_btn.height;	
						//}
						//break;
					//}
				//}	
			//}			
			
			//=============================================
			// Hover Over Screen Tipz0rz
				// If the currentHoverBlockIndex is -1 that 
				// means no block is being hovered over
			if (this.contains(hoverTipsMC))
			{
				this.removeChild(hoverTipsMC);
			}

			if (currentHoverBlockIndex != -1)
			{
				if (logicBank != null)
				{
					var tmpBlock2:logicBlock = logicBank[currentHoverBlockIndex];

					if (this.contains(hoverTipsMC))
					{
						this.removeChild(hoverTipsMC);
					}
					
					hoverTipsMC.x = tmpBlock2.blockTexture.x + 20;
					hoverTipsMC.y = tmpBlock2.blockTexture.y - 170;
					//hoverTipsMC.alpha = 0.90;
					
					// Text, wee.
					hoverTipsMC.tBox.text = "";
					if (tmpBlock2.isUsable != true)
					{
						hoverTipsMC.tBox.text += "[Unavailable on Current Level]\n"
					}
					hoverTipsMC.tBox.text += tmpBlock2.blockDescription + "\n";

					if (tmpBlock2.isCurrentlyUsable != true
						&& (tmpBlock2.isUsable == true))
					{

						if ((tmpBlock2.enumInstruction.toInt() == AiInstructionsEnum.SUBR1.toInt()
							||  tmpBlock2.enumInstruction.toInt() == AiInstructionsEnum.SUBR2.toInt())
							&& (curInstrTab.toInt() == instructionTab.TAB_SUB1.toInt()
								|| curInstrTab.toInt() == instructionTab.TAB_SUB2.toInt()))
						{
							hoverTipsMC.tBox.text += "[You can't place SubRoutines Here]\n";
						}
						else
						{
							hoverTipsMC.tBox.text += "[Not Enough Memory Available]\n";
						}
					}
					
					// now that we're at the end of the text...
					// lets draw the byte information for this block!
					hoverTipsMC.tBox.text += "(Uses " + tmpBlock2.byteCost + " Bytes)";
					this.addChild(hoverTipsMC);
				}
			}
			else
			{
				if (this.contains(hoverTipsMC))
				{
					this.removeChild(hoverTipsMC);
				}
			}
			
			
		}
		
		public function processMouse()
		{
			// Internal mouse position for hover over stuff
			
			// Menu buttons
			//alwaysActiveMenu->processMouse(x, y);
			//resetMenu->processMouse(x, y);
			//myMenu->processMouse(x, y);
			//if(isExecuting == true)
				//executingMenu->processMouse(x, y);
			
			// Dragging the block
			if (isMouseDragging == true
				&& draggedBlock != null)
			{
				draggedBlock.blockTexture.x = mouseX - (instructionBlockW / 2);
				draggedBlock.blockTexture.y = mouseY - (instructionBlockH / 2);
			}
				
			if (mouseX != lastMouseX
			&& mouseY != lastMouseY)
			{
				lastMouseX = mouseX;
				lastMouseY = mouseY;
			
				// Dragging & Insertion into the middle of the list
				if (isMouseDragging == true
					&& draggedBlock != null)
				{
					var localX:int = mouseX - (logicInterfaceMC.rightCommandList.x + rightCommandListOffsetX);
					var localY = mouseY - (logicInterfaceMC.rightCommandList.y  + rightCommandListOffsetY);
					var columnPosition = localX / (instructionSpacing + instructionBlockW);
					var rowPosition = localY / (instructionSpacing + instructionBlockH);
					
					if ((columnPosition >= 0)
						&& (columnPosition < instructionListNumColumns)
						&& (rowPosition >= 0)
						&& (rowPosition < instructionListNumRowsOnScreen))
					{
						insertionLineColumn = columnPosition;
						insertionLineRow = rowPosition;
						drawInsertionLine = true;
					}
					else
					{
						insertionLineColumn = 0;
						insertionLineRow = 0;
						drawInsertionLine = false;
						if (this.contains(insertionLine))
						{
							this.removeChild(insertionLine);
						}
					}
				}
				else
				{
					insertionLineColumn = 0;
					insertionLineRow = 0;
					drawInsertionLine = false;
					if (this.contains(insertionLine))
					{
						this.removeChild(insertionLine);
					}
				}
			}
		}
		
		public function processMouseDOWN(e:MouseEvent)
		{
			var i:int = 0;
			// Menu buttons
			//alwaysActiveMenu->processMouseClick(button, state, x, y);
			//resetMenu->processMouseClick(button, state, x, y);

			//if(isExecuting == true)
				//executingMenu->processMouseClick(button, state, x, y);
			//else if(isExecuting == false)
				//myMenu->processMouseClick(button, state, x, y);

			// Click & Drag
			// When the user clicks, we want them to be able to select an
			// instruction to drag over into the robot's instruction list.
			// Loop through the list of bank instructions and check x/y
			if (!isExecuting)
			{
				if (isButtonBeingClicked == false)
				{
					if (logicBank != null)
					{
						for (i = 0; i < logicBank.length; i++)
						{
							var tmpItr:logicBlock = logicBank[i];
							
							if (tmpItr.blockTexture.hitTestPoint(mouseX, mouseY))
							{
								if (tmpItr.isUsable
									&& tmpItr.isCurrentlyUsable)
								{
									// CJV clicktoremove
									draggedBlock = tmpItr.clone();
									draggedBlock.setButtonState(logicBlockEnum.BS_ACTIVE, this);
									draggedBlockMouseX = mouseX;
									draggedBlockMouseY = mouseY;
									draggedBlock.blockTexture.width = this.instructionBlockW;
									draggedBlock.blockTexture.height = this.instructionBlockH;
									
									
									this.addChild(draggedBlock.blockTexture);
									
									isMouseDragging = true;
									
									processMouse();
								}
							}
						}
					}
				}
			}


			//===============================
			// Pulling an instruction block 
			// out of one of the execution 
			// lists.
			if (!isExecuting)
			{
				if (isButtonBeingClicked == false)
				{
					if (curInstrTab.toInt() == instructionTab.TAB_MAIN.toInt())
					{
						curExecutionList = executionList;
						curExecutionListYOffset = executionListYOffset;
					}
					else if (curInstrTab.toInt() == instructionTab.TAB_SUB1.toInt())
					{
						curExecutionList = executionListSub1;
						curExecutionListYOffset = executionListSub1YOffset;
					}
					else if (curInstrTab.toInt() == instructionTab.TAB_SUB2.toInt())
					{
						curExecutionList = executionListSub2;
						curExecutionListYOffset = executionListSub2YOffset;
					}	
					
					for (i = 0; i < curExecutionList.length; i++)
					{
						if (curExecutionList[i].enumInstruction.toInt() != AiInstructionsEnum.DO_NOT_PROCESS.toInt())
						{
							if (curExecutionList[i].blockTexture.hitTestPoint(mouseX, mouseY))
							{
								if (curExecutionList[i].blockTexture.y >= logicInterfaceMC.rightCommandList.y
									&& curExecutionList[i].blockTexture.y <= logicInterfaceMC.rightCommandList.y + logicInterfaceMC.rightCommandList.height - (instructionSpacing + instructionBlockH))
								{
									draggedBlock = curExecutionList[i].clone();
									draggedBlock.setButtonState(logicBlockEnum.BS_ACTIVE, this);
									draggedBlock.blockTexture.width = this.instructionBlockW;
									draggedBlock.blockTexture.height = this.instructionBlockH;
									isMouseDragging = true;
									
									this.addChild(draggedBlock.blockTexture);
									
									this.removeChild(curExecutionList[i].blockTexture);
									curExecutionList.splice(i, 1);

									break;
								}
							}
						}
					}
				}
			}
			isButtonBeingClicked = false;
		}
		
		
		public function processMouseUP(e:MouseEvent)
		{
			var i:int = 0;
			//=====================================
			// If the player clicks an instruction 
			// from the logicBank it should add it 
			// to the current list
			if (!isExecuting)
			{
				if (isMouseDragging == true
					&& (draggedBlock != null))
				{
					if ((draggedBlockMouseX <= mouseX + 5) && (draggedBlockMouseX >= mouseX - 5)
						&& (draggedBlockMouseY <= mouseY + 5) && (draggedBlockMouseY >= mouseY - 5))
					{
						if (curInstrTab.toInt() == instructionTab.TAB_MAIN.toInt())
						{
							curExecutionList = executionList;
							curExecutionListYOffset = executionListYOffset;
						}
						else if (curInstrTab.toInt() == instructionTab.TAB_SUB1.toInt())
						{
							curExecutionList = executionListSub1;
							curExecutionListYOffset = executionListSub1YOffset;
						}
						else if (curInstrTab.toInt() == instructionTab.TAB_SUB2.toInt())
						{
							curExecutionList = executionListSub2;
							curExecutionListYOffset = executionListSub2YOffset;
						}
						
						// Add block to the end of the list
						var bytesLeft:int = mapByteLimit - usedBytes;
						if (bytesLeft >= draggedBlock.byteCost)
						{
							if (this.contains(curExecutionList[curExecutionList.length - 1].blockTexture))
							{
								this.removeChild(curExecutionList[curExecutionList.length - 1].blockTexture);
							}
							curExecutionList.pop();
							
							curExecutionList.push(draggedBlock.clone());
							curExecutionList[curExecutionList.length - 1].setButtonState(logicBlockEnum.BS_ACTIVE, this);
							
							curExecutionList.push(GameVars.getInstance().getPlaceInstructionBlock().clone());
							curExecutionList[curExecutionList.length - 1].setButtonState(logicBlockEnum.BS_ACTIVE, this);
						}
						if (this.contains(draggedBlock.blockTexture))
						{
							this.removeChild(draggedBlock.blockTexture);
						}
						draggedBlock = null;
						isMouseDragging = false;
						draggedBlockMouseX = 0;
						draggedBlockMouseY = 0;
						
						//=========================
						// Scrolling To The Bottom
						var curBlockIndex:int = curExecutionList.length;
						var curBlockRowCount:int = curBlockIndex / instructionListNumColumns;
						
						curExecutionListYOffset = 0;
						if (curBlockRowCount > instructionListNumRowsOnScreen - 1)
						{
							for (i = 0; i < curBlockRowCount - (instructionListNumRowsOnScreen - 1); i++)
							{
								ExecutionListDownArrowButtonClick();
							}
						}
					}
				}
			}


			//=====================================
			// Dropping the instruction block into 
			// the correct tabbed execution list
			if (!isExecuting)
			{
				if (isMouseDragging == true
					&& draggedBlock != null)
				{
					if (drawInsertionLine == true)
					{
						if (curInstrTab.toInt() == instructionTab.TAB_MAIN.toInt())
						{
							curExecutionList = executionList;
							curExecutionListYOffset = executionListYOffset;
							curExecutionListScrolled = executionListScrolled;
						}
						else if (curInstrTab.toInt() == instructionTab.TAB_SUB1.toInt())
						{
							curExecutionList = executionListSub1;
							curExecutionListYOffset = executionListSub1YOffset;
							curExecutionListScrolled = executionListSub1Scrolled;
						}
						else if (curInstrTab.toInt() == instructionTab.TAB_SUB2.toInt())
						{
							curExecutionList = executionListSub2;
							curExecutionListYOffset = executionListSub2YOffset;
							curExecutionListScrolled = executionListSub2Scrolled;
						}
						
						var rowOffset = (curExecutionListYOffset / (instructionSpacing + instructionBlockH));
						var vectorSize:int = curExecutionList.length;
						
						var lastBlockRow:int = vectorSize / instructionListNumColumns;
						var lastBlockColumn:int = vectorSize % instructionListNumColumns;
						
						lastBlockRow += rowOffset;
						
						if (lastBlockColumn != 0)
						{
							lastBlockColumn--;
						}
						else
						{
							lastBlockColumn = instructionListNumColumns - 1;
							lastBlockRow--;
						}
						//trace(draggedBlockMouseX + " " + mouseX);
						//if ((draggedBlockMouseX <= mouseX + 5) && (draggedBlockMouseX >= mouseX - 5)
							//&& (draggedBlockMouseY <= mouseY + 5) && (draggedBlockMouseY >= mouseY - 5))
						//{
							//
							//if (this.contains(draggedBlock.blockTexture))
							//{
								//this.removeChild(draggedBlock.blockTexture);
							//}
							//draggedBlock = null;
							//isMouseDragging = false;
						//}
						if (((insertionLineColumn > lastBlockColumn) && (insertionLineRow > lastBlockRow))
							|| ((insertionLineColumn > lastBlockColumn) && (insertionLineRow == lastBlockRow))
							|| ((insertionLineRow > lastBlockRow)))
						{
							//trace("I'm dropping a block in the end of the list..");
							// Add block to the end of the list
							bytesLeft = mapByteLimit - usedBytes;
							if (bytesLeft >= draggedBlock.byteCost)
							{
								if (this.contains(curExecutionList[curExecutionList.length - 1].blockTexture))
								{
									this.removeChild(curExecutionList[curExecutionList.length - 1].blockTexture);
								}
								curExecutionList.pop();
								
								var tmpBlock:logicBlock = draggedBlock.clone();
								tmpBlock.blockTexture.width = this.instructionBlockW;
								tmpBlock.blockTexture.height = this.instructionBlockH;
								tmpBlock.setButtonState(logicBlockEnum.BS_ACTIVE, this);
								curExecutionList.push(tmpBlock);							
								
								tmpBlock = GameVars.getInstance().getPlaceInstructionBlock().clone();
								tmpBlock.blockTexture.width = this.instructionBlockW;
								tmpBlock.blockTexture.height = this.instructionBlockH;
								tmpBlock.setButtonState(logicBlockEnum.BS_ACTIVE, this);
								curExecutionList.push(tmpBlock);
								
								curExecutionList[curExecutionList.length - 1].setButtonState(logicBlockEnum.BS_ACTIVE, this);
							}
							if (this.contains(draggedBlock.blockTexture))
							{
								this.removeChild(draggedBlock.blockTexture);
							}
							draggedBlock = null;
							isMouseDragging = false;
						}
						else
						{
							// trace("curExecutionListScrolled " + curExecutionListScrolled);
							// Insert block within the current list.
							//trace("Inserting block within current list");
							bytesLeft = mapByteLimit - usedBytes;
							if (bytesLeft >= draggedBlock.byteCost)
							{
								var insertionPosition:int = ((insertionLineRow * 8) + (insertionLineColumn) + (curExecutionListScrolled) * 8);
								//trace("curExecutionListScrolled " + curExecutionListScrolled);
								//trace ("insertionPosition " + insertionPosition);
								var tmpBlock3:logicBlock = draggedBlock.clone();
								tmpBlock3.setButtonState(logicBlockEnum.BS_ACTIVE, this);
								curExecutionList.splice(insertionPosition, 0, tmpBlock3);
							}
							if (this.contains(draggedBlock.blockTexture))
							{
								this.removeChild(draggedBlock.blockTexture);
							}
							draggedBlock = null;
							isMouseDragging = false;
						}
					}
					else
					{
						if (this.contains(draggedBlock.blockTexture))
						{
							this.removeChild(draggedBlock.blockTexture);
						}
						draggedBlock = null;
						isMouseDragging = false;
					}
				}
			}
		}
		
		public function GetCurrentMapLogicBank()
		{
			var i:int = 0;
			for (i = 0; i < logicBank.length; i++)
			{
				if (this.contains(logicBank[i].blockTexture))
				{
					this.removeChild(logicBank[i].blockTexture);
				}
			}
			
			logicBank = GameVars.getInstance().GetCurrentMapLogicBank();
		}
		
		public function GetCurrentLevelBytes()
		{
			mapByteLimit = GameVars.getInstance().getCurrentLevelBytes();
		}
		
		//============================================
		// LogicBank Arrow Callback
		public function LogicBankUpArrowClick():Boolean
		{
			//isButtonBeingClicked = true;
			executionListYOffset += 50;
			if (executionListYOffset > 0)
			{
				executionListYOffset = 0;
			}
			return true;
		}


		//============================================
		// LogicBank Down Arrow Callback
		public function LogicBankDownArrowButtonClick():Boolean
		{
			var i:int = executionList.length;
			var overallHeight:int = (logicInterfaceMC.leftCommandList.y + instructionSpacing) + ((i / logicBankNumRowsOnScreen) * instructionBlockH) + ((i / logicBankNumRowsOnScreen) * instructionSpacing);
			isButtonBeingClicked = true;
			
			if (executionList.length > 3)
			{
				executionListYOffset -= 50;
				if (executionListYOffset + overallHeight < 768 - 130)
				{
					executionListYOffset = 768 - 150 - overallHeight;
				}
			}
			return true;
		}

		
		public function executionListUpArrowButtonClick(e:MouseEvent)
		{
			ExecutionListUpArrowButtonClick();
		}
		
		//============================================
		// ExecutionList Up Arrow Callback
		public function ExecutionListUpArrowButtonClick():Boolean
		{
			if (curInstrTab.toInt() == instructionTab.TAB_MAIN.toInt())
			{
				curExecutionList = executionList;
				curExecutionListYOffset = executionListYOffset;
			}
			else if (curInstrTab.toInt() == instructionTab.TAB_SUB1.toInt())
			{
				curExecutionList = executionListSub1;
				curExecutionListYOffset = executionListSub1YOffset;
			}
			else if (curInstrTab.toInt() == instructionTab.TAB_SUB2.toInt())
			{
				curExecutionList = executionListSub2;
				curExecutionListYOffset = executionListSub2YOffset;
			}
			
			//isButtonBeingClicked = true;
			curExecutionListYOffset += (instructionSpacing + instructionBlockH);
			if (curExecutionListYOffset > 0)
			{
				curExecutionListYOffset = 0;
			}
			
			// Insertion fix based on scroll amount
			curExecutionListScrolled -= 1;
			if (curExecutionListScrolled < 0)
			{
				curExecutionListScrolled = 0;
			}
			
			//At this point we have to reassign the value gained from 
			//the calculations above in curExecutionListYOffset 
			//back to the current execution list's scroll amount.
			if (curInstrTab.toInt() == instructionTab.TAB_MAIN.toInt())
			{
				executionListYOffset = curExecutionListYOffset;
				executionListScrolled = curExecutionListScrolled;
			}
			else if (curInstrTab.toInt() == instructionTab.TAB_SUB1.toInt())
			{
				executionListSub1YOffset = curExecutionListYOffset;
				executionListSub1Scrolled = curExecutionListScrolled;
			}
			else if (curInstrTab.toInt() == instructionTab.TAB_SUB2.toInt())
			{
				executionListSub2YOffset = curExecutionListYOffset;
				executionListSub2Scrolled = curExecutionListScrolled;
			}
			
			return true;
		}

		public function executionListDownArrowButtonClick(e:MouseEvent)
		{
			ExecutionListDownArrowButtonClick();
		}
		
		//============================================
		// ExecutionList Down Arrow Callback
		public function ExecutionListDownArrowButtonClick():Boolean
		{
			if (curInstrTab.toInt() == instructionTab.TAB_MAIN.toInt())
			{
				curExecutionList = executionList;
				curExecutionListYOffset = executionListYOffset;
				curExecutionListScrolled = executionListScrolled;
			}
			else if (curInstrTab.toInt() == instructionTab.TAB_SUB1.toInt())
			{
				curExecutionList = executionListSub1;
				curExecutionListYOffset = executionListSub1Scrolled;;
				curExecutionListScrolled = executionListSub1Scrolled;
			}
			else if (curInstrTab.toInt() == instructionTab.TAB_SUB2.toInt())
			{
				curExecutionList = executionListSub2;
				curExecutionListYOffset = executionListSub2YOffset;
				curExecutionListScrolled = executionListSub2Scrolled;
			}
			
			var i:int = curExecutionList.length;
			var numRows:int = i / instructionListNumColumns;
			if ((i % instructionListNumColumns) > 0)
				numRows++;
				
			var overallHeight:int = instructionSpacing + (numRows * instructionBlockH) + (numRows * instructionSpacing);
			//isButtonBeingClicked = true;
			
			curExecutionListYOffset -= (instructionSpacing + instructionBlockH);
			var cmp1:int = curExecutionListYOffset + overallHeight;
			var cmp2:int = logicInterfaceMC.rightCommandList.height;
			if (curExecutionListYOffset + overallHeight < logicInterfaceMC.rightCommandList.height - 50)
			{
				curExecutionListYOffset += (instructionSpacing + instructionBlockH);
			}
			
			
			// insertion fix based on scroll amount
			curExecutionListScrolled += 1;
			if (curExecutionListScrolled > numRows - 3)
			{
				curExecutionListScrolled = numRows - 3;
				if (curExecutionListScrolled < 0)
				{
					curExecutionListScrolled = 0;
				}
			}
			
			
			//At this point we have to reassign the value gained from 
			//the calculations above in curExecutionListYOffset 
			//back to the current execution list's scroll amount.
			if (curInstrTab.toInt() == instructionTab.TAB_MAIN.toInt())
			{
				executionListYOffset = curExecutionListYOffset;
				executionListScrolled = curExecutionListScrolled;
				//trace("executionListYOffset " + executionListYOffset);
			}
			else if (curInstrTab.toInt() == instructionTab.TAB_SUB1.toInt())
			{
				executionListSub1YOffset = curExecutionListYOffset;
				executionListSub1Scrolled = curExecutionListScrolled;
				//trace("executionListSub1YOffset " + executionListSub1YOffset);
			}
			else if (curInstrTab.toInt() == instructionTab.TAB_SUB2.toInt())
			{
				executionListSub2YOffset = curExecutionListYOffset;
				executionListSub2Scrolled = curExecutionListScrolled;
				//trace("executionListSub2YOffset " + executionListSub2YOffset)
			}
			
			
			
			return true;
		}

		//============================================
		// Execute Button Callback
		public function ExecutionButtonClick(e:MouseEvent):Boolean 
		{
			isExecuting = true;
			if (executionList.length > 1)
			{
				GameVars.getInstance().setExecutionLists(executionList, executionListSub1, executionListSub2);
				stage.dispatchEvent(new Event("gameBoardExecute"));
			}
		
			// Swaps the z-index positions of abort and execute buttons
			logicInterfaceMC.swapChildren(logicInterfaceMC.abortBtn, logicInterfaceMC.executeBtn);
			
			var mc:MovieClip;
			
			return false;
		}

		public function MainTabButtonClick(e:MouseEvent)
		{
			curInstrTab = instructionTab.TAB_MAIN;
			return false;
		}

		public function Sub1TabButtonClick(e:MouseEvent)
		{
			// Check and see if Sub1 is available to use
			// in this level. If not, don't let the player select this tabs
			for (var i:int = 0; i < logicBank.length; i++)
			{
				if (logicBank[i].enumInstruction.toInt() == AiInstructionsEnum.SUBR1.toInt())
				{
					if (logicBank[i].isUsable == true)
					{
						curInstrTab = instructionTab.TAB_SUB1;
						return false;
					}
				}
			}
			return false;
		}
		
		public function Sub2TabButtonClick(e:MouseEvent)
		{
			// Check and see if Sub2 is available to use
			// in this level. If not, don't let the player select this tabs
			for (var i:int = 0; i < logicBank.length; i++)
			{
				if (logicBank[i].enumInstruction.toInt() == AiInstructionsEnum.SUBR2.toInt())
				{
					if (logicBank[i].isUsable == true)
					{
						curInstrTab = instructionTab.TAB_SUB2;
						return false;
					}
				}
			}
		}

		
		public function ClearExecutionListFP(e:Event)
		{
			ClearExecutionList();
		}
		
		public function ClearExecutionList()
		{
			executionListYOffset = 0;
			executionListSub1YOffset = 0;
			executionListSub2YOffset = 0;
			curInstrTab = instructionTab.TAB_MAIN;
			
			for (var i:int = 0; i < executionList.length; i++)
			{
				if (this.contains(executionList[i].blockTexture))
				{
					this.removeChild(executionList[i].blockTexture);
				}
			}
			
			for (i = 0; i < executionListSub1.length; i++)
			{
				if (this.contains(executionListSub1[i].blockTexture))
				{
					this.removeChild(executionListSub1[i].blockTexture);
				}
			}

			for (i = 0; i < executionListSub2.length; i++)
			{
				if (this.contains(executionListSub2[i].blockTexture))
				{
					this.removeChild(executionListSub2[i].blockTexture);
				}
			}
			
			executionList = new Array();
			executionList.push(GameVars.getInstance().getPlaceInstructionBlock().clone());
			executionList[executionList.length - 1].setButtonState(logicBlockEnum.BS_ACTIVE, this);
			
			executionListSub1 = new Array();
			executionListSub1.push(GameVars.getInstance().getPlaceInstructionBlock().clone());
			executionListSub1[executionListSub1.length - 1].setButtonState(logicBlockEnum.BS_ACTIVE, this);
			
			executionListSub2 = new Array();
			executionListSub2.push(GameVars.getInstance().getPlaceInstructionBlock().clone());
			executionListSub2[executionListSub2.length - 1].setButtonState(logicBlockEnum.BS_ACTIVE, this);
			
			for (i = 0; i < executionList.length; i++)
			{
				this.addChild(executionList[i].blockTexture);
			}
			return true;
		}

		public function ResetExecutionMode()
		{
			isExecuting = false;
			//ERROR - wtf?
			//stage.dispatchEvent(new Event("gameBoardReset"));
		}
		
		public function CommandAdvanced(e:Event)//instrTab:instructionTab, curBlock:logicBlock)
		{
			var instrTab:instructionTab = GameVars.getInstance().getCurrentInstructionTab();
			var curBlockIndex:int = GameVars.getInstance().getCurrentInstructionBlockIndex();
			
			curInstrTab = instrTab;
			
			var i:int = 0;
			//trace(curBlockIndex);
			switch(instrTab.toInt())
			{
				case instructionTab.TAB_MAIN.toInt():
				{
					for (i = 0; i < executionListSub1.length; i++)
					{
						executionListSub1[i].setButtonState(logicBlockEnum.BS_ACTIVE, this);
					}
					for (i = 0; i < executionListSub2.length; i++)
					{
						executionListSub2[i].setButtonState(logicBlockEnum.BS_ACTIVE, this);
					}
					for (i = 0; i < executionList.length; i++)
					{
						executionList[i].setButtonState(logicBlockEnum.BS_ACTIVE, this);
						
						if (i == curBlockIndex)
						{
							executionList[i].setButtonState(logicBlockEnum.BS_HIGHLIGHTED, this);
						}
					}
					
					// Auto Scroll the Main Tab
					var curBlockRowCount:int = curBlockIndex / instructionListNumColumns;
					
					executionListYOffset = 0;
					executionListScrolled = 0;
					if (curBlockRowCount > instructionListNumRowsOnScreen - 1)
					{
						for (i = 0; i < curBlockRowCount - (instructionListNumRowsOnScreen - 1); i++)
						{
							ExecutionListDownArrowButtonClick();
						}
					}
					break;
				}
				case instructionTab.TAB_SUB1.toInt():
				{
					for (i = 0; i < executionListSub1.length; i++)
					{
						executionListSub1[i].setButtonState(logicBlockEnum.BS_ACTIVE, this);
						
						if (i == curBlockIndex)
						{
							executionListSub1[i].setButtonState(logicBlockEnum.BS_HIGHLIGHTED, this);
						}
					}
					if (GameVars.getInstance().getIsMainOnFirstCommand())
					{
						for (i = 0; i < executionList.length; i++)
						{
							executionList[i].setButtonState(logicBlockEnum.BS_ACTIVE, this);
						}
						executionList[0].setButtonState(logicBlockEnum.BS_HIGHLIGHTED, this);
					}
					else if (GameVars.getInstance().getIsSub1OnFirstCommand())
					{
						var alreadyAdvancedMain:Boolean = false;
						for (i = 0; i < executionList.length; i++)
						{
							if (executionList[i].curButtonState.toInt() == logicBlockEnum.BS_HIGHLIGHTED.toInt()
							&& !alreadyAdvancedMain)
							{
								executionList[i].setButtonState(logicBlockEnum.BS_ACTIVE, this);
								if (i + 1 < executionList.length)
								{
									executionList[i+1].setButtonState(logicBlockEnum.BS_HIGHLIGHTED, this);
								}
								else
								{
									executionList[i].setButtonState(logicBlockEnum.BS_HIGHLIGHTED, this);
								}
								alreadyAdvancedMain = true;
							}
						}
					}
					// Clear out the highlighting in Sub2
					for (i = 0; i < executionListSub2.length; i++)
					{
						executionListSub2[i].setButtonState(logicBlockEnum.BS_ACTIVE, this);
					}
					
					// Auto Scroll the Sub1 Tab
					curBlockRowCount = 0;
					curBlockRowCount = curBlockIndex / instructionListNumColumns;
					
					executionListSub1YOffset = 0;
					executionListSub1Scrolled = 0;
					if (curBlockRowCount > instructionListNumRowsOnScreen - 1)
					{
						for (i = 0; i < curBlockRowCount - (instructionListNumRowsOnScreen - 1); i++)
						{
							ExecutionListDownArrowButtonClick();
						}
					}
					break;
				}
				case instructionTab.TAB_SUB2.toInt():
				{
					for (i = 0; i < executionListSub2.length; i++)
					{
						executionListSub2[i].setButtonState(logicBlockEnum.BS_ACTIVE, this);
						
						if (i == curBlockIndex)
						{
							executionListSub2[i].setButtonState(logicBlockEnum.BS_HIGHLIGHTED, this);
						}
					}
					if (GameVars.getInstance().getIsMainOnFirstCommand())
					{
						for (i = 0; i < executionList.length; i++)
						{
							executionList[i].setButtonState(logicBlockEnum.BS_ACTIVE, this);
						}
						executionList[0].setButtonState(logicBlockEnum.BS_HIGHLIGHTED, this);
					}
					else if (GameVars.getInstance().getIsSub2OnFirstCommand())
					{
						var alreadyAdvancedMain2:Boolean = false;
						for (i = 0; i < executionList.length; i++)
						{
							if (executionList[i].curButtonState.toInt() == logicBlockEnum.BS_HIGHLIGHTED.toInt()
							&& !alreadyAdvancedMain2)
							{
								executionList[i].setButtonState(logicBlockEnum.BS_ACTIVE, this);
								if (i + 1 < executionList.length)
								{
									executionList[i+1].setButtonState(logicBlockEnum.BS_HIGHLIGHTED, this);
								}
								else
								{
									executionList[i].setButtonState(logicBlockEnum.BS_HIGHLIGHTED, this);
								}
								alreadyAdvancedMain2 = true;
							}
						}
						// Clear out the highlighting in Sub1
						for (i = 0; i < executionListSub1.length; i++)
						{
							executionListSub1[i].setButtonState(logicBlockEnum.BS_ACTIVE, this);
						}
					}
					
					// Auto Scroll the Sub2 Tab
					curBlockRowCount = 0;
					curBlockRowCount = curBlockIndex / instructionListNumColumns;
					
					executionListSub2YOffset = 0;
					executionListSub2Scrolled = 0;
					if (curBlockRowCount > instructionListNumRowsOnScreen - 1)
					{
						for (i = 0; i < curBlockRowCount - (instructionListNumRowsOnScreen - 1); i++)
						{
							ExecutionListDownArrowButtonClick();
						}
					}
					break;
				}
			}

			
			
			//=================================
			// NOTE & WARNING
			// 4/7/09
			// Corwin 
			// Added in some tweaks to the way commands are highlighted,
			// so that the main list properly updates when subroutines
			// are being processed.
			//
			// WARNING: This code is being written reflecting the fact
			// that sub-routines can't be placed in sub-routines
			// which was a recent design decision. 
			// If we reverse this design decision, this code WILL BREAK!
//
//
//
			// To make sure the subs are highlighting correctly
			// in the main tab.. use a bool flag to track whether
			// or not we're executing a subroutine.
			//curInstrTab = instrTab;
			//if (curInstrTab.toInt() == instructionTab.TAB_MAIN.toInt())
			//{
				//curExecutionList = executionList;
				//curExecutionListYOffset = executionListYOffset;
				//
				//isProcessingSub = false;
			//}
			//else if (curInstrTab.toInt() == instructionTab.TAB_SUB1.toInt())
			//{
				//if (isProcessingSub == false)
				//{
					//var activateNextCommand:Boolean = false;
					//for (i = 0; i < executionList.length; i++)
					//{
						//if (executionList[i].curButtonState == logicBlockEnum.BS_HIGHLIGHTED.toInt())
						//{
							//activateNextCommand = true;
							//executionList[i].curButtonState = logicBlockEnum.BS_ACTIVE;
						//}
						//else if (activateNextCommand == true)
						//{
							//executionList[i].curButtonState = logicBlockEnum.BS_HIGHLIGHTED;
							//activateNextCommand = false;
						//}
					//}
					//
					//isProcessingSub = true;
				//}
				//
				//curExecutionList = executionListSub1;
				//curExecutionListYOffset = executionListSub1YOffset;
			//}
			//else if (curInstrTab.toInt() == instructionTab.TAB_SUB2.toInt())
			//{
				//if (isProcessingSub == false)
				//{
					// First command in a sub routine.. advance the main highlight
					//activateNextCommand = false;
					//
					//for (i = 0; i < executionList.length; i++)
					//{
						//if (executionList[i].curButtonState == logicBlockEnum.BS_HIGHLIGHTED.toInt())
						//{
							//activateNextCommand = true;
							//executionList[i].curButtonState = logicBlockEnum.BS_ACTIVE;
						//}
						//else if (activateNextCommand == true)
						//{
							//executionList[i].curButtonState = logicBlockEnum.BS_HIGHLIGHTED;
							//activateNextCommand = false;
						//}
					//}
					//
					//isProcessingSub = true;
				//}
				//
				//curExecutionList = executionListSub2;
				//curExecutionListYOffset = executionListSub2YOffset;
			//}	
			//
			//var curBlockIndex:int = 0;
			//for (var i:int = 0; i < curExecutionList.length; i++)
			//{
				//curExecutionList[i].curButtonState = logicBlockEnum.BS_ACTIVE;
				//if (executionList[i] == curBlock)
				//{
					//curBlockIndex = i;
				//}
			//}
			//curBlock.curButtonState = logicBlockEnum.BS_HIGHLIGHTED;
							//
			//
				// Auto-Scroll to follow the currently highlighted instruction
			// 1) Figure out how many rows down the current block is
			//var curBlockRowCount:int = curBlockIndex / instructionListNumColumns;
//
			// 2) Figure out if scrolling is needed to display that row
			//curExecutionListYOffset = 0;
			//if (curBlockRowCount > instructionListNumRowsOnScreen - 1)
			//{
				// 3) If so.. scroll however many times is needed
				//for (i = 0; i < curBlockRowCount - (instructionListNumRowsOnScreen - 1); i++)
				//{
					//ExecutionListDownArrowButtonClick();
				//}
			//}
//
			//return true;	
		}

		public function manualAbort(e:Event)
		{
			fireAbort();
		}

		public function ReprogramReached(e:Event)
		{
			isExecuting = false;
			return true;
		}

		public function launchHelpState(e:MouseEvent):Boolean
		{
			stage.dispatchEvent(new Event("launchHelpState"));
			return true;
		}

		public function speedUpButtonClick(e:MouseEvent)
		{
			stage.dispatchEvent(new Event("playGameSpeedUp"));
			return true;		
		}

		public function slowDownButtonClick(e:MouseEvent)
		{
			stage.dispatchEvent(new Event("playGameSlowDown"));
			return true;
		}
		
		public function skipTutorialButtonClick(e:MouseEvent)
		{
			var level:int = logicVars.getCurrentLevel();
			
			ClearExecutionList();
			// go to the next tutorial level
			if (level <= logicVars.getNumTutorialLevels())
			{
				level++;
				logicVars.setCurrentLevel(level);
				logicVars.setLevelSpecified(level);
				//trace("from the skip this tutorial button, current level is ", level);
				// make a call to create a new playGameState
				stage.dispatchEvent(new Event("skipLevel"));
			}
		}
		
		public function skipLevelButtonClick(e:MouseEvent)
		{
			var level:int = logicVars.getCurrentLevel();
			
			ClearExecutionList();
			// go to the next tutorial level
			if (level <= logicVars.maxLevel)
			{
				level++;
				logicVars.setCurrentLevel(level);
				logicVars.setLevelSpecified(level);
				stage.dispatchEvent(new Event("skipLevel"));
			}
		}

		// ==============================
		// Compass Button Callbacks
		public function panUpButtonClick(e:MouseEvent)
		{
			stage.dispatchEvent(new Event("playGamePanUp"));
			panUpFiring = false;
			
			// Tom's uncommitted stuff.... 
			//var buttonDown:Boolean;
			//if (e.toString() == MouseEvent.MOUSE_DOWN)
			//{
				//buttonDown = true;
			//}
			//if (e.toString() == MouseEvent.MOUSE_UP)
			//{
				//buttonDown = false;
			//}
			//while (buttonDown == true)
			//{
				//stage.dispatchEvent(new Event("playGamePanUp"));
			//}
			//return;		
		}
		
		public function panUpLeftButtonClick(e:MouseEvent)
		{
			stage.dispatchEvent(new Event("playGamePanUpLeft"));
			panUpLeftFiring = false;
			return;		
		}
		
		public function panUpRightButtonClick(e:MouseEvent)
		{
			stage.dispatchEvent(new Event("playGamePanUpRight"));
			panUpRightFiring = false;
			return;		
		}
		
		public function panRightButtonClick(e:MouseEvent)
		{
			stage.dispatchEvent(new Event("playGamePanRight"));
			panRightFiring = false;
			return;		
		}
		
		public function panLeftButtonClick(e:MouseEvent)
		{
			stage.dispatchEvent(new Event("playGamePanLeft"));
			panLeftFiring = false;
			return;		
		}
		
		public function panDownButtonClick(e:MouseEvent)
		{
			stage.dispatchEvent(new Event("playGamePanDown"));
			panDownFiring = false;
			return;		
		}
		
		public function panDownRightButtonClick(e:MouseEvent)
		{
			stage.dispatchEvent(new Event("playGamePanDownRight"));
			panDownRightFiring = false;
			return;		
		}
		
		public function panDownLeftButtonClick(e:MouseEvent)
		{
			stage.dispatchEvent(new Event("playGamePanDownLeft"));
			panDownLeftFiring = false;
			return;		
		}
		
		public function centerButtonClick(e:MouseEvent)
		{
			stage.dispatchEvent(new Event("playGameCenter"));
			return;		
		}
		
		public function zoomInButtonClick(e:MouseEvent)
		{
			stage.dispatchEvent(new Event("playGameZoomIn"));
			zoomInFiring = false;
			return;		
		}
		
		public function zoomOutButtonClick(e:MouseEvent)
		{
			stage.dispatchEvent(new Event("playGameZoomOut"));
			zoomOutFiring = false;
			return;		
		}
		
		public function rotateRightButtonClick(e:MouseEvent)
		{
			stage.dispatchEvent(new Event("playGameRotateRight"));
			return;		
		}
		
		public function rotateLeftButtonClick(e:MouseEvent)
		{
			stage.dispatchEvent(new Event("playGameRotateLeft"));
			return;		
		}
		
		public function optionsButtonClick(e:MouseEvent)
		{
			stage.dispatchEvent(new Event("optionsButtonClicked"));
			return;		
		}
		
		//============================================
		// Abort Button Callback
		public function AbortButtonClick(e:MouseEvent):Boolean
		{
			fireAbort();
			return false;			
		}
		
		public function fireAbort()
		{
			isExecuting = false;
			stage.dispatchEvent(new Event("gameBoardAbort"));
			
			// Swaps the z-index positions of abort and execute buttons
			logicInterfaceMC.swapChildren(logicInterfaceMC.abortBtn, logicInterfaceMC.executeBtn);
		}

		//============================================
		// Reset Button Callback
		public function ResetButtonClick(e:MouseEvent):Boolean
		{
				fireAbort();
			//if (isExecuting == false)
			//{
				//ClearExecutionList();
				curInstrTab = instructionTab.TAB_MAIN;
				
				// Clear the status of the instructions so there
				// is no highlighted square.
				for (var i:int = 0; i < executionList.length; i++)
				{
					executionList[i].setButtonState(logicBlockEnum.BS_ACTIVE, this);
				}
				
				for (i = 0; i < executionListSub1.length; i++)
				{
					executionListSub1[i].setButtonState(logicBlockEnum.BS_ACTIVE, this);
				}

				for (i = 0; i < executionListSub2.length; i++)
				{
					executionListSub2[i].setButtonState(logicBlockEnum.BS_ACTIVE, this);
				}
				
				//isExecuting = false;

				stage.dispatchEvent(new Event("gameBoardReset"));
				return false;
			//}
			return false;
		}


		//============================================
		// Clear Button Callback
		public function ClearButtonClick(e:MouseEvent)
		{
			if (isExecuting == false)
			{
				ClearExecutionList();
			}
			return true;
		}
		
		// info button clicked thingie
		public function infoButtonClick(e:MouseEvent)
		{
			stage.dispatchEvent(new Event("infoButtonClicked"));
		}
		
		
		
		//////// autoclicker thingies for compass
		
		public function startFiringPanDown(e:MouseEvent)
		{
			panDownFiring = true;
		}
		public function startFiringPanDownRight(e:MouseEvent)
		{
			panDownRightFiring = true;
		}
		public function startFiringPanDownLeft(e:MouseEvent)
		{
			panDownLeftFiring = true;
		}
		public function startFiringPanUp(e:MouseEvent)
		{
			panUpFiring = true;
		}
		public function startFiringPanUpLeft(e:MouseEvent)
		{
			panUpLeftFiring = true;
		}
		public function startFiringPanUpRight(e:MouseEvent)
		{
			panUpRightFiring = true;
		}
		public function startFiringPanLeft(e:MouseEvent)
		{
			panLeftFiring = true;
		}
		public function startFiringPanRight(e:MouseEvent)
		{
			panRightFiring = true;
		}
		public function startFiringZoomIn(e:MouseEvent)
		{
			zoomInFiring = true;
		}
		public function startFiringZoomOut(e:MouseEvent)
		{
			zoomOutFiring = true;
		}
		
		public function stopFiringPanDown(e:MouseEvent)
		{
			panDownFiring = false;
		}
		public function stopFiringPanDownRight(e:MouseEvent)
		{
			panDownRightFiring = false;
		}
		public function stopFiringPanDownLeft(e:MouseEvent)
		{
			panDownLeftFiring = false;
		}
		public function stopFiringPanUp(e:MouseEvent)
		{
			panUpFiring = false;
		}
		public function stopFiringPanUpLeft(e:MouseEvent)
		{
			panUpLeftFiring = false;
		}
		public function stopFiringPanUpRight(e:MouseEvent)
		{
			panUpRightFiring = false;
		}
		public function stopFiringPanLeft(e:MouseEvent)
		{
			panLeftFiring = false;
		}
		public function stopFiringPanRight(e:MouseEvent)
		{
			panRightFiring = false;
		}
		public function stopFiringZoomIn(e:MouseEvent)
		{
			zoomInFiring = false;
		}
		public function stopFiringZoomOut(e:MouseEvent)
		{
			zoomOutFiring = false;
		}
		
		public function processAutoFires()
		{
			if (panUpFiring)
			{
				stage.dispatchEvent(new Event("playGamePanUp"));
			}
			else if (panUpLeftFiring)
			{
				stage.dispatchEvent(new Event("playGamePanUpLeft"));
			}
			else if (panUpRightFiring)
			{
				stage.dispatchEvent(new Event("playGamePanUpRight"));
			}
			else if (panRightFiring)
			{
				stage.dispatchEvent(new Event("playGamePanRight"));
			}
			else if (panLeftFiring)
			{
				stage.dispatchEvent(new Event("playGamePanLeft"));
			}
			else if (panDownFiring)
			{
				stage.dispatchEvent(new Event("playGamePanDown"));
			}
			else if (panDownRightFiring)
			{
				stage.dispatchEvent(new Event("playGamePanDownRight"));
			}
			else if (panDownLeftFiring)
			{
				stage.dispatchEvent(new Event("playGamePanDownLeft"));
			}
			else if (zoomInFiring)
			{
				stage.dispatchEvent(new Event("playGameZoomIn"));
			}
			else if (zoomOutFiring)
			{
				stage.dispatchEvent(new Event("playGameZoomOut"));
			}			
		}

	} // End Class
}// End Package