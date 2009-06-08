package code
{
	import flash.display.MovieClip;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import code.enums.GameStateEnum;
	import code.GameStateManager;
	import flash.events.MouseEvent;
	
	public class GameState extends MovieClip
	{
		public var currentStatus:GameStateEnum;
		public var GSM:GameStateManager;
		public var screenWidth:int = 1024;
		public var screenHeight:int = 768;
		
		public function GameState(gsm:GameStateManager)
		{
			// Initialize our reference to the game state manager
			GSM = gsm;
			
			// Initialize the current status
			currentStatus = new GameStateEnum(1); //<-- currentState is a null reference up until this point
			currentStatus = GameStateEnum.ACTIVE; // After we initialize it we can change states by assigning the EnumName.ENUM
		}
		
		public function Update()
		{
			
		}
		
		public function getStateName():String
		{
			return "Base Gamestate";
		}
		
		public function initMouse()
		{
			stage.addEventListener(MouseEvent.CLICK, processMouseClick);
		}
		
		public function setStatus(newStatus:GameStateEnum)
		{
			currentStatus = newStatus;
		}
		
		public function getStatus()
		{
			return currentStatus;
		}
		
		public function processMouseClick(e:MouseEvent)
		{
			
		}
		
		public function destruct()
		{
			
		}
	}
}

