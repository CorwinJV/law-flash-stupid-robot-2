package code 
{	
	/**
	 * ...
	 * Original Author: Grant Skinner (http://www.gskinner.com/blog/archives/2006/07/as3_singletons.html)
	 * Modified By: Corwin VanHook 
	 * Further Modified By: Tom Lindeman
	 */
	
	import code.enums.ClickOKEnum;
	import code.logicBlock;
	import code.enums.AiInstructionsEnum;
	import code.structs.Switch;
	import fl.motion.ITween;
	import flash.display.MovieClip;
	import code.structs.levelData;
	import code.structs.playerInfo;
	import code.switchManager;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.net.registerClassAlias;
	import flash.utils.ByteArray;
	import flash.media.Sound;
	
	import code.enums.instructionTab;
	
	public class GameVars 
	{
		private static var instance:GameVars;
		private static var allowInstantiation:Boolean;
		
		//var PM:profileManager = new profileManager();
		//var PI:playerInfo = new playerInfo();
		//var SM:switchManager = new switchManager();
		
		public var didYouKnow:Array;
		public var didYouKnowIterator:int;
	
		var tutorialMovieClip:int;
		var currentLevelBytes:int;
		var levelHeight:int;
		var levelWidth:int;
		var mPlayerName:String;
		var mTotalScore:int;
		var currentLevel:int;
		var maxLevel:int;
		var playerMaxLevel:int;
		var levelScore:int;
		var levelCommands:int;
		var levelInstructions:int;
		var levelSpecified:int;
		var curBytesUsed:int;
		var robotXPos:int;
		var robotYPos:int;
		var tileActive:Boolean;
		var pmStatus:int;
		var SM:switchManager = new switchManager();
		var SMD:switchManager = new switchManager();
		//var allLogicBlocks:Array;
		//var placeInstructionBlock:logicBlock = new logicBlock();
		var currentLogicBank:Array = new Array();
		var numTutorialLevels:int;
		var inGame:Boolean;
		
		// variable to see if robot is done dancing, initialize to false
		var doneDancing:Boolean = true;
		var startedDancing:Boolean = false;
		
		var logicInteraceDoNotProcessMouse:Boolean = false;
		
		var isSub1OnFirstCommand:Boolean;
		var isSub2OnFirstCommand:Boolean;
		var isMainOnFirstCommand:Boolean;
		
		var allLogicBlocks:Array = new Array();
		var placeInstructionBlock:logicBlock = null;
		
		var levelList:Array;
		public var commandsProcessed:int;
		public var totalCommandsProcessed:int;
		
		// The speed at which the gameBoard should process at.. by default 500.
		var processSpeed:int = 500;
		
		// Current instruction tab & current instruction index for LogicInterface command highlighting
		private var currentInstructionTab:instructionTab = instructionTab.TAB_MAIN;
		private var currentInstructionIndex:int = 0;
		
		// Execution lists from logic interface to pass to gameboard
		private var executionListMain:Array = null;
		private var executionListSub1:Array = null;
		private var executionListSub2:Array = null;
		
		public var robotDiedElectricity:Boolean = false;
		public var robotDiedWater:Boolean = false;
		public var robotDiedGap:Boolean = false;
		
		// boolean variables for all directions for all types of jumping scenarios
		public var robotJumpSuccessBR:Boolean = false;
		public var robotJumpSuccessBL:Boolean = false;
		public var robotJumpSuccessTR:Boolean = false;
		public var robotJumpSuccessTL:Boolean = false;
		public var robotJumpFailFarBR = false;
		public var robotJumpFailFarBL = false;
		public var robotJumpFailFarTR = false;
		public var robotJumpFailFarTL = false;
		public var robotJumpFailCloseBR = false;
		public var robotJumpFailCloseBL = false;
		public var robotJumpFailCloseTR = false;
		public var robotJumpFailCloseTL = false;
		
		// ui for instructions
		public var SSoundInterfaceAddInstruction:Sound;
		public var SSoundInterfaceRemoveInstruction:Sound;
		public var SSoundInterfaceExecute:Sound;
		public var SSoundInterfaceAbort:Sound;
		
		// robot processing instructions
		public var SSoundMoveForward:Sound;
		public var SSoundTurnLeft:Sound;
		public var SSoundTurnRight:Sound;
		public var SSoundCrouch:Sound;
		public var SSoundClimb:Sound;
		public var SSoundJump:Sound;
		public var SSoundPunch:Sound;
		public var SSoundMoveForwardUntilUnable:Sound;
		public var SSoundStop:Sound;
		
		// tiles
		public var SSoundTileIce:Sound;
		public var SSoundTileDefault:Sound;
		public var SSoundTileElectricOn:Sound;
		public var SSoundTileElectricOff:Sound;
		public var SSoundTileSwitchOn:Sound;
		public var SSoundTileSwitchOff:Sound;
		public var SSoundTileReprogramTile:Sound;
		public var SSoundTileBreakableBreaking:Sound;
		public var SSoundTileEndOff:Sound;
		public var SSoundTileEndOn:Sound;
		public var SSoundTileToggle:Sound;
		public var SSoundTileSolidHit:Sound;
		public var SSoundTileCannotMoveForward:Sound;
		public var SSoundTileTeleport:Sound;
		public var SSoundTileDoorOpen:Sound;
		public var SSoundTileDoorClose:Sound;
				
		// events
		public var SSoundRobotDiedElectric:Sound;
		public var SSoundRobotDiedGap:Sound;
		public var SSoundRobotDiedWater:Sound;
		public var SSoundLevelComplete:Sound;
		public var SSoundRobotDance:Sound;
		
		// menu shit
		public var SSoundMenuClick:Sound;
		public var SSoundMenuBack:Sound;
		
		// music
		var MMusicDefault:Sound;
		var MMusicMenus:Sound;
		var MMusicCredits:Sound;
		var MusicChannel:SoundChannel;
		
		var tutPopUpUseShield:Boolean = false;

		public static function getInstance():GameVars
		{
			if (instance == null) 
			{
				allowInstantiation = true;
				instance = new GameVars();
				allowInstantiation = false;
			}
			return instance;
		}
		
		public function setCurrentLogicBank(moveForwardAvail:Boolean, moveForwardUntilAvail:Boolean, turnLeftAvail:Boolean, 
											turnRightAvail:Boolean, punchAvail:Boolean, climbAvail:Boolean, crouchAvail:Boolean, 
											jumpAvail:Boolean, activateAvail:Boolean, sub1Avail:Boolean, sub2Avail:Boolean):void
		{
			//if(currentLogicBank != NULL)
				//delete currentLogicBank;
						
			currentLogicBank = new Array();

			for(var i:int = 0; i < allLogicBlocks.length; i++)
			{
				allLogicBlocks[i].isUsable = true;
				allLogicBlocks[i].isCurrentlyUsable = true;
			}

			currentLogicBank.push(allLogicBlocks[0]);
			if(!moveForwardAvail)
			{
				currentLogicBank[currentLogicBank.length - 1].isUsable = false;
			}
						
			currentLogicBank.push(allLogicBlocks[1]);
			if(!moveForwardUntilAvail)
			{
				currentLogicBank[currentLogicBank.length - 1].isUsable = false;
			}
						
			currentLogicBank.push(allLogicBlocks[2]);
			if(!turnLeftAvail)
			{
				currentLogicBank[currentLogicBank.length - 1].isUsable = false;
			}
						
			currentLogicBank.push(allLogicBlocks[3]);
			if(!turnRightAvail)
			{
				currentLogicBank[currentLogicBank.length - 1].isUsable = false;
			}
						
			currentLogicBank.push(allLogicBlocks[4]);
			if(!punchAvail)
			{
				currentLogicBank[currentLogicBank.length - 1].isUsable = false;
			}
						
			currentLogicBank.push(allLogicBlocks[5]);
			if(!climbAvail)
			{
				currentLogicBank[currentLogicBank.length - 1].isUsable = false;
			}
						
			currentLogicBank.push(allLogicBlocks[6]);
			if(!crouchAvail)
			{
				currentLogicBank[currentLogicBank.length - 1].isUsable = false;
			}
						
			currentLogicBank.push(allLogicBlocks[7]);
			if(!jumpAvail)
			{
				currentLogicBank[currentLogicBank.length - 1].isUsable = false;
			}
						
			currentLogicBank.push(allLogicBlocks[8]);
			if(!activateAvail)
			{
				currentLogicBank[currentLogicBank.length - 1].isUsable = false;
			}
						
			currentLogicBank.push(allLogicBlocks[9]);
			if(!sub1Avail)
			{
				currentLogicBank[currentLogicBank.length - 1].isUsable = false;
			}
						
			currentLogicBank.push(allLogicBlocks[10]);
			if(!sub2Avail)
			{
				currentLogicBank[currentLogicBank.length - 1].isUsable = false;
			}
					
			//stop always useable
			currentLogicBank.push(allLogicBlocks[11]);
		}
			
		public function setCurrentLevelBytes(newBytes:int):void
		{
			currentLevelBytes = newBytes;
		}
		
		public function setLevelHeight(height:int):void
		{
			levelHeight = height;
		}
		
		public function setLevelWidth(width:int):void
		{
			levelWidth = width;
		}
		
		public function clearScreen()
		{
		
		}
													
		
		public function GameVars() :void
		{
			if (!allowInstantiation)
			{
				throw new Error("Error: Instantiation failed: Use GameVars.getInstance() instead of new.");
			}
			else
			{
				// Set up code here, guys! --Corwin
				
				////////////////////////////
				// logic block loading
				loadAllLogicBlocks();
				
				mTotalScore = 0;
				currentLevel = 1;
				maxLevel = 1;
				playerMaxLevel = 1;
				levelScore = 0;
				currentLevelBytes = 1;
				levelSpecified = -1;
				
				////////////////////////////
				// load sounds yay!
				loadAllSoundThings();
				
				////////////////////////////
				// level loading
				loadAllLevels();
				
				////////////////////////////
				// profile manager stuff
				//maxLevel = levelList.size();
				//PI = new playerInfo(maxLevel);
				//PM = new profileManager(maxLevel);

				////////////////////////////
				// did you know info
				loadDidYouKnow();

				////////////////////////////
				// switch manager
				//SM = new switchManager();
			}
		}
		
		
		//===============================================
		// Non singleton functions and data members here
		//===============================================
		//
		public function getPlayerName():String
		{
			return mPlayerName;
		}

		public function setPlayerName(sName:String):void
		{
			mPlayerName = sName;
		}
		
		public function setLevelSpecified(level:int):void
		{
			levelSpecified = level;
		}
		
		public function getLevelSpecified():int
		{
			return levelSpecified;
		}
	
		public function getRobotX():int
		{
			return robotXPos;
		}

		public function getRobotY():int
		{
			return robotYPos;
		}

		public function setRobotX(x:int):void
		{
			robotXPos = x;
		}

		public function setRobotY(y:int):void
		{
			robotYPos = y;
		}

		public function getLevelHeight():int
		{
			return levelHeight;
		}
	
		public function getLevelWidth():int
		{
			return levelWidth;
		}

		public function getTileActive(x:int, y:int):Boolean
		{
			return tileActive;
		}

		public function getFilename(level:int):String
		{
			return levelList[level].getFile();
		}

		public function getDesc(level:int):String
		{
			return levelList[level].getDesc();
		}
		
		public function getLevelName(level:int):String
		{
			return levelList[level].getName();
		}
		
		public function setBytesUsed(val:int):void
		{
			curBytesUsed = val;
		}
		
		public function getBytesUsed():int
		{
			return curBytesUsed;
		}
		
		public function getCurrentInstructionTab():instructionTab
		{
			return currentInstructionTab;
		}
		
		public function getCurrentInstructionBlockIndex():int
		{
			return currentInstructionIndex;
		}
				
		public function setCurrentInstructionTab(instrTab:instructionTab):void
		{
			currentInstructionTab = instrTab;
		}
		
		public function setCurrentInstructionBlockIndex(i:int):void
		{
			currentInstructionIndex = i;
		}
		
		public function setIsSub1OnFirstCommand(b:Boolean)
		{
			isSub1OnFirstCommand = b;
		}
		
		public function setIsSub2OnFirstCommand(b:Boolean)
		{
			isSub2OnFirstCommand = b;
		}
		
		public function getIsSub1OnFirstCommand():Boolean
		{
			return isSub1OnFirstCommand;
		}

		public function getIsSub2OnFirstCommand():Boolean
		{
			return isSub2OnFirstCommand;
		}
		
		public function setIsMainOnFirstCommand(b:Boolean)
		{
			isMainOnFirstCommand = b;
		}
		
		public function getIsMainOnFirstCommand():Boolean
		{
			return isMainOnFirstCommand;
		}
		
		public function setExecutionLists(a1:Array, a2:Array, a3:Array)
		{
			executionListMain = a1;
			executionListSub1 = a2;
			executionListSub2 = a3;
		}
		
		public function getMainExecutionList():Array
		{
			return executionListMain;
		}
		
		public function getSub1ExecutionList():Array
		{
			return executionListSub1;
		}
		
		public function getSub2ExecutionList():Array
		{
			return executionListSub2;
		}
		
		public function updatePlayerFile():Boolean
		{

			// get the players name and ensure it isn't set to blank which would 
			// break our vector
			var playerGame:String;
			playerGame = getPlayerName();
	
			var tempString:String;
			var highLevel:int;
			var curLevel:int;
			var levelHighScore:int;
			var playerLevelScore:int;
			
			curLevel = getCurrentLevel();
		
			// get which level the player just completed for stat comparisons
			// initialize variables for max level, level score, used to compare
			// against the stats in the array
	
			playerLevelScore = getLevelScore();
			//levelHighScore = GameVars.PM.getPlayerLevelScore(curLevel);

			highLevel = getPlayerMaxLevel();

			//in all cases, keep the better stats by replacing them
			//also if stats are set to the initialized value of -1
			//save over them
	
			if(playerLevelScore > levelHighScore)
			//{
				//GameVars.PM.setPlayerLevelScore(curLevel, playerLevelScore);
			//}

			// increment the level
			curLevel++;

			if(curLevel > highLevel)
			{
				highLevel = curLevel;
				//GameVars.setPlayerMaxLevel(highLevel);
				//GameVars.PM.setPlayerHighestLevel(highLevel);
			}

			//GameVars.PM.saveProfile();

			return true;
		}

		public function setCurrentLevel(level:int):void
		{
			currentLevel = level;
		}
	
		public function getTotalScore():int
		{
			// zero out the total score
			var totScore:int = 0;
			
			// determine the highest level the player has reached that has been saved
			//for(var i:int = 0; i < GameVars.PM.getPlayerHighestLevel(); i++)
			//{
				// iterate through adding all level scores to the players score
				//totScore += GameVars.PM.getPlayerLevelScore(i);
			//}
			
			// add 1 to players score to makeup for the the initial score for each level 
			// being intialized to 0
			totScore += 1;
			
			// return the newly calculated score
			return totScore;
		}

		public function getPlayerMaxLevel():int
		{
			return playerMaxLevel;
		}
	
		public function getLevelScore():int
		{
			return levelScore;
		}

		public function getCurrentLevel():int
		{
			return currentLevel;
		}
		
		public function setLevel(level:int):void
		{
			currentLevel = level;
		}

		public function getCurrentLevelBytes():int
		{
			return currentLevelBytes;
		}
		
		public function setMaxLevel(newMax:int):void
		{
			maxLevel = newMax;
		}

		public function setPlayerMaxLevel(level:int):void
		{
			playerMaxLevel = level;
		}

		public function getMaxLevel():int
		{
			return maxLevel;
		}

		public function setLevelScore(score:int):void
		{
			levelScore = score;
		}

		public function setTotalScore(score:int)
		{
			mTotalScore = score;
		}
		
		public function setPMStatus(status:int):void
		{
			pmStatus = status;
		}

		public function getPMStatus():int
		{
			return pmStatus;
		}

		public function setLevelCommands(commands:int):void
		{
			levelCommands = commands;
		}
	
		public function setLevelInstructions(instructions:int):void
		{
			levelInstructions = instructions;
		}

		public function getLevelCommands():int
		{
			return levelCommands;
		}
		
		public function getLevelInstructions():int
		{
			return levelInstructions;
		}
		
		public function setTutorialMovieClip(mcID:int)
		{
			tutorialMovieClip = mcID;
		}
		
		public function getTutorialMovieClip():int
		{
			return tutorialMovieClip;
		}

		
		public function setTutPopUpUseShield(b:Boolean)
		{
			tutPopUpUseShield = b;
		}
		
		public function getTutPopUpUseShield():Boolean
		{
			return tutPopUpUseShield;
		}
		
		public function loadAllLevels():void
		{
			levelList = new Array();
			var tempLevel:levelData;
			//var tempArt:oglTexture2D;
			
			numTutorialLevels = 0;
			
			tempLevel = new levelData("DEBUG MAP", "THIS IS FOR DAVE TO DEBUG MAP TILES", "additionalContent/maps/testMap1orig.txt");
			levelList.push(tempLevel);
			
			tempLevel = new levelData("Stupid Robot Tutorial.", "Everything you need to know to enjoy the game.", "additionalContent/maps/Tutorialmap.txt");
			levelList.push(tempLevel);			
			numTutorialLevels++;
			
			tempLevel = new levelData("Ice Ice Baby!", "Ice is Slippery.", "additionalContent/maps/tileTutorialMap2.txt");
			levelList.push(tempLevel);
			
			tempLevel = new levelData("Abracadabra", "The Map Will Magically Appear!! Remember commands an loop.", "additionalContent/maps/Abracadabra.txt");
			levelList.push(tempLevel);
			
			tempLevel = new levelData("Jump The Holes", "Don't trip and fall.", "additionalContent/maps/Jumptheholes.txt");
			levelList.push(tempLevel);	
			
			tempLevel = new levelData("Mouse Trap", "Its like the board game", "additionalContent/maps/mousetrap.txt");
			levelList.push(tempLevel);			
			
			tempLevel = new levelData("Needle in a Haystack", "Only one will open your path.", "additionalContent/maps/Needleinahaystack.txt");
			levelList.push(tempLevel);
			
			tempLevel = new levelData("Figure it out as You Go", "No really figure it out as you go.", "additionalContent/maps/Figureitoutasyougo.txt");
			levelList.push(tempLevel);	
			
			tempLevel = new levelData("Steps of Doom", "Climb Up to Higher Levels", "additionalContent/maps/tileTutorialMap1.txt");
			levelList.push(tempLevel);
			
			tempLevel = new levelData("Holes and Ice", "Jump, Activate, Slide, Activate.", "additionalContent/maps/holesandice.txt");
			levelList.push(tempLevel);
			
			tempLevel = new levelData("Hedge Maze", "Get to the finish line.", "additionalContent/maps/Mapo6.txt");
			levelList.push(tempLevel);	
			
			tempLevel = new levelData("Corners", "Hit all four.", "additionalContent/maps/Mapo8.txt");
			levelList.push(tempLevel);	
			
			tempLevel = new levelData("Steps of Doom - Revist", "Subroutine Required", "additionalContent/maps/tileTutorialMap1b.txt");
			levelList.push(tempLevel);
			
			tempLevel = new levelData("Haystack Sub Needle", "This seems oddly familiar. You see where we're going with this.", "additionalContent/maps/Haystacksubneedle.txt");
			levelList.push(tempLevel);
			
			tempLevel = new levelData("Mastermind", "Its like the board game. Figure out the Pattern.", "additionalContent/maps/Mastermind.txt");
			levelList.push(tempLevel);
			
			tempLevel = new levelData("Those tiles need changin'", "Flip the switch and watch it fly.", "additionalContent/maps/Mapo10.txt");
			levelList.push(tempLevel);
			
			tempLevel = new levelData("Poof!!!", "Where did he go...there he is.", "additionalContent/maps/poof.txt");
			levelList.push(tempLevel);
			
			tempLevel = new levelData("You Must Choose Wisely.", "Only the right switch will lead to eternal glory.", "additionalContent/maps/Choosewisely.txt");
			levelList.push(tempLevel);
			
			tempLevel = new levelData("Rufus Robot and the Temple of Dumb.", "Dumb dumb dumb dummmmmmm...dumb dumb dummmmmmm.", "additionalContent/maps/Rufusandthetempleofdumb.txt");
			levelList.push(tempLevel);
			
			tempLevel = new levelData("Pitfalls", "Careful not to slip.", "additionalContent/maps/Mapo9.txt");
			levelList.push(tempLevel);
			
			//tempLevel = new levelData("Moving Forward", "Click the \"Move Forward\" Instruction, then click \"Execute\".", "additionalContent/maps/tutorialMoveForward.txt");
			//levelList.push(tempLevel);
			
			//tempLevel = new levelData("Moving forward Until Unable", "Tutorial - Move Forward Until Unable, then turn left", "additionalContent/maps/tutorialMoveForwardUnable.txt");
			//levelList.push(tempLevel);
			
			//tempLevel = new levelData("Activating Switches and Doors", "Tutorial - Use activate on the door and the switch", "additionalContent/maps/tutorialSwitchDoorBlock.txt");
			//levelList.push(tempLevel);
			
			//tempLevel = new levelData("Moving, Turning and Punching", "Tutorial - Place instructions to move, turn and punch your way through this level.", "additionalContent/maps/tutorialMoveTurnPunch.txt");
			//levelList.push(tempLevel);
			
			//tempLevel = new levelData("Crouching, Climbing and Jumping", "Tutorial - Place instructions to crouch, climb and jump over obstacles to reach the end.", "additionalContent/maps/tutorialCrouchClimbJump.txt");
			//levelList.push(tempLevel);
			
			//tempLevel = new levelData("Teleporters and AutoLoop", "Tutorial - Instructions auto-loop and teleporters move you to new locations.", "additionalContent/maps/tutorialTeleporters.txt");
			//levelList.push(tempLevel);
			
			//tempLevel = new levelData("Zzzzap! Flip! Silence...", "Tutorial - Switches and Electricity, make sure you're facing the red switch edge.", "additionalContent/maps/tutorialSwitchesElectricity.txt");
			//levelList.push(tempLevel);
					
			//tempLevel = new levelData("Not enough memory...", "Tutorial - Reprogrammable Squares let you reprogram your robot at them.", "additionalContent/maps/tutorialReprogrammable.txt");
			//levelList.push(tempLevel);
			
			//tempLevel = new levelData("Repetition..", "Tutorial - Subroutines - Use subroutines to repeat a set of commands using a minimal amount of memory.", "additionalContent/maps/Mapd1.txt");
			//levelList.push(tempLevel);
			
			tempLevel = new levelData("Tricky Tricky", "Stick with it.", "additionalContent/maps/Mapo7.txt");
			levelList.push(tempLevel);	
			
			//tempLevel = new levelData("Escape!", "Use what you have learned wisely.", "additionalContent/maps/Mapd2.txt");
			//levelList.push(tempLevel);	
			
			tempLevel = new levelData("Roundabout", "This map has no catchy description", "additionalContent/maps/Mapo1.txt");
			levelList.push(tempLevel);
			
			tempLevel = new levelData("Out and About", "Wheee!", "additionalContent/maps/Mapo2.txt");
			levelList.push(tempLevel);			
			
			//tempLevel = new levelData("Three to beam up.", "Engage.", "additionalContent/maps/tileTutorialMap4.txt");
			//levelList.push(tempLevel);			

			tempLevel = new levelData("Flip the Switch!", "It's not as hard as you think.", "additionalContent/maps/Mapo3.txt");
			levelList.push(tempLevel);			
			
			//tempLevel = new levelData("Trapped on the Outside", "I want to be somewhere else.", "additionalContent/maps/Mapo5.txt");
			//levelList.push(tempLevel);
			
					
			//tempLevel = new levelData("Trapped!", "One of these switches must do something.", "additionalContent/maps/Mapo4.txt");
			//levelList.push(tempLevel);
			
			
			setMaxLevel(levelList.length);
		}

		public function loadAllLogicBlocks():void
		{
			//trace("Loading all logic blocks..");
			var tmpBlock:logicBlock;
			
			tmpBlock = new logicBlock(new logicBlockMC(), new logicBlockMC(), new logicBlockMC(), 40, 40, "Move Forward\nUse this to move forward one tile", 2, AiInstructionsEnum.MOVE_FORWARD1);
			allLogicBlocks.push(tmpBlock);
			
			tmpBlock = new logicBlock(new logicBlockMC(), new logicBlockMC(), new logicBlockMC(), 40, 40, "Move Forward (Until Unable)\nMove forward until you are unable to any more, or die.", 8, AiInstructionsEnum.MOVE_FORWARD_UNTIL_UNABLE);
			allLogicBlocks.push(tmpBlock);
			
			tmpBlock = new logicBlock(new logicBlockMC(), new logicBlockMC(), new logicBlockMC(), 40, 40, "Rotate Left\nUse this to rotate left.", 2, AiInstructionsEnum.TURN_LEFT1);
			allLogicBlocks.push(tmpBlock);
			
			tmpBlock = new logicBlock(new logicBlockMC(), new logicBlockMC(), new logicBlockMC(), 40, 40, "Rotate Right\nUse this to rotate right.", 2, AiInstructionsEnum.TURN_RIGHT1);
			allLogicBlocks.push(tmpBlock);
			
			tmpBlock = new logicBlock(new logicBlockMC(), new logicBlockMC(), new logicBlockMC(), 40, 40, "Punch\nUse this to break breakable walls.", 4, AiInstructionsEnum.PUNCH);
			allLogicBlocks.push(tmpBlock);
			
			tmpBlock = new logicBlock(new logicBlockMC(), new logicBlockMC(), new logicBlockMC(), 40, 40, "Climb\nUse this to climb up to a higher level.", 3, AiInstructionsEnum.CLIMB);
			allLogicBlocks.push(tmpBlock);
			
			tmpBlock = new logicBlock(new logicBlockMC(), new logicBlockMC(), new logicBlockMC(), 40, 40, "Crouch\nUse this to crawl through small holes.", 4, AiInstructionsEnum.CROUCH);
			allLogicBlocks.push(tmpBlock);
			
			tmpBlock = new logicBlock(new logicBlockMC(), new logicBlockMC(), new logicBlockMC(), 40, 40, "Jump\nUse this to jumpover most obstacles.", 8, AiInstructionsEnum.JUMP);
			allLogicBlocks.push(tmpBlock);
			
			tmpBlock = new logicBlock(new logicBlockMC(), new logicBlockMC(), new logicBlockMC(), 40, 40, "Activate\nUse this to activate Doors, Switches and to use  Reprogram  Tiles.", 2, AiInstructionsEnum.ACTIVATE);
			allLogicBlocks.push(tmpBlock);
			
			tmpBlock = new logicBlock(new logicBlockMC(), new logicBlockMC(), new logicBlockMC(), 40, 40, "Sub 1\nUse this to call Subroutine 1.", 2, AiInstructionsEnum.SUBR1);
			allLogicBlocks.push(tmpBlock);
			
			tmpBlock = new logicBlock(new logicBlockMC(), new logicBlockMC(), new logicBlockMC(), 40, 40, "Sub 2\nUse this to call Subroutine 2.", 2, AiInstructionsEnum.SUBR2);
			allLogicBlocks.push(tmpBlock);
			
			tmpBlock = new logicBlock(new logicBlockMC(), new logicBlockMC(), new logicBlockMC(), 40, 40, "Stop\nThis stops all  procressing.", 0, AiInstructionsEnum.STOP);
			allLogicBlocks.push(tmpBlock);
			
			placeInstructionBlock = new logicBlock(new logicBlockMC(), new logicBlockMC(), new logicBlockMC, 40, 40, "Place a new instruction here.", 0, AiInstructionsEnum.DO_NOT_PROCESS);
			
		}
		
		public function loadDidYouKnow():void
		{
			didYouKnow = new Array();
			didYouKnow.push("You can add instructions by single clicking an instruction in the logic bank.");
			didYouKnow.push("You can remove an instruction by single clicking in the instruction list.");
			didYouKnow.push("You can pan the map by moving the mouse to the edge of the screen.");
			didYouKnow.push("You can drag an instruction into the middle of a command list.");
			didYouKnow.push("Clicking on the middle of the map navigation will center on the robot.");
			didYouKnow.push("You can jump over most squares that will kill you.");
			didYouKnow.push("You can rotate the map left or right to see behind obstructions.");
			didYouKnow.push("You can view lots of useful information in the help screen.");
			didYouKnow.push("You can save memory by putting repeated commands into a subroutine.");
			didYouKnow.push("You get more points by finishing a level with fewer bytes used.");
			didYouKnow.push("Your command list loops when it is processing.");
			didYouKnow.push("You can navigate the map with the number pad on the keyboard.");
			didYouKnow.push("If you die, the next command that would processes is highlighted.");
			didYouKnow.push("You can speed up the processing speed by changing the Mhz.");
			//didYouKnow.push_back(""); // add whatever
			didYouKnow.push("You can email the designers at admin@wilshiregamedevelopment.com");
			didYouKnowIterator = 0;
		}

		public function getNumTutorialLevels():int
		{
			return numTutorialLevels;
		}
		
		public function getPlaceInstructionBlock():logicBlock
		{
			return placeInstructionBlock;
		}
		
		public function GetCurrentMapLogicBank():Array
		{
			var a:Array = GetAllLogicBlocks();//currentLogicBank;
			var b:Array = new Array();
			for (var i:int = 0; i < a.length; i++)
			{
				b.push(a[i].clone());
				b[b.length - 1].isUsable = a[i].isUsable;
			}
			return b;
		}
		
		public function getInGame():Boolean
		{
			return inGame;
		}
		
		public function setInGame(status:Boolean):void
		{
			inGame = status;
		}

		public function GetAllLogicBlocks()
		{
			return allLogicBlocks;
		}
		
		public function getDoNotProcessMouse():Boolean
		{
			return logicInteraceDoNotProcessMouse;
		}
		
		public function setDoNotProcessMouse(b:Boolean)
		{
			logicInteraceDoNotProcessMouse = b;
		}
		
		public function loadAllSoundThings()
		{
			// ui for instructions
			SSoundInterfaceAddInstruction 		= new SoundInterfaceAddInstruction();
			SSoundInterfaceRemoveInstruction 	= new SoundInterfaceRemoveInstruction();
			SSoundInterfaceExecute 				= new SoundInterfaceExecute();
			SSoundInterfaceAbort 				= new SoundInterfaceAbort();
			
			// robot processing instructions
			SSoundMoveForward 					= new SoundMoveForward();
			SSoundTurnLeft 						= new SoundTurnLeft();
			SSoundTurnRight 					= new SoundTurnRight();
			SSoundCrouch 						= new SoundCrouch();
			SSoundClimb 						= new SoundClimb();
			SSoundJump 							= new SoundJump();
			SSoundPunch 						= new SoundPunch();
			SSoundMoveForwardUntilUnable 		= new SoundMoveForwardUntilUnable();
			SSoundStop 							= new SoundStop();
			
			// tiles
			SSoundTileIce 						= new SoundTileIce();
			SSoundTileDefault 					= new SoundTileDefault();
			SSoundTileElectricOn 				= new SoundTileElectricOn();
			SSoundTileElectricOff 				= new SoundTileElectricOff();
			SSoundTileSwitchOn 					= new SoundTileSwitchOn();
			SSoundTileSwitchOff 				= new SoundTileSwitchOff();
			SSoundTileReprogramTile 			= new SoundTileReprogramTile();
			SSoundTileBreakableBreaking 		= new SoundTileBreakableBreaking();
			SSoundTileEndOff 					= new SoundTileEndOff();
			SSoundTileEndOn 					= new SoundTileEndOn();
			SSoundTileToggle 					= new SoundTileToggle();
			SSoundTileSolidHit 					= new SoundTileSolidHit();
			SSoundTileCannotMoveForward 		= new SoundTileCannotMoveForward();
			SSoundTileTeleport 					= new SoundTileTeleport();
			SSoundTileDoorOpen 					= new SoundTileDoorOpen();
			SSoundTileDoorClose 				= new SoundTileDoorClose();
					
			// events
			SSoundRobotDiedElectric 			= new SoundRobotDiedElectric();
			SSoundRobotDiedGap 					= new SoundRobotDiedGap();
			SSoundRobotDiedWater 				= new SoundRobotDiedWater();
			SSoundLevelComplete 				= new SoundLevelComplete();
			SSoundRobotDance 					= new SoundRobotDance();
			
			// menu shit
			SSoundMenuClick 					= new SoundMenuClick();
			SSoundMenuBack 						= new SoundMenuBack();
			
			// music
			MMusicDefault						= new MusicMenus();
			MMusicMenus							= new MusicMenus();
			MMusicCredits						= new MusicMenus();
		}
		
		public function MusicDefaultPlay()
		{
			if (MusicChannel != null)
			{
				MusicChannel.stop();
			}
			MusicChannel = MMusicDefault.play();
		}
		
		public function MusicMenusPlay()
		{
			if (MusicChannel != null)
			{
				MusicChannel.stop();
			}
			MusicChannel = MMusicMenus.play();
		}
		
		public function MusicCreditsPlay()
		{
			if (MusicChannel != null)
			{
				MusicChannel.stop();
			}
			MusicChannel = MMusicCredits.play();
		}
		
		public function MusicStop()
		{
			MusicChannel.stop();
		}
		
		public function encryptPlayerData()
		{
			// info we are going to encode
			
			// player name
			// player max level
			// for each level
			//  best score for level
			
			var x:int; // going to use this alot, stupid loops
			
			// the name is a max of 15 chars, we're going to store a bunch of blank space -after- the name if the name is less than 15 chars
			var paddingToAdd:int = 15 - GameVars.getInstance().getPlayerName().length;
			
			var nameToStore:String = GameVars.getInstance().getPlayerName();
			for (x = 0; x < paddingToAdd; x++)
			{
				nameToStore += " ";
			}
			
			
			// we're going to store their max level as a max of 9999, if we ever get 10,000 levels, we will have a problem
			var maxLevelToStore:String = "";
			paddingToAdd = 4 - GameVars.getInstance().getPlayerMaxLevel().toString().length;
			for (x = 0; x < paddingToAdd; x++)
			{
				maxLevelToStore += "0";
			}
			maxLevelToStore += GameVars.getInstance().getPlayerMaxLevel().toString();
			
			//trace(nameToStore);
			//trace(nameToStore.length);
			//
			//trace(maxLevelToStore);
			//trace(maxLevelToStore.length);
			
			
			
			
			
			//var magicNumber:int = 0;
			//var x:int;
			// player name
			//var tempPlayerName:String = "";
			//magicNumber = 10 - this.getPlayerName().length;
			//
			//for (x = 0; x < magicNumber; x++)
			//{
				//tempPlayerName += " ";
			//}
			//
			//tempPlayerName += this.getPlayerName();
			//
			//
			//var maxLevel:int = newMaxLevel;			
			//
			//var playerHighestLevel:int = 1;
			//
			//var playerCurrentLevel:int = 1;
			//
			//var playerLevelInfo:Array() = new Array();
			//
			//var tempPlayerLevelInfo:levelInfo;
			//tempPlayerLevelInfo = new levelInfo();
			//
			//for(var i:int = 0; i < maxLevel; i++)
			//{
				//tempPlayerInfo = new levelInfo();
				//tempPlayerLevelInfo.level = i;
				//tempPlayerLevelInfo.levelHighScore = -1;
				//playerLevelInfo.push(tempPlayerLevelInfo);
			//}
		}
		
		public function getDoneDancing():Boolean
		{
			// returns the doneDancing true or false
			return doneDancing;
		}
		
		public function setDoneDancing(done:Boolean)
		{
			// set the doneDancing variable to whatever is received
			doneDancing = done;
		}
		
		public function setStartedDancing(started:Boolean)
		{
			startedDancing = started;
		}
		
		public function getStartedDancing():Boolean
		{
			return startedDancing;
		}
		
		public function decryptPlayerData(newData:String)
		{
			
		}
		
		///////////////////////// end of function, no code below here
	}
}