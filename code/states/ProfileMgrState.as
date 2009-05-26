package code.states
{
	//*********************
	//Author : Tom Lindeman
	//*********************
	
	import flash.display.MovieClip;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import code.GameState;
	import code.GameStateManager;
	import code.enums.GameStateEnum;
	import code.states.MainMenuState;
	import code.GameVars;
	//import code.states.createProfileState;
	//import code.states.deleteProfileState;
	//import code.states.selectProfileState;
	
	public class ProfileMgrState extends GameState
	{
		var profileMenu:MovieClip = new MENU_profileMenu();
		
		public function ProfileMgrState(gsm:GameStateManager)
		{
			// this calls gamestate's default constructor and sets up the proper GSM assignment
			super(gsm); // <-- Calls the base class constructor to make sure all the setup shit happens.
			
			profileMenu.x = (screenWidth / 2) - (profileMenu.width / 2);
			profileMenu.y = screenHeight / 2 - (profileMenu.height / 2);
			
			this.addChild(profileMenu);
			
			profileMenu.mainMenuButton.addEventListener(MouseEvent.MOUSE_UP, mainMenuButtonClick);
			//profileMenu.selectProfileButton.addEventListener(MouseEvent.MOUSE_UP, selectProfileButtonClick);
			//profileMenu.deleteProfileButton.addEventListener(MouseEvent.MOUSE_UP, deleteProfileButtonClick);
			profileMenu.createProfileButton.addEventListener(MouseEvent.MOUSE_UP, createProfileButtonClick);
		}
		
		public override function Update()
		{
			
		}
		
		//===================================
		// Click Event Handlers
		public function mainMenuButtonClick(e:MouseEvent)
		{
			GSM.addGameState(new MainMenuState(GSM));
			this.setStatus(GameStateEnum.DELETE_ME);
		}
		
		public override function getStateName():String
		{
			return "ProfileMgrState";
		}
		
		//public function selectProfileButtonClick(e:MouseEvent)
		//{
			//GSM.addGameState(new selectProfileState(GSM));
			//this.setStatus(GameStateEnum.DELETE_ME);
		//}
		//
		//public function deleteProfileButtonClick(e:MouseEvent)
		//{
			//GSM.addGameState(new deleteProfileState(GSM));
			//this.setStatus(GameStateEnum.DELETE_ME);
		//}
		//
		public function createProfileButtonClick(e:MouseEvent)
		{
			GameVars.getInstance().encryptPlayerData();
			//GSM.addGameState(new createProfileState(GSM));
			//this.setStatus(GameStateEnum.DELETE_ME);
		}
		
		
	}
}

