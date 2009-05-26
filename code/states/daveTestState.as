package code.states 
{
	import adobe.utils.CustomActions;
	import flash.display.MovieClip;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import code.GameState;
	import code.GameStateManager;
	import code.enums.GameStateEnum;
	import code.LogicInterface;
	import flash.media.Sound;
	
	// file io stuff
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.events.Event;
	
	// additional state specific stuff
	import flash.text.TextField;
	import flash.text.TextFormat;
	import code.Key;
	
	import code.gameBoard;
	
	import flash.media.Sound;
	
	/**
	 * ...
	 * @author David Moss
	 */
	public class daveTestState extends GameState
	{
		private var tempGameBoard:gameBoard;
		
		public function daveTestState(gsm:GameStateManager) 
		{
			super(gsm);
			tempGameBoard = new gameBoard();
			this.addChild(tempGameBoard);
			//tempGameBoard.loadMapFromFile("additionalContent/maps/newtemp1.txt");
			//tempGameBoard.loadMapFromFile("additionalContent/maps/Mapo3.txt");
			tempGameBoard.loadMapFromFile("additionalContent/maps/testMap1.txt");
			
			
		}
		
		public override function getStateName():String
		{
			return "daveTestState";
		}
		
		public override function Update()
		{
			tempGameBoard.update();
		}
		
	}
	
}