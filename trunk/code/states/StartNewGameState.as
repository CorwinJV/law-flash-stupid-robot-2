package code.states
{
	import flash.display.MovieClip;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import code.GameState;
	import code.GameStateManager;
	import code.enums.GameStateEnum;
	import code.GameVars;
	
	public class StartNewGameState extends GameState
	{
		var startNewGameMenu:MovieClip = new MENU_startNewGame();
		
		public function StartNewGameState(gsm:GameStateManager)
		{
			// this calls gamestate's default constructor and sets up the proper GSM assignment
			super(gsm); // <-- Calls the base class constructor to make sure all the setup shit happens.
			this.addChild(startNewGameMenu);			
			startNewGameMenu.okBtn.addEventListener(MouseEvent.MOUSE_UP, okButtonClick);
			startNewGameMenu.nameBox.text = "Default";
		}
		
		public override function Update()
		{
			if (startNewGameMenu.nameBox.text.length > 15)
			{
				startNewGameMenu.nameBox.text = startNewGameMenu.nameBox.text.substr(0, 10);
			}
		}
		
		public override function getStateName():String
		{
			return "StartNewGameState";
		}
		
		public function okButtonClick(e:MouseEvent)
		{
			//trace(startNewGameMenu.nameBox.text.length);
			if (startNewGameMenu.nameBox.text.length != 0)
			{
				// save name
				GameVars.getInstance().setPlayerName(startNewGameMenu.nameBox.text);
				
				// launch playgame state
				GSM.addGameState(new playGameState(GSM));
				//GSM.addGameState(new ProfileMgrState(GSM));
				this.setStatus(GameStateEnum.DELETE_ME);
				//trace("Here I would have gone into a new state, but i'm not for testing purposes");
			}
			else
			{
				// tell the user they are a moron and must put in a name
				startNewGameMenu.nameBox.text = "Default";
				// then set the name back to Default
				//trace("no name entered");
			}
		}
		
		//===================================
		// Click Event Handlers
		/*public function startGameButtonClick(e:MouseEvent)
		{
			
		}*/
		
		
	}
}

