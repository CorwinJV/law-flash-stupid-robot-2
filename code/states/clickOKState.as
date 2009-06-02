package code.states
{
	//********************
	//Author: Tom Lindeman
	//********************

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
	
	public class clickOKState extends GameState
	{
		//access click OK Menu
		var clickOKMenu:MovieClip = new MENU_clickOKMenu();
		//member variables
		var tempString:String;
		var checkEnum:ClickOKEnum;
		var check:int;
		var clickVars:GameVars = GameVars.getInstance();
		var topText:TextField = new TextField();
		var midText:TextField = new TextField();
		var bottomText:TextField = new TextField();
		var tFormat:TextFormat = new TextFormat();
		
		public function clickOKState(gsm:GameStateManager)
		{
			// this calls gamestate's default constructor and sets up the proper GSM assignment
			super(gsm); // <-- Calls the base class constructor to make sure all the setup shit happens.
			
			clickOKMenu.x = (screenWidth / 2) - (clickOKMenu.width / 2);
			clickOKMenu.y = screenHeight / 2 - (clickOKMenu.height / 2);
			
			this.addChild(clickOKMenu);
			
			clickOKMenu.okButton.addEventListener(MouseEvent.MOUSE_UP, OKButtonClick);
			clickOKMenu.helpButton.addEventListener(MouseEvent.MOUSE_UP, helpButtonClick);
			clickOKMenu.addChild(topText);
			clickOKMenu.addChild(midText);
			clickOKMenu.addChild(bottomText);
			Update();
			draw();
	
		}
		
		public override function getStateName():String
		{
			return "clickOKState";
		}
		
		public override function Update()
		{
			//GSM.setAllButTopActive();
			//GameStateManager.setAllButTopPassive();
			check = clickVars.getPMStatus();

			//if(myMenu != NULL)
				//myMenu.Update();

		}
		
		public function draw():void
		{
			//if((check != saved) && (check != reprogram))
			//{
			//clearBackground();
			//logoImage.drawImage();
			//}
			//
			//if(myMenu != NULL)
				//myMenu.Draw();
			
			var tempTopX:int;
			var tempTopY:int;
			var tempMidX:int;
			var tempMidY:int;
			var basetextY = 125;
			
			switch(check)
			{
				case ClickOKEnum.CREATED.toInt():
					tempTopX = 75;
					tempTopY = 55;
					tempMidX = 75;
					tempMidY = 80;
					topText.text = "Profile has been created.";
					midText.text = "Click OK to begin game.";
					break;
				case ClickOKEnum.SELECTED.toInt():
					tempTopX = 75;
					tempTopY = 55;
					tempMidX = 75;
					tempMidY = 80;
					topText.text = "Profile has been selected.";
					midText.text = "Click OK to select level.";
					break;
				case ClickOKEnum.DELETED.toInt():
					tempTopX = 75;
					tempTopY = 55;
					tempMidX = 75;
					tempMidY = 80;
					topText.text = "Profile has been deleted.";
					midText.text = "Click OK to continue.";
					break;
				case ClickOKEnum.NOPROFILE.toInt():
					tempTopX = 75;
					tempTopY = 55;
					tempMidX = 75;
					tempMidY = 80;
					topText.text = "There are no existing profiles.";
					midText.text = "To load click OK to continue.";
					break;
				case ClickOKEnum.SAVED.toInt():
					tempTopX = 75;
					tempTopY = 55;
					tempMidX = 75;
					tempMidY = 80;
					topText.text = "Profile has been saved.";
					midText.text = "Click OK to continue.";
					break;
				case ClickOKEnum.REPROGRAM.toInt():
					tempTopX = 75;
					tempTopY = 25;
					tempMidX = 75;
					tempMidY = 120;
					topText.text = "You have hit a reprogrammable square. Your instruction list has been cleared, and all of your memory has been replenished.";
					midText.text = "Click OK to continue or";
					break;
				default:
					break;
			}
			
			bottomText.text = "Click \"Help\" to learn more about the game.";
			bottomText.x = 75;
			bottomText.y = basetextY + 150;
			topText.x = tempTopX;
			topText.y = basetextY + tempTopY;
			midText.x = tempMidX;
			midText.y = basetextY + tempMidY;
			
			//happy fun format stuff
			tFormat.size = 24;
			tFormat.font = "Arial";
			tFormat.leading = 0;
			tFormat.color = 0x00FF00;
			
			//now apply the happy fun format stuff
			topText.setTextFormat(tFormat);	
			topText.width = 500;
			topText.height = 100;
			topText.wordWrap = true;
			midText.setTextFormat(tFormat);	
			midText.width = 500;
			midText.height = 100;
			midText.wordWrap = true;
			bottomText.setTextFormat(tFormat);	
			bottomText.width = 500;
			//bottomText.height = 100;
			//bottomText.wordWrap = true;
		}
		
	
		//===================================
		//Click Event Handlers
		public function OKButtonClick(e:MouseEvent)
		{
			this.setStatus(GameStateEnum.DELETE_ME);
		}
		
		public function helpButtonClick(e:MouseEvent)
		{
			GSM.addGameState(new HelpScreenState(GSM));
		}
		
	}
}





