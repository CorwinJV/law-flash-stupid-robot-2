package code.states
{
	//import files
	import adobe.utils.CustomActions;
	import flash.display.MovieClip;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import code.GameState;
	import code.GameStateManager;
	import code.GameVars;
	import code.enums.ClickOKEnum;
	import code.enums.GameStateEnum;
	import code.states.HelpScreenState;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class tutorialPopUpState extends GameState
	{
		
		public function tutorialPopUpState(gsm:GameStateManager)
		{
			// this calls gamestate's default constructor and sets up the proper GSM assignment
			super(gsm); // <-- Calls the base class constructor to make sure all the setup shit happens.
			
	
		}
		
		public override function getStateName():String
		{
			return "tutorialPopUpState";
		}
		
		public override function Update()
		{

		}
		
		public function draw():void
		{

		}
	}
}





