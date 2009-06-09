﻿package code.states
{
	import flash.display.MovieClip;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import code.GameState;
	import code.GameStateManager;
	import code.enums.GameStateEnum;
	import flash.net.FileFilter;
	import flash.text.TextFormat;
	
	// file io stuff
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	// additional state specific stuff
	import flash.text.TextField;
	import flash.text.TextFormat;
	import code.Key;
	import code.GameVars;
			
	public class CreditsState extends GameState
	{
		//var DevLogo:MovieClip = new DevLogoFade();
		var offsetYLimit:int = 0;
		var scrollAmount:int = 1;
		
		//var creditsText:TextField = new TextField();
		var creditsClick:MovieClip = new creditsClicker();
		var creditsBG:MovieClip = new MENU_credits();
		var creditsMask:MovieClip = new creditsMaskMC();
		var creditsText:MovieClip = new creditsData();
		
		public function CreditsState(gsm:GameStateManager)
		{
			// this calls gamestate's default constructor and sets up the proper GSM assignment
			super(gsm); // <-- Calls the base class constructor to make sure all the setup shit happens.
			
			// Some code to do something with the loaded text
			// For example you have a text field instance called
			// myTextField, so you could do
			// myTextField.text = textLoader.data;
			// or for HTML text
			// myTextField.htmlText = textLoader.data;

			this.addChild(creditsBG);
			
			// strip the text into our textField
			//trace("creditsTextLoaded.text.text = ", creditsTextLoaded.text.text);
			
			//var tempString:String = creditsTextLoaded.text.text;
			
			//creditsText.text = tempString;
			//creditsText.text = creditsTextLoaded.text.text;
			
			//trace("creditsText.text = ", creditsText.text);
			
			//creditsText.width = 1000;
			//creditsText.height = creditsText.textHeight;
			
			//trace("text formatting here");
			//var tf:TextFormat =  new TextFormat();
			//tf.size = 24;
			//tf.font = "Arial";
			//tf.leading = -14;
			//tf.color = 0x00FF00;
			
			//creditsText.setTextFormat(tf);					

			// add it to the stage
			this.addChild(creditsText);
			this.addChild(creditsMask);
			
			offsetYLimit = -(creditsText.text.textHeight + 80);
			
			// set the initial positions
			creditsText.x = 150;
			creditsText.y = 768;
			creditsText.selectable = false;
	
			//trace(textLoader.data);
			
			//myTextField.text = textLoader.data;
			GameVars.getInstance().MusicCreditsPlay();
					
			this.addChild(creditsClick);
			creditsClick.x = 0;
			creditsClick.y = 0;
			creditsClick.addEventListener(MouseEvent.MOUSE_UP, theyClicked);
			creditsBG.addEventListener(MouseEvent.MOUSE_UP, theyClicked);
			creditsMask.addEventListener(MouseEvent.MOUSE_UP, theyClicked);
			creditsText.addEventListener(MouseEvent.MOUSE_UP, theyClicked);
			
		}
		
		public override function getStateName():String
		{
			return "CreditsState";
		}
		
		public function DCreditsState(): void
		{
			this.removeChild(creditsText);			
		}
		
		private function theyClicked(e:MouseEvent)
		{
			doEsc();
		}
		
		public override function Update()
		{	
			// check for keyboard input
			if(Key.isDown(192)) // The tilde key
			{
				doEsc();
			}
			
			//trace("credits text/offsetlimit", creditsText.y, " ..... ", offsetYLimit);
			if (creditsText.y < offsetYLimit)
			{
				GSM.addGameState(new MainMenuState(GSM));
				if (this.contains(creditsText))
				{
					this.removeChild(creditsText);
				}
				
				if (stage.contains(creditsClick))
				{
					this.removeChild(creditsClick);
				}
				
				if (stage.contains(creditsBG))
				{
					this.removeChild(creditsBG);
				}
				
				if (stage.contains(creditsMask))
				{
					this.removeChild(creditsMask);
				}
				
				this.setStatus(GameStateEnum.DELETE_ME);
				GameVars.getInstance().MusicStop();
			}
			
			creditsText.y -= scrollAmount;						
		}
		
		private function doEsc()
		{
			if (scrollAmount == 1)
			{
				scrollAmount = 8;
			}
			else if (scrollAmount == 8)
			{
				scrollAmount = 20;
			}
			else if (scrollAmount == 20)
			{
				scrollAmount = 50;
			}
		}
	}
}



    
			