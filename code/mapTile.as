package code
{
	import code.enums.tileEnums;
	import flash.display.MovieClip;
	
	/**
	 * ...
	 * @author David Moss
	 */
	public class mapTile extends MovieClip
	{
		var tileType:tileEnums = new tileEnums(0);
		var baseTileType:tileEnums = new tileEnums(0);
		var alternateTileType:tileEnums = new tileEnums(0);
		var isActive:Boolean;
		var resetActiveStatus:Boolean;
		var gridXPos:int;
		var gridYPos:int;
		var drawXPos:Number;
		var drawYPos:Number;
		var scale:Number;
		
		var tileClip:MovieClip;
		
		var baseWidth:int = 72;
		var baseHeight:int = 72;
		
		//public function mapTile() 
		//{
			//isActive = false;
			//resetActiveStatus = false;
			//tileType = tileEnums.TEmpty;
			//baseTileType = tileEnums.TEmpty;
			//alternateTileType = tileEnums.TEmpty;
		//}
		
		public function mapTile(nType:tileEnums, nisActive:Boolean)
		{
			tileClip = new GenericTileContainer();
			tileClip.x = 0;
			tileClip.y = 0;
			tileClip.width = baseWidth;
			tileClip.height = baseWidth;
			this.addChild(tileClip);
			
			isActive = nisActive;
			resetActiveStatus = nisActive;
			
			tileType = nType;
			baseTileType = nType;
			alternateTileType = nType;
			
			setTileImage();			
		}
		
		public function getType():tileEnums
		{
			return tileType;			
		}
		
		public function setType(nType:tileEnums)
		{
			tileType = nType;			
		}
		
		public function getIsActive():Boolean
		{
			return isActive;			
		}
		
		public function setActive(nActive:Boolean)
		{
			isActive = nActive;			
		}
		
		public function toggleActive()
		{
			if (isActive == true)
			{
				isActive = false;
			}
			else
			{
				isActive = true;
			}			
		}
				
		public function resetActive()
		{
			isActive = resetActiveStatus;
		}
		
		public function setResetActive(newActive:Boolean)
		{
			resetActiveStatus = newActive;
		}
		
		public function setBaseType(newType:tileEnums)
		{
			baseTileType = newType;
		}
		public function swapTileType()
		{
			var tempTile:tileEnums = new tileEnums(0);
			
			tempTile = tileType;
			tileType = alternateTileType;
			alternateTileType = tempTile;			
		}
		
		public function resetTileType()
		{
			if (tileType != baseTileType)
			{
				tileType = baseTileType;
			}			
		}
		
		public function rotateRight()
		{
			//trace("Rotate Right, tiletype = ", tileType);
			// do the base tile types first
			// half tops
			if		( tileType.toInt() == tileEnums.THalfTopL.toInt())		{	 tileType = tileEnums.THalfTopR;	}
			else if	( tileType.toInt() == tileEnums.THalfTopR.toInt())		{	 tileType = tileEnums.THalfTopL;	}
			// half bottom
			else if ( tileType.toInt() == tileEnums.THalfBottomR.toInt())	{	 tileType = tileEnums.THalfBottomL;	}
			else if ( tileType.toInt() == tileEnums.THalfBottomL.toInt())	{	 tileType = tileEnums.THalfBottomR;	}
			// electric
			else if	( tileType.toInt() == tileEnums.TElectricTL.toInt())	{	 tileType = tileEnums.TElectricTR;	}
			else if ( tileType.toInt() == tileEnums.TElectricTR.toInt())	{	 tileType = tileEnums.TElectricBR;	}
			else if ( tileType.toInt() == tileEnums.TElectricBR.toInt())	{	 tileType = tileEnums.TElectricBL;	}
			else if ( tileType.toInt() == tileEnums.TElectricBL.toInt())	{	 tileType = tileEnums.TElectricTL;	}
			// switches
			else if	( tileType.toInt() == tileEnums.TSwitchTL.toInt())		{	 tileType = tileEnums.TSwitchTR;	}
			else if	( tileType.toInt() == tileEnums.TSwitchTR.toInt())		{	 tileType = tileEnums.TSwitchBR;	}
			else if	( tileType.toInt() == tileEnums.TSwitchBR.toInt())		{	 tileType = tileEnums.TSwitchBL;	}
			else if	( tileType.toInt() == tileEnums.TSwitchBL.toInt())		{	 tileType = tileEnums.TSwitchTL;	}
			// reprogram squares
			else if	( tileType.toInt() == tileEnums.TProgramTL.toInt())		{	 tileType = tileEnums.TProgramTR;	}
			else if	( tileType.toInt() == tileEnums.TProgramTR.toInt())		{	 tileType = tileEnums.TProgramBR;	}
			else if	( tileType.toInt() == tileEnums.TProgramBR.toInt())		{	 tileType = tileEnums.TProgramBL;	}
			else if	( tileType.toInt() == tileEnums.TProgramBL.toInt())		{	 tileType = tileEnums.TProgramTL;	}
			// breakables
			else if	( tileType.toInt() == tileEnums.TBreakableTL.toInt())	{	 tileType = tileEnums.TBreakableTR;	}
			else if	( tileType.toInt() == tileEnums.TBreakableTR.toInt())	{	 tileType = tileEnums.TBreakableBR;	}
			else if	( tileType.toInt() == tileEnums.TBreakableBR.toInt())	{	 tileType = tileEnums.TBreakableBL;	}
			else if	( tileType.toInt() == tileEnums.TBreakableBL.toInt())	{	 tileType = tileEnums.TBreakableTL;	}
			// doors
			else if	( tileType.toInt() == tileEnums.TDoorTL.toInt())		{	 tileType = tileEnums.TDoorTR;		}
			else if	( tileType.toInt() == tileEnums.TDoorTR.toInt())		{	 tileType = tileEnums.TDoorBR;		}
			else if	( tileType.toInt() == tileEnums.TDoorBR.toInt())		{	 tileType = tileEnums.TDoorBL;		}
			else if	( tileType.toInt() == tileEnums.TDoorBL.toInt())		{	 tileType = tileEnums.TDoorTL;		}
			
			// now the alternate tiletypes
			// half tops
			if		( alternateTileType.toInt() == tileEnums.THalfTopL.toInt())		{	 alternateTileType = tileEnums.THalfTopR;	}
			else if	( alternateTileType.toInt() == tileEnums.THalfTopR.toInt())		{	 alternateTileType = tileEnums.THalfTopL;	}
			// half bottom
			else if ( alternateTileType.toInt() == tileEnums.THalfBottomR.toInt())	{	 alternateTileType = tileEnums.THalfBottomL;}
			else if ( alternateTileType.toInt() == tileEnums.THalfBottomL.toInt())	{	 alternateTileType = tileEnums.THalfBottomR;}
			// electric
			else if	( alternateTileType.toInt() == tileEnums.TElectricTL.toInt())	{	 alternateTileType = tileEnums.TElectricTR;	}
			else if ( alternateTileType.toInt() == tileEnums.TElectricTR.toInt())	{	 alternateTileType = tileEnums.TElectricBR;	}
			else if ( alternateTileType.toInt() == tileEnums.TElectricBR.toInt())	{	 alternateTileType = tileEnums.TElectricBL;	}
			else if ( alternateTileType.toInt() == tileEnums.TElectricBL.toInt())	{	 alternateTileType = tileEnums.TElectricTL;	}
			// switches
			else if	( alternateTileType.toInt() == tileEnums.TSwitchTL.toInt())		{	 alternateTileType = tileEnums.TSwitchTR;	}
			else if	( alternateTileType.toInt() == tileEnums.TSwitchTR.toInt())		{	 alternateTileType = tileEnums.TSwitchBR;	}
			else if	( alternateTileType.toInt() == tileEnums.TSwitchBR.toInt())		{	 alternateTileType = tileEnums.TSwitchBL;	}
			else if	( alternateTileType.toInt() == tileEnums.TSwitchBL.toInt())		{	 alternateTileType = tileEnums.TSwitchTL;	}
			// reprogram squares
			else if	( alternateTileType.toInt() == tileEnums.TProgramTL.toInt())	{	 alternateTileType = tileEnums.TProgramTR;	}
			else if	( alternateTileType.toInt() == tileEnums.TProgramTR.toInt())	{	 alternateTileType = tileEnums.TProgramBR;	}
			else if	( alternateTileType.toInt() == tileEnums.TProgramBR.toInt())	{	 alternateTileType = tileEnums.TProgramBL;	}
			else if	( alternateTileType.toInt() == tileEnums.TProgramBL.toInt())	{	 alternateTileType = tileEnums.TProgramTL;	}
			// breakables
			else if	( alternateTileType.toInt() == tileEnums.TBreakableTL.toInt())	{	 alternateTileType = tileEnums.TBreakableTR;}
			else if	( alternateTileType.toInt() == tileEnums.TBreakableTR.toInt())	{	 alternateTileType = tileEnums.TBreakableBR;}
			else if	( alternateTileType.toInt() == tileEnums.TBreakableBR.toInt())	{	 alternateTileType = tileEnums.TBreakableBL;}
			else if	( alternateTileType.toInt() == tileEnums.TBreakableBL.toInt())	{	 alternateTileType = tileEnums.TBreakableTL;}
			// doors
			else if	( alternateTileType.toInt() == tileEnums.TDoorTL.toInt())		{	 alternateTileType = tileEnums.TDoorTR;		}
			else if	( alternateTileType.toInt() == tileEnums.TDoorTR.toInt())		{	 alternateTileType = tileEnums.TDoorBR;		}
			else if	( alternateTileType.toInt() == tileEnums.TDoorBR.toInt())		{	 alternateTileType = tileEnums.TDoorBL;		}
			else if	( alternateTileType.toInt() == tileEnums.TDoorBL.toInt())		{	 alternateTileType = tileEnums.TDoorTL;		}
			
		}
		
		public function rotateLeft()
		{
			// half top
			if		(tileType.toInt() == tileEnums.THalfTopL.toInt())		{	tileType = tileEnums.THalfTopR;		}
			else if	(tileType.toInt() == tileEnums.THalfTopR.toInt())		{	tileType = tileEnums.THalfTopL;		}
			// half bottom
			else if (tileType.toInt() == tileEnums.THalfBottomR.toInt())	{	tileType = tileEnums.THalfBottomL;	}
			else if (tileType.toInt() == tileEnums.THalfBottomL.toInt())	{	tileType = tileEnums.THalfBottomR;	}
			// electric
			else if	(tileType.toInt() == tileEnums.TElectricTL.toInt())		{	tileType = tileEnums.TElectricBL;	}
			else if (tileType.toInt() == tileEnums.TElectricBL.toInt())		{	tileType = tileEnums.TElectricBR;	}
			else if (tileType.toInt() == tileEnums.TElectricBR.toInt())		{	tileType = tileEnums.TElectricTR;	}
			else if (tileType.toInt() == tileEnums.TElectricTR.toInt())		{	tileType = tileEnums.TElectricTL;	}
			// switches
			else if	(tileType.toInt() == tileEnums.TSwitchTL.toInt())		{	tileType = tileEnums.TSwitchBL;		}
			else if	(tileType.toInt() == tileEnums.TSwitchBL.toInt())		{	tileType = tileEnums.TSwitchBR;		}
			else if	(tileType.toInt() == tileEnums.TSwitchBR.toInt())		{	tileType = tileEnums.TSwitchTR;		}
			else if	(tileType.toInt() == tileEnums.TSwitchTR.toInt())		{	tileType = tileEnums.TSwitchTL;		}
			// reprogram squares
			else if	(tileType.toInt() == tileEnums.TProgramTL.toInt())		{	tileType = tileEnums.TProgramBL;	}
			else if	(tileType.toInt() == tileEnums.TProgramBL.toInt())		{	tileType = tileEnums.TProgramBR;	}
			else if	(tileType.toInt() == tileEnums.TProgramBR.toInt())		{	tileType = tileEnums.TProgramTR;	}
			else if	(tileType.toInt() == tileEnums.TProgramTR.toInt())		{	tileType = tileEnums.TProgramTL;	}
			// breakables
			else if	(tileType.toInt() == tileEnums.TBreakableTL.toInt())	{	tileType = tileEnums.TBreakableBL;	}
			else if	(tileType.toInt() == tileEnums.TBreakableBL.toInt())	{	tileType = tileEnums.TBreakableBR;	}
			else if	(tileType.toInt() == tileEnums.TBreakableBR.toInt())	{	tileType = tileEnums.TBreakableTR;	}
			else if	(tileType.toInt() == tileEnums.TBreakableTR.toInt())	{	tileType = tileEnums.TBreakableTL;	}
			// doors
			else if	(tileType.toInt() == tileEnums.TDoorTL.toInt())			{	tileType = tileEnums.TDoorBL;		}
			else if	(tileType.toInt() == tileEnums.TDoorBL.toInt())			{	tileType = tileEnums.TDoorBR;		}
			else if	(tileType.toInt() == tileEnums.TDoorBR.toInt())			{	tileType = tileEnums.TDoorTR;		}
			else if	(tileType.toInt() == tileEnums.TDoorTR.toInt())			{	tileType = tileEnums.TDoorTL;		}
			
			// half top
			if		(alternateTileType.toInt() == tileEnums.THalfTopL.toInt())		{	alternateTileType = tileEnums.THalfTopR;	}
			else if	(alternateTileType.toInt() == tileEnums.THalfTopR.toInt())		{	alternateTileType = tileEnums.THalfTopL;	}
			// half bottom
			else if (alternateTileType.toInt() == tileEnums.THalfBottomR.toInt())	{	alternateTileType = tileEnums.THalfBottomL;	}
			else if (alternateTileType.toInt() == tileEnums.THalfBottomL.toInt())	{	alternateTileType = tileEnums.THalfBottomR;	}
			// electric
			else if	(alternateTileType.toInt() == tileEnums.TElectricTL.toInt())	{	alternateTileType = tileEnums.TElectricBL;	}
			else if (alternateTileType.toInt() == tileEnums.TElectricBL.toInt())	{	alternateTileType = tileEnums.TElectricBR;	}
			else if (alternateTileType.toInt() == tileEnums.TElectricBR.toInt())	{	alternateTileType = tileEnums.TElectricTR;	}
			else if (alternateTileType.toInt() == tileEnums.TElectricTR.toInt())	{	alternateTileType = tileEnums.TElectricTL;	}
			// switches
			else if	(alternateTileType.toInt() == tileEnums.TSwitchTL.toInt())		{	alternateTileType = tileEnums.TSwitchBL;	}
			else if	(alternateTileType.toInt() == tileEnums.TSwitchBL.toInt())		{	alternateTileType = tileEnums.TSwitchBR;	}
			else if	(alternateTileType.toInt() == tileEnums.TSwitchBR.toInt())		{	alternateTileType = tileEnums.TSwitchTR;	}
			else if	(alternateTileType.toInt() == tileEnums.TSwitchTR.toInt())		{	alternateTileType = tileEnums.TSwitchTL;	}
			// reprogram squares
			else if	(alternateTileType.toInt() == tileEnums.TProgramTL.toInt())		{	alternateTileType = tileEnums.TProgramBL;	}
			else if	(alternateTileType.toInt() == tileEnums.TProgramBL.toInt())		{	alternateTileType = tileEnums.TProgramBR;	}
			else if	(alternateTileType.toInt() == tileEnums.TProgramBR.toInt())		{	alternateTileType = tileEnums.TProgramTR;	}
			else if	(alternateTileType.toInt() == tileEnums.TProgramTR.toInt())		{	alternateTileType = tileEnums.TProgramTL;	}
			// breakables
			else if	(alternateTileType.toInt() == tileEnums.TBreakableTL.toInt())	{	alternateTileType = tileEnums.TBreakableBL;	}
			else if	(alternateTileType.toInt() == tileEnums.TBreakableBL.toInt())	{	alternateTileType = tileEnums.TBreakableBR;	}
			else if	(alternateTileType.toInt() == tileEnums.TBreakableBR.toInt())	{	alternateTileType = tileEnums.TBreakableTR;	}
			else if	(alternateTileType.toInt() == tileEnums.TBreakableTR.toInt())	{	alternateTileType = tileEnums.TBreakableTL;	}
			// doors
			else if	(alternateTileType.toInt() == tileEnums.TDoorTL.toInt())		{	alternateTileType = tileEnums.TDoorBL;		}
			else if	(alternateTileType.toInt() == tileEnums.TDoorBL.toInt())		{	alternateTileType = tileEnums.TDoorBR;		}
			else if	(alternateTileType.toInt() == tileEnums.TDoorBR.toInt())		{	alternateTileType = tileEnums.TDoorTR;		}
			else if	(alternateTileType.toInt() == tileEnums.TDoorTR.toInt())		{	alternateTileType = tileEnums.TDoorTL;		}				
		}
	
		public function setDrawXY(newX:Number, newY:Number)
		{
			drawXPos = newX;
			drawYPos = newY;
		}
		
		public function setGridXY(newX:int, newY:int)
		{
			gridXPos = newX;
			gridYPos = newY;
		}
		
		public function update(newX:Number, newY:Number, newScale:Number):void
		{
			var tempdx:int;
			var tempdy:int;
			tempdx = tileClip.width;
			tempdy = tileClip.height;
			
			tileClip.width = baseWidth * scale;
			tileClip.height = baseHeight * scale;
			
			tileClip.x = newX;
			tileClip.y = newY;
			
			setTileImage();			
		}
		
		public function setTileImage():void
		{
			// first lets make sure our lovely tileclip is emptied out
			for (var x:int = 0; x < tileClip.numChildren; x++)
			{
				tileClip.removeChildAt(0);
			}
						
			switch(tileType.toInt())
			{
				case 0:
					if (isActive)			{	tileClip.addChild(new TEmptyABG());	}
					else					{	tileClip.addChild(new TEmptyIBG());	}
					break;
					
				case 1:
					if (isActive)			{	tileClip.addChild(new TDefaultABG());	}
					else					{	tileClip.addChild(new TDefaultIBG());	}
					break;
					
				case 2:
					if (isActive)			{	tileClip.addChild(new TRaised1ABG());	}
					else					{	tileClip.addChild(new TRaised1IBG());	}
					break;
					
				case 3:
					if (isActive)			{	tileClip.addChild(new TRaised2ABG());	}
					else					{	tileClip.addChild(new TRaised2IBG());	}
					break;
					
				case 4:
					if (isActive)			{	tileClip.addChild(new TRaised3ABG());	}
					else					{	tileClip.addChild(new TRaised3IBG());	}
					break;
					
				case 5:
					if (isActive)			{	tileClip.addChild(new TRaised4ABG());	}
					else					{	tileClip.addChild(new TRaised4IBG());	}
					break;
					
				case 6:
					if (isActive)			{	tileClip.addChild(new THalfTopLABG());	}
					else					{	tileClip.addChild(new THalfTopLIBG());	}
					break;
					
				case 7:
					if (isActive)			{	tileClip.addChild(new THalfTopRABG());	}
					else					{	tileClip.addChild(new THalfTopRIBG());	}
					break;
					
				case 8:
					if (isActive)			{	tileClip.addChild(new THalfBottomLABG());	}
					else					{	tileClip.addChild(new THalfBottomLIBG());	}
					break;
					
				case 9:
					if (isActive)			{	tileClip.addChild(new THalfBottomRABG());	}
					else					{	tileClip.addChild(new THalfBottomRIBG());	}
					break;
					
				case 10:
					if (isActive)			{	tileClip.addChild(new TGapABG());	}
					else					{	tileClip.addChild(new TGapIBG());	}
					break;
					
				case 11:
					if (isActive)			{	tileClip.addChild(new TElectricABG());	}
					else					{	tileClip.addChild(new TElectricIBG());	}
					break;
					
				case 12:
					if (isActive)			{	tileClip.addChild(new TElectricTLABG());	}
					else					{	tileClip.addChild(new TElectricTLIBG());	}
					break;
					
				case 13:
					if (isActive)			{	tileClip.addChild(new TElectricTRABG());	}
					else					{	tileClip.addChild(new TElectricTRIBG());	}
					break;
					
				case 14:
					if (isActive)			{	tileClip.addChild(new TElectricBLABG());	}
					else					{	tileClip.addChild(new TElectricBLIBG());	}
					break;
					
				case 15:
					if (isActive)			{	tileClip.addChild(new TElectricBRABG());	}
					else					{	tileClip.addChild(new TElectricBRIBG());	}
					break;
					
				case 16:
					if (isActive)			{	tileClip.addChild(new TIceABG());	}
					else					{	tileClip.addChild(new TIceIBG());	}
					break;
					
				case 17:
					if (isActive)			{	tileClip.addChild(new TWaterABG());	}
					else					{	tileClip.addChild(new TWaterIBG());	}
					break;
					
				case 18:
					if (isActive)			{	tileClip.addChild(new TSwitchTLABG());	}
					else					{	tileClip.addChild(new TSwitchTLIBG());	}
					break;
					
				case 19:
					if (isActive)			{	tileClip.addChild(new TSwitchTRABG());	}
					else					{	tileClip.addChild(new TSwitchTRIBG());	}
					break;
					
				case 20:
					if (isActive)			{	tileClip.addChild(new TSwitchBLABG());	}
					else					{	tileClip.addChild(new TSwitchBLIBG());	}
					break;
					
				case 21:
					if (isActive)			{	tileClip.addChild(new TSwitchBRABG());	}
					else					{	tileClip.addChild(new TSwitchBRIBG());	}
					break;
					
				case 22:
					if (isActive)			{	tileClip.addChild(new TSwitchABG());	}
					else					{	tileClip.addChild(new TSwitchIBG());	}
					break;
					
				case 23:
					if (isActive)			{	tileClip.addChild(new TProgramTLABG());	}
					else					{	tileClip.addChild(new TProgramTLIBG());	}
					break;
					
				case 24:
					if (isActive)			{	tileClip.addChild(new TProgramTRABG());	}
					else					{	tileClip.addChild(new TProgramTRIBG());	}
					break;
					
				case 25:
					if (isActive)			{	tileClip.addChild(new TProgramBLABG());	}
					else					{	tileClip.addChild(new TProgramBLIBG());	}
					break;
					
				case 26:
					if (isActive)			{	tileClip.addChild(new TProgramBRABG());	}
					else					{	tileClip.addChild(new TProgramBRIBG());	}
					break;
					
				case 27:
					if (isActive)			{	tileClip.addChild(new TProgramABG());	}
					else					{	tileClip.addChild(new TProgramIBG());	}
					break;
					
				case 28:
					if (isActive)			{	tileClip.addChild(new TBreakableTLABG());	}
					else					{	tileClip.addChild(new TBreakableTLIBG());	}
					break;	
					
				case 29:
					if (isActive)			{	tileClip.addChild(new TBreakableTRABG());	}
					else					{	tileClip.addChild(new TBreakableTRIBG());	}
					break;	
					
				case 30:
					if (isActive)			{	tileClip.addChild(new TBreakableBLABG());	}
					else					{	tileClip.addChild(new TBreakableBLIBG());	}
					break;	
				
				case 31:
					if (isActive)			{	tileClip.addChild(new TBreakableBRABG());	}
					else					{	tileClip.addChild(new TBreakableBRIBG());	}
					break;	
					
				case 32:
					if (isActive)			{	tileClip.addChild(new TSolidABG());	}
					else					{	tileClip.addChild(new TSolidIBG());	}
					break;
					
				case 33:
					if (isActive)			{	tileClip.addChild(new TBreakableABG());	}
					else					{	tileClip.addChild(new TBreakableIBG());	}
					break;
					
				case 34:
					if (isActive)			{	tileClip.addChild(new TStartABG());	}
					else					{	tileClip.addChild(new TStartIBG());	}
					break;
					
				case 35:
					if (isActive)			{	tileClip.addChild(new TEndABG());	}
					else					{	tileClip.addChild(new TEndIBG());	}
					break;
					
				case 36:
					if (isActive)			{	tileClip.addChild(new TDoorTLABG());	}
					else					{	tileClip.addChild(new TDoorTLIBG());	}
					break;
					
				case 37:
					if (isActive)			{	tileClip.addChild(new TDoorTRABG());	}
					else					{	tileClip.addChild(new TDoorTRIBG());	}
					break;
					
				case 38:
					if (isActive)			{	tileClip.addChild(new TDoorBLABG());	}
					else					{	tileClip.addChild(new TDoorBLIBG());	}
					break;
					
				case 39:
					if (isActive)			{	tileClip.addChild(new TDoorBRABG());	}
					else					{	tileClip.addChild(new TDoorBRIBG());	}
					break;
					
				case 40:
					if (isActive)			{	tileClip.addChild(new TTeleportABG());	}
					else					{	tileClip.addChild(new TTeleportIBG());	}
					break;
			}
		}

		
		// functions end here
		
	}

}