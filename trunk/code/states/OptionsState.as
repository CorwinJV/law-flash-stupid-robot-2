package code.states
{
	import flash.display.MovieClip;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import code.GameState;
	import code.GameStateManager;
	import code.enums.GameStateEnum;
	
	public class OptionsState extends GameState
	{
		var MainMenu:MovieClip = new MENU_mainMenu();
		
		public function OptionsState(gsm:GameStateManager)
		{
			// this calls gamestate's default constructor and sets up the proper GSM assignment
			super(gsm); // <-- Calls the base class constructor to make sure all the setup shit happens.
			
			
		}
		
		public override function getStateName():String
		{
			return "OptionsState";
		}
		
		public override function Update()
		{
			
		}
		
		//===================================
		// Click Event Handlers
		/*public function startGameButtonClick(e:MouseEvent)
		{
			
		}*/
		
		
	}
}
