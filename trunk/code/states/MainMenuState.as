package code.states
{
	import flash.display.MovieClip;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import code.GameState;
	import code.GameStateManager;
	import code.enums.GameStateEnum;
	import code.states.corwinTestState;
	import code.states.clickOKState;
	import code.states.ProfileMgrState;
	import code.states.HelpScreenState;
	import code.GameVars;
	
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.events.Event;
	
	import flash.net.navigateToURL;
    import flash.net.URLRequest;
    import flash.net.URLVariables;
	
	
	public class MainMenuState extends GameState
	{
		var MainMenu:MovieClip = new MENU_mainMenu();
		
		public function MainMenuState(gsm:GameStateManager)
		{
			// this calls gamestate's default constructor and sets up the proper GSM assignment
			super(gsm); // <-- Calls the base class constructor to make sure all the setup shit happens.
			
			MainMenu.x = (screenWidth / 2) - (MainMenu.width / 2);
			MainMenu.y = screenHeight / 2 - (MainMenu.height / 2);
			
			this.addChild(MainMenu);
			MainMenu.startNewGameBtn.addEventListener(MouseEvent.MOUSE_UP, startGameButtonClick);
			//MainMenu.profileManagerBtn.addEventListener(MouseEvent.MOUSE_UP, profileManagerButtonClick);
			//MainMenu.profileManagementBtn.addEventListener(MouseEvent.MOUSE_UP, profileManagerButtonClick);
			//MainMenu.loadGameBtn.addEventListener(MouseEvent.MOUSE_UP, loadGameButtonClick);
			//MainMenu.helpBtn.addEventListener(MouseEvent.MOUSE_UP, helpButtonClick);
			MainMenu.helpBtn.addEventListener(MouseEvent.MOUSE_UP, helpButtonClick);
			MainMenu.creditsBtn.addEventListener(MouseEvent.MOUSE_UP, creditsButtonClick);
			MainMenu.quitBtn.addEventListener(MouseEvent.MOUSE_UP, quitButtonClick);

			//MainMenu.quitBtn.addEventListener(MouseEvent.MOUSE_UP, clickTestClick);
			
			// UNCOMMENT BELOW TO START MUSIC BACK UP
			//GameVars.getInstance().MusicMenusPlay();
		
		}
		
		public override function Update()
		{
			
		}
		
		public override function getStateName():String
		{
			return "MainMenuState";
		}
		
		//===================================
		// Click Event Handlers
		public function startGameButtonClick(e:MouseEvent)
		{
			//GSM.addGameState(new corwinTestState(GSM));
			//GSM.addGameState(new corwinTestState(GSM));
			//GSM.addGameState(new playGameState(GSM));
			GSM.addGameState(new StartNewGameState(GSM));
			this.setStatus(GameStateEnum.DELETE_ME);
		}
		//
		//public function profileManagerButtonClick(e:MouseEvent)
		//{
			//GSM.addGameState(new ProfileMgrState(GSM));
			//this.setStatus(GameStateEnum.DELETE_ME);
		//}
		//public function profileManagerButtonClick(e:MouseEvent)
		//{
			//GSM.addGameState(new ProfileMgrState(GSM));
			//this.setStatus(GameStateEnum.DELETE_ME);
		//}
		
		/*
		public function loadGameButtonClick(e:MouseEvent)
		{
			GSM.addGameState(new GameState(GSM));
			this.setStatus(GameStateEnum.DELETE_ME);
		}*/
		
		
		public function helpButtonClick(e:MouseEvent)
		{
			GSM.addGameState(new HelpScreenState(GSM));
			this.setStatus(GameStateEnum.PASSIVE);
		}
			//GSM.addGameState(new HelpScreenState(GSM));
			//this.setStatus(GameStateEnum.DELETE_ME);
		//}
		
		public function creditsButtonClick(e:MouseEvent)
		{
			GSM.addGameState(new CreditsState(GSM));
			this.setStatus(GameStateEnum.DELETE_ME);
			GameVars.getInstance().MusicStop();
		}
		
		
		public function quitButtonClick(e:MouseEvent)
		{
			GSM.addGameState(new GameState(GSM));
			this.setStatus(GameStateEnum.DELETE_ME);	
			var request:URLRequest = new URLRequest("http://www.braincorps.net");
			navigateToURL(request, "_self");			
		}
		
		
		public function clickTestClick(e:MouseEvent)
		{
			GSM.addGameState(new clickOKState(GSM));
			this.setStatus(GameStateEnum.DELETE_ME);
		}
		
		///////////////// end functions here
	}
}