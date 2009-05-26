package code.states
{
	import code.GameVars;
	import flash.display.MovieClip;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import code.GameState;
	import code.GameStateManager;
	import code.enums.GameStateEnum;
	import code.states.HelpScreenState;
	import code.states.MainMenuState;
	import code.states.LevelSelectState;
	
	public class PauseGameState extends GameState
	{
		var pauseMenu:MovieClip = new MENU_pauseMenu();
		var pauseVars:GameVars = GameVars.getInstance();
		var skipAll:MovieClip = new MENU_skipAllTutorials();
		var transparentBG:MovieClip = new creditsClicker();
		
		public function PauseGameState(gsm:GameStateManager)
		{
			// this calls gamestate's default constructor and sets up the proper GSM assignment
			super(gsm); // <-- Calls the base class constructor to make sure all the setup shit happens.
			
			pauseMenu.x = (screenWidth / 2) - (pauseMenu.width / 2);
			pauseMenu.y = screenHeight / 2 - (pauseMenu.height / 2);
			
			// adding a transparent thing behind this to disallow clicking of other crap
			transparentBG.width = 1024;
			transparentBG.height = 768;
			transparentBG.x = 0;
			transparentBG.y = 0;
			this.addChild(transparentBG);
			
			this.addChild(pauseMenu);
			
			pauseMenu.mainMenuButton.addEventListener(MouseEvent.MOUSE_UP, mainMenuButtonClick);
			pauseMenu.resumeButton.addEventListener(MouseEvent.MOUSE_UP, resumeButtonClick);
			pauseMenu.levelSelectButton.addEventListener(MouseEvent.MOUSE_UP, levelSelectButtonClick);
			pauseMenu.quitButton.addEventListener(MouseEvent.MOUSE_UP, quitButtonClick);
			pauseMenu.helpButton.addEventListener(MouseEvent.MOUSE_UP, helpButtonClick);
			if (pauseVars.getCurrentLevel() < pauseVars.getNumTutorialLevels())
			{
				pauseMenu.skipAllButton.addEventListener(MouseEvent.MOUSE_UP, skipButtonClick);
			}
		}
		
		public override function Update()
		{
			
		}
		
		public override function getStateName():String
		{
			return "PauseGameState";
		}
		
		//===================================
		// Click Event Handlers
		public function mainMenuButtonClick(e:MouseEvent)
		{
			GSM.addGameState(new MainMenuState(GSM));
			GSM.deleteAllButTopState();
			this.setStatus(GameStateEnum.DELETE_ME);
		}
		
		public function resumeButtonClick(e:MouseEvent)
		{
			this.setStatus(GameStateEnum.DELETE_ME);
		}
		
		public function levelSelectButtonClick(e:MouseEvent)
		{
			GSM.addGameState(new LevelSelectState(GSM));
			this.setStatus(GameStateEnum.DELETE_ME);
		}
		
		public function quitButtonClick(e:MouseEvent)
		{
			//GSM.addGameState(new QuitState(GSM));
			this.setStatus(GameStateEnum.DELETE_ME);
		}
		
		public function helpButtonClick(e:MouseEvent)
		{
			GSM.addGameState(new HelpScreenState(GSM));
		}
		
		public function skipButtonClick(e:MouseEvent)
		{
			var level:int = pauseVars.getNumTutorialLevels() + 1;
			pauseVars.setLevel(level);
			pauseVars.setLevelSpecified(level);
			
			// add a new playGame
			GSM.addGameState(new playGameState(GSM));
			// then delete the menu
			this.setStatus(GameStateEnum.DELETE_ME);
			stage.dispatchEvent(new Event("skipButtonClicked"));
		}
	}
}
