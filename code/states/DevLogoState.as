package code.states
{
	import flash.display.MovieClip;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
//	import flash.sampler.NewObjectSample;
	import flash.ui.Keyboard;
	import code.GameState;
	import code.GameStateManager;
	import code.enums.GameStateEnum;
	import code.states.MainMenuState;
	import code.Key;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.media.Sound;
	
	
	public class DevLogoState extends GameState
	{
		var DevLogo:MovieClip = new developerLogoFade();
		var PubLogo:MovieClip = new publisherLogoFade();
		var GameLogo:MovieClip = new gameLogoFade();
		var progress:int = 0;
		var skipDisabled:Boolean = false;
		var skipTimer:Timer = new Timer(150, 1);
		var armyMarch:Sound;
		var drumBeats:Sound;
		
		public function DevLogoState(gsm:GameStateManager)
		{
			// this calls gamestate's default constructor and sets up the proper GSM assignment
			super(gsm); // <-- Calls the base class constructor to make sure all the setup shit happens.
			progress = 1;
			this.addChild(DevLogo);
			armyMarch = new armyMarching();
			drumBeats = new drumBeat();
			armyMarch.play();
			drumBeats.play();
			
			DevLogo.addEventListener(MouseEvent.MOUSE_UP, forceSkip);
			PubLogo.addEventListener(MouseEvent.MOUSE_UP, forceSkip);
			GameLogo.addEventListener(MouseEvent.MOUSE_UP, forceSkip);
		}
		
		public override function getStateName():String
		{
			return "DevLogoState";
		}
		
		public override function initMouse()
		{		
			//stage.addEventListener("devLogoFadeFinished", launchPublisherLogo);
			//stage.addEventListener("publisherLogoFadeFinished", launchGameLogo);
			//stage.addEventListener("gameLogoFadeFinished", launchMainMenu);
		}
		
		public override function Update()
		{
		//	trace(Key.isDown(Keyboard.ESCAPE));
			
			if(!skipDisabled && Key.isDown(192)) // The tilde key
			{
				skipLogo();
				skipDisabled = true;
				skipTimer.addEventListener(TimerEvent.TIMER_COMPLETE, turnSkipBackOn);
				skipTimer.start();
			}
			switch(progress)
			{
				case 1:
					if (DevLogo.currentFrame >= 235)
					{
						skipLogo();
					}
					break;
				case 2:
					if (PubLogo.currentFrame >= 235)
					{
						skipLogo();
					}
					break;
				case 3:
					if (GameLogo.currentFrame >= 235)
					{
						skipLogo();
					}
					break;
			}
		}
		
		function turnSkipBackOn(e:TimerEvent)
		{
			skipDisabled = false;
		}
		
		function forceSkip(e:MouseEvent)
		{
			skipLogo();
			skipDisabled = true;
			skipTimer.addEventListener(TimerEvent.TIMER_COMPLETE, turnSkipBackOn);
			skipTimer.start();
		}
		
		function skipLogo()
		{
			switch(progress)
			{
				case 1:
					launchPublisherLogoS();
					break;
				case 2:
					launchGameLogoS();
					break;
				case 3:
					launchMainMenuS();
					break;
			}
		}
		
		function launchPublisherLogoS()
		{
			progress = 2;
			this.removeChild(DevLogo);
			this.addChild(PubLogo);
		}
		
		function launchGameLogoS()
		{
			progress = 3;
			this.removeChild(PubLogo);
			this.addChild(GameLogo);
		}
		
		function launchMainMenuS()
		{
			if (this.contains(GameLogo))
			{
				this.removeChild(GameLogo);
			}
			GSM.addGameState(new MainMenuState(GSM));
			this.setStatus(GameStateEnum.DELETE_ME);
		}
	}
}

