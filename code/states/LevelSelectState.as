// ********************
// Author: Tom Lindeman
// ********************
package code.states
{
	// import files
	import code.gameBoard;
	import flash.display.MovieClip;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import code.GameState;
	import code.GameStateManager;
	import code.enums.GameStateEnum;
	import code.enums.GameBoardStateEnum;
	import code.GameVars;
	import code.states.MainMenuState;
	import code.states.playGameState;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import code.gameBoard;
	
	public class LevelSelectState extends GameState
	{
		// local variables
		var selectMenu:MovieClip = new MENU_levelSelect();
		var playerCurrentLevel:int;
		var levelList:Array;
		var selectVars:GameVars = GameVars.getInstance();
		var counter:int;
		var levelText:TextField;
		var titleText:TextField;
		var descText:TextField;
		var tFormat:TextFormat;
		
		var gamePlay:gameBoard = new gameBoard();
		var previewHeight:int = 200;
		var previewX:int = 400;	// this number is going to be recalculated later, i'm just specifying a random number here so that we don't have bad data loaded
		var previewY:int = 350;
		
		
		public function LevelSelectState(gsm:GameStateManager)
		{
			// this calls gamestate's default constructor and sets up the proper GSM assignment
			super(gsm); // <-- Calls the base class constructor to make sure all the setup shit happens.
			
			// set the on screen coordinates for the menu
			//selectMenu.x = (screenWidth / 2) - (selectMenu.width / 2);
			//selectMenu.y = screenHeight / 2 - (selectMenu.height / 2);
			selectMenu.x = 0;
			selectMenu.y = 0;
			
			// add the menu to the scene as a child
			this.addChild(selectMenu);
			
			// event listeners for the buttons on the menu
			selectMenu.exitButton.addEventListener(MouseEvent.MOUSE_UP, exitButtonClick);
			selectMenu.selectButton.addEventListener(MouseEvent.MOUSE_UP, selectButtonClick);
			selectMenu.incrementButton.addEventListener(MouseEvent.MOUSE_UP, incrementButtonClick);
			selectMenu.decrementButton.addEventListener(MouseEvent.MOUSE_UP, decrementButtonClick);
			
			// set the counter to the player's max level, so we only allow them to choose levels 
			// they have gotten to. This variable will keep track of which level they select.
			
			//uncomment this for the release version
			//playerCurrentLevel = selectVars.getPlayerMaxLevel();
			
			//comment this out for release version
			playerCurrentLevel = 1;
			
			// initialize the text fields so they can be used
			levelText = new TextField();
			titleText = new TextField();
			descText = new TextField();
			tFormat = new TextFormat();
			
			// set the positions of the text displaying the current level number, max level number,
			// and level description
			levelText.x = 250;				levelText.y = 175;
			titleText.x = 250;				titleText.y = 215;
			descText.x = 250;				descText.y = 255;
			
			
			// add the text fields to the scene as children
			this.addChild(levelText);
			this.addChild(titleText);
			this.addChild(descText);
			
			// level preview stuff
			var tempString:String = GameVars.getInstance().getFilename(playerCurrentLevel);
			//trace("+++ loadMapFromFile is being called inside LEVELSELCTSTATE constructor to load in map ", tempString);
			gamePlay.loadMapFromFile(tempString);
		
			Update();
		}
		
		public override function getStateName():String
		{
			return "LevelSelectState";
		}
		
		public override function Update()
		{
			levelText.text = "Level ";
			levelText.appendText(playerCurrentLevel.toString());
			levelText.appendText(" / ");
			
			//uncomment this for release version
			//levelText.appendText((selectVars.getPlayerMaxLevel()).toString());
			
			//comment this out for release version
			levelText.appendText((selectVars.getMaxLevel() - 1).toString());
			
			titleText.text = selectVars.getLevelName(playerCurrentLevel);
			
			descText.text = selectVars.getDesc(playerCurrentLevel);
			
			// text format information
			tFormat.size = 24;
			tFormat.font = "Arial";
			tFormat.leading = 0;
			tFormat.color = 0x00FF00;
			
			// set the format to all text fields
			levelText.setTextFormat(tFormat);
			levelText.width = 150;
			levelText.height = 100;
			
			titleText.setTextFormat(tFormat);
			titleText.width = 550;
			titleText.height = 100;
			titleText.wordWrap = true;
			
			descText.setTextFormat(tFormat);
			descText.width = 550;
			descText.height = 100;
			descText.wordWrap = true;
			
			if (!this.contains(gamePlay))
			{
				if (gamePlay.areYouDoneLoadingAMapFromFile())
				{
					fixMap();
					this.addChild(gamePlay);
				}
			}
		
			//fixMap();
		}
		
		//===================================
		// Click Event Handlers
		public function selectButtonClick(e:MouseEvent)
		{
			// player has pressed the select button, set the level
			// they selected as the current level and load the game
			selectVars.setLevel(playerCurrentLevel);
			selectVars.setLevelSpecified(playerCurrentLevel);
	
			// then delete the level select menu
			this.setStatus(GameStateEnum.DELETE_ME);
			stage.dispatchEvent(new Event("skipButtonClicked"));
		}		
		
		public function exitButtonClick(e:MouseEvent)
		{
			// delete the menu from the screen and return to the previous screen
			this.setStatus(GameStateEnum.DELETE_ME);
		}
		
		public function incrementButtonClick(e:MouseEvent)
		{
			// increment the level upon click
			playerCurrentLevel++;
			// if the current level to be selected is higher than the player's
			// max level reset it back to one.
			
			//switch if statements back out once finished debugging
			//if (playerCurrentLevel > selectVars.getPlayerMaxLevel())
			if(playerCurrentLevel > (selectVars.getMaxLevel() - 1))
			{
				playerCurrentLevel = 1;
			}
			
			// map preview stuff
			if (this.contains(gamePlay))
			{
				this.removeChild(gamePlay);
			}
			
			var tempString:String = GameVars.getInstance().getFilename(playerCurrentLevel);
			gamePlay = new gameBoard();
			gamePlay.setState(GameBoardStateEnum.GB_PREGAME);
			//trace("+++ loadMapFromFile is being called inside levelselectstate INCREMENTBUTTONCLICK to load in map ", tempString);
			gamePlay.loadMapFromFile(tempString);
			fixMap();
		}
		
		public function decrementButtonClick(e:MouseEvent)
		{
			// decrement the level upon click
			playerCurrentLevel--;
			// if the current level to be selected goes under one, then set
			// the players level to their max level
			if (playerCurrentLevel < 1)
			{
				//switch this line back out once finished debugging
				//playerCurrentLevel = selectVars.getPlayerMaxLevel();
				playerCurrentLevel = selectVars.getMaxLevel() - 1;
			}
			
			// map preview stuff			
			if (this.contains(gamePlay))
			{
				this.removeChild(gamePlay);
			}
			
			gamePlay = new gameBoard();
			var tempString:String = GameVars.getInstance().getFilename(playerCurrentLevel);
			gamePlay.setState(GameBoardStateEnum.GB_PREGAME);
			//trace("+++ loadMapFromFile is being called inside levelselectstate DECREMENTBUTTONCLICK to load in map ", tempString);
			gamePlay.loadMapFromFile(tempString);
			fixMap();
		}
		private function fixMap()
		{
			// lets try some direct manipluation
			var tempWidth:int = gamePlay.width;
			var tempHeight:int = gamePlay.height;
			var ratio:Number = tempWidth / tempHeight;
			gamePlay.height = previewHeight;
			gamePlay.width = (int)(previewHeight * ratio);
			gamePlay.x = (1024 / 2)
			gamePlay.y = previewY;
		}
	}
}


	

	