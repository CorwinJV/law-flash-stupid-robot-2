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
	import code.GameVars;
	import code.states.clickOKState;
	
	
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
	public class tomTestGameState extends GameState
	{
		private var tempGameBoard:gameBoard;
		var tomVars = GameVars.getInstance();
		
		public function tomTestGameState(gsm:GameStateManager) 
		{
			super(gsm);
			GameVars.getInstance().setPMStatus(5);
			//GSM.addGameState(new playGameState(GSM));
			GSM.addGameState(new HelpScreenState(GSM));
			//tempGameBoard = new gameBoard();
			//this.addChild(tempGameBoard);
			
			
			
		}
		
		public override function Update()
		{
			//tempGameBoard.update();
		}
		
		public override function getStateName():String
		{
			return "tomTestGameState";
		}
		
	}
	
}