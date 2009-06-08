﻿package code.states
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
		
		var mcPagesArray:Array = new Array();

		var currentMC:MovieClip;
		var currentPageMC:MovieClip;
		var currentPage:int = 1;
		var currentMaxPage:int = 0;
		var currentMessageStartPage:int = 0;
		
		var currentPageTF:TextField = new TextField();
		var maxPageTF:TextField = new TextField();
		
		var oldTFormat:TextFormat = new TextFormat();
		var curTFormat:TextFormat =  new TextFormat();
		
		var shieldMC:MovieClip = new black();
		
		public function tutorialPopUpState(gsm:GameStateManager)
		{
			// this calls gamestate's default constructor and sets up the proper GSM assignment
			super(gsm); // <-- Calls the base class constructor to make sure all the setup shit happens.
			
			switch(GameVars.getInstance().getTutorialMovieClip())
			{
				case 1:
				{
					loadMCPagesArray(1);
					if (GameVars.getInstance().getTutPopUpUseShield())
					{
						mc1.exitButton.addEventListener(MouseEvent.MOUSE_UP, exitButtonClicked);
					}
					mc1.leftArrowButton.addEventListener(MouseEvent.MOUSE_UP, leftArrowButtonClicked);
					mc1.rightArrowButton.addEventListener(MouseEvent.MOUSE_UP, rightArrowButtonClicked);
					currentPageMC = mc1.textBox;
					currentMC = mc1;
					currentMessageStartPage = 1;
					currentPage = currentMessageStartPage;
					currentMaxPage = 15;
					break;
				}
				case 2:
				{
					loadMCPagesArray(1);
					loadMCPagesArray(2);
					if (GameVars.getInstance().getTutPopUpUseShield())
					{
						mc2.exitButton.addEventListener(MouseEvent.MOUSE_UP, exitButtonClicked);
					}
					mc2.leftArrowButton.addEventListener(MouseEvent.MOUSE_UP, leftArrowButtonClicked);
					mc2.rightArrowButton.addEventListener(MouseEvent.MOUSE_UP, rightArrowButtonClicked);
					currentPageMC = mc2.textBox;
					currentMC = mc2;
					currentMessageStartPage = 16;
					currentPage = currentMessageStartPage;
					currentMaxPage = 16;
					break;
				}
				case 3:
				{
					loadMCPagesArray(1);
					loadMCPagesArray(2);
					loadMCPagesArray(3);
					if (GameVars.getInstance().getTutPopUpUseShield())
					{
						mc3.exitButton.addEventListener(MouseEvent.MOUSE_UP, exitButtonClicked);
					}
					mc3.leftArrowButton.addEventListener(MouseEvent.MOUSE_UP, leftArrowButtonClicked);
					mc3.rightArrowButton.addEventListener(MouseEvent.MOUSE_UP, rightArrowButtonClicked);
					currentPageMC = mc3.textBox;
					currentMC = mc3;
					currentMessageStartPage = 17;
					currentPage = currentMessageStartPage;
					currentMaxPage = 17;
					break;
				}
				case 4:
				{
					loadMCPagesArray(1);
					loadMCPagesArray(2);
					loadMCPagesArray(3);
					loadMCPagesArray(4);
					if (GameVars.getInstance().getTutPopUpUseShield())
					{
						mc4.exitButton.addEventListener(MouseEvent.MOUSE_UP, exitButtonClicked);
					}
					mc4.leftArrowButton.addEventListener(MouseEvent.MOUSE_UP, leftArrowButtonClicked);
					mc4.rightArrowButton.addEventListener(MouseEvent.MOUSE_UP, rightArrowButtonClicked);
					currentPageMC = mc4.textBox;
					currentMC = mc4;
					currentMessageStartPage = 18;
					currentPage = currentMessageStartPage;
					currentMaxPage = 18;
					break;
				}
				case 5:
				{
					loadMCPagesArray(1);
					loadMCPagesArray(2);
					loadMCPagesArray(3);
					loadMCPagesArray(4);
					loadMCPagesArray(5);
					if (GameVars.getInstance().getTutPopUpUseShield())
					{
						mc5.exitButton.addEventListener(MouseEvent.MOUSE_UP, exitButtonClicked);
					}
					mc5.leftArrowButton.addEventListener(MouseEvent.MOUSE_UP, leftArrowButtonClicked);
					mc5.rightArrowButton.addEventListener(MouseEvent.MOUSE_UP, rightArrowButtonClicked);
					currentPageMC = mc5.textBox;
					currentMC = mc5;
					currentMessageStartPage = 19;
					currentPage = currentMessageStartPage;
					currentMaxPage = 19;
					break;
				}
				case 6:
				{
					loadMCPagesArray(1);
					loadMCPagesArray(2);
					loadMCPagesArray(3);
					loadMCPagesArray(4);
					loadMCPagesArray(5);
					loadMCPagesArray(6);
					if (GameVars.getInstance().getTutPopUpUseShield())
					{
						mc6.exitButton.addEventListener(MouseEvent.MOUSE_UP, exitButtonClicked);
					}
					mc6.leftArrowButton.addEventListener(MouseEvent.MOUSE_UP, leftArrowButtonClicked);
					mc6.rightArrowButton.addEventListener(MouseEvent.MOUSE_UP, rightArrowButtonClicked);
					currentPageMC = mc6.textBox;
					currentMC = mc6;
					currentMessageStartPage = 20;
					currentPage = currentMessageStartPage;
					currentMaxPage = 22;
					break;
				}
				case 7:
				{
					loadMCPagesArray(1);
					loadMCPagesArray(2);
					loadMCPagesArray(3);
					loadMCPagesArray(4);
					loadMCPagesArray(5);
					loadMCPagesArray(6)
					loadMCPagesArray(7);
					if (GameVars.getInstance().getTutPopUpUseShield())
					{
						mc7.exitButton.addEventListener(MouseEvent.MOUSE_UP, exitButtonClicked);
					}
					mc7.leftArrowButton.addEventListener(MouseEvent.MOUSE_UP, leftArrowButtonClicked);
					mc7.rightArrowButton.addEventListener(MouseEvent.MOUSE_UP, rightArrowButtonClicked);
					currentPageMC = mc7.textBox;
					currentMC = mc7;
					currentMessageStartPage = 23;
					currentPage = currentMessageStartPage;
					currentMaxPage = 24;
					break;
				}
				case 8:
				{
					loadMCPagesArray(1);
					loadMCPagesArray(2);
					loadMCPagesArray(3);
					loadMCPagesArray(4);
					loadMCPagesArray(5);
					loadMCPagesArray(6)
					loadMCPagesArray(7);
					loadMCPagesArray(8);
					if (GameVars.getInstance().getTutPopUpUseShield())
					{
						mc8.exitButton.addEventListener(MouseEvent.MOUSE_UP, exitButtonClicked);
					}
					mc8.leftArrowButton.addEventListener(MouseEvent.MOUSE_UP, leftArrowButtonClicked);
					mc8.rightArrowButton.addEventListener(MouseEvent.MOUSE_UP, rightArrowButtonClicked);
					currentPageMC = mc8.textBox;
					currentMC = mc8;
					currentMessageStartPage = 25;
					currentPage = currentMessageStartPage;
					currentMaxPage = 26;
					break;
				}
				case 9:
				{
					loadMCPagesArray(1);
					loadMCPagesArray(2);
					loadMCPagesArray(3);
					loadMCPagesArray(4);
					loadMCPagesArray(5);
					loadMCPagesArray(6)
					loadMCPagesArray(7);
					loadMCPagesArray(8);
					loadMCPagesArray(9);
					if (GameVars.getInstance().getTutPopUpUseShield())
					{
						mc9.exitButton.addEventListener(MouseEvent.MOUSE_UP, exitButtonClicked);
					}
					mc9.leftArrowButton.addEventListener(MouseEvent.MOUSE_UP, leftArrowButtonClicked);
					mc9.rightArrowButton.addEventListener(MouseEvent.MOUSE_UP, rightArrowButtonClicked);
					currentPageMC = mc9.textBox;
					currentMC = mc9;
					currentMessageStartPage = 27;
					currentPage = currentMessageStartPage;
					currentMaxPage = 27;
					break;
				}
			}
		
			// Add a new movie clip to block the player from being
			// able to access any interface elements in the states
			// below this one.
			if (GameVars.getInstance().getTutPopUpUseShield())
			{
				shieldMC.alpha = 0.0;
				shieldMC.x = 0;
				shieldMC.y = 0;
				shieldMC.width = 1024;
				shieldMC.height = 768;
				this.addChild(shieldMC);
			}
			
			// Tell logicInterface not to process the mouse
			if (GameVars.getInstance().getTutPopUpUseShield())
			{
				GameVars.getInstance().setDoNotProcessMouse(true);
			}
			
			// Position the current movie clip & add to display list
			currentMC.x = 205;
			currentMC.y = 50;
			this.addChild(currentMC);
			
			// Position the page-count text fields & add to display list
			currentPageTF.x = currentMC.x + (currentMC.width / 2) - 30;
			currentPageTF.y = currentMC.y + 15;
			this.addChild(currentPageTF);
			
			maxPageTF.x = currentMC.x + (currentMC.width / 2) - 10;
			maxPageTF.y = currentMC.y + 15;
			this.addChild(maxPageTF);
		}
		
		public override function getStateName():String
		{
			return "tutorialPopUpState";
		}
		
		public override function Update()
		{
			draw();
		}
		
		public function draw():void
		{
			oldTFormat.size = 24;
			oldTFormat.font = "Arial";
			oldTFormat.color = 0xFFFF00;
			
			curTFormat.size = 24;
			curTFormat.font = "Arial";
			curTFormat.color = 0x00FF00;

			currentPageTF.text = currentPage.toString();
			if(currentPage >= currentMessageStartPage)
			{
				currentPageTF.setTextFormat(curTFormat);
			}
			else
			{
				currentPageTF.setTextFormat(oldTFormat);
			}
				
			maxPageTF.text = " / " + currentMaxPage.toString();
			maxPageTF.setTextFormat(curTFormat);
		}
		
		public function loadMCPagesArray(i:int)
		{
			switch(i)
			{
				case 1:
				{
					mcPagesArray.push(new tutorialPage01Text01());
					mcPagesArray.push(new tutorialPage01Text02());
					mcPagesArray.push(new tutorialPage01Text03());
					mcPagesArray.push(new tutorialPage01Text04());
					mcPagesArray.push(new tutorialPage01Text05());
					mcPagesArray.push(new tutorialPage01Text06());
					mcPagesArray.push(new tutorialPage01Text07());
					mcPagesArray.push(new tutorialPage01Text08());
					mcPagesArray.push(new tutorialPage01Text09());
					mcPagesArray.push(new tutorialPage01Text10());
					mcPagesArray.push(new tutorialPage01Text11());
					mcPagesArray.push(new tutorialPage01Text12());
					mcPagesArray.push(new tutorialPage01Text13());
					mcPagesArray.push(new tutorialPage01Text14());
					mcPagesArray.push(new tutorialPage01Text15());
					break;
				}
				case 2:
				{
					mcPagesArray.push(new tutorialPage02Text01());
					break;
				}
				case 3:
				{
					mcPagesArray.push(new tutorialPage03Text01());
					break;
				}
				case 4:
				{
					mcPagesArray.push(new tutorialPage04Text01());
					break;
				}
				case 5:
				{
					mcPagesArray.push(new tutorialPage05Text01());
					break;
				}
				case 6:
				{
					mcPagesArray.push(new tutorialPage06Text01());
					mcPagesArray.push(new tutorialPage06Text02());
					mcPagesArray.push(new tutorialPage06Text03());
					break;
				}
				case 7:
				{
					mcPagesArray.push(new tutorialPage07Text01());
					mcPagesArray.push(new tutorialPage07Text02());
					break;
				}
				case 8:
				{
					mcPagesArray.push(new tutorialPage08Text01());
					mcPagesArray.push(new tutorialPage08Text02());
					break;
				}
				case 9:
				{
					mcPagesArray.push(new tutorialPage09Text01());
					break;
				}
			}
		}
		
		public function exitButtonClicked(e:MouseEvent)
		{
			this.setStatus(GameStateEnum.DELETE_ME);
			GameVars.getInstance().setDoNotProcessMouse(false);
		}
		
		public function leftArrowButtonClicked(e:MouseEvent)
		{
			//trace("Current Page: " +  currentPage);
			currentPage--;
			if (currentPage < 1)
			{
				currentPage = 1;
			}
			
			var oldX = currentPageMC.x;
			var oldY = currentPageMC.y;
			
			currentMC.removeChild(currentPageMC);
			currentPageMC = mcPagesArray[currentPage - 1]; // -1 because we're using a 0-based array 
														   // and a 1-based counter for the current page
			currentPageMC.x = oldX;
			currentPageMC.y = oldY;
			currentMC.addChild(currentPageMC);
		}
		
		public function rightArrowButtonClicked(e:MouseEvent)
		{
//			trace("Current Page: " +  currentPage);
//			trace("Current max page: " + currentMaxPage);
			currentPage++;
			if (currentPage > currentMaxPage)
			{
				currentPage = currentMaxPage;
			}
			
			var oldX = currentPageMC.x;
			var oldY = currentPageMC.y;
			
			currentMC.removeChild(currentPageMC);
			currentPageMC = mcPagesArray[currentPage - 1]; // -1 because we're using a 0-based array 
														   // and a 1-based counter for the current page
			currentPageMC.x = oldX;
			currentPageMC.y = oldY;
			currentMC.addChild(currentPageMC);
		}
	}
}





