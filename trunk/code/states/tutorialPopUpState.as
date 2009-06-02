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
	import flash.events.MouseEvent;
	
	public class tutorialPopUpState extends GameState
	{
		var mc1:MovieClip = new A_tutorialPage01();
		var mc2:MovieClip = new A_tutorialPage02();
		var mc3:MovieClip = new A_tutorialPage03();
		var mc4:MovieClip = new A_tutorialPage04();
		var mc5:MovieClip = new A_tutorialPage05();
		var mc6:MovieClip = new A_tutorialPage06();
		var mc7:MovieClip = new A_tutorialPage07();
		var mc8:MovieClip = new A_tutorialPage08();
		var mc9:MovieClip = new A_tutorialPage09();
		var currentMC:MovieClip;
		
		public function tutorialPopUpState(gsm:GameStateManager)
		{
			// this calls gamestate's default constructor and sets up the proper GSM assignment
			super(gsm); // <-- Calls the base class constructor to make sure all the setup shit happens.
			
			switch(GameVars.getInstance().getTutorialMovieClip())
			{
				case 1:
				{
					mc1.exitButton.addEventListener(MouseEvent.MOUSE_UP, exitButtonClicked);
					currentMC = mc1;
					break;
				}
				case 2:
				{
					mc2.exitButton.addEventListener(MouseEvent.MOUSE_UP, exitButtonClicked);
					currentMC = mc2;
					break;
				}
				case 3:
				{
					mc3.exitButton.addEventListener(MouseEvent.MOUSE_UP, exitButtonClicked);
					currentMC = mc3;
					break;
				}
				case 4:
				{
					mc4.exitButton.addEventListener(MouseEvent.MOUSE_UP, exitButtonClicked);
					currentMC = mc4;
					break;
				}
				case 5:
				{
					mc5.exitButton.addEventListener(MouseEvent.MOUSE_UP, exitButtonClicked);
					currentMC = mc5;
					break;
				}
				case 6:
				{
					mc6.exitButton.addEventListener(MouseEvent.MOUSE_UP, exitButtonClicked);
					currentMC = mc6;
					break;
				}
				case 7:
				{
					mc7.exitButton.addEventListener(MouseEvent.MOUSE_UP, exitButtonClicked);
					currentMC = mc7;					
					break;
				}
				case 8:
				{
					mc8.exitButton.addEventListener(MouseEvent.MOUSE_UP, exitButtonClicked);
					currentMC = mc8;
					break;
				}
				case 9:
				{
					mc9.exitButton.addEventListener(MouseEvent.MOUSE_UP, exitButtonClicked);
					currentMC = mc9;
					break;
				}
			}
			
			currentMC.x = 200;
			currentMC.y = 200;
			
			this.addChild(currentMC);
		
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
		
		public function exitButtonClicked(e:MouseEvent)
		{
			this.setStatus(GameStateEnum.DELETE_ME);
		}
	}
}





