package code
{
	import code.states.CreditsState;
	import code.states.MainMenuState;
	import code.states.playGameState;
	import flash.display.MovieClip;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.ui.Keyboard;
	import code.GameStateManager;
	import code.Key;
	import code.GameVars;
	import code.states.tomTestGameState;

	// state includes here
	import code.states.DevLogoState;
	import code.states.CreditsState;
	
	import code.states.daveTestState;
		
	public class main extends MovieClip
	{
		//=========================
		// Private Data Members
		var GSM:GameStateManager;
		
		
		//=========================
		// Constructor
		public function main()
		{
			// Sets up the main game loop
			addEventListener(Event.ENTER_FRAME, Update);
			
			// Initialize the static class Key for input stuff.
			Key.initialize(stage);
			
			// Initialize the GameVars singleton
			GameVars.getInstance();
			
			// Initialize the game state manager.
			GSM = new GameStateManager(this);
			
			// Add a new state to the GSM
			GSM.addGameState(new DevLogoState(GSM));
			//GSM.addGameState(new tomTestGameState(GSM));
			//GSM.addGameState(new playGameState(GSM));
			//GSM.addGameState(new daveTestState(GSM));
			//GSM.addGameState(new CreditsState(GSM));
			//GSM.addGameState(new MainMenuState(GSM));
			
		}
		
		public function Update(event:Event):void
		{
			GSM.Update();
		}
	}
}
