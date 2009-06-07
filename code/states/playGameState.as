package code.states
{
	// 99
	import adobe.utils.CustomActions;
	import code.enums.GameBoardStateEnum;
	import flash.display.MovieClip;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import code.GameState;
	import code.GameStateManager;
	import code.enums.GameStateEnum;
	import code.gameBoard;
	import code.LogicInterface;
	import code.GameVars;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	//____ following 3 import haven't been created yet
	//import code.utility;
	//import code.button;
	//import code.states.SaveGameState;
	import code.states.PauseGameState;
	import code.states.DevLogoState;
	import code.states.MainMenuState;
	import code.states.HelpScreenState;
	// file io imports
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.events.Event;
	// additional text imports
	import flash.text.TextField;
	import flash.text.TextFormat;
	import code.Key;
	import code.enums.ClickOKEnum;
	import code.states.tutorialPopUpState;
	
	
	public class playGameState extends GameState
	{
		var MainMenu:MovieClip = new MENU_mainMenu();
		var deathMC:MovieClip = new MENU_youDied();
		var deathClickPreventionMC:MovieClip = new deathClickPrevention();
		var background:MovieClip = new playgameBG();
		
		var PreGameMC:MovieClip = new GB_PREGAME();
		var ViewScoreMC:MovieClip = new GB_VIEWSCORE();
		
		
		// private class variables
		var gamePlay:gameBoard = new gameBoard();
		var timer:int;
		//dont think we need the next two variables
		var spintimer:int;
		var spintimerStart:int;
		var levelList:Array;
		var endGamePics:Array;
		var endAnimationCounter:int;
		//var myMenu:menuSys;
		//var compass:menuSys;
		var compassOffsetX:int;
		var compassOffsetY:int;
		//var img:texture2D;
		//var blackImage:texture2D;
		//var youDiedImage:texture2D;
		var curState:GameBoardStateEnum;
		var buttonList:Array;
		var gameSaved:Boolean;
		var pregameRunning:Boolean;
		var finishNow:Boolean;
		var finishing:Boolean;
		var pregGameTextOffsetX:int;
		var preGameTextOffsetY:int;
		var preGameTextSpacing:int;
		var preGameTitleDescSpacing:int;
		var playerScore:int;
		var doneDead:Boolean;
		// variable to make sure we only do the dance one time
		var didYouDance:Boolean;
		var playVars:GameVars = GameVars.getInstance();
		var startTime:int;
		var viewScoreAdd:Boolean;
		var prePostBG:MovieClip = new MENU_playGameStuff();
		
		
		//text variable
		var textDisplay:TextField = new TextField();
		var format:TextFormat = new TextFormat();
	
		//public member variables
		public var mInterface:LogicInterface = new LogicInterface();
		var diedTimer:Timer = new Timer(500, 1);
		
		
		//================================
		// Some Timer Code.. Wee
		var preGameTimer:Timer = new Timer(5000, 1);
		var isPreGameTimerRunning:Boolean = false;
		
		var robotIsDeadTimer:Timer = new Timer(3000, 1);
		var isRobotDeadTimerRunning:Boolean = false;
		
		var alreadyLoadedLogicInstructions:Boolean = false;
		
		
		public function playGameState(gsm:GameStateManager)
		{
			// this calls gamestate's default constructor and sets up the proper GSM assignment
			super(gsm); // <-- Calls the base class constructor to make sure all the setup shit happens.
			initialize();
		}
		
		
		public function DplayGameState():void
		{
			var numLevels:int = levelList.length;
			
			for (var itr:int = 0; itr < numLevels; itr++)
			{
				levelList.pop();
			}
			//delete levelList;
		}
		
		public override function initMouse()
		{
			// We have to init our children's event listeners 
			// after the construtor (here) --Corwin
			
			stage.addEventListener("launchHelpState", launchHelpState);
			stage.addEventListener("playGameSpeedUp", speedUp);
			stage.addEventListener("playGameSlowDown", slowDown);
			
			// compass function pointers
			stage.addEventListener("playGamePanUp", panUp);
			stage.addEventListener("playGamePanUpLeft", panUpLeft);
			stage.addEventListener("playGamePanUpRight", panUpRight);
			stage.addEventListener("playGamePanDown", panDown);
			stage.addEventListener("playGamePanDownLeft", panDownLeft);
			stage.addEventListener("playGamePanDownRight", panDownRight);
			stage.addEventListener("playGamePanLeft", panLeft);
			stage.addEventListener("playGamePanRight", panRight);
			stage.addEventListener("playGameCenter", center);
			
			stage.addEventListener("playGameZoomIn", zoomIn);
			stage.addEventListener("playGameZoomOut", zoomOut);
			stage.addEventListener("playGameRotateLeft", rotateMapLeft);
			stage.addEventListener("playGameRotateRight", rotateMapRight);
			
			stage.addEventListener("optionsButtonClicked", optionsButtonClick);
			
			stage.addEventListener("skipButtonClicked", deleteBoard);
			//stage.addEventListener("newPlayGameState", bringDownTheHouse);
			stage.addEventListener("skipLevel", skipLevel);
		}
		
		//public function bringDownTheHouse(e:Event)
		//{
			//GSM.addGameState(new playGameState(GSM));
			//gameplay.setState(GameBoardStateEnum.GB_PREGAME);
			//stage.dispatchEvent(new Event("skipButtonClicked"));
			// then delete the level select menu
			//this.setStatus(GameStateEnum.DELETE_ME);
			//
			// i had it as...
			// curstate = GameBoardstateEnum.GB_PREGAME;
			// gameplay.setState(curState);
			// stage.dispatchEvent(new Event("skipButtonClicked"));
			// stage.dispatchEvent(new Event("skipButtonClicked"));
		//}
		//
		
		public function skipLevel(e:Event)
		{
			viewScoreAdd = false;
			// set state to pregame
			curState = GameBoardStateEnum.GB_FINISHED;
			gamePlay.setState(curState);
			
			// if a gameboard exists, nuke it 
			if (this.contains(gamePlay));
			{
				this.removeChild(gamePlay);
			}
			
			// if interface exists, nuke it...  (this is for the purpose of making the info and skip tutorial buttons vanishing after tutorials
			if ( (this.contains(mInterface)));
			{
				this.removeChild(mInterface);
			}
			mInterface = new LogicInterface();
			
			// create a new game board
			gamePlay = new gameBoard();
			
			// load the map for the appropriate level
			gamePlay.loadMapFromFile(playVars.getFilename(playVars.getCurrentLevel()));
			// add game board to the scene
			//this.addChild(gamePlay);
			// set it to draw behind everything
			//if (this.getChildIndex(gamePlay) != 0)
			//{
				//this.setChildIndex(gamePlay, 0);
			//}
			
			gamePlay.update();
			gamePlay.draw();
		}
		
		public function draw():void
		{
			//var curState:GameBoardStateEnum;
			//
			//var tempString:String;
			//var offsetAmt:int = 0;
			//var textString:String;
			//clock_t startTime;
			//var tempInt:int;
			//var fadeToBlack:texture2D = new texture2D();
			//var textspacing:int = 30;
			//var speed:int;// = gamePlay.getProcessSpeed();
			//var viewscoretext:int = backgroundImage.mY+50;
			//var speedAdjust:int;
			//
			//did you know variables
			//var tY:int = 600;
			//var tYspace:int = 20;
			//var tAmt:int = 0;
			//var didYouKnowParsed:Array;
			//var didYouKnowCounter:int;
			//
			//
//
			//curState = gamePlay.getCurState();
			//switch(curState.toInt())
			//{
			//case GameBoardStateEnum.GB_LOGICVIEW.toInt():
				//gamePlay.draw();
				//mInterface.Draw();
				//drawLevelInfo();
				//compass.Draw();
				//
				//display starting speed
				//playVars.fontArial12.drawText(258, 650, "Speed: ");
				//textString = "";
				//speedAdjust = (1100 - speed);
				//textString << speedAdjust.toString << " MHZ";
				//display text string here
				//textDisplay.text = textString;
				//textDisplay.width = textDisplay.textWidth;
				//textDisplay.height = textDisplay.textHeight;
				//
				//format.size = 12;
				//format.font = "Digital";
				//format.leading = -14;
				//playVars.fontDigital12.drawText(258, 670, textString);
				//break;
//
			//case GameBoardStateEnum.GB_EXECUTION.toInt():
				//gamePlay.draw();
				//mInterface.Draw();
				//drawLevelInfo();
				//compass.Draw();
//
				//display current speed
				//playVars.fontArial12.drawText(258, 650, "Speed: ");
				//textString = "";
				//speedAdjust = (1100 - speed);
				//textString << speedAdjust.toString << " MHZ";
				//playVars.fontDigital12.drawText(258, 670, tempString);
				//break;
			//case GameBoardStateEnum.GB_PREGAME.toInt():
//
				//clearBackground();
//
				//logoImage.drawImage();
				//backgroundImage.drawImage();
//
				//glColor3ub(0, 0, 0);
//
				//player name
				//tempString = "Player Name: ";
				//tempString += playVars.PM.getPlayerName();
				//playVars.fontArial24.drawText(preGameTextOffsetX, preGameTextOffsetY + offsetAmt*preGameTextSpacing, tempString);
				//offsetAmt++;
//
				//level name
				//tempInt = playVars.getCurrentLevel();
				//tempString = playVars.getLevelName(tempInt);
//
				//offsetAmt += playVars.fontArial24.drawText(preGameTextOffsetX, preGameTextOffsetY + offsetAmt*preGameTextSpacing, tempString, 48);
//
				//level description
				//offsetAmt += playVars.fontArial18.drawText(preGameTextOffsetX, preGameTextOffsetY + offsetAmt*preGameTextSpacing, playVars.getDesc(tempInt), 48);
//
				//bytes available
				//tempString = "Bytes Available: ";
				//textString = "";
				//tempInt = playVars.getCurrentLevelBytes();
				//textString = tempInt.toString();
				//playVars.fontArial18.drawText(preGameTextOffsetX, preGameTextOffsetY + offsetAmt*preGameTextSpacing, tempString);
				//offsetAmt++;
				//
				//did you know
				//playVars.fontArial16.drawText(preGameTextOffsetX, tY+ (tAmt*tYspace), "Did You Know:");
				//tAmt++;
			//
				//didYouKnowCounter = 0;
				//
				//for(;didYouKnowCounter < didYouKnowParsed.length; didYouKnowCounter++)
				//{
					//playVars.fontArial16.drawText(preGameTextOffsetX, tY+ (tAmt*tYspace), (*dykItr).c_str());
					//tAmt++;
				//}
				//break;
//
			//case GameBoardStateEnum.GB_ROBOTDIED.toInt():
				 //gl shit that may or may not be needed for font stuff, we shall find out shortly
				//clearBackground();
				//glutSwapBuffers();
			//	glEnable(GL_TEXTURE_2D);
			//	glEnable(GL_BLEND);
//
				///*glColor3ub(255, 0, 0);
//
				//glBlendFunc(GL_SRC_ALPHA,GL_ONE_MINUS_SRC_ALPHA);*/
//
				// player name
				//playVars.fontDigital200.drawText(150 + rand()%15, 250 + rand()%15, "YOU DIED");
				//youDiedImage.mX = rand()%15;
				//youDiedImage.mY = rand()%15;
				//youDiedImage.drawImage();
				//break;
//
			//case GameBoardStateEnum.GB_VIEWSCORE.toInt():
				//clearBackground();
				//logoImage.drawImage();
				//backgroundImage.drawImage();
				//
				//if(myMenu != NULL)
				//	myMenu.Draw();
//
				//glColor3ub(0, 0, 0);
				//
				// level name
				//tempString = "Congratulations! Level Complete!";
				//playVars.fontArial32.drawText(150, viewscoretext+ offsetAmt*textspacing, tempString);
				//offsetAmt++;
				//offsetAmt++;
				//offsetAmt++;
//
				// level name
				//tempInt = playVars.getCurrentLevel();
				//tempString = playVars.getLevelName(tempInt);
//
				//offsetAmt += playVars.fontArial18.drawText(200, viewscoretext+ offsetAmt*textspacing, tempString, 45);
//
				// level description
				//tempString = playVars.getDesc(tempInt);
				// description
			//	offsetAmt += playVars.fontArial18.drawText(200, viewscoretext+ offsetAmt*textspacing, tempString, 45);
				//offsetAmt++;
//
				//
//
				// bytes used
				//textString = "";
				//textString = "BYTES USED: ";
				//tempInt = playVars.getBytesUsed(); // this should get the bytes used value
				//textString += tempInt.toString();
				//playVars.fontArial24.drawText(200, viewscoretext+ offsetAmt*textspacing, tempString);
				//offsetAmt++;
//
				// commands used
				//textString = "";
				//textString = "COMMANDS PROCESSED: ";
				//tempInt = playVars.totalCommandsProcessed;
				//textString += tempInt.toString();
				//playVars.fontArial24.drawText(200, viewscoretext+ offsetAmt*textspacing, tempString);
				//offsetAmt++;
				//
				// level score
				//textString = "";
				//textString = "YOUR LEVEL SCORE: ";
				//tempInt = playVars.getLevelScore();
				//textString += tempInt.toString();
				//playVars.fontArial24.drawText(200, viewscoretext+ offsetAmt*textspacing, tempString);
				//offsetAmt++;
//
				// TOTAL SCORE
				//textString = "";
				//textString = "YOUR TOTAL SCORE: ";
				//tempInt = playVars.getTotalScore();
				//tempString += tempInt.toString();
				//playVars.fontArial24.drawText(200, viewscoretext+ offsetAmt*textspacing, tempString);
				//offsetAmt++;
				//
				//if(myMenu != NULL)
					//myMenu.Draw();
				//mInterface.Draw();
				//break;
//
			//case GameBoardStateEnum.GB_FINISHED.toInt():
				//gamePlay.draw();
			//	mInterface.Draw();
				//break;
//
			//case GameBoardStateEnum.GB_YOUWIN.toInt():
				//doEndGameDraw();
				//break;
//
			//default:
				//break;
			//}
		}

		private function drawLevelInfo():void
		{
			var tempString:String;
			var playerCurrentLevel:int;
				
			var textOffsetX:int = 10;
			var textOffsetY:int = 10;
			var textSpacing:int = 20;
			var offsetAmt:int = 0;
	
//
			//blackImage.mX = 0;
			//blackImage.mY = 0;
			//blackImage.drawImageFaded(0.75, 1024, 85);
			//
			//glColor3ub(255, 0, 0);
			//glBlendFunc(GL_SRC_ALPHA,GL_ONE_MINUS_SRC_ALPHA);
//

			//this wont work if we're coming in out of a level select
			playerCurrentLevel = playVars.getCurrentLevel();

			var levelNumText:String;

			//levelNumText << "Level " << playerCurrentLevel.toString() << " - " << playVars.getLevelName(playerCurrentLevel);
			//offsetAmt += playVars.fontArialRed14.drawText(textOffsetX, textOffsetY + offsetAmt*textSpacing, levelNumText.str(), 87);


			// description
			tempString = playVars.getDesc(playerCurrentLevel);
			//offsetAmt += playVars.playVars.fontArialRed14.drawText(textOffsetX, textOffsetY + offsetAmt*textSpacing, tempString, 87);
			
		}
		
		private function panUp(e:Event)
		{
			gamePlay.panup();
			return;
		}
		
		private function panDown(e:Event)
		{
			gamePlay.pandown();
			return;
		}
		
		private function panLeft(e:Event)
		{
			gamePlay.panleft();
			return;
		}
		
		private function panRight(e:Event)
		{
			gamePlay.panright();
			return;
		}
		
		private function panUpLeft(e:Event)
		{
			gamePlay.panupleft();
			return;
		}
		
		private function panUpRight(e:Event)
		{
			gamePlay.panupright();
			return;
		}
		
		private function panDownLeft(e:Event)
		{
			gamePlay.pandownleft();
			return;
		}
		
		private function panDownRight(e:Event)
		{
			gamePlay.pandownright();
			return;
		}
		
		private function zoomOut(e:Event)
		{
			gamePlay.zoomout();
			return;
		}
		
		private function zoomIn(e:Event)
		{
			gamePlay.zoomin();
			return;
		}
		
		private function rotateMapLeft(e:Event)
		{
			gamePlay.rotateMapLeft();
			return;
		}
		
		private function rotateMapRight(e:Event)
		{
			gamePlay.rotateMapRight();
			return;
		}
		
		private function center(e:Event)
		{
			gamePlay.center();		
			gamePlay.resetZoom();
			return;
		}
		
		private function optionsButtonClick(e:Event)
		{
			//trace ("option button click firing inside playgame");
			GSM.addGameState(new PauseGameState(GSM));
			this.setStatus(GameStateEnum.PASSIVE);
			return;
		}
		
		private function speedUp(e:Event)
		{
			var speed:int = gamePlay.getProcessSpeed();

			//speed up the process time by lowering the timer
			// make sure it doesn't get so fast the user can't tell what's going on
			if(speed >= 200)
			{
				speed -= 100;
			}
			else if(speed == 100)
			{
				speed = 50;
			}
			else if(speed == 50)
			{
				speed = 25;
			}
			else if(speed == 25)
			{
				speed = 10;
			}

			// set the speed to the newly altered value
			gamePlay.setProcessSpeed(speed);
		}
	
		private function slowDown(e:Event)
		{
			// get the current game speed
			var speed:int;
			speed = gamePlay.getProcessSpeed();

			//slow down the process time by raising the timer
			if(speed == 10)
			{
				speed = 25;
			}
			else if (speed == 25)
			{
				speed = 50;
			}
			else if(speed == 50)
			{
				speed = 100;
			}
			else
			{
				speed += 100;
			}

			// make sure it doesn't get too slow
			if(speed > 1000)
			{
				speed = 1000;
			}

			
			// set the speed to the newly altered value
			gamePlay.setProcessSpeed(speed);
		}
		
		private function launchHelpState(e:Event):Boolean
		{
			GSM.addGameState(new HelpScreenState(GSM));
			return true;
		}

		
		//public functions
		public function initialize():Boolean
		{
			//setup the button functionability for the view score state
			ViewScoreMC.replayLevelButton.addEventListener(MouseEvent.MOUSE_UP, replayLevel);
			ViewScoreMC.exitButton.addEventListener(MouseEvent.MOUSE_UP, exitGame);
			ViewScoreMC.advanceButton.addEventListener(MouseEvent.MOUSE_UP, advance);
			deathMC.addEventListener(MouseEvent.MOUSE_UP, deathClick);
			
			//setup and initialize variables
			finishNow = false;
			finishing = false;
			var tempString:String;
			var playerCurrentLevel:int;
			
			//youDiedImage = new texture2D();
			//youDiedImage.loadImage("youdied.png", 1024, 768):
			
			doneDead = false;

			gamePlay = new gameBoard();

			//check to see if a level has been specified (initialized to -1)
			playerCurrentLevel = playVars.getLevelSpecified();
			if(playerCurrentLevel < 0)
			{
				//if a level has not been specified, set to max level
				playerCurrentLevel = playVars.getPlayerMaxLevel();
			}

			playVars.setLevel(playerCurrentLevel);
			//playVars.setLevelSpecified( -1);
			//until profile manager is setup, this is being hardcoded as level one below
			//abcxyz
			playerCurrentLevel = 0;
			playVars.setLevelSpecified(0);
			playVars.setCurrentLevel(0);

			tempString = playVars.getFilename(playerCurrentLevel);
			gamePlay.loadMapFromFile(tempString);
			//gamePlay.loadMapFromFile("additionalContent/maps/testMap1.txt");
			mInterface.GetCurrentMapLogicBank();
			mInterface.GetCurrentLevelBytes();
			
			gamePlay.setState(GameBoardStateEnum.GB_PREGAME);
			curState = GameBoardStateEnum.GB_PREGAME;
			pregameRunning = false;
			gameSaved = false;
			viewScoreAdd = false;

			//display a menu that shows info and contains advance, replay level and exit buttons

			//blackImage = new oglTexture2D();
			//blackImage.loadImage("black.png", 373, 75);

			Update();
			
			return true;			
		}
		
		public override function getStateName():String
		{
			return "playGameState";
		}
		
		public override function Update()
		{
			// get the game state
			//gamePlay.setState(curState);
			curState = gamePlay.getCurState();
			
			// level variables
			var levelCounter:int;
			var tempString:String;
			var tempInt:int;
			var inGameStatus:Boolean;
							

			if (gamePlay.areYouDoneLoadingAMapFromFile())
			{
				// see if the robot is at the end square
				if((gamePlay.robotAtEndSquare())&& (curState.toInt() == GameBoardStateEnum.GB_EXECUTION.toInt()))
				{
					curState = GameBoardStateEnum.GB_VICTORYDANCE;
				}
			}

			// Update mInterface all the time
			//mInterface.Update();
			//compass.Update();
			
			var maxLevel:int;
			
			switch(curState.toInt())
			{
			case GameBoardStateEnum.GB_PREGAME.toInt():
				// if coming from between levels, remove the view score screen
				if (this.contains(ViewScoreMC))
				{
					this.removeChild(ViewScoreMC);
				}
				
				// Set the bool for loading current logic blocks
				alreadyLoadedLogicInstructions = false;
				
				// nuke the previous gameboard if it exists
				if (this.contains(gamePlay))
				{
					this.removeChild(gamePlay);
				}
				
				if(currentStatus.toInt() == GameStateEnum.PASSIVE.toInt())	// waiting for click ok to continue to finish...
				{
					pregameRunning = true;
					gamePlay.setState(GameBoardStateEnum.GB_PREGAME);
				}
				
				if(currentStatus.toInt() == GameStateEnum.ACTIVE.toInt())
				{
					inGameStatus = true;
					playVars.setInGame(inGameStatus);
					gameSaved = false;
					
					//====================================
					// Add the pre-game stuff to the display list
					if (gamePlay.areYouDoneLoadingAMapFromFile())
					{
						if (!this.contains(PreGameMC))
						{
							this.addChild(PreGameMC);
							// Add text fields...
							PreGameMC.playerNameTextBox.text = playVars.getPlayerName();
							PreGameMC.levelNameTextBox.text = playVars.getLevelName(playVars.getCurrentLevel());
							PreGameMC.levelDescriptionTextBox.text = playVars.getDesc(playVars.getCurrentLevel());
							PreGameMC.bytesAvailableTextBox.text = playVars.getCurrentLevelBytes();
							PreGameMC.didYouKnowTextBox.text = playVars.didYouKnow[playVars.didYouKnowIterator];
							
							PreGameMC.addEventListener(MouseEvent.MOUSE_UP, skippingPregame);						
						}
					}
					//====================================
					// Check if the pregame is running,
					// If it is not, start the pregame timer and
					// set the bool for pregame running.
					if (this.isPreGameTimerRunning == false)
					{
						this.isPreGameTimerRunning = true;
						this.preGameTimer.addEventListener(TimerEvent.TIMER_COMPLETE, preGameTimerEnded);
						this.preGameTimer.start();
					}
					
					// reset the bool for the you died text
					doneDead = false;
				}
				break;
			case GameBoardStateEnum.GB_LOGICVIEW.toInt():
					// If the gameboard & logicinterface are not on the display list, add them.
					
					if (!this.contains(gamePlay))
					{
						this.addChild(gamePlay);
						if (this.getChildIndex(gamePlay) != 0)
						{
							this.setChildIndex(gamePlay, 0);
						}
					}
					if (!this.contains(mInterface))
					{
						this.addChild(mInterface);
					}
					
					mInterface.GetCurrentLevelBytes();
					
					// Check to see that gamePlay (the game board) is done loading it's level
					// And we haven't already loaded the interface's instruction list
					// Then load the instruction list.
					if ((gamePlay.areYouDoneLoadingAMapFromFile() == true) && (this.alreadyLoadedLogicInstructions == false))
					{
						mInterface.GetCurrentMapLogicBank();
						alreadyLoadedLogicInstructions = true;
					}
					
					gamePlay.update();
					mInterface.Update();
					
					mInterface.initEventListeners();
					gamePlay.initEventListeners();
			
			
					inGameStatus = true;
					playVars.setInGame(inGameStatus);
					gameSaved = false;
					pregameRunning = false;
					
					updateTextInsideLogicInterface();
					//gamePlay.update();
					//gamePlay.mapScroll();
					break;

			case GameBoardStateEnum.GB_EXECUTION.toInt():
					inGameStatus = true;
					playVars.setInGame(inGameStatus);
					if(!finishNow && !finishing)
					{
						gameSaved = false;
						gamePlay.update();
						gamePlay.mapScroll();
					}
					
					updateTextInsideLogicInterface();
					mInterface.Update();
					
					break;
			case GameBoardStateEnum.GB_ROBOTDIED.toInt():
				if (!doneDead)
				{
					//zoom in on the robot to view animation of death
					gamePlay.zoomToMax();
					
					// fire abort button
					mInterface.fireAbort();
					//add the you died text Menu to the Screen
					doneDead = true;
				}
				
				inGameStatus = true;
				playVars.setInGame(inGameStatus);
				gameSaved = false;
				//why?
				//doneDead = false;
				
				// do animation shit if it isn't on the board already
				// start event timer....
				// lets add ourselves an animation yay
				gamePlay.setRobotDeathAnimation();
				if (!this.contains(deathClickPreventionMC))
				{
					deathClickPreventionMC.x = 0;
					deathClickPreventionMC.y = 0;
					this.addChild(deathClickPreventionMC);
				}
				
				robotIsDeadTimer.addEventListener(TimerEvent.TIMER, finishKillingTheRobot);
				robotIsDeadTimer.start();	
				
				deathMC.x = (screenWidth / 2) - (deathMC.width / 2);
				deathMC.y = (screenHeight / 2) - (deathMC.height / 2);
				//deathMC.y = 0;
				break;
				
			case GameBoardStateEnum.GB_VIEWSCORE.toInt():
				inGameStatus = false;
				playVars.setInGame(inGameStatus);
				//trace("now we're in view score");
				//save the game for the player, if it hasn't been saved yet
				finishNow = false;
				if(!gameSaved)
				{
					playVars.updatePlayerFile();
					gameSaved = true;
				}

				//Get the number of bytes user started the level off with and subtract number remaining
				playerScore = playVars.getTotalScore();

				// eventually we will implement an equation here to calculate the score based off percentage 
				// of points used for the level score
				
				// the movie clip needs to be added then..
				if (viewScoreAdd == false)
				{
					this.addChild(ViewScoreMC);
					ViewScoreMC.levelNameTextBox.text = playVars.getLevelName(playVars.getCurrentLevel());
					ViewScoreMC.levelDescriptionTextBox.text = playVars.getDesc(playVars.getCurrentLevel());
					ViewScoreMC.bytesUsedTextBox.text = playVars.getBytesUsed();
					ViewScoreMC.levelScoreTextBox.text = playVars.getLevelScore();
					ViewScoreMC.totalScoreTextBox.text = playVars.getTotalScore();
					
					viewScoreAdd = true;
				}
				
				
				// update the text fields
				
				//myMenu.Update();
				break;

			case GameBoardStateEnum.GB_FINISHED.toInt():
				this.removeChild(gamePlay);
				inGameStatus = false;
				playVars.setInGame(inGameStatus);
				mInterface.ClearExecutionList();
				mInterface.ResetExecutionMode();
				levelCounter = playVars.getCurrentLevel();
				levelCounter++;
				maxLevel = playVars.getMaxLevel();

				if(levelCounter < (playVars.getMaxLevel()))
				{		
					// in with the new
					gamePlay = new gameBoard();		
					tempString = playVars.getFilename(levelCounter);
					tempInt = playVars.getCurrentLevel();
					gamePlay.loadMapFromFile(tempString);
					mInterface.GetCurrentMapLogicBank();
					mInterface.GetCurrentLevelBytes();
					playVars.commandsProcessed = 0;
					playVars.totalCommandsProcessed = 0;
					curState = GameBoardStateEnum.GB_PREGAME;
					playVars.didYouKnowIterator++;

					if(playVars.didYouKnowIterator == playVars.didYouKnow.length)
					{
						playVars.didYouKnowIterator = 0;
					}
				}
				else
				{
					//trace("trying to call you win");
					curState = GameBoardStateEnum.GB_YOUWIN;
					//levelCounter;		// dont think this is necessary	
				}

				playVars.setLevel(levelCounter);
			
				//=====================================================
				// Register the gameBoard callback with the interface!
				//mInterface.SetExecuteHandler(BE::CreateFunctionPointer3R(gamePlay, &gameBoard::interfaceHasFiredExecuteOrder));
				//mInterface.SetAbortHandler(BE::CreateFunctionPointer0R(gamePlay, &gameBoard::interfaceHasFiredAbortOrder));
				//mInterface.SetResetHandler(BE::CreateFunctionPointer0R(gamePlay, &gameBoard::interfaceHasFiredResetOrder));
				//mInterface.SetHelpHandler(BE::CreateFunctionPointer0R(this, &playGame::launchHelpState));
				//mInterface.SetSpeedUpHandler(BE::CreateFunctionPointer0R(this, &playGame::speedUp));
				//mInterface.SetSlowDownHandler(BE::CreateFunctionPointer0R(this, &playGame::slowDown));
				//gamePlay.SetInterfaceAdvanceHandler(BE::CreateFunctionPointer2R(&mInterface, &LogicInterface::CommandAdvanced));
				//gamePlay.SetInterfaceReprogramHandler(BE::CreateFunctionPointer0R(&mInterface, &LogicInterface::ReprogramReached));
				//gamePlay.SetInterfaceClearExecutionListHandler(BE::CreateFunctionPointer0R(&mInterface, &LogicInterface::ClearExecutionList));
	//
				gamePlay.setState(curState);
				pregameRunning = false;
				break;
			case GameBoardStateEnum.GB_YOUWIN.toInt():
				// upload score onto server (when it gets implemented)
				//trace("we are now in you win");
				break;
			case GameBoardStateEnum.GB_VICTORYDANCE.toInt():
				if(!finishing)
				{
					finishing = true;
				}

				//trace("victory dance");
				//timer = clock();
				gamePlay.update();
				// dispatch event to occur after an alotted time...
				//if ((!playVars.getDoneDancing()) && (!playVars.getStartedDancing()))
				if((!playVars.getStartedDancing()) && (!didYouDance))
				{
					//trace("started dancing");
					stage.dispatchEvent(new Event("startDancing"));
					// set that we have dance one time
					didYouDance = true;
				}
				
				// for now lets just make it always happen
				//if(timer > startTime + 2000)
				//if(playVars.getDoneDancing()
				if((playVars.getDoneDancing()) && (!playVars.getStartedDancing()))
				{
					// the dance is over, reset the counter back to zero
					didYouDance = false;
					//trace("done dancing");
					finishing = false;
					finishNow = true;
					curState = GameBoardStateEnum.GB_VIEWSCORE;
					gamePlay.setState(curState);
					playVars.totalCommandsProcessed += playVars.commandsProcessed;
					var scoreToAdd:Number = 0;
					var bytesUsed:int = playVars.getBytesUsed();
					var bytesAvail = playVars.getCurrentLevelBytes();
							
					// happy magical scoring stuff yay

					// for the time being, we're going to add a 10% bonus per level
					// such that at level 1 you get 110% score, level 2 you get  120%
					// and so on and so on capping out at roughly 250% at 15 levels
					// so bust out those subroutines on the higher levels for maximum scorage yay!
					// score bonus is only applied to the memory used portion of the scoring
					// function, the default of 200 base is always default of 200 base so yeah there
					// for shitz n gigglez i'm having it give only 25% bonus on tutorial levels
					// you won't get a whole lot of points on the tutorials
					
					var levelMultiplier:Number = 0.0;
							
					if(playVars.getCurrentLevel() > playVars.getNumTutorialLevels())
					{	
						// if we're in a normal level, do this
						levelMultiplier = playVars.getCurrentLevel() - playVars.getNumTutorialLevels();
						levelMultiplier *= 0.1;  // here's our 10% 
						levelMultiplier += 1;
					}
					else
					{
						levelMultiplier = 0.25;	// 25% for tutorial levels, suck it tutorials
					}
					
					scoreToAdd = ((100 - ((bytesUsed / bytesAvail) * 100)) * 10) * levelMultiplier + 200;

					// sends in your score for the level just completed to be compared against previous attempts
					playVars.setLevelScore(scoreToAdd);
					
					// Get the level score from the level just completed, and add it up with all previous levels completed
					playVars.setTotalScore(playVars.getLevelScore() + playVars.getTotalScore());
				}
					
				//spintimer = clock();
				//if(spintimer > spintimerStart + 200)
				//{
					//gamePlay.spinRobot();
					//spintimerStart = clock();
				//}
				break;

			default:
				break;
			}

			
			if((!gamePlay.getRobotAlive()) && doneDead)
			{
				//mInterface.AbortButtonClick();
				doneDead = false;
				gamePlay.setState(GameBoardStateEnum.GB_LOGICVIEW);
			}

			// ask the gameboard is a reprogrammable square was hit, if so we need to make a popup screen!
			if(gamePlay.getReprogramHit())
			{
				gamePlay.setReprogramHit(false);
				playVars.setPMStatus(ClickOKEnum.REPROGRAM.toInt());
				GSM.addGameState(new clickOKState(GSM));
			}
			//trace("Tutorial hit checking...")
			if (gamePlay.getTutorialHit())
			{
				//trace("End tutorial hit checking");
				gamePlay.setTutorialHit(false);
				//trace("End set tutorial hit");
				mInterface.GetCurrentMapLogicBank();
				GSM.addGameState(new tutorialPopUpState(GSM));
			}
			
			if (!this.contains(background))
			{
				background.x = 0;
				background.y = 0;
				background.width = 1024;
				background.height = 768;
				this.addChild(background);
			}
			else
			{
				if (this.getChildIndex(background) != 0)
				{
					this.setChildIndex(background, 0);
				}			
			}

		}
		public function updateTextInsideLogicInterface()
		{
			var tempSpeed = 1100 - gamePlay.getProcessSpeed();
			mInterface.logicInterfaceMC.speedText.text = tempSpeed + " MHZ";
			
			mInterface.logicInterfaceMC.topLevelNameTextBox.text = playVars.getLevelName(playVars.getCurrentLevel());
			mInterface.logicInterfaceMC.topLevelDescriptionTextBox.text = playVars.getDesc(playVars.getCurrentLevel());
		}
		
		// click event handlers
		public function exitGame(e:MouseEvent)
		{
			//delete this state while creating a Main Menu State
			GSM.addGameState(new MainMenuState(GSM));
			this.setStatus(GameStateEnum.DELETE_ME);

			return;
		}
		
		public function advance(e:MouseEvent)
		{
			viewScoreAdd = false;
			// sets the game state to finished to allow advancement through mini state manager
			curState = GameBoardStateEnum.GB_FINISHED;
			gamePlay.setState(curState);

			return;
		}
		
		public function replayLevel(e:MouseEvent)
		{
			removeAndRebuild();
		}
		
		public function deleteBoard(e:Event)
		{
			removeAndRebuild();
		}
		
		public function removeAndRebuild()
		{
			//trace("entered remove and rebuild");
			
			//setup and initialize variables
			finishNow = false;
			finishing = false;			
			doneDead = false;
			
			// get rid of the view score movie clip, gameboard and interface if they exist
			if (this.contains(ViewScoreMC))
			{
				this.removeChild(ViewScoreMC);
			}
			
			if (this.contains(gamePlay))
			{
				this.removeChild(gamePlay);
			}
			
			if (this.contains(mInterface))
			{
				this.removeChild(mInterface);
			}
			
			
			// if this is only firing as this state is about to be deleted, lets try not re-adding alot of this stuff
			//create a new interface for the recently departed
			mInterface = new LogicInterface();
			
			// Set the bool for loading current logic blocks
			alreadyLoadedLogicInstructions = false;

			// set the boolean variable to false, so the menu stops displaying
			viewScoreAdd = false;
			
			// reset the state to pregame of the current level
			curState = GameBoardStateEnum.GB_FINISHED;
			gamePlay.setState(curState);

			// reset the map for a fresh start for the replay
			gamePlay.resetMap();
			gamePlay.update();

			playVars.updatePlayerFile();

			// is there a way to clear the instruction list?
			// find/use same code as when user clicks clear button on interface
	
			////////////////////
			// complete and total map reset			
			mInterface.ClearExecutionList();
			
			// this next line is crashing somewhere inside of it
			//mInterface.ResetExecutionMode();
		
	
			//create a fresh new one			
			gamePlay = new gameBoard();	

			var levelCounter:int = playVars.getCurrentLevel();
			//trace ("inside of delete board, we are about to set the level to ", playVars.getCurrentLevel());
			var tempString:String = playVars.getFilename(playVars.getCurrentLevel());
			
			gamePlay.loadMapFromFile(tempString);
			mInterface.GetCurrentMapLogicBank();
			mInterface.GetCurrentLevelBytes();

			playVars.commandsProcessed = 0;
			playVars.totalCommandsProcessed = 0;
			//curState = GameBoardStateEnum.GB_FINISHED;
			playVars.didYouKnowIterator++;
	
			if(playVars.didYouKnowIterator == playVars.didYouKnow.length)
			{
				playVars.didYouKnowIterator = 0;
			}
			
			pregameRunning = false;
			gameSaved = false;
			viewScoreAdd = false;

			Update();

			return;			
		}
		
		
		public function deathClick(e:MouseEvent)
		{
			if (this.contains(deathMC))
			{
				this.removeChild(deathMC);
			}
			if (this.contains(deathClickPreventionMC))
			{
				this.removeChild(deathClickPreventionMC);
			}
			gamePlay.resetZoom();
			GameVars.getInstance().setDoNotProcessMouse(false);
		}
		
		public function doEndGameDraw():void
		{
			if(endGamePics.length == 0)
			{
				// load in alot of pictures
				var numPics:int = 45;
			//	var tempPic:texture2D;
				var filename:String;
				var fileNumber:int
				
				for(var x:int = 0; x < numPics; x++)
				{
					// build a variable filename
					fileNumber = x;
					filename = "ending/frames/ending00";
					filename += fileNumber.toString();
					filename += ".png";
					//tempPic = new oglTexture2D;
					//tempPic.loadImage(filename, 1024, 768);
					//endGamePics.push(tempPic);
				}
				endAnimationCounter = 0;
			}
			else
			{
				// iterate through the pictures drawing them
				//(*endGameAnimation).drawImage(0, 0);
				//glColor3ub(0, 0, 0);
				//playVars.fontArial24.drawText(200,  80, "We apologize for the crappy ending,");
				//playVars.fontArial24.drawText(200, 120, "we needed to save space.");
				//playVars.fontArial24.drawText(200, 160, "Press ESC to return to the main menu.");
				endAnimationCounter++;
				if(endAnimationCounter == endGamePics.length)
					endAnimationCounter = 0;
				//timer = clock();
				//startTime = clock();
				//while(timer < startTime + 50)
				//{
					//timer = clock();
				//}		
			}
					
		}

		public function preGameTimerEnded(e:TimerEvent)
		{
			if (isPreGameTimerRunning == true)
			{
				isPreGameTimerRunning = false;
				playVars.commandsProcessed = 0;
				playVars.totalCommandsProcessed = 0; 
				
				// Remove the pre game movie clips from the display list as we
				// transition into logic view
				if (this.contains(PreGameMC))
				{
					this.removeChild(PreGameMC);
				}
				
				gamePlay.setState(GameBoardStateEnum.GB_LOGICVIEW);
				//trace("Setting state to logicview");
			}
		}
		
		public function skippingPregame(e:MouseEvent)
		{
			PreGameMC.removeEventListener(MouseEvent.MOUSE_UP, skippingPregame);
			
			isPreGameTimerRunning = false;
			playVars.commandsProcessed = 0;
			playVars.totalCommandsProcessed = 0; 
			
			// Remove the pre game movie clips from the display list as we
			// transition into logic view
			if (this.contains(PreGameMC))
			{
				this.removeChild(PreGameMC);
			}
			
			gamePlay.setState(GameBoardStateEnum.GB_LOGICVIEW);
			curState = GameBoardStateEnum.GB_LOGICVIEW;
		}
		
		public function finishKillingTheRobot(e:TimerEvent)
		{
			this.addChild(deathMC);
			GameVars.getInstance().setDoNotProcessMouse(true);
			curState = GameBoardStateEnum.GB_LOGICVIEW;
			//mInterface.fireAbort();
		}
				//void processMouse(int x, int y);
				//void processMouseClick(int button, int state, int x, int y);
				//void keyboardInput(unsigned char c, int x, int y);

		///// end functions
	}
}