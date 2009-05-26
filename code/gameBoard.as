package code 
{
	import code.structs.Switch;
	import code.structs.Teleport;
	import flash.display.MovieClip;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import code.GameState;
	import code.GameStateManager;
	import code.enums.GameStateEnum;
	import code.enums.AiInstructionsEnum;
	import code.enums.instructionTab;
	import flash.events.TimerEvent;
	import flash.net.FileFilter;
	import flash.text.TextFormat;
	import flash.events.MouseEvent;

	
	// file io stuff
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.events.Event;
	
	// additional state specific stuff
	import flash.text.TextField;
	import flash.text.TextFormat;
	import code.Key;
	import code.enums.GameBoardStateEnum;
	import code.GameVars;
	import code.mapTile;
	import code.enums.tileEnums;
	import flash.utils.Timer;
	import code.enums.logicBlockEnum;
	
	import code.GameVars;
	import code.structs.object;	
	import flash.ui.Keyboard;
	import code.structs.subroutine;
	
	public class gameBoard extends MovieClip
	{		
		var mapList:Array = new Array();
		var mapListImages:Array = new Array();
		var myGameVar:GameVars = GameVars.getInstance();
		
		// elimination of tile images array, we may infact need it who knows
		
		var switchList:Array = new Array();
		var teleportList:Array = new Array();
		var dSwitchList:Array = new Array();
		var myRobotImage:MovieClip = new robotClip();
		
		var myRobot:Object;
		//var OM:objectManager;
		var logicBank = new Array();
		var SUB1:subroutine;
		var SUB2:subroutine;
		
		var processSubRecurCounter:int;
		
		var robotX:int;
		var robotY:int;
		var robotStartX:int;
		var robotStartY:int;
		var robotReprogramX:int;
		var robotReprogramY:int;
		var mapRotation:int;
		
		var switchInProgress:Boolean;
		var switchToggled:Boolean;	
		
		var DswitchInProgress:Boolean;
		var DswitchToggled:Boolean;	
		
		var didWeJustTeleport:Boolean;
		var robotAlive:Boolean;
		
		var Width:int;
		var Height:int;
		
		var mouseTimer:int; // may not be needed
		var moustimerStart:int; // may not be needed
		
		var scale:Number; // as3 form of a double whee
		var maxScale:Number;
		var minScale:Number;
		var mapOffsetX:int;
		var mapOffsetY:int;
		var centerX:Number;
		var centerY:Number;
		var currentX:Number;
		var currentY:Number;
		
		var overallHeight:Number;
		var overallWidth:Number;		
		
		var imageWidth:Number;
		var imageHeight:Number;
		
		var imageBaseWidth:int;
		var imageBaseHeight:int;
		var hw:Number;
		var hh:Number;
		var screenWidth:int;
		var screenHeight:int;
		var screenEdgeHeight:int;
		var screenEdgeWidth:int;
		var screenEdge:Number;
		var moveSpeed:Number;
		var interfaceHeight:Number;
		
		//var myTimer:Timer = new Timer(500)
		//myTimer.addEventListener(”timer”, timedFunction);
		var timer:Timer;
		var startTime:int;
		
		var executionCycleInterval:int = 500;
		var executionCycleTimer:Timer = new Timer(executionCycleInterval, 1);
		var teleportTimer:Timer = new Timer(executionCycleInterval, 1);
		var teleportInProgress:Boolean = false;
		
		
		var drawText:Boolean;
		var delayAdvance:Boolean;
		var reprogramHit:Boolean;
		
		var curState:GameBoardStateEnum;
		var processSpeed:int;
		var myMap:MovieClip;
		//var massInstruct:MovieClip;
		var doneLoadingMapFromFile:Boolean;
		
		var diedElectricity = new robotDiedElectricity();
		var diedGap = new robotDiedGap();
		var diedWater = new robotDiedWater();
		
		public function gameBoard() 
		{
			// temp shit for testing, remove this later
			//massInstruct = new massInstruction();
			//massInstruct.x = 50;
			//massInstruct.y = 100;
			
			//this.addChild(massInstruct);
			
			//massInstruct.dMoveForward.addEventListener(MouseEvent.MOUSE_UP, 		addMoveForward);
			//massInstruct.dMoveForwardUntil.addEventListener(MouseEvent.MOUSE_UP, 	addMoveForwardUntil);
			//massInstruct.dTurnLeft.addEventListener(MouseEvent.MOUSE_UP, 			addTurnLeft);
			//massInstruct.dTurnRight.addEventListener(MouseEvent.MOUSE_UP, 			addTurnRight);
			//massInstruct.dActivate.addEventListener(MouseEvent.MOUSE_UP, 			addActivate);
			//massInstruct.dPunch.addEventListener(MouseEvent.MOUSE_UP, 				addPunch);
			//massInstruct.dClimb.addEventListener(MouseEvent.MOUSE_UP, 				addClimb);
			//massInstruct.dCrouch.addEventListener(MouseEvent.MOUSE_UP, 				addCrouch);
			//massInstruct.dJump.addEventListener(MouseEvent.MOUSE_UP, 				addJump);
			//massInstruct.dStop.addEventListener(MouseEvent.MOUSE_UP, 				addStop);
			//massInstruct.dExecute.addEventListener(MouseEvent.MOUSE_UP, 			execute);
			
			
			// end temp shit
			
			//GameVars.getInstance();
			curState = GameBoardStateEnum.GB_PREGAME;
			myMap = new mapClip();
			this.addChild(myMap);
			
			doneLoadingMapFromFile = false;
			
			
			// MUST CALL INIT DAMMIT!
			initialize();
			
				// RE: 
				// Call it, friendo.
		}
		
		public function initEventListeners()
		{
			stage.addEventListener("gameBoardExecute", interfaceHasFiredExecuteOrder);
			stage.addEventListener("gameBoardAbort", interfaceHasFiredAbortOrder);
			stage.addEventListener("gameBoardReset", interfaceHasFiredResetOrder);
		}
		
		// these are all debug commands and aren't actually used in game...
		public function addMoveForward(e:MouseEvent)
		{
			myRobot.addCommand(AiInstructionsEnum.MOVE_FORWARD1);
		}
		
		public function addMoveForwardUntil(e:MouseEvent)
		{
			myRobot.addCommand(AiInstructionsEnum.MOVE_FORWARD_UNTIL_UNABLE);
		}
		
		public function addTurnLeft(e:MouseEvent)
		{
			myRobot.addCommand(AiInstructionsEnum.TURN_LEFT1);
		}
		
		public function addTurnRight(e:MouseEvent)
		{
			myRobot.addCommand(AiInstructionsEnum.TURN_RIGHT1);
		}
		
		public function addActivate(e:MouseEvent)
		{
			myRobot.addCommand(AiInstructionsEnum.ACTIVATE);
		}
		
		public function addPunch(e:MouseEvent)
		{
			myRobot.addCommand(AiInstructionsEnum.PUNCH);
		}
		
		public function addClimb(e:MouseEvent)
		{
			myRobot.addCommand(AiInstructionsEnum.CLIMB);
		}
		
		public function addCrouch(e:MouseEvent)
		{
			myRobot.addCommand(AiInstructionsEnum.CROUCH);
		}
		
		public function addJump(e:MouseEvent)
		{
			myRobot.addCommand(AiInstructionsEnum.JUMP);
		}
		
		public function addStop(e:MouseEvent)
		{
			myRobot.addCommand(AiInstructionsEnum.STOP);
		}
		
		public function execute(e:MouseEvent)
		{
			if ((!switchInProgress) && (!DswitchInProgress))
			{
				processRobot();
				setRobotImage(myRobot.getDirection());
				reInjectRobotImage();
			}
			else 
			{
				if (switchInProgress)
				{
					processSwitch();
				}
				if (DswitchInProgress)
				{
					processDSwitch();
				}
			}
			populateMapImages();
			//processRobot();
		}
		// end debug stuff
		
		public function DgameBoard()
		{
			for (var x:int = 0; x < Width; x++)
			{
				for (var y:int = 0; y < Height; y++)
				{
					//mapList[x][y] . deleteMeDammit
				}
			}
			cleanup();
		}
		
		public function update()
		{
				
			processKeyboard();
			
			mapScroll();
			
			recalcPositions();
			
			myMap.x = mapOffsetX;
			myMap.y = mapOffsetY;
			//trace ("mapOffsetX = ", mapOffsetX, " | mapOffsetY = ", mapOffsetY);
						
			draw(); // this should be where everythign is sized/lined up automagically?
			
		}
		
		public function draw()
		{
			var imageWidth:int = 72;
			var imageHeight:int = 72;
			imageWidth *= scale;
			imageHeight *= scale;
			var hw:int = (imageWidth / 2);
			var hh:int = (imageHeight / 2);
			
			// are the numbers even making sense?
			//trace ("imageWidth = ", imageWidth, "  imageHeight = ", imageHeight);
			//trace ("hh = ", hh, "   hw = ", hw);
			
			var basex:int = 0;
			var basey:int = 0;
			var drawAtX:int = 0;
			var drawAtY:int = 0;
			for (var x:int = 0; x < Width; x++)
			{
				basex = x * hw;
				basey = y * hh;
				
				for (var y:int = 0; y < Height; y++)
				{
					//drawAtX = (int)(mapOffsetX + (x * hw - (y * hw) + hw));
					//drawAtY = (int)(mapOffsetY + (y * hh) + (x * hh)) - hh / 2 * x - hh / 2 * y + x + y;
					drawAtX = (int)((x * hw - (y * hw) + hw));
					drawAtY = (int)((y * hh) + (x * hh)) - hh/2*x - hh/2*y + x*scale + y*scale;
					
					//trace ("drawAtx = ", drawAtX, "  drawAty = ", drawAtY);
					
					/// abcxyz
					// this needs to be uncommented
					//mapList[x][y].setTileImage();
					
					//mapList[x][y].setDrawXY(drawAtX, drawAtY);
					//mapList[x][y].update(drawAtX, drawAtY, scale);
					
					mapListImages[x][y].x = drawAtX;
					mapListImages[x][y].y = drawAtY;
					
					mapListImages[x][y].width = imageWidth;
					mapListImages[x][y].height = imageHeight;
					
					
					if ((x == robotX) && (y == robotY))
					{
						//drawAtY += hh / 2;
						
						if (mapList[robotX][robotY].getType().toInt() == tileEnums.TRaised1.toInt())
						{
							drawAtY -= (hh * 0.45);
						}
						else  if (mapList[robotX][robotY].getType().toInt() == tileEnums.TRaised2.toInt())
						{
							drawAtY -= (hh * 0.9);
						}
						else  if (mapList[robotX][robotY].getType().toInt() == tileEnums.TRaised3.toInt())
						{
							drawAtY -= (hh * 1.35);
						}
						else  if (mapList[robotX][robotY].getType().toInt() == tileEnums.TRaised4.toInt())
						{
							drawAtY -= (hh * 1.8);
						}
//						drawObject(0, drawAtX, drawAtY, scale);
						myRobotImage.x = drawAtX;
						myRobotImage.y = drawAtY;
						myRobotImage.width = imageWidth;
						myRobotImage.height = imageHeight;
					}
				}
				
			}
		}
			
		public function setTileType(x:int, y:int, ntileType:tileEnums)
		{
			mapList[x][y].setType(ntileType);
		}
		
		public function getTileType(x:int, y:int):tileEnums
		{
			return mapList[x][y].getType();
		}
		
		public function drawTile(nType:tileEnums, txPos:int, tyPost:int, scale:Number, isActive:Boolean)
		{
			// dave stopped here
		}
		
		public function initialize():void
		{
			mapOffsetX = 0;
			mapOffsetY = 0;
			scale = 1;
			imageBaseWidth = 144;
			imageBaseHeight = 72;
			
			imageWidth = imageBaseWidth * scale;
			imageHeight = imageBaseHeight * scale;
			
			hw = (int)(imageWidth/2);	// half width
			hh = (int)(imageHeight/2);	// half height
			
			screenWidth = 1024;
			screenHeight = 768;
			screenEdgeWidth = 1024;
			screenEdgeHeight = 768;

			screenEdge = 0.03;
			moveSpeed = scale * 0.1;
			maxScale = 3.45;
			minScale = 0.6;		
			
			overallWidth = (Height + Width) * hw;
			overallHeight = (Height + Width) * hh;

			centerX = (int)((Width+1)/2);
			centerY = (int)((Height+1)/2);
			currentX = centerX;
			currentY = centerY;

			// time to setup offsets based on centers
			//logicBank = GameVars.Instance().getAllLogicBlocks();
			//logicBank = GameVars.getInstance().getAllLogicBlocks();
			
			robotAlive = true;
			drawText = false;

			SUB1 = new subroutine();
			SUB2 = new subroutine();
			
			interfaceHeight = 190;
			screenHeight -= interfaceHeight;
			screenHeight -= (int)(hh);
			mapRotation = 0;

			//mouseTimer = 0;
			//mouseTimerStart = 0;

			switchInProgress = false;
			switchToggled = false;
			
			DswitchInProgress = false;
			DswitchToggled = false;

			processSpeed = 500;

			reprogramHit = false;
		}
		
		public function cleanup()
		{
			//delete SUB1;
			//delete SUB2;
		}
		
		public function setOffsets(x:int, y:int)
		{
			mapOffsetX = x;
			mapOffsetY = y;
		}
		
		public function loadMapFromFile(filename:String)
		{
			var loadedFile:TextField = new TextField();
			var tempString:String = new String();
			
			doneLoadingMapFromFile = false;
			
						
			// TODO: add error handling here
			var textLoader:URLLoader = new URLLoader();
			var textReq:URLRequest = new URLRequest(filename);
			textLoader.load(textReq);
			textLoader.addEventListener(Event.COMPLETE, textLoadComplete);
			
			var x:int;
			var y:int;
						
			function textLoadComplete(event:Event):void
			{
				//trace ("Starting to read in file ", filename);
				var fileIndex:int = 0;
				// this could maybe use some error checking incase the text file doesn't exist
				loadedFile.text = textLoader.data;
				tempString = textLoader.data;				
				
				// first read in width and height
				var ones:int;
				var tens:int;
				
				var nWidth:int;
				var nHeight:int;
				var startDirection:int;
				var bytesAvail:int;
								
				tens = (tempString.charCodeAt(fileIndex++) - 48) * 10; 	ones = tempString.charCodeAt(fileIndex++) - 48;
				nWidth = tens + ones;
				fileIndex++;
				// error checking!
				if (nWidth < 1)
				{
					trace ("ERROR: nWidth <1, nWidth = ", nWidth);
					return;
				}
				
				tens = (tempString.charCodeAt(fileIndex++) - 48) * 10; 	ones = tempString.charCodeAt(fileIndex++) - 48;
				nHeight = tens + ones;
				fileIndex++;
				
				// error checking!
				if (nHeight < 1)
				{
					trace ("ERROR: nHeight <1, nHeight = ", nHeight);
					return;
				}
				
				tens = (tempString.charCodeAt(fileIndex++) - 48) * 10; 	ones = tempString.charCodeAt(fileIndex++) - 48;
				startDirection = tens + ones;
				fileIndex++;
				
				// error checking!
				if ((startDirection < 0) || (startDirection > 4))
				{
					trace ("ERROR: Invalid startDirection of ", startDirection);
					return;
				}
				
				tens = (tempString.charCodeAt(fileIndex++) - 48) * 10; 	ones = tempString.charCodeAt(fileIndex++) - 48;
				bytesAvail = tens + ones;
				bytesAvail *= 100;
				
				tens = (tempString.charCodeAt(fileIndex++) - 48) * 10; 	ones = tempString.charCodeAt(fileIndex++) - 48;
				bytesAvail += tens + ones;
				fileIndex++;
				fileIndex++;

				if (bytesAvail < 0)
				{
					trace ("ERROR: bytesAvail < 0, bytesAvail = ", bytesAvail);
					return;
				}
				
				//trace ("nWidth = ", nWidth, "  nHeight = ", nHeight, "   startDirection =", startDirection, "   bytesAvail = ", bytesAvail);
				
				
				setRobotImage(startDirection);
								
				var moveForwardAvail:Boolean;
				if (tempString.charCodeAt(fileIndex++)-48 == 1)	{	moveForwardAvail = true;	}	else	{	moveForwardAvail = false;	} fileIndex++;
				
				var moveForwardUntilAvail:Boolean;
				if (tempString.charCodeAt(fileIndex++)-48 == 1)	{	moveForwardUntilAvail = true;	}	else	{	moveForwardUntilAvail = false;	} fileIndex++;
								
				var turnLeftAvail:Boolean;
				if (tempString.charCodeAt(fileIndex++)-48 == 1)	{	turnLeftAvail = true;	}	else	{	turnLeftAvail = false;	} fileIndex++;
				
				var turnRightAvail:Boolean;
				if (tempString.charCodeAt(fileIndex++)-48 == 1)	{	turnRightAvail = true;	}	else	{	turnRightAvail = false;	} fileIndex++;
				
				var punchAvail:Boolean;
				if (tempString.charCodeAt(fileIndex++)-48 == 1)	{	punchAvail = true;	}	else	{	punchAvail = false;	} fileIndex++;
				
				var climbAvail:Boolean;
				if (tempString.charCodeAt(fileIndex++)-48 == 1)	{	climbAvail = true;	}	else	{	climbAvail = false;	} fileIndex++;
				
				var crouchAvail:Boolean;
				if (tempString.charCodeAt(fileIndex++)-48 == 1)	{	crouchAvail = true;	}	else	{	crouchAvail = false;	} fileIndex++;
				
				var jumpAvail:Boolean;
				if (tempString.charCodeAt(fileIndex++)-48 == 1)	{	jumpAvail = true;	}	else	{	jumpAvail = false;	} fileIndex++;
				
				var activateAvail:Boolean;
				if (tempString.charCodeAt(fileIndex++)-48 == 1)	{	activateAvail = true;	}	else	{	activateAvail = false;	} fileIndex++;
				
				var sub1Avail:Boolean;
				if (tempString.charCodeAt(fileIndex++)-48 == 1)	{	sub1Avail = true;	}	else	{	sub1Avail = false;	} fileIndex++;
				
				var sub2Avail:Boolean;
				if (tempString.charCodeAt(fileIndex++) - 48 == 1)	{	sub2Avail = true;	}	else	{	sub2Avail = false;	} fileIndex++;
				
				//trace ("moveForward, moveForwardUntil, turnLeft, turnRight, punch, climb, crouch, jump, activate, sub1, sub2 = ", moveForwardAvail, moveForwardUntilAvail, turnLeftAvail, turnRightAvail, punchAvail, climbAvail, crouchAvail, jumpAvail, activateAvail, sub1Avail, sub2Avail);
								
				myGameVar.setCurrentLogicBank(moveForwardAvail, moveForwardUntilAvail, turnLeftAvail, turnRightAvail, punchAvail, climbAvail, crouchAvail, jumpAvail, activateAvail, sub1Avail, sub2Avail);
				myGameVar.setCurrentLevelBytes(bytesAvail);
				//

				
				//trace ("maplist = new array()");
				mapList = new Array();
				
				
				var currentCol:Array;
				
				// populate the array with a bunch of empty arrays.. argh!
				for (x = 0; x < nWidth; x++)
				{
					currentCol = new Array();
					mapList.push(currentCol);
				}
				
				var tempTile:mapTile;
				var total:int;

				fileIndex++;
				for (y = 0; y < nHeight; y++)
				{
					currentCol = new Array();
					for (x = 0; x < nWidth; x++)
					{
						// read in a value
						tens = (tempString.charCodeAt(fileIndex++) - 48) * 10; 	ones = tempString.charCodeAt(fileIndex++) - 48; fileIndex++;
						var val:int = tens + ones;
						if ((val == tileEnums.THalfBottomL.toInt()) || (val == tileEnums.THalfBottomR.toInt()))
						{
							val = tileEnums.TGap.toInt();
							trace(filename, " is referencing a THalfBottomL or THalfBottomR, I have converted it to a TGap");
						}
						
						if (val < 0)
						{
							trace ("Read in invalid tileType of ", val, ". aborting now before bad things happen");
							return;
						}
						// push it on to current col
						//trace ("At map position ", x, ", ", y, " I just read in a value of ", val);
						mapList[x].push(new mapTile(new tileEnums(val), true));	
						
						// if its a start spot, add the robot to the object list
						if(val == tileEnums.TStart.toInt())
						{
							//trace ("Oh and the start spot is here so I set up the robot");
							myRobot = new object(x, y, startDirection);
							robotX = x;
							robotY = y;
							robotStartX = x;
							robotStartY = y;
							currentX = robotX;
							currentY = robotY;
						}
					}
					fileIndex++;
					// now that the whole column has been read, push it onto maplist
					//trace ("CurrentCol = ", currentCol);
					//trace ("Done with row");
				}
				
				Width = nWidth;
				Height = nHeight;
				myGameVar.setLevelHeight(Height);
				myGameVar.setLevelWidth(Width);
				populateMapImages();
				
				/////////////////////////////////////////////////////////////////
				// now lets see if there's any switches in the game map
				// either way lets clear the switchlist manager first
				
				var switchCount:int;
				var teleportCount:int;
				tens = (tempString.charCodeAt(fileIndex++) - 48) * 10; 	ones = tempString.charCodeAt(fileIndex++) - 48; fileIndex++;
				switchCount = tens + ones;
				tens = (tempString.charCodeAt(fileIndex++) - 48) * 10; 	ones = tempString.charCodeAt(fileIndex++) - 48; fileIndex++;
				teleportCount = tens + ones;
				fileIndex++;
				
				//trace ("Switches = ", switchCount, "   Teleporters = ", teleportCount);
								
				myGameVar.SM.clearSwitchList();
				
				var numcnt:int;
				var myX:int;
				var myY:int;
				var tempX:int;
				var tempY:int;
				
				var tempObj:Switch;
				var tempObjT:Teleport;

				// read in the switches
				var x:int;
							
				for (x = 0; x < switchCount; x++)
				{
					
					// switch data layout
					// # of tiles controlled
					tens = (tempString.charCodeAt(fileIndex++) - 48) * 10; 	ones = tempString.charCodeAt(fileIndex++) - 48; fileIndex++;
					numcnt = tens + ones;
					fileIndex++;

					// x y of this switch
					tens = (tempString.charCodeAt(fileIndex++) - 48) * 10; 	ones = tempString.charCodeAt(fileIndex++) - 48; fileIndex++;
					myX = tens + ones;
					tens = (tempString.charCodeAt(fileIndex++) - 48) * 10; 	ones = tempString.charCodeAt(fileIndex++) - 48; fileIndex++;
					myY = tens + ones;
					fileIndex++;

					/////////////////////////////////////
					// add a switch to the switch manager
					myGameVar.SM.addSwitch(myX, myY, numcnt);
					//trace("added a switch at ", myX, myY, " with ", numcnt, " targets");
					
					for(var sx:int = 0; sx < numcnt; sx++)
					{
						///////////////////////////////
						// x y of first tile controlled
						tens = (tempString.charCodeAt(fileIndex++) - 48) * 10; 	ones = tempString.charCodeAt(fileIndex++) - 48; fileIndex++;
						tempX = tens + ones;
						tens = (tempString.charCodeAt(fileIndex++) - 48) * 10; 	ones = tempString.charCodeAt(fileIndex++) - 48; fileIndex++;
						tempY = tens + ones;
						fileIndex++;
						//trace ("Added target at ", tempX, ", ", tempY);

						///////////////////////////////////////////////////////////
						// add this target to the last switch in the switch manager
						myGameVar.SM.addTargetToLastSwitch(tempX, tempY);
					}
				}

				// read in the teleporters
				for(x = 0; x < teleportCount; x++)
				{
					// read in source
					tens = (tempString.charCodeAt(fileIndex++) - 48) * 10; 	ones = tempString.charCodeAt(fileIndex++) - 48; fileIndex++;
					myX = tens + ones;
					tens = (tempString.charCodeAt(fileIndex++) - 48) * 10; 	ones = tempString.charCodeAt(fileIndex++) - 48; fileIndex++;
					myY = tens + ones;
					fileIndex++;
					
					// read in destination
					tens = (tempString.charCodeAt(fileIndex++) - 48) * 10; 	ones = tempString.charCodeAt(fileIndex++) - 48; fileIndex++;
					tempX = tens + ones;
					tens = (tempString.charCodeAt(fileIndex++) - 48) * 10; 	ones = tempString.charCodeAt(fileIndex++) - 48; fileIndex++;
					tempY = tens + ones;
					fileIndex++;
					
					tempObjT = new Teleport(myX, myY, 0);
					//trace("added a teleport at position ", myX, ", ", myY);
					tempObjT.setTarget(tempX, tempY);
					//trace("teleport targets are ", tempX, ", ", tempY);
					teleportList.push(tempObjT);
				}
				
				// read in tiles that start as inactive
				
				// first lets find out how many tiles we have
				tens = (tempString.charCodeAt(fileIndex++) - 48) * 10; 	ones = tempString.charCodeAt(fileIndex++) - 48; fileIndex++;
				fileIndex++;
				var numInactives:int = tens + ones;
				//trace ("we're about to read in ", numInactives, " inactive tiles");
				
				// now read in the inactive tiles
				for (x = 0; x < numInactives; x++)
				{
					tens = (tempString.charCodeAt(fileIndex++) - 48) * 10; 	ones = tempString.charCodeAt(fileIndex++) - 48; fileIndex++;
					tempX = tens + ones;
					tens = (tempString.charCodeAt(fileIndex++) - 48) * 10; 	ones = tempString.charCodeAt(fileIndex++) - 48; fileIndex++;
					tempY = tens + ones;
					fileIndex++;
					//trace("setting tile at location ", tempX, ", ", tempY, " to inactive");
					mapList[tempX][tempY].setActive(false);	
					mapList[tempX][tempY].setResetActive(false);
				}
				populateMapImages();
				
				myGameVar.SMD.clearSwitchList();
				
				// read in dswitches
				tens = (tempString.charCodeAt(fileIndex++) - 48) * 10; 	ones = tempString.charCodeAt(fileIndex++) - 48; fileIndex++;
				fileIndex++;
				var numDSwitches = tens + ones;
				//trace ("we're about to read in ", numDSwitches, " DSwitches");
				
				// read in the dswitches
							
				for (x = 0; x < numDSwitches; x++)
				{
					
					// switch data layout
					// # of tiles controlled
					tens = (tempString.charCodeAt(fileIndex++) - 48) * 10; 	ones = tempString.charCodeAt(fileIndex++) - 48; fileIndex++;
					numcnt = tens + ones;
					fileIndex++;

					// x y of this switch
					tens = (tempString.charCodeAt(fileIndex++) - 48) * 10; 	ones = tempString.charCodeAt(fileIndex++) - 48; fileIndex++;
					myX = tens + ones;
					tens = (tempString.charCodeAt(fileIndex++) - 48) * 10; 	ones = tempString.charCodeAt(fileIndex++) - 48; fileIndex++;
					myY = tens + ones;
					fileIndex++;

					/////////////////////////////////////
					// add a switch to the switch manager
					myGameVar.SMD.addSwitch(myX, myY, numcnt);
					//trace("added a Dswitch at ", myX, myY, " with ", numcnt, " targets");
					
					var targetType:tileEnums;
					
					for(sx = 0; sx < numcnt; sx++)
					{
						///////////////////////////////
						// x y of first tile controlled
						tens = (tempString.charCodeAt(fileIndex++) - 48) * 10; 	ones = tempString.charCodeAt(fileIndex++) - 48; fileIndex++;
						tempX = tens + ones;
						tens = (tempString.charCodeAt(fileIndex++) - 48) * 10; 	ones = tempString.charCodeAt(fileIndex++) - 48; fileIndex++;
						tempY = tens + ones;
						// and now target type of the tile controlled
						tens = (tempString.charCodeAt(fileIndex++) - 48) * 10; 	ones = tempString.charCodeAt(fileIndex++) - 48; fileIndex++;
						var targetNum = tens + ones;
						if ((targetNum > 40) || (targetNum < 0))
						{
							trace ("we read in an invalid dSwitch target type of ", targetNum, " this has been overriden with a empty tile");
							targetNum = 0;
						}
						targetType = new tileEnums(targetNum);
						
						fileIndex++;

						///////////////////////////////////////////////////////////
						// add this target to the last switch in the switch manager
						//trace ("Adding Dtarget at ", tempX, ", ", tempY, " of type ", targetType.toInt());
						myGameVar.SMD.addTargetToLastSwitchD(tempX, tempY, targetType);
					}
				}
				
				
				doneLoadingMapFromFile = true;
			}

			//centerX = (int)((Width+1)/2);
			//centerY = (int)((Height+1)/2);
			//currentX = centerX;
			//currentY = centerY;

			imageBaseWidth = 144;
			imageBaseHeight = 72;

			hw = (imageWidth/2);	// half width
			hh = (imageHeight/2);	// half height
			overallWidth = (Height + Width) * hw;
			overallHeight = (Height + Width) * hh;

			currentX = robotX;
			currentY = robotY;
			
			recalcPositions();
			
			return true;
		}
		
		public function setScale(newScale:Number)
		{
			scale = newScale;
		}
		
		public function getScale():Number
		{
			return scale;
		}
		
		public function mapScroll()
		{
			var mMoveSpeed:Number = moveSpeed / 2;
			// mouse stuff
			//recalcPositions();
//
			//mouseTimer = clock();
			//int mouseDelay = 50;
//
			// see if mouse is at top of screen
			//if((mouseY >= 0) && (mouseY < screenEdgeHeight*screenEdge))
			//{
				//if(mouseTimer > mouseTimerStart + mouseDelay)
				//{
					//mouseTimerStart = clock();
					//mapOffsetY+= moveSpeed;
					//panup();
				//}
			//}
//
			// see if mouse is at bottom of screen
			//if((mouseY < screenEdgeHeight) && (mouseY > (screenEdgeHeight - (screenEdgeHeight*screenEdge))))
			//{
				//if(mouseTimer > mouseTimerStart + mouseDelay)
				//{
					//mouseTimerStart = clock();
					//pandown();
				//}
			//}
			// see if mouse is at left side of screen
			//if((mouseX >= 0) && (mouseX < screenEdgeWidth * screenEdge))
			//{
				//if(mouseTimer > mouseTimerStart + mouseDelay)
				//{
					//mouseTimerStart = clock();
					//panleft();
				//}
			//}
			// see if mouse is at right side of screen
			//if((mouseX < screenEdgeWidth) && (mouseX > (screenEdgeWidth - (screenEdgeWidth * screenEdge))))
			//{
				//if(mouseTimer > mouseTimerStart + mouseDelay)
				//{
					//mouseTimerStart = clock();
					//panright();
				//}
			//}
			//verifyCameraCenter();
			//
		}	
		
		public function processKeyboard()
		{
			// check for keyboard input
			if((Key.isDown(81)) || (Key.isDown(103)))	// numpad 7 - q
			{
				//panupleft();
				//trace("panupleft()");
			//}
			//else if ((Key.isDown(69)) || (Key.isDown(105))) // numpad 9 - e
			//{
				//panupright();
				//trace("panupright()");
			//}
			//else if ((Key.isDown(90)) || (Key.isDown(97))) // numpad 1 - z
			//{
				//pandownleft();
				//trace("pandownleft()");
			//}
			//else if ((Key.isDown(67)) || (Key.isDown(99)))	// numpad 3 - c
			//{
				//pandownright();
				//trace("pandownright()");
			//}
			//else if ((Key.isDown(87)) || (Key.isDown(104))) // numpad 8 - w
			//{
				//panup();
				//trace("panup()");
			//}
			//else if ((Key.isDown(65)) || (Key.isDown(100)))	// numpad 4 - a
			//{
				//panleft();
				//trace("panleft()");
			//}
			//else if ((Key.isDown(68)) || (Key.isDown(102)))	// numpad 6 - d
			//{
				//panright();
				//trace("panright()");
			//}
			//else if ((Key.isDown(83)) || (Key.isDown(98)))	// numpad 2 - x
			//{
				//pandown();
				//trace("pandown()");
			//}
			//else if (Key.isDown(101) || Key.isDown(83))	// numpad 5 - s
			//{
				//center();
				//trace("center()");
			//}
			//else if (Key.isDown(109)) // -
			//{
				//zoomout();
				//trace("zoomout()");
			//}
			//else if (Key.isDown(107)) // +
			//{
				//zoomin();
				//trace("zoomin()");
			//}
			}
			else if (Key.isDown(106) || Key.isDown(49)) // * - 1 (not numpad)
			{
				rotateMapRight();
			}
			else if (Key.isDown(111) || Key.isDown(50))	// "/" - 2
			{
				rotateMapLeft();
			}
			else if (Key.isDown(57)) // 9
			{
				toggleAllMapTiles();
				trace("toggleallmaptiles()");
			}
			
			// debug commands for direct and potentially bad breaking access to the robot's memory directly
			else if (Key.isDown(54))	// move the robot x+1	6
			{
				robotX++;
				//trace("robotX++");
				reInjectRobotImage();
				trace("Robot X/Y = ", robotX, robotY);
			}
			else if (Key.isDown(53))	// move the robot x-1	5
			{
				robotX--;
				//trace("robotX--");
				reInjectRobotImage();
				trace("Robot X/Y = ", robotX, robotY);				
			}
			else if (Key.isDown(56))  // move the robot y+1		8
			{
				robotY++;
				//trace("robotY++");
				reInjectRobotImage();
				trace("Robot X/Y = ", robotX, robotY);
			}
			else if (Key.isDown(55))  // move the robot y-1		7
			{
				robotY--;
				//trace("robotY--");
				reInjectRobotImage();
				trace("Robot X/Y = ", robotX, robotY);
			}
						
			
			if (scale > maxScale)
			{
				scale = maxScale;
			}
			if (scale < minScale)
			{
				scale = minScale;
			}
			
			keepRobotOnTheBoard();
			verifyCameraCenter();
			teleporterCheck();
		}
		
		public function resetMap()
		{
			if (mapRotation > 0)
			{
				while (mapRotation > 0)
				{
					rotateMapLeft();
				}
			}
			if (mapRotation < 0)
			{
				while (mapRotation < 0)
				{
					rotateMapRight();
				}
			}
			
			myGameVar.SM.resetAllSwitches();
			switchInProgress = false;
			switchToggled = false;
			
			myGameVar.SMD.resetAllSwitches();
			DswitchInProgress = false;
			DswitchToggled = false;
			
			robotX = robotStartX;
			robotY = robotStartY;
			myRobot.setXPos(robotX);
			myRobot.setYPos(robotY);
			for (var x:int = 0; x < Width; x++)
			{
				for (var y:int = 0; y < Height; y++)
				{
					mapList[x][y].resetActive();
					mapList[x][y].resetTileType();
				}
			}
		}
		
		public function drawObject(txPos:int, tyPos:int, scale:Number)
		{
			txPos += (hh * 0.7) + 5 * scale;
			tyPos += (hh * 0.2) + 5 * scale;
			
			myRobotImage.width = imageBaseWidth * scale;
			myRobotImage.height = imageBaseHeight * scale;
			
		}
		
		public function setRobotImage(newDir:int)
		{
			// first lets nuke the image that's there
			//myRobotImage = new robotClip();
			if (myRobotImage.numChildren > 0)
			{
				myRobotImage.removeChildAt(0);
			}
			switch(newDir)
			{
				case 0:
					myRobotImage.addChild(new robot_idle_ne());
					break;
				case 1:
					myRobotImage.addChild(new robot_idle_se());
					break;
				case 2:
					myRobotImage.addChild(new robot_idle_sw());
					break;
				case 3:
					myRobotImage.addChild(new robot_idle_nw());
					break;
			}
		}
		
		public function processRobot()
		{
			//trace("entering process robot");
			delayAdvance = false;

			//===================================
			//  Command Highlighting
			switch(myRobot.getNextCommand().toInt())
			{
			case AiInstructionsEnum.SUBR1.toInt():
				{					
					myGameVar.setCurrentInstructionTab(instructionTab.TAB_SUB1);
					myGameVar.setCurrentInstructionBlockIndex(SUB1.getCurrentInstructionIndex());
					myGameVar.setIsSub1OnFirstCommand(SUB1.isOnFirstCommand());
					myGameVar.setIsMainOnFirstCommand(myRobot.isOnFirstCommand());
					break;
				}
			case AiInstructionsEnum.SUBR2.toInt(): // CJV 42
				{
					myGameVar.setCurrentInstructionTab(instructionTab.TAB_SUB2);
					myGameVar.setCurrentInstructionBlockIndex(SUB2.getCurrentInstructionIndex());
					myGameVar.setIsSub2OnFirstCommand(SUB2.isOnFirstCommand());
					myGameVar.setIsMainOnFirstCommand(myRobot.isOnFirstCommand());
					break;
				}
			default:
				{
					myGameVar.setCurrentInstructionTab(instructionTab.TAB_MAIN);
					myGameVar.setCurrentInstructionBlockIndex(myRobot.getCurrentInstructionIndex());
					break;
				}
			}
			stage.dispatchEvent(new Event("commandAdvanced"));

			if (myRobot.getAlive() == false)
			{
				// tempabc
				curState = GameBoardStateEnum.GB_ROBOTDIED;
				return;
			}
					
			switch(myRobot.getNextCommand().toInt())//myRobot.getNextCommand())
			{
			case AiInstructionsEnum.SUBR1.toInt():
				delayAdvance = processSub(1);
				break;
			case AiInstructionsEnum.SUBR2.toInt():
				delayAdvance = processSub(2);
				break;
			case AiInstructionsEnum.MOVE_FORWARD1.toInt():
				//trace("processing move Forward");
				RCmoveRobotForward();
				// special case for ice squares
				if(mapList[robotX][robotY].getType().toInt() == tileEnums.TIce.toInt())
				{
					if(RCcanRobotMoveForward(myRobot.getDirection(), 1))
					{
						delayAdvance = true;
					}
				}
				break;
			case AiInstructionsEnum.TURN_LEFT1.toInt():
				//trace("processing turn left");
				myGameVar.SSoundTurnLeft.play();
				myRobot.rotate(-1);
				break;
			case AiInstructionsEnum.TURN_RIGHT1.toInt():
				//trace("processing turn right");
				myGameVar.SSoundTurnRight.play();
				myRobot.rotate(1);
				break;
			case AiInstructionsEnum.CROUCH.toInt():  // just like move forward above, only far less squares that can be moved into
				//trace("processing crouch");
				RCcrouch();
				break;
			case AiInstructionsEnum.CLIMB.toInt():	  // just like move forward above, only far less squares that can be moved into
				//trace("processing climb");
				RCclimb();
				break;
			case AiInstructionsEnum.JUMP.toInt():	  // just like move forward above, only far less squares that can be moved into
				//trace("processing jump");
				RCjumpRobotForward();
				break;
			case AiInstructionsEnum.PUNCH.toInt():	  // just like move forward above, only far less squares that can be moved into
				//trace("processing punch");
				RCpunch();
				break;
			case AiInstructionsEnum.MOVE_FORWARD_UNTIL_UNABLE.toInt(): // just like move forward above, only no advancement of command until destination square is invalid
				//trace("processing move forward until unable");
				delayAdvance = RCmoveRobotForward();
				break;
			case AiInstructionsEnum.SUB.toInt():	// special case
				break;
			case AiInstructionsEnum.LOOP:	// since this should always be displayed as the last command automatically, this isn't really needed
						// the object's ai list automagically loops when it gets to its end
				break;
			case AiInstructionsEnum.ACTIVATE.toInt():	// for now lets just check for a door so we can see it working in testmap1
				//trace("processing activate");
				RCactivate();
				break;
			case AiInstructionsEnum.DO_NOT_PROCESS.toInt():
				break;
			case AiInstructionsEnum.STOP.toInt():
				// Let logic interface know to abort.
				stage.dispatchEvent(new Event("logicInterfaceAbort"));
				
				//trace("processing stop");
				delayAdvance = true;
				break;
			default:
				break;
			}
		
			if(!delayAdvance)
			{
				myRobot.advanceCommand();
			}
			
			currentX = robotX;
			currentY = robotY;
			reInjectRobotImage();
			verifyCameraCenter();
			teleporterCheck();
		}
		
		public function robotAtEndSquare():Boolean
		{
			// find the end square
			if ((mapList[robotX][robotY].getType().toInt() == tileEnums.TEnd.toInt()) && (mapList[robotX][robotY].getIsActive()))
			{
				return true;
			}
			else
			{
				return false;
			}
		}
		
		public function getCurState():GameBoardStateEnum
		{
			return curState;
		}
		
		public function teleporterCheck()
		{	
			if(!teleportInProgress && doneLoadingMapFromFile)
			{
					
				// see if we're standing in a teleporter square
				if(mapList[robotX][robotY].getType().toInt() == tileEnums.TTeleport.toInt())
				{
					//trace("found a teleporter at the robot square");
					// if we are, lets find the teleporter in the list
					myGameVar.SSoundTileTeleport.play();
					for(var x:int = 0; x < teleportList.length; x++)
					{
						if(((teleportList[x].getXPos()) == robotX) && ((teleportList[x].getYPos()) == robotY))
						{
							teleportInProgress = true;
							 //draw before
							currentX = teleportList[x].getTargetX();
							currentY = teleportList[x].getTargetY();
							//trace("teleport leads to square ", teleportList[x].getTargetX() , ", ", teleportList[x].getTargetY());
							recalcPositions();
							draw();
							
							// setup event timer to occur after like 500 milliseconds, this will do the post teleport stuff
							// event goes here
							var i:int = this.processSpeed;
							teleportTimer = new Timer(i, 1);
							teleportTimer.addEventListener(TimerEvent.TIMER, postTeleport);
							teleportTimer.start();
						}						
					}
				}
			}
		}
		
		public function postTeleport(e:TimerEvent)
		{	
			
			for(var x:int = 0; x < teleportList.length; x++)
			{
				if(((teleportList[x].getXPos()) == robotX) && ((teleportList[x].getYPos()) == robotY))
				{
						
					 // now lets teleport!
					robotX = teleportList[x].getTargetX();
					robotY = teleportList[x].getTargetY();
					keepRobotOnTheBoard();
					recalcPositions();
					//trace("we arrived at our destination of ", robotX, ", ", robotY);
					
					 //draw after
					draw();

					// setup event time to occur after 500 milliseconds, this tells the system to go continue processing
					var i:int = this.processSpeed;
					teleportTimer = new Timer(i, 1);
					teleportTimer.addEventListener(TimerEvent.TIMER, teleportDone);
					teleportTimer.start();
				}
			}
		}
		
		public function teleportDone(e:TimerEvent)
		{
			teleportInProgress = false;
		}
		
		public function keepRobotOnTheBoard()
		{
			if (robotX < 0)			
				robotX = 0;
			if (robotX >= Width)		
				robotX = Width-1;
			if (robotY < 0)			
				robotY = 0;
			if (robotY >= Height)	
				robotY = Height-1;
		}
		
		public function interfaceHasFiredExecuteOrder(e:Event)
		{
			//trace ("just entered interface has fired execute order");
			resetMap();
			teleportInProgress = false;
			var exList:Array = myGameVar.getMainExecutionList();
			var exListSub1:Array = myGameVar.getSub1ExecutionList();
			var exListSub2:Array = myGameVar.getSub2ExecutionList();
			
			SUB1 = new subroutine();
			SUB2 = new subroutine();
			
			
			SUB1.clearInstructions();
			
			//trace ("SUB1 just got cleared");
			for (var i:int = 0; i < exListSub1.length; i++)
			{
				//trace("exListSub1[", i, "] = ", exListSub1[i].enumInstruction);
				if (exListSub1[i].enumInstruction.toInt() != AiInstructionsEnum.DO_NOT_PROCESS.toInt())
				{
					SUB1.addCommand(exListSub1[i].enumInstruction);
				}
			}
			
			SUB2.clearInstructions();
			for (i = 0; i < exListSub2.length; i++)
			{
				if (exListSub2[i].enumInstruction.toInt() != AiInstructionsEnum.DO_NOT_PROCESS.toInt())
				{
					SUB2.addCommand(exListSub2[i].enumInstruction);
				}
			}		
			
			myRobot.reset();
			myRobot.setAlive(true);
			robotAlive = true;
			robotX = robotStartX;
			robotY = robotStartY;
			currentX = robotX;
			currentY = robotY;
			
			myRobot.clearInstructions();
			for (i = 0; i < exList.length; i++)
			{
				if (exList[i].enumInstruction.toInt() != AiInstructionsEnum.DO_NOT_PROCESS.toInt())
				{
					myRobot.addCommand(exList[i].enumInstruction);
				}
			}
			
			curState = GameBoardStateEnum.GB_EXECUTION;
			
			//trace("Starting execution Cycle");
			executionCycleTimer.addEventListener(TimerEvent.TIMER, processExecutionCycle);
			executionCycleTimer.start();
		}
		
		public function processExecutionCycle(e:TimerEvent)
		{
			if (curState.toInt() == GameBoardStateEnum.GB_EXECUTION.toInt())
			{
				//trace("Beginning to process execution cycle");
				if ((!switchInProgress) && (!DswitchInProgress))
				{
					if (!teleportInProgress)
					{
						processRobot();
						setRobotImage(myRobot.getDirection());
						reInjectRobotImage();
					}
				}
				else 
				{
					if (switchInProgress)
					{
						processSwitch();
					}
					if (DswitchInProgress)
					{
						processDSwitch();
					}
				}
				//trace("Populating map");
				populateMapImages();
				
				if (this.curState.toInt() == GameBoardStateEnum.GB_EXECUTION.toInt())
				{
					//trace("Attempting to query speed");
					var i:int = this.processSpeed;
					
					//trace(i);
					executionCycleTimer = new Timer(i, 1);
					executionCycleTimer.addEventListener(TimerEvent.TIMER, processExecutionCycle);
					executionCycleTimer.start();
				}
			}
		}
		
		public function setProcessSpeed(incSpeed:int):void
		{
			//trace(incSpeed);
			processSpeed = incSpeed;
		}
		
		public function getProcessSpeed():int
		{
			return processSpeed;
		}
		
		public function interfaceHasFiredAbortOrder(e:Event)
		{
			if((curState.toInt() == GameBoardStateEnum.GB_EXECUTION.toInt()) && (!robotAtEndSquare()))
			{
				curState = GameBoardStateEnum.GB_LOGICVIEW;
				myGameVar.SM.resetAllSwitches();
				switchInProgress = false;
				switchToggled = false;
				DswitchInProgress = false;
				DswitchToggled = false;
				teleportInProgress = false;
			}
			return false;
		}
		
		public function interfaceHasFiredResetOrder(e:Event)
		{
			curState = GameBoardStateEnum.GB_LOGICVIEW;
			
			resetMap();

			SUB1 = new subroutine();
			SUB2 = new subroutine();

			// Find the robot
			
			myRobot.reset();
			myRobot.setAlive(true);
			robotAlive = true;
			robotX = robotStartX;
			robotY = robotStartY;
			currentX = robotX;
			currentY = robotY;
			myRobot.clearInstructions();
			
			setRobotImage(myRobot.getDirection());
			reInjectRobotImage();
			populateMapImages();
			teleportInProgress = false;
			
			return false;
		}
		
		public function RCcanRobotLeaveSquare(direction:int):Boolean
		{
			// we just need to know information about our own square
			var robotSquare:tileEnums = mapList[robotX][robotY].getType();		
			var robotSquareActive:Boolean = mapList[robotX][robotY].getIsActive();

			// squares that can be left
			if( (robotSquare.toInt() == tileEnums.TDefault.toInt()) ||
				(robotSquare.toInt() == tileEnums.TRaised1.toInt()) ||
				(robotSquare.toInt() == tileEnums.TRaised2.toInt()) ||
				(robotSquare.toInt() == tileEnums.TRaised3.toInt()) ||
				(robotSquare.toInt() == tileEnums.TRaised4.toInt()) ||
				(robotSquare.toInt() == tileEnums.TElectric.toInt()) ||
				((robotSquare.toInt() == tileEnums.TElectricTL.toInt()) && (direction != 3)) ||
				((robotSquare.toInt() == tileEnums.TElectricTR.toInt()) && (direction != 0)) || 
				((robotSquare.toInt() == tileEnums.TElectricBL.toInt()) && (direction != 2)) ||
				((robotSquare.toInt() == tileEnums.TElectricBR.toInt()) && (direction != 1)) ||
				(robotSquare.toInt() == tileEnums.TIce.toInt()) ||
				(robotSquare.toInt() == tileEnums.TWater.toInt()) ||
				(robotSquare.toInt() == tileEnums.TSwitchTL.toInt()) ||
				(robotSquare.toInt() == tileEnums.TSwitchTR.toInt()) ||
				(robotSquare.toInt() == tileEnums.TSwitchBL.toInt()) ||
				(robotSquare.toInt() == tileEnums.TSwitchBR.toInt()) ||
				(robotSquare.toInt() == tileEnums.TSwitch.toInt()) ||
				(robotSquare.toInt() == tileEnums.TProgramTL.toInt()) ||
				(robotSquare.toInt() == tileEnums.TProgramTR.toInt()) ||
				(robotSquare.toInt() == tileEnums.TProgramBL.toInt()) ||
				(robotSquare.toInt() == tileEnums.TProgramBR.toInt()) ||
				(robotSquare.toInt() == tileEnums.TProgram.toInt()) ||
				((robotSquare.toInt() == tileEnums.TBreakableTL.toInt()) && (((!robotSquareActive) && (direction == 3)) || (direction != 3))) ||
				((robotSquare.toInt() == tileEnums.TBreakableTR.toInt()) && (((!robotSquareActive) && (direction == 0)) || (direction != 0))) ||
				((robotSquare.toInt() == tileEnums.TBreakableBL.toInt()) && (((!robotSquareActive) && (direction == 2)) || (direction != 2))) ||
				((robotSquare.toInt() == tileEnums.TBreakableBR.toInt()) && (((!robotSquareActive) && (direction == 1)) || (direction != 1))) ||
				(robotSquare.toInt() == tileEnums.TSolid.toInt()) ||
				(robotSquare.toInt() == tileEnums.TBreakable.toInt()) ||
				(robotSquare.toInt() == tileEnums.TStart.toInt()) ||
				(robotSquare.toInt() == tileEnums.TEnd.toInt()) ||
				( (robotSquare.toInt() == tileEnums.TDoorTL.toInt()) && (((direction == 3) && (!robotSquareActive)) || (direction != 3))) ||
				( (robotSquare.toInt() == tileEnums.TDoorTR.toInt()) && (((direction == 0) && (!robotSquareActive)) || (direction != 0))) ||
				( (robotSquare.toInt() == tileEnums.TDoorBL.toInt()) && (((direction == 2) && (!robotSquareActive)) || (direction != 2))) ||
				( (robotSquare.toInt() == tileEnums.TDoorBR.toInt()) && (((direction == 1) && (!robotSquareActive)) || (direction != 1))))
			{
				return true;
			}
			else
			{
				return false;
			}
		}
		
		public function RCwillRobotDieTryingToLeaveSquare(direction:int):Boolean
		{
			var robotSquare:tileEnums = mapList[robotX][robotY].getType();
			var robotSquareActive:Boolean = mapList[robotX][robotY].getIsActive();
			
			if ((((robotSquare.toInt() == tileEnums.TElectricTL.toInt()) && (direction == 3)) || 
				 ((robotSquare.toInt() == tileEnums.TElectricTR.toInt()) && (direction == 0)) ||
				 ((robotSquare.toInt() == tileEnums.TElectricBL.toInt()) && (direction == 2)) ||
				 ((robotSquare.toInt() == tileEnums.TElectricBR.toInt()) && (direction == 1))) && robotSquareActive)
			{
				return true;
			}
			else
			{
				return false;
			}
		}
		
		public function RCcanRobotMoveForward(direction:int, destNum:int):Boolean
		{
			var destX:int;
			var destY:int;
			var robotSquare:tileEnums;
			var destType:tileEnums;
			var destActive:Boolean;

			destX = robotX;
			destY = robotY;

			switch(direction)
			{
			case 0:// facing up/right (up on map)
				destY = robotY -destNum;					
				break;
			case 1:// facing down/right (right on map)
				destX = robotX +destNum;
				break;
			case 2:// facing down/left (down on map)
				destY = robotY + destNum;
				break;
			case 3:// facing up/left (left on map)
				destX = robotX -destNum;
				break;
			}
						
			if((destX >= 0) && (destX < Width) && (destY >= 0) && (destY < Height))
			{
				destType = mapList[destX][destY].getType();
				destActive = mapList[destX][destY].getIsActive();

				robotSquare = mapList[robotX][robotY].getType();

				if ( (destType.toInt() == tileEnums.TDefault.toInt()) || 
					 ((destType.toInt() == tileEnums.TRaised1.toInt()) && ((robotSquare.toInt() == tileEnums.TRaised1.toInt()) || (robotSquare.toInt() == tileEnums.TRaised2.toInt()) || (robotSquare.toInt() == tileEnums.TRaised3.toInt()) || (robotSquare.toInt() == tileEnums.TRaised4.toInt()))) ||
					 ((destType.toInt() == tileEnums.TRaised2.toInt()) && ((robotSquare.toInt() == tileEnums.TRaised2.toInt()) || (robotSquare.toInt() == tileEnums.TRaised3.toInt()) || (robotSquare.toInt() == tileEnums.TRaised4.toInt()))) ||
					 ((destType.toInt() == tileEnums.TRaised3.toInt()) && ((robotSquare.toInt() == tileEnums.TRaised3.toInt()) || (robotSquare.toInt() == tileEnums.TRaised4.toInt())))||
					 ((destType.toInt() == tileEnums.TRaised4.toInt()) && ((robotSquare.toInt() == tileEnums.TRaised4.toInt()))) ||
					 (destType.toInt() == tileEnums.TGap.toInt()) || 
					 (destType.toInt() == tileEnums.TElectric.toInt()) ||
					 ((destType.toInt() == tileEnums.TElectricTL.toInt()) && (direction != 1)) || 
					 ((destType.toInt() == tileEnums.TElectricTR.toInt()) && (direction != 2)) ||
					 ((destType.toInt() == tileEnums.TElectricBL.toInt()) && (direction != 0)) ||
					 ((destType.toInt() == tileEnums.TElectricBR.toInt()) && (direction != 3)) ||
					 (destType.toInt() == tileEnums.TIce.toInt()) ||
					 (destType.toInt() == tileEnums.TWater.toInt()) ||
					 (destType.toInt() == tileEnums.TSwitchTL.toInt()) ||
					 (destType.toInt() == tileEnums.TSwitchTR.toInt()) ||
					 (destType.toInt() == tileEnums.TSwitchBL.toInt()) ||
					 (destType.toInt() == tileEnums.TSwitchBR.toInt()) ||
					 (destType.toInt() == tileEnums.TSwitch.toInt()) ||
					 (destType.toInt() == tileEnums.TProgramTL.toInt()) ||
					 (destType.toInt() == tileEnums.TProgramTR.toInt()) ||
					 (destType.toInt() == tileEnums.TProgramBL.toInt()) ||
					 (destType.toInt() == tileEnums.TProgramBR.toInt()) ||
					 (destType.toInt() == tileEnums.TProgram.toInt()) ||
					 ((destType.toInt() == tileEnums.TBreakableTL.toInt()) && (((direction == 0) || (direction == 2) || (direction == 3)) || !destActive)) ||
					 ((destType.toInt() == tileEnums.TBreakableTR.toInt()) && (((direction == 0) || (direction == 1) || (direction == 3)) || !destActive)) ||
					 ((destType.toInt() == tileEnums.TBreakableBL.toInt()) && (((direction == 1) || (direction == 2) || (direction == 3)) || !destActive)) ||
					 ((destType.toInt() == tileEnums.TBreakableBR.toInt()) && (((direction == 0) || (direction == 1) || (direction == 2)) || !destActive)) ||
					 ((destType.toInt() == tileEnums.TBreakable.toInt()) && (!destActive)) ||
					 ((destType.toInt() == tileEnums.TSolid.toInt()) && (!destActive)) ||
					 (destType.toInt() == tileEnums.TStart.toInt()) ||
					 (destType.toInt() == tileEnums.TEnd.toInt()) ||
					 ( (destType.toInt() == tileEnums.TDoorTL.toInt()) && (((direction == 0) || (direction == 2) || (direction == 3)) || !destActive)) ||
					 ( (destType.toInt() == tileEnums.TDoorTR.toInt()) && (((direction == 0) || (direction == 1) || (direction == 3)) || !destActive)) ||
					 ( (destType.toInt() == tileEnums.TDoorBL.toInt()) && (((direction == 1) || (direction == 2) || (direction == 3)) || !destActive)) ||
					 ( (destType.toInt() == tileEnums.TDoorBR.toInt()) && (((direction == 0) || (direction == 1) || (direction == 2)) || !destActive)) ||
					 (destType.toInt() == tileEnums.TTeleport.toInt()))
				{
					return true; 
				}
			}
			return false;
		}
		
		public function RCwillRobotDieStayingHere():Boolean
		{
			// robot vars
			var robotSquare:tileEnums;

			robotSquare = mapList[robotX][robotY].getType();
			var robotSquareActive:Boolean = mapList[robotX][robotY].getIsActive();

			// if robot square = a bad square, return true, otherwise return false
			if(	(robotSquare.toInt() == tileEnums.TGap.toInt()) ||
				(robotSquare.toInt() == tileEnums.TWater.toInt()) ||
				((robotSquare.toInt() == tileEnums.TElectric.toInt()) && (robotSquareActive == true))
				)
			{
				// this is going to probably want to be setup to play a different sound for each death, i'm not doing that now so there! --dave
				myGameVar.SSoundRobotDiedElectric.play();
				return true;
			}
			else
			{
				return false;
			}
		}
		
		public function RCjumpRobotForward()
		{
			var distanceToMove:int = 2;

			var robotDirection:int = myRobot.getDirection();

			// lets see if we are going to die attempting to leave this squiare
			if(RCwillRobotDieTryingToLeaveSquare(robotDirection))
			{
				// yes we died
				myGameVar.SSoundRobotDiedElectric.play();
				myRobot.setAlive(false);
				robotAlive = false;
				return;
			}

			// at this point we're still alive, now lets see if we can leave this square
			if(!RCcanRobotLeaveSquare(robotDirection))
			{
				// no we can't leave
				myGameVar.SSoundTileSolidHit.play();
				return;
			}

			// now lets see if our jump can allow us to move forward from our square to the destination square
			if(!RCcanRobotMoveForward(robotDirection, 2))
			{
				// no we can't actually land at the destination square
				// lets check the one square infront of us and see if that can be landed on instead
				if(!RCcanRobotMoveForward(robotDirection, 1))
				{
					// no we can't even move forward 1 square, you're screwed, stay put
					myGameVar.SSoundTileSolidHit.play();
					return;
				}
				else
				{
					// at least we can move forward 1 square, lets set our distance to 1
					distanceToMove = 1;
				}
			}
			else
			{
				// wow we can jump two squares forward! amazing!
				// lets see if we can also clear the square infront of us
				if(!this.RCcanRobotMoveForward(robotDirection, 1))
				{
					// nope we cannot even move out of this square, we'll just have to stay put
					myGameVar.SSoundTileSolidHit.play();
					return;
				}
				
				// now for the odd circumstance
				// we can land 2 squares away.. and can enter the square infront of us which means that this is actually a viable square to enter

				// what if what's in the next square is a wall that we're facing, so lets check against that
				// and while we're at it, lets also see if that wall is an electric wall that's about to kill us
				// first lets check for solid unbroken walls
				var tempDestX:int = robotX;
				var tempDestY:int = robotY;
				switch(robotDirection)
				{
				case 0:// facing up/right (up on map)
					tempDestY = robotY - 1;
					break;
				case 1:// facing down/right (right on map)
					tempDestX = robotX + 1;
					break;
				case 2:// facing down/left (down on map)
					tempDestY = robotY + 1;
					break;
				case 3:// facing up/left (left on map)
					tempDestX = robotX - 1;
					break;
				}
				
				switch(robotDirection)
				{
					case 0: // facing up/right
						// if its a breakable wall that isn't broken
						if (mapList[tempDestX][tempDestY].getType().toInt() == tileEnums.TBreakableTR.toInt() && mapList[tempDestX][tempDestY].getIsActive())
						{
							// play a solid hit sound
							myGameVar.SSoundTileSolidHit.play();
							// set distance to move to 1
							distanceToMove = 1;
						}
						
						// if its an electric wall..
						if (mapList[tempDestX][tempDestY].getType().toInt() == tileEnums.TElectricTR.toInt())
						{
							// play a solid hit sound
							myGameVar.SSoundTileSolidHit.play();
							// set distance to move to 1
							distanceToMove = 1;
							
							// if its active, set robot to dead and play a death sound
							if (mapList[tempDestX][tempDestY].getIsActive())
							{
								myGameVar.SSoundRobotDiedElectric.play();
								myRobot.setAlive(false);
								robotAlive = false;
							}
						}
						break;
					case 1:	// facing down/right
						// if its a breakable wall that isn't broken
						if (mapList[tempDestX][tempDestY].getType().toInt() == tileEnums.TBreakableBR.toInt() && mapList[tempDestX][tempDestY].getIsActive())
						{
							// play a solid hit sound
							myGameVar.SSoundTileSolidHit.play();
							// set distance to move to 1
							distanceToMove = 1;
						}
						
						// if its an electric wall..
						if (mapList[tempDestX][tempDestY].getType().toInt() == tileEnums.TElectricBR.toInt())
						{
							// play a solid hit sound
							myGameVar.SSoundTileSolidHit.play();
							// set distance to move to 1
							distanceToMove = 1;
							
							// if its active, set robot to dead and play a death sound
							if (mapList[tempDestX][tempDestY].getIsActive())
							{
								myGameVar.SSoundRobotDiedElectric.play();
								myRobot.setAlive(false);
								robotAlive = false;
							}
						}
						break;
					case 2:	// facing down/left
						// if its a breakable wall that isn't broken
						if (mapList[tempDestX][tempDestY].getType().toInt() == tileEnums.TBreakableBL.toInt() && mapList[tempDestX][tempDestY].getIsActive())
						{
							// play a solid hit sound
							myGameVar.SSoundTileSolidHit.play();
							// set distance to move to 1
							distanceToMove = 1;
						}
						
						// if its an electric wall..
						if (mapList[tempDestX][tempDestY].getType().toInt() == tileEnums.TElectricBL.toInt())
						{
							// play a solid hit sound
							myGameVar.SSoundTileSolidHit.play();
							// set distance to move to 1
							distanceToMove = 1;
							
							// if its active, set robot to dead and play a death sound
							if (mapList[tempDestX][tempDestY].getIsActive())
							{
								myGameVar.SSoundRobotDiedElectric.play();
								myRobot.setAlive(false);
								robotAlive = false;
							}
						}
						break;
					case 3:	// facing up/left
						// if its a breakable wall that isn't broken
						if (mapList[tempDestX][tempDestY].getType().toInt() == tileEnums.TBreakableTL.toInt() && mapList[tempDestX][tempDestY].getIsActive())
						{
							// play a solid hit sound
							myGameVar.SSoundTileSolidHit.play();
							// set distance to move to 1
							distanceToMove = 1;
						}
						
						// if its an electric wall..
						if (mapList[tempDestX][tempDestY].getType().toInt() == tileEnums.TElectricTL.toInt())
						{
							// play a solid hit sound
							myGameVar.SSoundTileSolidHit.play();
							// set distance to move to 1
							distanceToMove = 1;
							
							// if its active, set robot to dead and play a death sound
							if (mapList[tempDestX][tempDestY].getIsActive())
							{
								myGameVar.SSoundRobotDiedElectric.play();
								myRobot.setAlive(false);
								robotAlive = false;
							}
						}
						break;
				}
				
			}

			// ok at this point we're not dead, we can leave our square, and we can either jump 2 squares clearing the middle
			// square, or can jump forward 1 square, at least we're not dead.. yet
			// lets do the jump and see what happens!

			var destX:int = robotX;
			var destY:int = robotY;
			switch(robotDirection)
			{
			case 0:// facing up/right (up on map)
				destY = robotY - distanceToMove;					
				break;
			case 1:// facing down/right (right on map)
				destX = robotX + distanceToMove;
				break;
			case 2:// facing down/left (down on map)
				destY = robotY + distanceToMove;
				break;
			case 3:// facing up/left (left on map)
				destX = robotX - distanceToMove;
				break;
			}
			if( (destX >=0) && (destX < Width) )
				robotX = destX;
			if( (destY >=0) && (destY < Height) )
				robotY = destY;

			myRobot.setXPos(robotX);
			myRobot.setYPos(robotY);
			
			myGameVar.SSoundJump.play();
			
			// now that we've moved forward
			// lets see if we're about to die
			if(RCwillRobotDieStayingHere())
			{
				// yes we died
				myRobot.setAlive(false);
				robotAlive = false;
			}
			
			
		}
		
		public function RCcrouch()
		{
			
			var robotDirection:int = myRobot.getDirection();
			var robotSquare:tileEnums = mapList[robotX][robotY].getType();
			var destSquare:tileEnums;

			var destX:int = robotX;
			var destY:int = robotY;
			var landingX:int = robotX;
			var landingY:int = robotY;
			switch(robotDirection)
			{
			case 0:// facing up/right (up on map)
				destY = robotY -1;
				landingY = robotY - 2;
				break;
			case 1:// facing down/right (right on map)
				destX = robotX +1;
				landingX = robotX +2;
				break;
			case 2:// facing down/left (down on map)
				destY = robotY + 1;
				landingY = robotY +2;
				break;
			case 3:// facing up/left (left on map)
				destX = robotX -1;
				landingX = robotX -2;
				break;
			}
			
			if (((destX >=0) && (destX < Width)) && ((landingX >=0) && (landingX < Width)))
			{}
			else
			{
				myGameVar.SSoundTileSolidHit.play();
				return;
			}
			if (((destY >=0) && (destY < Height)) && ((landingY >=0) && (landingY < Height)))
			{}
			else
			{
				myGameVar.SSoundTileSolidHit.play();
				return;
			}

			destSquare = mapList[destX][destY].getType();

			if( ((destSquare.toInt() == tileEnums.THalfTopR.toInt()) && ((robotDirection == 0) || (robotDirection == 2))) ||
				((destSquare.toInt() == tileEnums.THalfTopL.toInt()) && ((robotDirection == 1) || (robotDirection == 3))) )				
			{
				robotX = landingX;
				robotY = landingY;
				myRobot.setXPos(robotX);
				myRobot.setYPos(robotY);
				myGameVar.SSoundCrouch.play();
				RCwillRobotDieStayingHere();
			}
		}				
		
		public function RCclimb()
		{
			
			var robotDirection:int = myRobot.getDirection();
			var robotSquare:tileEnums = mapList[robotX][robotY].getType();
			var destSquare:tileEnums;

			var destX:int = robotX;
			var destY:int = robotY;
			var landingX:int = robotX;
			var landingY:int = robotY;
			
			switch(robotDirection)
			{
			case 0:// facing up/right (up on map)
				destY = robotY -1;
				landingY = robotY - 2;
				break;
			case 1:// facing down/right (right on map)
				destX = robotX +1;
				landingX = robotX +2;
				break;
			case 2:// facing down/left (down on map)
				destY = robotY + 1;
				landingY = robotY +2;
				break;
			case 3:// facing up/left (left on map)
				destX = robotX -1;
				landingX = robotX -2;
				break;
			}
			if((destX >= 0) && (destX < Width) && (destY >= 0) && (destY < Height))
			{
				destSquare = mapList[destX][destY].getType();
			}
			else
			{
				myGameVar.SSoundTileSolidHit.play();
				return;
			}

			// first lets see if we're climbing up to a new level
			if(((destSquare.toInt() == tileEnums.TRaised4.toInt()) && (robotSquare.toInt() == tileEnums.TRaised3.toInt())) ||
			   ((destSquare.toInt() == tileEnums.TRaised3.toInt()) && (robotSquare.toInt() == tileEnums.TRaised2.toInt())) ||
			   ((destSquare.toInt() == tileEnums.TRaised2.toInt()) && (robotSquare.toInt() == tileEnums.TRaised1.toInt())) ||
			   ((destSquare.toInt() == tileEnums.TRaised1.toInt()) && ( (robotSquare.toInt() != tileEnums.TRaised1.toInt()) && (robotSquare.toInt() != tileEnums.TRaised2.toInt()) && 
											  (robotSquare.toInt() != tileEnums.TRaised3.toInt()) && (robotSquare.toInt() != tileEnums.TRaised4.toInt()))))
			{
				robotX = destX;
				robotY = destY;
				myRobot.setXPos(robotX);
				myRobot.setYPos(robotY);
				myGameVar.SSoundClimb.play();
				RCwillRobotDieStayingHere();
				return;
			}
		}	
		
		public function RCpunch()
		{
			var robotDirection:int = myRobot.getDirection();
			var robotSquare:tileEnums = mapList[robotX][robotY].getType();
			var destSquare:tileEnums;

			var destX:int = robotX;
			var destY:int = robotY;
			switch(robotDirection)
			{
			case 0:// facing up/right (up on map)
				destY = robotY -1;					
				break;
			case 1:// facing down/right (right on map)
				destX = robotX +1;
				break;
			case 2:// facing down/left (down on map)
				destY = robotY + 1;
				break;
			case 3:// facing up/left (left on map)
				destX = robotX -1;
				break;
			}

			if( (destX >=0) && (destX < Width))	{}
			else
			{
				myGameVar.SSoundTileSolidHit.play();
				return;
			}
			if((destY >=0) && (destY < Height))	{}
			else
			{
				myGameVar.SSoundTileSolidHit.play();
				return;
			}

			// at this point the dest square is in the map so we can just go ahead and work with stuff

			destSquare = mapList[destX][destY].getType();
			
			myGameVar.SSoundPunch.play();
			// first lets check for the standard breakable square 1 square away from us...
			if(destSquare.toInt() == tileEnums.TBreakable.toInt())
			{
				// its breakable!
				// lets break it
				mapList[destX][destY].setActive(false);
				myGameVar.SSoundTileBreakableBreaking.play();
			}
			// now lets check if its a breakable wall that we're facing the back of
			else if( ((destSquare.toInt() == tileEnums.TBreakableBL.toInt()) && (robotDirection == 0)) ||
					 ((destSquare.toInt() == tileEnums.TBreakableTL.toInt()) && (robotDirection == 1)) ||
					 ((destSquare.toInt() == tileEnums.TBreakableTR.toInt()) && (robotDirection == 2)) ||
					 ((destSquare.toInt() == tileEnums.TBreakableBR.toInt()) && (robotDirection == 3)))
			{
				myGameVar.SSoundTileBreakableBreaking.play();
				mapList[destX][destY].setActive(false);
			}
			// or lets also check to see if the square we're standing in is a breakable directional square
			// since our dest's are set, we don't need to set anything additional
			else if (((robotSquare.toInt() == tileEnums.TBreakableTR.toInt()) && (robotDirection == 0)) ||
					 ((robotSquare.toInt() == tileEnums.TBreakableBR.toInt()) && (robotDirection == 1)) ||
					 ((robotSquare.toInt() == tileEnums.TBreakableBL.toInt()) && (robotDirection == 2)) ||
					 ((robotSquare.toInt() == tileEnums.TBreakableTL.toInt()) && (robotDirection == 3)))
			{

				//mapList[destX][destY].setActive(false);	// disabling the destruction of what's behind a breakable wall
				mapList[robotX][robotY].setActive(false);
				myGameVar.SSoundTileBreakableBreaking.play();
			}
			populateMapImages();
		}			
		
		public function RCactivate()
		{
			var robotSquare:tileEnums;
			var robotDirection:int;
			var destType:tileEnums;
			var destActive:Boolean;

			var destX:int = 0;
			var destY:int = 0;
			robotSquare = mapList[robotX][robotY].getType();
			robotDirection = myRobot.getDirection();

			// first lets see if anything happens based upon the square we're standing in....

			// are we standing in a door square facing the door in our own square?
			// if so, lets toggle it
			switch(robotDirection)
			{
			case 0:// facing up/right (up on map)					
				if (robotSquare.toInt() == tileEnums.TDoorTR.toInt())
				{
					mapList[robotX][robotY].toggleActive();
					myGameVar.SSoundTileDoorOpen.play();
				}
				break;
			case 1:// facing down/right (right on map)
				if (robotSquare.toInt() == tileEnums.TDoorBR.toInt())
				{
					mapList[robotX][robotY].toggleActive();
					myGameVar.SSoundTileDoorOpen.play();	
				}
				break;
			case 2:// facing down/left (down on map)
				if (robotSquare.toInt() == tileEnums.TDoorBL.toInt())
				{
					mapList[robotX][robotY].toggleActive();
					myGameVar.SSoundTileDoorOpen.play();
				}
				break;
			case 3:// facing up/left (left on map)
				if (robotSquare.toInt() == tileEnums.TDoorTL.toInt())
				{
					mapList[robotX][robotY].toggleActive();
					myGameVar.SSoundTileDoorOpen.play();
				}
				break;
			}

			destX = robotX;
			destY = robotY;
			// now lets see if the robot is facing a door				
			switch(robotDirection)
			{
			case 0:// facing up/right (up on map)					
				destY = robotY -1;					
				break;
			case 1:// facing down/right (right on map)
				destX = robotX +1;
				break;
			case 2:// facing down/left (down on map)
				destY = robotY + 1;
				break;
			case 3:// facing up/left (left on map)
				destX = robotX -1;
				break;
			}

			// now lets check if the door that is facing the robot
			if((destX >= 0) && (destX < Width) && (destY >= 0) && (destY < Height))
			{
				destType = (mapList[destX][destY].getType()) ;
				destActive = (mapList[destX][destY].getIsActive());

				switch(robotDirection)
				{
				case 0:// facing up/right (up on map)					
					if (destType.toInt() == tileEnums.TDoorBL.toInt())
					{
						myGameVar.SSoundTileDoorOpen.play();
						mapList[destX][destY].toggleActive();
					}
					break;
				case 1:// facing down/right (right on map)
					if (destType.toInt() == tileEnums.TDoorTL.toInt())
					{
						myGameVar.SSoundTileDoorOpen.play();
						mapList[destX][destY].toggleActive();
					}
					break;
				case 2:// facing down/left (down on map)
					if (destType.toInt() == tileEnums.TDoorTR.toInt())
					{
						myGameVar.SSoundTileDoorOpen.play();
						mapList[destX][destY].toggleActive();
					}
					break;
				case 3:// facing up/left (left on map)
					if (destType.toInt() == tileEnums.TDoorBR.toInt())
					{
						myGameVar.SSoundTileDoorOpen.play();
						mapList[destX][destY].toggleActive();
					}
					break;
				}
			}

			// are we standing on a switch square?

			//int sx;
			//int sy;

			if((robotSquare.toInt() == tileEnums.TSwitch.toInt()) ||
			   ((robotSquare.toInt() == tileEnums.TSwitchTR.toInt()) && (robotDirection == 0)) ||
			   ((robotSquare.toInt() == tileEnums.TSwitchBR.toInt()) && (robotDirection == 1)) ||
			   ((robotSquare.toInt() == tileEnums.TSwitchBL.toInt()) && (robotDirection == 2)) ||
			   ((robotSquare.toInt() == tileEnums.TSwitchTL.toInt()) && (robotDirection == 3)))

			{
				// if we are in fact standing on a switch... lets see if one exists in the switch list
				if((myGameVar.SM.isThereASwitchAt(robotX, robotY)) && (!switchInProgress))
				{
					// if there is, lets set the happy go lucky bool in gameboard to true
					switchInProgress = true;
					mapList[robotX][robotY].toggleActive();
					myGameVar.SM.startProcessing(robotX, robotY);
				}
				// lets also check to see if there's a dswitch at our spot
				if((myGameVar.SMD.isThereASwitchAt(robotX, robotY)) && (!DswitchInProgress))
				{
					//trace("we're standing on a dswitch square and activate fired and isthereaswitchat worked properly");
					// if there is, lets set the happy go lucky bool in gameboard to true
					DswitchInProgress = true;
					mapList[robotX][robotY].toggleActive();
					myGameVar.SMD.startProcessing(robotX, robotY);
				}
			}

			// now lets see if we're on a reprogrammable square or facing a reprogram wall
			if( (robotSquare.toInt() == tileEnums.TProgram.toInt()) ||
				((robotSquare.toInt() == tileEnums.TProgramTR.toInt()) && (robotDirection == 0)) ||
				((robotSquare.toInt() == tileEnums.TProgramBR.toInt()) && (robotDirection == 1)) ||
				((robotSquare.toInt() == tileEnums.TProgramBL.toInt()) && (robotDirection == 2)) ||
				((robotSquare.toInt() == tileEnums.TProgramTL.toInt()) && (robotDirection == 3)) )				
			{
				myRobot.setDefaults(robotDirection, robotX, robotY);

				// store the map tiles actives
				for(var x:int = 0; x < Width; x++)
				{
					for(var y:int = 0; y < Height; y++)
					{
						mapList[x][y].setResetActive(mapList[x][y].getIsActive());
						mapList[x][y].setBaseType(mapList[x][y].getType());
					}
				}
								
				robotStartX = robotX;
				robotStartY = robotY;
				curState = GameBoardStateEnum.GB_LOGICVIEW;
				myGameVar.SSoundTileReprogramTile.play();

				// Go ahead and tell the interface it can stop processing...
				stage.dispatchEvent(new Event("reprogramReached"));

				// and clear the instruction list
				stage.dispatchEvent(new Event("clearExecutionList"));
				//myGameVar.setPMStatus(5);
				reprogramHit = true;
			}
		}
			
		public function RCmoveRobotForward():Boolean	// returns false when its over, true if its still activating
		{
			var robotDirection:int = myRobot.getDirection();

			// lets see if we are going to die attempting to leave this squiare
			if(RCwillRobotDieTryingToLeaveSquare(robotDirection))
			{
				// yes we died
				myGameVar.SSoundRobotDiedElectric.play();
				myRobot.setAlive(false);
				robotAlive = false;
				return false;
			}

			// at this point we're still alive, now lets see if we can leave this square
			if(!RCcanRobotLeaveSquare(robotDirection))
			{
				// no we can't leave
				return false;
			}

			// now lets see if we can move forward a square
			if(!RCcanRobotMoveForward(robotDirection, 1))
			{
				// no we can't move forward
				return false;
			}

			// ok at this point we're not dead, we can leave our square, and we can move forward into the next square
			// lets move forward and see what happens!

			var destX:int = robotX;
			var destY:int = robotY;
			switch(robotDirection)
			{
			case 0:// facing up/right (up on map)
				destY = robotY -1;					
				break;
			case 1:// facing down/right (right on map)
				destX = robotX +1;
				break;
			case 2:// facing down/left (down on map)
				destY = robotY + 1;
				break;
			case 3:// facing up/left (left on map)
				destX = robotX -1;
				break;
			}
			if( (destX >=0) && (destX < Width) )
				robotX = destX;
			if( (destY >=0) && (destY < Height) )
				robotY = destY;

			myRobot.setXPos(robotX);
			myRobot.setYPos(robotY);
			myGameVar.SSoundMoveForward.play();
			
			// now that we've moved forward
			// lets see if we're about to die
			if(RCwillRobotDieStayingHere())
			{
				// yes we died
				myRobot.setAlive(false);
				robotAlive = false;
				return false;
			}
			return true;
		}
		
		public function setState(state:GameBoardStateEnum)
		{
			curState = state;
		}
		
		public function processSub(whichSub:int):Boolean
		{
			processSubRecurCounter++;
			var nextCommand:AiInstructionsEnum;
			var parentDelay:Boolean = false;
			var moveForwardFiring:Boolean = false;
			
			if(whichSub == 1)
				if(SUB1.isEmpty())
				{
					return false;
				}
				else
				{
					nextCommand = SUB1.getNextCommand();
				}

			if(whichSub == 2)
				if(SUB2.isEmpty())
				{
					return false;
				}
				else
				{
					nextCommand = SUB2.getNextCommand();
				}
			
			//trace("about to enter the main switch statement");
			switch(nextCommand.toInt())
				{
					case AiInstructionsEnum.MOVE_FORWARD1.toInt():
						RCmoveRobotForward();
						// special case for ice squares
						if(mapList[robotX][robotY].getType().toInt() == tileEnums.TIce.toInt())
						{
							if(RCcanRobotMoveForward(myRobot.getDirection(), 1))
							{
								parentDelay = true;
								/*processSubRecurCounter--;*/
								return true;
							}
						}
						break;
					case AiInstructionsEnum.TURN_LEFT1.toInt():
						myRobot.rotate(-1);
						break;
					case AiInstructionsEnum.TURN_RIGHT1.toInt():
						myRobot.rotate(1);
						break;
					case AiInstructionsEnum.CROUCH.toInt():  // just like move forward above, only far less squares that can be moved into
						RCcrouch();
						break;
					case AiInstructionsEnum.CLIMB.toInt():	  // just like move forward above, only far less squares that can be moved into
						RCclimb();
						break;
					case AiInstructionsEnum.JUMP.toInt():	  // just like move forward above, only far less squares that can be moved into
						RCjumpRobotForward();
						break;
					case AiInstructionsEnum.PUNCH.toInt():	  // just like move forward above, only far less squares that can be moved into
						RCpunch();
						break;
					case AiInstructionsEnum.SUB.toInt():	// special case
						break;
					case AiInstructionsEnum.LOOP.toInt():	// since this should always be displayed as the last command automatically, this isn't really needed
								// the object's ai list automagically loops when it gets to its end
						break;
					case AiInstructionsEnum.ACTIVATE.toInt():	// for now lets just check for a door so we can see it working in testmap1
						RCactivate();
						break;
					case AiInstructionsEnum.MOVE_FORWARD_UNTIL_UNABLE.toInt(): // just like move forward above, only no advancement of command until destination square is invalid
						moveForwardFiring = RCmoveRobotForward();	// false if over, true if activating
						if(moveForwardFiring)
						{
							/*processSubRecurCounter--;*/
							return true;
						}				
						break;

					case AiInstructionsEnum.SUBR1.toInt():
						parentDelay = processSub(1);
						return parentDelay;
						break;

					case AiInstructionsEnum.SUBR2.toInt():
						parentDelay = processSub(2);
						return parentDelay;
						break;

					case AiInstructionsEnum.DO_NOT_PROCESS.toInt():
						break;
					case AiInstructionsEnum.STOP.toInt():
						return true;
					default:
						break;
				}
			if(whichSub == 1)
				parentDelay = SUB1.advanceCommand();
				
			if(whichSub == 2)
				parentDelay = SUB2.advanceCommand();

			//if(this.robotAtEndSquare())
			//{
				// stupid parent is going to subtract one because we're in a subroutine, that's no good
			//}
			return parentDelay;
		}
		
		//public function SetInterfaceAdvanceHandler(CFunctionPointer2R<bool, instructionTab, logicBlock*> interfaceAdvanceHandler)
		//{
			//mInterfaceAdvanceHandler = interfaceAdvanceHandler;
		//}

		//public function SetInterfaceReprogramHandler(CFunctionPointer0R<bool> interfaceReprogramHandler)
		//{
			//mInterfaceReprogramHandler = interfaceReprogramHandler;
		//}

		//public function SetInterfaceClearExecutionListHandler(CFunctionPointer0R<bool> InterfaceClearExecutionList)
		//{
			//mInterfaceClearExecutionList = InterfaceClearExecutionList;
		//}
		
		public function panleft()
		{	
			recalcPositions();
			currentX -= moveSpeed*2;
			currentY += moveSpeed*2;
			verifyCameraPositionX();
			verifyCameraPositionY();
			verifyCameraCenter();
		}

		public function panright()
		{
			recalcPositions();
			currentX += moveSpeed*2;
			currentY -= moveSpeed*2;
			verifyCameraPositionX();
			verifyCameraPositionY();
			verifyCameraCenter();
		}

		public function panup()
		{
			recalcPositions();
			currentX -= moveSpeed*2;
			currentY -= moveSpeed*2;
			verifyCameraPositionX();
			verifyCameraPositionY();
			verifyCameraCenter();
		}

		public function pandown()
		{
			recalcPositions();
			currentX += moveSpeed*2;
			currentY += moveSpeed*2;
			verifyCameraPositionX();
			verifyCameraPositionY();
			verifyCameraCenter();
		}
		
		public function panupleft()
		{
			recalcPositions();
			currentX -= moveSpeed*2;
			verifyCameraPositionX();
			verifyCameraCenter();
		}
		
		public function panupright()
		{
			recalcPositions();
			currentY -= moveSpeed*2;
			verifyCameraPositionY();
			verifyCameraCenter();
		}
		
		public function pandownleft()
		{
			recalcPositions();
			currentY += moveSpeed*2;
			verifyCameraPositionY();
			verifyCameraCenter();
		}
		
		public function pandownright()
		{
			recalcPositions();
			currentX += moveSpeed*2;
			verifyCameraPositionX();
			verifyCameraCenter();
		}
		
		public function zoomout()
		{
			scale -= 0.05;
			if (scale < minScale)	scale = minScale;
		}
		
		public function zoomin()
		{
			scale += 0.05;
			if (scale > maxScale)	scale = maxScale;
		}
		
		public function center()
		{
			currentX = robotX;
			currentY = robotY;
			recalcPositions();
		}
	
		public function getRobotAlive():Boolean
		{
			return robotAlive;
		}
		
		public function spinRobot()
		{
			myRobot.rotate(1);
		}
		
		public function rotateMapRight()
		{
			mapRotation++;

			var tempWidth:int = Height;
			var tempHeight:int = Width;

			// make it all empty
			var mapListTemp:Array = new Array(tempWidth);
			var x:int;
			
			for(x = 0; x < tempWidth; x++)
			{
				mapListTemp[x] = new Array(tempHeight);
			}
			
			var foundRobot:Boolean = false;

			// now that we have an empty vector
			for(x = 0; x < tempWidth; x++)
			{
				for(var y:int = 0; y < tempHeight; y++)
				{
					var newY:int = Height - x - 1;
					mapListTemp[x][y] = mapList[y][newY];
					mapListTemp[x][y].rotateRight();

					if((robotX == y) && (robotY == (newY)) && (!foundRobot))
					{
						foundRobot = true;
						robotX = x;
						robotY = y;
						myRobot.rotate(1);	
					}
				}
			}

			// now rotate the camera whee
			var tempX:Number;
			var tempY:Number;

			tempX = Height - currentY;
			tempY = currentX;

			currentX = tempX;
			currentY = tempY;

			// now for switches
			myGameVar.SM.rotateRight(Width, Height);

			var tempTargetX:int;
			var tempTargetY:int;

			// now for teleporters
			for(x; x < teleportList.length; x++)
			{
				tempX = teleportList[x].getXPos();
				tempY = teleportList[x].getYPos();
				tempTargetX = teleportList[x].getTargetX();
				tempTargetY = teleportList[x].getTargetY();
				teleportList[x].setXPos(Height - tempY - 1);
				teleportList[x].setYPos(tempX);
				teleportList[x].setTarget(Height - tempTargetY - 1, tempTargetX);
			}

			// recalculate any positions that need recalculating
			recalcPositions();

			Width = tempWidth;
			Height = tempHeight;
			mapList = mapListTemp;
			populateMapImages();
			rebuildMapClip();
		}
			
		public function rotateMapLeft()
		{
			mapRotation--;
			var mapListTemp:Array;

			var tempWidth:int = Height;
			var tempHeight:int = Width;

			var x:int;
			// make it all empty
			mapListTemp = new Array(tempWidth);
			for(x = 0; x < tempWidth; x++)
			{
				mapListTemp[x] = new Array(tempHeight);
			}
			var foundRobot:Boolean = false;

			// now that we have an empty vector
			for(x = 0; x < tempWidth; x++)
			{
				for(var y:int = 0; y < tempHeight; y++)
				{
					mapListTemp[x][y] = mapList[Width - y - 1][x];
					mapListTemp[x][y].rotateLeft();

					if((robotX == (Width-y-1)) && (robotY == x) && (!foundRobot))
					{
						foundRobot = true;
						robotX = x;
						robotY = y;
						myRobot.rotate(-1);				
					}
				}
			}
			var tempX:Number;
			var tempY:Number;

			tempX = currentY;
			tempY = Width - currentX;

			currentX = tempX;
			currentY = tempY;

			var tempTargetX:int;
			var tempTargetY:int;

			// now for switches
			myGameVar.SM.rotateLeft(Width, Height);

			// now for teleporters
			for(x = 0; x < teleportList.length; x++)
			{
				tempX = teleportList[x].getXPos();
				tempY = teleportList[x].getYPos();
				tempTargetX = teleportList[x].getTargetX();
				tempTargetY = teleportList[x].getTargetY();
				teleportList[x].setXPos(tempY);
				teleportList[x].setYPos(Width-tempX-1);
				teleportList[x].setTarget(tempTargetY, Width-tempTargetX -1);
			}
			recalcPositions();

			Width = tempWidth;
			Height = tempHeight;
			mapList = mapListTemp;
			populateMapImages();
			rebuildMapClip();
		}
		
		
		public function verifyCameraCenter():Boolean
		{
			// this function should be run after other functions, it effectively checks
			// to see if the board should be centered in any direction

			// with the new camera centering, i'm not sure if this is really even needed
			// it doesn't seem to be breaking anything soo... i'm not going to touch it

			//recalcPositions();
			//int centerpointX = (int)screenWidth/2;
			//int centerpointY = (int)(screenHeight - interfaceHeight)/2;

			//// now lets see if this board should be centered or not
			//if(overallWidth < screenWidth)
			//{
			//	// center horizontally
			//	mapOffsetX = centerpointX - (int)overallWidth/2;
			//}
			//
			//if(overallHeight < screenHeight)
			//{
			//	// center vertically
			//	mapOffsetY = centerpointY - (int)overallHeight/2;
			//}
			//recalcPositions();
			return true;
		}
		
		public function recalcPositions()
		{	
			// recalculate image width/height with current scale
			imageWidth = imageBaseWidth * scale;
			imageHeight = imageBaseHeight * scale;
			//trace("imageWidth/Height = ", imageWidth, ", ", imageHeight);

			// recalc half width/height
			hw = imageWidth/2;
			hh = imageHeight / 2;
			//trace ("hh/hw = ", hh, ", ", hw);

			// recalc overall width and height
			overallWidth = (((Height + Width) * hw) + hw);
			overallHeight = (((Height + Width) * hh) + hh);
			//trace ("overall Width/Height = ", overallWidth, ", ", overallHeight);

			//moveSpeed = scale * 0.1;	

			// setting offsetx based on camera center spot
			// start at the center of the screen
			// if the screen is not centering properly, look here
			
			// old code
			//mapOffsetX = (screenWidth/2) + (hw*currentY) - (hw*currentX) - hw*2;
			//mapOffsetY = (screenHeight / 2) - (hh * currentY) - (hh * currentX) - hh;
			mapOffsetX = (screenWidth/2) + (hw*currentY/2) - (hw*currentX/2) - hw;
			mapOffsetY = (screenHeight / 2) - (hh * currentY/2) - (hh * currentX/2) + hh - (hh*2);
			
			//trace ("Current X/y = ", currentX, currentY);
			//trace ("screen width/height = ", screenWidth, ", ", screenHeight);
			//trace ("map offset x/y = ", mapOffsetX, ", ", mapOffsetY);
		}
		
		public function verifyCameraPositionX():Boolean
		{
			// if they have moved the camera beyond the gameboard
			// return a failure
			//std::cout << "Camera X = " << currentX << endl;
			if(currentX > Width)	
			{
				currentX = Width;
				return false;
			}
			else if(currentX < 0)
			{
				currentX = 0;
				return false;
			}
			return true;
		}

		public function verifyCameraPositionY():Boolean
		{
			// if they have moved the camera beyond the gameboard
			// return a failure
			//std::cout << "Camera Y = " << currentY << endl;
			if(currentY > Height)	
			{
				currentY = Height;
				return false;
			}
			else if(currentY < 0)
			{
				currentY = 0;	
				return false;
			}
			return true;
		}
		
		public function processSwitch()
		{
			// this function should NEVER be called other than by the update code
			// switches adjust at the same rate that the robot moves
			// all this code needs to do is change the currentx/y to match a switch
			// then toggle the switch
			// two cycles per switch, one pre, one post
			
			currentX = myGameVar.SM.getCurrentTargetX(robotX, robotY);
			currentY = myGameVar.SM.getCurrentTargetY(robotX, robotY);
			
			if(!switchToggled)
			{
				// since this is the pre state, we just need to find out where this switch's next target is and set currentx/y to it
				
				switchToggled = true;
			}
			else
			{
				mapList[myGameVar.SM.getCurrentTargetX(robotX, robotY)][myGameVar.SM.getCurrentTargetY(robotX, robotY)].toggleActive();
				myGameVar.SM.advanceTarget(robotX, robotY);
				switchToggled = false;
				// now in this state, we need to toggle it one single time and set the currentx/y to our position

			}
			if(myGameVar.SM.doneProcessing())
			{
				switchInProgress = false;
			}
		}
		
		public function processDSwitch()
		{
			// this function should NEVER be called other than by the update code
			// switches adjust at the same rate that the robot moves
			// all this code needs to do is change the currentx/y to match a switch
			// then toggle the switch
			// two cycles per switch, one pre, one post
			
			currentX = myGameVar.SMD.getCurrentTargetX(robotX, robotY);
			currentY = myGameVar.SMD.getCurrentTargetY(robotX, robotY);
			
			if(!DswitchToggled)
			{
				// since this is the pre state, we just need to find out where this switch's next target is and set currentx/y to it
				//trace("dswitchtoggled wasn't true, going to set it to true now");
				DswitchToggled = true;
				//trace("success on setting dswitchtoggled to true");
			}
			else
			{
				//trace("dswitchtoggled was true, we're going to set the tile type of map location ", myGameVar.SMD.getCurrentTargetX(robotX, robotY), ", ", myGameVar.SMD.getCurrentTargetY(robotX, robotY), " to type ", myGameVar.SMD.getCurrentTargetType(robotX, robotY).toInt());
				mapList[myGameVar.SMD.getCurrentTargetX(robotX, robotY)][myGameVar.SMD.getCurrentTargetY(robotX, robotY)].setType(myGameVar.SMD.getCurrentTargetType(robotX, robotY));
				
				//trace ("now we're going to advance the target");
				myGameVar.SMD.advanceTarget(robotX, robotY);
				
				//trace ("and now we're going to set dswitchtoggled to false");
				DswitchToggled = false;
				// now in this state, we need to toggle it one single time and set the currentx/y to our position

			}
			if(myGameVar.SMD.doneProcessing())
			{
				//trace("smd doneprocessing returned true, setting dswitchinprogress to false");
				DswitchInProgress = false;
			}
		}

		public function getReprogramHit():Boolean
		{
			return reprogramHit;
		}

		public function setReprogramHit(newStatus:Boolean)
		{
			reprogramHit = newStatus;
		}

		public function resetZoom()
		{
			scale = 1.45;
		}
		
		
		private function populateMapImages()
		{
			// we are going to build a vector full of movieclips
			// so lets make ourselves a new array yay
			// first lets empty out the old array

			if (mapListImages.length > 0)
			{
				for (var xx:int = 0; xx < mapListImages.length; xx++)
				{
					if (mapListImages[xx].length > 0)
					{
						for (var yy:int = 0; yy < mapListImages[xx].length; yy++)
						{
							delete(mapListImages[xx][yy]);
						}
					}
				}
			}
			
			mapListImages = new Array();
			var tempCols:Array;
			
			var tileClip:MovieClip;
			
			//trace ("populating map images at width/height of ", Width, Height);
			// first the columns (x)
			if (mapList.length < Width)
			{
				trace("Map failed to load properly");
				return;
			}
			
			for (var x:int = 0; x < Width; x++)
			{
				if (mapList[x].length < Height)
				{
					trace("Map failed to load properly");
					return;
				}
				
				tempCols = new Array();
				// now the rows
				for (var y:int = 0; y < Height; y++)
				{
					tileClip = new GenericTileContainer();
					
					// now for the horribly ugly messy code that sucks
					//trace("about to add a tile of type ", mapList[x][y].getType().toInt(), " to the mapList");
					switch(mapList[x][y].getType().toInt())
					{
						case 0:
							if (mapList[x][y].getIsActive())			{	tileClip.addChild(new TEmptyABG());	}
							else									{	tileClip.addChild(new TEmptyIBG());	}
							break;
							
						case 1:
							if (mapList[x][y].getIsActive())			{	tileClip.addChild(new TDefaultABG());	}
							else									{	tileClip.addChild(new TDefaultIBG());	}
							break;
							
						case 2:
							if (mapList[x][y].getIsActive())			{	tileClip.addChild(new TRaised1ABG());	}
							else									{	tileClip.addChild(new TRaised1IBG());	}
							break;
							
						case 3:
							if (mapList[x][y].getIsActive())			{	tileClip.addChild(new TRaised2ABG());	}
							else									{	tileClip.addChild(new TRaised2IBG());	}
							break;
							
						case 4:
							if (mapList[x][y].getIsActive())			{	tileClip.addChild(new TRaised3ABG());	}
							else									{	tileClip.addChild(new TRaised3IBG());	}
							break;
							
						case 5:
							if (mapList[x][y].getIsActive())			{	tileClip.addChild(new TRaised4ABG());	}
							else									{	tileClip.addChild(new TRaised4IBG());	}
							break;
							
						case 6:
							if (mapList[x][y].getIsActive())			{	tileClip.addChild(new THalfTopLABG());	}
							else									{	tileClip.addChild(new THalfTopLIBG());	}
							break;
							
						case 7:
							if (mapList[x][y].getIsActive())			{	tileClip.addChild(new THalfTopRABG());	}
							else									{	tileClip.addChild(new THalfTopRIBG());	}
							break;
							
						case 8:
							if (mapList[x][y].getIsActive())			{	tileClip.addChild(new THalfBottomLABG());	}
							else									{	tileClip.addChild(new THalfBottomLIBG());	}
							break;
							
						case 9:
							if (mapList[x][y].getIsActive())			{	tileClip.addChild(new THalfBottomRABG());	}
							else									{	tileClip.addChild(new THalfBottomRIBG());	}
							break;
							
						case 10:
							if (mapList[x][y].getIsActive())			{	tileClip.addChild(new TGapABG());	}
							else									{	tileClip.addChild(new TGapIBG());	}
							break;
							
						case 11:
							if (mapList[x][y].getIsActive())			{	tileClip.addChild(new TElectricABG());	}
							else									{	tileClip.addChild(new TElectricIBG());	}
							break;
							
						case 12:
							if (mapList[x][y].getIsActive())			{	tileClip.addChild(new TElectricTLABG());	}
							else									{	tileClip.addChild(new TElectricTLIBG());	}
							break;
							
						case 13:
							if (mapList[x][y].getIsActive())			{	tileClip.addChild(new TElectricTRABG());	}
							else									{	tileClip.addChild(new TElectricTRIBG());	}
							break;
							
						case 14:
							if (mapList[x][y].getIsActive())			{	tileClip.addChild(new TElectricBLABG());	}
							else									{	tileClip.addChild(new TElectricBLIBG());	}
							break;
							
						case 15:
							if (mapList[x][y].getIsActive())			{	tileClip.addChild(new TElectricBRABG());	}
							else									{	tileClip.addChild(new TElectricBRIBG());	}
							break;
							
						case 16:
							if (mapList[x][y].getIsActive())			{	tileClip.addChild(new TIceABG());	}
							else									{	tileClip.addChild(new TIceIBG());	}
							break;
							
						case 17:
							if (mapList[x][y].getIsActive())			{	tileClip.addChild(new TWaterABG());	}
							else									{	tileClip.addChild(new TWaterIBG());	}
							break;
							
						case 18:
							if (mapList[x][y].getIsActive())			{	tileClip.addChild(new TSwitchTLABG());	}
							else									{	tileClip.addChild(new TSwitchTLIBG());	}
							break;
							
						case 19:
							if (mapList[x][y].getIsActive())			{	tileClip.addChild(new TSwitchTRABG());	}
							else									{	tileClip.addChild(new TSwitchTRIBG());	}
							break;
							
						case 20:
							if (mapList[x][y].getIsActive())			{	tileClip.addChild(new TSwitchBLABG());	}
							else									{	tileClip.addChild(new TSwitchBLIBG());	}
							break;
							
						case 21:
							if (mapList[x][y].getIsActive())			{	tileClip.addChild(new TSwitchBRABG());	}
							else									{	tileClip.addChild(new TSwitchBRIBG());	}
							break;
							
						case 22:
							if (mapList[x][y].getIsActive())			{	tileClip.addChild(new TSwitchABG());	}
							else									{	tileClip.addChild(new TSwitchIBG());	}
							break;
							
						case 23:
							if (mapList[x][y].getIsActive())			{	tileClip.addChild(new TProgramTLABG());	}
							else									{	tileClip.addChild(new TProgramTLIBG());	}
							break;
							
						case 24:
							if (mapList[x][y].getIsActive())			{	tileClip.addChild(new TProgramTRABG());	}
							else									{	tileClip.addChild(new TProgramTRIBG());	}
							break;
							
						case 25:
							if (mapList[x][y].getIsActive())			{	tileClip.addChild(new TProgramBLABG());	}
							else									{	tileClip.addChild(new TProgramBLIBG());	}
							break;
							
						case 26:
							if (mapList[x][y].getIsActive())			{	tileClip.addChild(new TProgramBRABG());	}
							else									{	tileClip.addChild(new TProgramBRIBG());	}
							break;
							
						case 27:
							if (mapList[x][y].getIsActive())			{	tileClip.addChild(new TProgramABG());	}
							else									{	tileClip.addChild(new TProgramIBG());	}
							break;
							
						case 28:
							if (mapList[x][y].getIsActive())			{	tileClip.addChild(new TBreakableTLABG());	}
							else									{	tileClip.addChild(new TBreakableTLIBG());	}
							break;	
							
						case 29:
							if (mapList[x][y].getIsActive())			{	tileClip.addChild(new TBreakableTRABG());	}
							else									{	tileClip.addChild(new TBreakableTRIBG());	}
							break;	
							
						case 30:
							if (mapList[x][y].getIsActive())			{	tileClip.addChild(new TBreakableBLABG());	}
							else									{	tileClip.addChild(new TBreakableBLIBG());	}
							break;	
						
						case 31:
							if (mapList[x][y].getIsActive())			{	tileClip.addChild(new TBreakableBRABG());	}
							else									{	tileClip.addChild(new TBreakableBRIBG());	}
							break;	
							
						case 32:
							if (mapList[x][y].getIsActive())			{	tileClip.addChild(new TSolidABG());	}
							else									{	tileClip.addChild(new TSolidIBG());	}
							break;
							
						case 33:
							if (mapList[x][y].getIsActive())			{	tileClip.addChild(new TBreakableABG());	}
							else									{	tileClip.addChild(new TBreakableIBG());	}
							break;
							
						case 34:
							if (mapList[x][y].getIsActive())			{	tileClip.addChild(new TStartABG());	}
							else									{	tileClip.addChild(new TStartIBG());	}
							break;
							
						case 35:
							if (mapList[x][y].getIsActive())			{	tileClip.addChild(new TEndABG());	}
							else									{	tileClip.addChild(new TEndIBG());	}
							break;
							
						case 36:
							if (mapList[x][y].getIsActive())			{	tileClip.addChild(new TDoorTLABG());	}
							else									{	tileClip.addChild(new TDoorTLIBG());	}
							break;
							
						case 37:
							if (mapList[x][y].getIsActive())			{	tileClip.addChild(new TDoorTRABG());	}
							else									{	tileClip.addChild(new TDoorTRIBG());	}
							break;
							
						case 38:
							if (mapList[x][y].getIsActive())			{	tileClip.addChild(new TDoorBLABG());	}
							else									{	tileClip.addChild(new TDoorBLIBG());	}
							break;
							
						case 39:
							if (mapList[x][y].getIsActive())			{	tileClip.addChild(new TDoorBRABG());	}
							else									{	tileClip.addChild(new TDoorBRIBG());	}
							break;
							
						case 40:
							if (mapList[x][y].getIsActive())			{	tileClip.addChild(new TTeleportABG());	}
							else									{	tileClip.addChild(new TTeleportIBG());	}
							break;
					}
					tempCols.push(tileClip);
				}
				mapListImages.push(tempCols);
			}
			rebuildMapClip();						
		}
		
		private function rebuildMapClip()
		{
			var something:int = myMap.numChildren;
			
			for (var x:int = 0; x < something; x++)
			{
				myMap.removeChildAt(0);
			}
			
			// add all the children to the mapclip
			//trace ("Rebuild map of size ", Width, Height);
			for (y = 0; y < Height; y++)
			{
				for (x = 0; x < Width; x++)
				{
					myMap.addChild(mapListImages[x][y]);
					if ((x == robotX) && (y == robotY))
					{
						setRobotImage(myRobot.getDirection());
						myMap.addChild(myRobotImage);
					}
				}
			}
			draw();
		}
		
		private function toggleAllMapTiles()
		{
			trace ("Toggling all map tiles");
			for (var x:int = 0; x < Width; x++)
			{
				for (var y:int = 0; y < Height; y++)
				{
					mapList[x][y].toggleActive();
				}
			}
			populateMapImages();
		}
		
		private function reInjectRobotImage()
		{
			myMap.setChildIndex(myRobotImage, robotX + (Width * robotY) +1 );
			//trace("Robot at index ", myMap.getChildIndex(myRobotImage));
			
			
			
			//myMap.removeChild(myRobotImage);
			//myMap.addChildAt(myRobotImage, robotX + (Width * robotY));
		}		

		public function areYouDoneLoadingAMapFromFile():Boolean
		{
			return doneLoadingMapFromFile;
		}
		
		public function howDidTheRobotDie()
		{
			// since only once can be true, lets set them all to false...
			myGameVar.robotDiedElectricity = false;
			myGameVar.robotDiedGap = false;
			myGameVar.robotDiedWater = false;
			
			// it could have died from standing in water
			if (mapList[robotX][robotY].getType().toInt() == tileEnums.TWater.toInt())
			{
				//trace("robot died from Water");
				myGameVar.robotDiedWater = true;
			}
			
			// or it could have died from standing in a gap
			if (mapList[robotX][robotY].getType().toInt() == tileEnums.TGap.toInt())
			{
				//trace("robot died from gap");
				myGameVar.robotDiedGap = true;
			}
			
			// or maybe it was something electrical
			if (mapList[robotX][robotY].getType().toInt() == tileEnums.TElectric.toInt())
			{
				//trace("robot died from electric");
				myGameVar.robotDiedElectricity = true;
			}
			else if (mapList[robotX][robotY].getType().toInt() == tileEnums.TElectricTL.toInt())
			{
				//trace("robot died from electrictl");
				myGameVar.robotDiedElectricity = true;
			}
			else if (mapList[robotX][robotY].getType().toInt() == tileEnums.TElectricTR.toInt())
			{
				//trace("robot died from electrictr");
				myGameVar.robotDiedElectricity = true;
			}
			else if (mapList[robotX][robotY].getType().toInt() == tileEnums.TElectricBL.toInt())
			{
				//trace("robot died from electricbl");
				myGameVar.robotDiedElectricity = true;
			}
			else if (mapList[robotX][robotY].getType().toInt() == tileEnums.TElectricBR.toInt())
			{
				//trace("robot died from electricbr");
				myGameVar.robotDiedElectricity = true;
			}
		}
		
		public function setRobotDeathAnimation()
		{
			howDidTheRobotDie();
			
			// lets get rid of the living robot
			var tempClip:MovieClip;
			if (myRobotImage.numChildren > 0)
			{
				myRobotImage.removeChildAt(0);
			}
			
			if (myGameVar.robotDiedElectricity)
			{
				// if it died from electricty do something
				if (!myRobotImage.contains(diedElectricity))
				{
					myRobotImage.addChild(diedElectricity);
				}
			}
			else if (myGameVar.robotDiedGap)
			{
				// if it died from a gap... do this stuff
				if (!myRobotImage.contains(diedGap))
				{
					myRobotImage.addChild(diedGap);
				}
			}
			else if (myGameVar.robotDiedWater)
			{
				// if it died from water do this stuff
				if (!myRobotImage.contains(diedWater))
				{
					myRobotImage.addChild(diedWater);
				}
			}
			else
			{
				// somehow its dead but didn't die from anything
				trace("ROBOT DIED FROM NOTHING");
			}
			reInjectRobotImage();
			update();
		}
		
		public function resetRobotImage()
		{
			
			setRobotImage(myRobot.getDirection());
			reInjectRobotImage();
		}
		
		public function zoomToHeight(newHeight:Number)
		{
			// we're going to see if the overall height is larger or smaller than the specified height
			// then we're going to start zooming in or out accordingly
			//trace("Current width/height of the mapclip is ", myMap.width, ", ", myMap.height);
			//trace("requested height was ", newHeight);
			if (myMap.height < newHeight)
			{
				//trace ("since we're too short, lets start making this larger....");
				// we need to start zooming in
				while (myMap.height < newHeight)
				{
					//trace ("since we're still too short, lets start making this larger....");
					scale += 0.05;
					draw();
					//trace("Now the width/height of the mapclip is ", myMap.width, ", ", myMap.height);
				}
				
			}
			else if (myMap.height > newHeight)
			{
				//trace ("since we're too tall, lets start making this smaller....");
				// we need to start zooming out
				while (myMap.height > newHeight)
				{
					//trace ("since we're still too tall, lets start making this smaller....");
					scale -= 0.05;
					draw();
					//trace("Now the width/height of the mapclip is ", myMap.width, ", ", myMap.height);
				}
			}
			
		}
		
		public function setPosition(xPos:int, yPos:int)
		{
			myMap.x = xPos;
			myMap.y = yPos;
		}
		
		///////////// functions start before this
	}
}
