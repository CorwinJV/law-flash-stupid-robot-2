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
		var animationPage:MovieClip = new baseScreen();
		// this variable keeps track of which page we are on the help menu
		var pageNumber:int;
		// this needs to be adjusted as to how many pages there are in the help menu
		var maxPages:int = 6;
		// the X and Y coordinates for the animation base screen
		var animX:int = 239;
		var animY:int = 164;
		var animWidth:int = 545;
		var animHeight:int = 439;
		// the X and Y coordinates for each individual animation inside the animation base screen
		var indivX:int = 112;
		var indivY:int = 225;
		
		public function HelpScreenState(gsm:GameStateManager)
		{
			pageNumber = 1;
			// this calls gamestate's default constructor and sets up the proper GSM assignment
			super(gsm); // <-- Calls the base class constructor to make sure all the setup shit happens.
			
			// set the x and y coordiates for the help menu and background
			helpMenu.x = (screenWidth / 2) - (helpMenu.width / 2);
			helpMenu.y = screenHeight / 2 - (helpMenu.height / 2);
			helpMenuBG.x = helpMenu.x;
			helpMenuBG.y = helpMenu.y;
			helpMenuBG.width = helpMenu.width;
			helpMenuBG.height = helpMenu.height;
			
			// add the help menu and background to the scene
			this.addChild(helpMenuBG);
			this.addChild(helpMenu);
			
			// event listeners for all the button for each menu
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
			if (this.contains(animationPage))
			{
				this.removeChild(animationPage);
			}
			else
			{
				this.setStatus(GameStateEnum.DELETE_ME);
			}
		}
		
		public function removeCurrentPage():void
		{
			if (helpMenu.contains(loadedPage))
			{
				helpMenu.removeChild(loadedPage);
			}	
		}
		
		public function removeAnimationPage():void
		{
			if (helpMenu.contains(animationPage))
			{
				helpMenu.removeChild(animationPage);
			}
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
			addAnimationScreen();
			
			var activateMC:MovieClip = new activateAnimation(); 
			// add the appropriate animation to the page
			if (!animationPage.contains(activateMC))
			{
				activateMC.x = indivX;
				activateMC.y = indivY;
				animationPage.addChild(activateMC);
			}
		}
		
		public function climbClick(e:MouseEvent)
		{
			addAnimationScreen();
			
			var climbMC:MovieClip = new climbAnimation(); 
			// add the appropriate animation to the page
			if (!animationPage.contains(climbMC))
			{
				climbMC.x = indivX;
				climbMC.y = indivY;
				animationPage.addChild(climbMC);
			}
		}
		
		public function crouchClick(e:MouseEvent)
		{
			addAnimationScreen();
			
			var crouchMC:MovieClip = new crouchAnimation(); 
			// add the appropriate animation to the page
			if (!animationPage.contains(crouchMC))
			{
				crouchMC.x = indivX;
				crouchMC.y = indivY;
				animationPage.addChild(crouchMC);
			}
		}
		
		public function forwardUntilUnableClick(e:MouseEvent)
		{
			addAnimationScreen();
			
			var forwardUntilUnableMC:MovieClip = new forwardUntilUnableAnimation(); 
			// add the appropriate animation to the page
			if (!animationPage.contains(forwardUntilUnableMC))
			{
				forwardUntilUnableMC.x = indivX;
				forwardUntilUnableMC.y = indivY;
				animationPage.addChild(forwardUntilUnableMC);
			}
		}
		
		public function jumpClick(e:MouseEvent)
		{
			addAnimationScreen();
			
			var jumpMC:MovieClip = new jumpAnimation(); 
			// add the appropriate animation to the page
			if (!animationPage.contains(jumpMC))
			{
				jumpMC.x = indivX;
				jumpMC.y = indivY;
				animationPage.addChild(jumpMC);
			}
		}
		
		public function forwardClick(e:MouseEvent)
		{
			addAnimationScreen();
			
			var forwardMC:MovieClip = new forwardAnimation(); 
			// add the appropriate animation to the page
			if (!animationPage.contains(forwardMC))
			{
				forwardMC.x = indivX;
				forwardMC.y = indivY;
				animationPage.addChild(forwardMC);
			}
		}
		
		public function leftClick(e:MouseEvent)
		{
			addAnimationScreen();
			
			var leftMC:MovieClip = new leftAnimation(); 
			// add the appropriate animation to the page
			if (!animationPage.contains(leftMC))
			{
				leftMC.x = indivX;
				leftMC.y = indivY;
				animationPage.addChild(leftMC);
			}
		}
		
		public function rightClick(e:MouseEvent)
		{
			addAnimationScreen();
			
			var rightMC:MovieClip = new rightAnimation(); 
			// add the appropriate animation to the page
			if (!animationPage.contains(rightMC))
			{
				rightMC.x = indivX;
				rightMC.y = indivY;
				animationPage.addChild(rightMC);
			}
		}
		
		public function punchClick(e:MouseEvent)
		{
			addAnimationScreen();
			
			var punchMC:MovieClip = new punchAnimation(); 
			// add the appropriate animation to the page
			if (!animationPage.contains(punchMC))
			{
				punchMC.x = indivX;
				punchMC.y = indivY;
				animationPage.addChild(punchMC);
			}
		}
		
		public function stopClick(e:MouseEvent)
		{
			addAnimationScreen();
			
			var stopMC:MovieClip = new stopAnimation(); 
			// add the appropriate animation to the page
			if (!animationPage.contains(stopMC))
			{
				stopMC.x = indivX;
				stopMC.y = indivY;
				animationPage.addChild(stopMC);
			}
		}
		
		public function sub1Click(e:MouseEvent)
		{
			addAnimationScreen();
			
			var subMC:MovieClip = new subAnimation(); 
			// add the appropriate animation to the page
			if (!animationPage.contains(subMC))
			{
				subMC.x = indivX;
				subMC.y = indivY;
				animationPage.addChild(subMC);
			}
		}
		
		public function placeClick(e:MouseEvent)
		{
			addAnimationScreen();
			
			var placeMC:MovieClip = new placeAnimation(); 
			// add the appropriate animation to the page
			if (!animationPage.contains(placeMC))
			{
				placeMC.x = indivX;
				placeMC.y = indivY;
				animationPage.addChild(placeMC);
			}
		}
		
		public function electricClick(e:MouseEvent)
		{
			addAnimationScreen();
			
			var electricMC:MovieClip = new electricAnimation(); 
			// add the appropriate animation to the page
			if (!animationPage.contains(electricMC))
			{
				electricMC.x = indivX;
				electricMC.y = indivY;
				animationPage.addChild(electricMC);
			}
		}
		
		public function doorClick(e:MouseEvent)
		{
			addAnimationScreen();
			
			var doorMC:MovieClip = new doorAnimation(); 
			// add the appropriate animation to the page
			if (!animationPage.contains(doorMC))
			{
				doorMC.x = indivX;
				doorMC.y = indivY;
				animationPage.addChild(doorMC);
			}
		}
		
		public function halfTopLClick(e:MouseEvent)
		{
			addAnimationScreen();
			
			var halfTopMC:MovieClip = new halfTopAnimation(); 
			// add the appropriate animation to the page
			if (!animationPage.contains(halfTopMC))
			{
				halfTopMC.x = indivX;
				halfTopMC.y = indivY;
				animationPage.addChild(halfTopMC);
			}
		}
		
		public function gapClick(e:MouseEvent)
		{
			addAnimationScreen();
			
			var gapMC:MovieClip = new gapAnimation(); 
			// add the appropriate animation to the page
			if (!animationPage.contains(gapMC))
			{
				gapMC.x = indivX;
				gapMC.y = indivY;
				animationPage.addChild(gapMC);
			}
		}
		
		public function breakableTLClick(e:MouseEvent)
		{
			addAnimationScreen();
			
			var breakableMC:MovieClip = new breakableAnimation(); 
			// add the appropriate animation to the page
			if (!animationPage.contains(breakableMC))
			{
				breakableMC.x = indivX;
				breakableMC.y = indivY;
				animationPage.addChild(breakableMC);
			}
		}
		
		public function breakableClick(e:MouseEvent)
		{
			addAnimationScreen();
			
			var breakableWallMC:MovieClip = new breakableWallAnimation(); 
			// add the appropriate animation to the page
			if (!animationPage.contains(breakableWallMC))
			{
				breakableWallMC.x = indivX;
				breakableWallMC.y = indivY;
				animationPage.addChild(breakableWallMC);
			}
		}
		
		public function electricTLClick(e:MouseEvent)
		{
			addAnimationScreen();
			
			var electricWallMC:MovieClip = new electricWallAnimation(); 
			// add the appropriate animation to the page
			if (!animationPage.contains(electricWallMC))
			{
				electricWallMC.x = indivX;
				electricWallMC.y = indivY;
				animationPage.addChild(electricWallMC);
			}
		}
		
		public function emptyClick(e:MouseEvent)
		{
			addAnimationScreen();
			
			var emptyMC:MovieClip = new emptyAnimation(); 
			// add the appropriate animation to the page
			if (!animationPage.contains(emptyMC))
			{
				emptyMC.x = indivX;
				emptyMC.y = indivY;
				animationPage.addChild(emptyMC);
			}
		}
		
		public function iceClick(e:MouseEvent)
		{
			addAnimationScreen();
			
			var iceMC:MovieClip = new iceAnimation(); 
			// add the appropriate animation to the page
			if (!animationPage.contains(iceMC))
			{
				iceMC.x = indivX;
				iceMC.y = indivY;
				animationPage.addChild(iceMC);
			}
		}
		
		public function teleportClick(e:MouseEvent)
		{
			addAnimationScreen();
			
			var teleportMC:MovieClip = new teleportAnimation(); 
			// add the appropriate animation to the page
			if (!animationPage.contains(teleportMC))
			{
				teleportMC.x = indivX;
				teleportMC.y = indivY;
				animationPage.addChild(teleportMC);
			}
		}
		
		public function switchTLClick(e:MouseEvent)
		{
			addAnimationScreen();
			
			var switchMC:MovieClip = new switchAnimation(); 
			// add the appropriate animation to the page
			if (!animationPage.contains(switchMC))
			{
				switchMC.x = indivX;
				switchMC.y = indivY;
				animationPage.addChild(switchMC);
			}
		}
		
		public function switchClick(e:MouseEvent)
		{
			addAnimationScreen();
			
			var switchMC:MovieClip = new switchAnimation(); 
			// add the appropriate animation to the page
			if (!animationPage.contains(switchMC))
			{
				switchMC.x = indivX;
				switchMC.y = indivY;
				animationPage.addChild(switchMC);
			}
		}
		
		public function defaultClick(e:MouseEvent)
		{
			addAnimationScreen();
			
			var defaultMC:MovieClip = new defaultAnimation(); 
			// add the appropriate animation to the page
			if (!animationPage.contains(defaultMC))
			{
				defaultMC.x = indivX;
				defaultMC.y = indivY;
				animationPage.addChild(defaultMC);
			}
		}
		
		public function programTLClick(e:MouseEvent)
		{
			addAnimationScreen();
			
			var reprogramMC:MovieClip = new reprogramAnimation(); 
			// add the appropriate animation to the page
			if (!animationPage.contains(reprogramMC))
			{
				reprogramMC.x = indivX;
				reprogramMC.y = indivY;
				animationPage.addChild(reprogramMC);
			}
		}
		
		public function raised3Click(e:MouseEvent)
		{
			addAnimationScreen();
			
			var raisedMC:MovieClip = new raisedAnimation(); 
			// add the appropriate animation to the page
			if (!animationPage.contains(raisedMC))
			{
				raisedMC.x = indivX;
				raisedMC.y = indivY;
				animationPage.addChild(raisedMC);
			}
		}
		
		public function solidClick(e:MouseEvent)
		{
			addAnimationScreen();
			
			var solidMC:MovieClip = new solidAnimation(); 
			// add the appropriate animation to the page
			if (!animationPage.contains(solidMC))
			{
				solidMC.x = indivX;
				solidMC.y = indivY;
				animationPage.addChild(solidMC);
			}
		}
		
		public function addAnimationScreen()
		{
			animationPage = new baseScreen();
			animationPage.exitButton.addEventListener(MouseEvent.MOUSE_UP, exitButtonClick);
			// if the animation page doesn't exist
			if (!this.contains(animationPage))
			{
				// set the dimensions and position of the animation screen
				animationPage.x = animX;
				animationPage.y = animY;
				animationPage.width = animWidth;
				animationPage.height = animHeight;
				// add it to the scene
				this.addChild(animationPage);
			}
			
			this.setChildIndex(animationPage, 2);
		}
	}
}
