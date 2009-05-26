package code.states
{
	//********************
	//Author: Tom Lindeman
	//********************
	
	import flash.display.MovieClip;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import code.GameState;
	import code.GameStateManager;
	import code.enums.GameStateEnum;
	
	public class HelpScreenState extends GameState
	{
		var helpMenu:MovieClip = new MENU_helpMenu();
		var helpMenuBG:MovieClip = new blankMenu();
		var loadedPage:MovieClip;
		// this variable keeps track of which page we are on the help menu
		var pageNumber:int;
		// this needs to be adjusted as to how many pages there are in the help menu
		var maxPages:int = 6;
		
		public function HelpScreenState(gsm:GameStateManager)
		{
			pageNumber = 1;
			// this calls gamestate's default constructor and sets up the proper GSM assignment
			super(gsm); // <-- Calls the base class constructor to make sure all the setup shit happens.
			
			helpMenu.x = (screenWidth / 2) - (helpMenu.width / 2);
			helpMenu.y = screenHeight / 2 - (helpMenu.height / 2);
			helpMenuBG.x = helpMenu.x;
			helpMenuBG.y = helpMenu.y;
			helpMenuBG.width = helpMenu.width;
			helpMenuBG.height = helpMenu.height;
			
			this.addChild(helpMenuBG);
			this.addChild(helpMenu);
			
			helpMenu.leftArrowButton.addEventListener(MouseEvent.MOUSE_UP, leftButtonClick);
			helpMenu.rightArrowButton.addEventListener(MouseEvent.MOUSE_UP, rightButtonClick);
			helpMenu.exitButton.addEventListener(MouseEvent.MOUSE_UP, exitButtonClick);
			
			addCurrentPage();
		}
		
		public override function Update()
		{
			
		}
		
		public override function getStateName():String
		{
			return "HelpScreenState";
		}
		
		//===================================
		// Click Event Handlers
		public function leftButtonClick(e:MouseEvent)
		{
			removeCurrentPage();
			pageNumber--;
			addCurrentPage();
		}
		
		public function rightButtonClick(e:MouseEvent)
		{
			removeCurrentPage();
			pageNumber++;
			addCurrentPage();
		}
		
		public function exitButtonClick(e:MouseEvent)
		{
			this.setStatus(GameStateEnum.DELETE_ME);
		}
		
		public function removeCurrentPage():void
		{
			helpMenu.removeChild(loadedPage);
		}
		
		public function addCurrentPage():void
		{
			updatePageNumber();
			switch(pageNumber)
			{
				case 1:
					loadedPage = new helpScreenOverview();
					break;
				case 2:
					loadedPage = new helpScreenTilesPg1();
					// add the event listeners for the buttons on this page
					loadedPage.halfBottomLButton.addEventListener(MouseEvent.MOUSE_UP, halfBottomLClick);
					loadedPage.electricTLButton.addEventListener(MouseEvent.MOUSE_UP, electricTLClick);
					loadedPage.doorTLButton.addEventListener(MouseEvent.MOUSE_UP, doorClick);
					loadedPage.halfTopLButton.addEventListener(MouseEvent.MOUSE_UP, halfTopLClick);
					loadedPage.gapButton.addEventListener(MouseEvent.MOUSE_UP, gapClick);
					loadedPage.breakableTLButton.addEventListener(MouseEvent.MOUSE_UP, breakableTLClick);
					loadedPage.breakableButton.addEventListener(MouseEvent.MOUSE_UP, breakableClick);
					loadedPage.electricButton.addEventListener(MouseEvent.MOUSE_UP, electricClick);
					loadedPage.emptyButton.addEventListener(MouseEvent.MOUSE_UP, emptyClick);
					loadedPage.iceButton.addEventListener(MouseEvent.MOUSE_UP, iceClick);
					break;
				case 3:
					loadedPage = new helpScreenTilesPg2();
					// add the event listeners for the buttons on this page
					loadedPage.waterButton.addEventListener(MouseEvent.MOUSE_UP, waterClick);
					loadedPage.teleportButton.addEventListener(MouseEvent.MOUSE_UP, teleportClick);
					loadedPage.switchTLButton.addEventListener(MouseEvent.MOUSE_UP, switchTLClick);
					loadedPage.switchButton.addEventListener(MouseEvent.MOUSE_UP, switchClick);
					loadedPage.defaultButton.addEventListener(MouseEvent.MOUSE_UP, defaultClick);
					loadedPage.programTLButton.addEventListener(MouseEvent.MOUSE_UP, programTLClick);
					loadedPage.raised3Button.addEventListener(MouseEvent.MOUSE_UP, raised3Click);
					loadedPage.solidButton.addEventListener(MouseEvent.MOUSE_UP, solidClick);
					break;
				case 4:
					loadedPage = new helpScreenInstrPg1();
					// add the event listeners for the buttons on this page
					loadedPage.activateButton.addEventListener(MouseEvent.MOUSE_UP, activateClick);
					loadedPage.climbButton.addEventListener(MouseEvent.MOUSE_UP, climbClick);
					loadedPage.crouchButton.addEventListener(MouseEvent.MOUSE_UP, crouchClick);
					loadedPage.forwardUntilUnableButton.addEventListener(MouseEvent.MOUSE_UP, forwardUntilUnableClick);
					loadedPage.jumpButton.addEventListener(MouseEvent.MOUSE_UP, jumpClick);
					loadedPage.forwardButton.addEventListener(MouseEvent.MOUSE_UP, forwardClick);
					break;
				case 5:
					loadedPage = new helpScreenInstrPg2();
					// add the event listeners for the buttons on this page
					loadedPage.leftButton.addEventListener(MouseEvent.MOUSE_UP, leftClick);
					loadedPage.rightButton.addEventListener(MouseEvent.MOUSE_UP, rightClick);
					loadedPage.punchButton.addEventListener(MouseEvent.MOUSE_UP, punchClick);
					loadedPage.stopButton.addEventListener(MouseEvent.MOUSE_UP, stopClick);
					loadedPage.sub1Button.addEventListener(MouseEvent.MOUSE_UP, sub1Click);
					loadedPage.placeButton.addEventListener(MouseEvent.MOUSE_UP, placeClick);
					break;
				case 6:
					loadedPage = new helpScreenUI();
					break;
				default:
					break;
			}
			helpMenu.addChild(loadedPage);
			helpMenu.setChildIndex(loadedPage, 2);
		}
		
		public function updatePageNumber():void
		{
			if (pageNumber < 1)
			{
				pageNumber = maxPages;
			}
			
			if (pageNumber > maxPages)
			{
				pageNumber = 1;
			}
		}
		
		public function activateClick(e:MouseEvent)
		{
			// code for activate animation here
			trace("activate");
		}
		
		public function climbClick(e:MouseEvent)
		{
			// code for climb animation here
			trace("climb");
		}
		
		public function crouchClick(e:MouseEvent)
		{
			// code for crouch animation here
			trace("crouch");
		}
		
		public function forwardUntilUnableClick(e:MouseEvent)
		{
			// code for move forward until unable animation here
			trace("until unable");
		}
		
		public function jumpClick(e:MouseEvent)
		{
			// code for jump animation here
			trace("jump");
		}
		
		public function forwardClick(e:MouseEvent)
		{
			// code for forward animation here
			trace("forward");
		}
		
		public function leftClick(e:MouseEvent)
		{
			// code for forward animation here
			trace("left");
		}
		
		public function rightClick(e:MouseEvent)
		{
			// code for forward animation here
			trace("right");
		}
		
		public function punchClick(e:MouseEvent)
		{
			// code for forward animation here
			trace("punch");
		}
		
		public function stopClick(e:MouseEvent)
		{
			// code for forward animation here
			trace("stop");
		}
		
		public function sub1Click(e:MouseEvent)
		{
			// code for forward animation here
			trace("sub1");
		}
		
		public function placeClick(e:MouseEvent)
		{
			// code for forward animation here
			trace("place");
		}
		
		public function halfBottomLClick(e:MouseEvent)
		{
			// code for forward animation here
			trace("halfBottomL");
		}
		
		public function electricClick(e:MouseEvent)
		{
			// code for forward animation here
			trace("electric");
		}
		
		public function doorClick(e:MouseEvent)
		{
			// code for forward animation here
			trace("door");
		}
		
		public function halfTopLClick(e:MouseEvent)
		{
			// code for forward animation here
			trace("halfTopL");
		}
		
		public function gapClick(e:MouseEvent)
		{
			// code for forward animation here
			trace("gap");
		}
		
		public function breakableTLClick(e:MouseEvent)
		{
			// code for forward animation here
			trace("breakableTL");
		}
		
		public function breakableClick(e:MouseEvent)
		{
			// code for forward animation here
			trace("breakable");
		}
		
		public function electricTLClick(e:MouseEvent)
		{
			// code for forward animation here
			trace("electricTL");
		}
		
		public function emptyClick(e:MouseEvent)
		{
			// code for forward animation here
			trace("empty");
		}
		
		public function iceClick(e:MouseEvent)
		{
			// code for forward animation here
			trace("ice");
		}
		
		public function waterClick(e:MouseEvent)
		{
			// code for forward animation here
			trace("water");
		}
		
		public function teleportClick(e:MouseEvent)
		{
			// code for forward animation here
			trace("teleport");
		}
		
		public function switchTLClick(e:MouseEvent)
		{
			// code for forward animation here
			trace("switchTL");
		}
		
		public function switchClick(e:MouseEvent)
		{
			// code for forward animation here
			trace("switch");
		}
		
		public function defaultClick(e:MouseEvent)
		{
			// code for forward animation here
			trace("default");
		}
		
		public function programTLClick(e:MouseEvent)
		{
			// code for forward animation here
			trace("programTL");
		}
		
		public function raised3Click(e:MouseEvent)
		{
			// code for forward animation here
			trace("raised3");
		}
		
		public function solidClick(e:MouseEvent)
		{
			// code for forward animation here
			trace("solid");
		}
	}
}
