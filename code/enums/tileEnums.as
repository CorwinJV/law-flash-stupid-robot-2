package code.enums 
{
	
	/**
	 * ...
	 * @author David Moss
	 */
	public final class tileEnums 
	{
		private var _value:int;
		
		public static const TEmpty			:tileEnums = new tileEnums(0);		// 0 empty
		public static const TDefault		:tileEnums = new tileEnums(1);		// 1 default floor tile
		public static const TRaised1		:tileEnums = new tileEnums(2);		// 2 raised 1 level
		public static const TRaised2		:tileEnums = new tileEnums(3);		// 3 raised 2 levels
		public static const TRaised3		:tileEnums = new tileEnums(4);		// 4 raised 3 levels
		public static const TRaised4		:tileEnums = new tileEnums(5);		// 5 raised 4 levels
		public static const THalfTopL		:tileEnums = new tileEnums(6);		// 6 half top		:tileEnums = new tileEnums(0); left
		public static const THalfTopR		:tileEnums = new tileEnums(7);		// 7 half top		:tileEnums = new tileEnums(0); right
		public static const THalfBottomL	:tileEnums = new tileEnums(8);		// 8 half bottom		:tileEnums = new tileEnums(0); left
		public static const THalfBottomR	:tileEnums = new tileEnums(9);		// 9 half bottom		:tileEnums = new tileEnums(0); right
		public static const TGap			:tileEnums = new tileEnums(10);		// 10 gap
		public static const TElectric		:tileEnums = new tileEnums(11);		// 11 electric tile
		public static const TElectricTL		:tileEnums = new tileEnums(12);		// 12 electric wall top left
		public static const TElectricTR		:tileEnums = new tileEnums(13);		// 13 electric wall top right
		public static const TElectricBL		:tileEnums = new tileEnums(14);		// 14 electric wall bottom left
		public static const TElectricBR		:tileEnums = new tileEnums(15);		// 15 electric wall bottom right
		public static const TIce			:tileEnums = new tileEnums(16);		// 16 ice tile
		public static const TWater			:tileEnums = new tileEnums(17);		// 17 water tile
		public static const TSwitchTL		:tileEnums = new tileEnums(18);		// 18 switch top left
		public static const TSwitchTR		:tileEnums = new tileEnums(19);		// 19 switch top right
		public static const TSwitchBL		:tileEnums = new tileEnums(20);		// 20 switch bottom left
		public static const TSwitchBR		:tileEnums = new tileEnums(21);		// 21 switch bottom right
		public static const TSwitch			:tileEnums = new tileEnums(22);		// 22 switch whole square
		public static const TProgramTL		:tileEnums = new tileEnums(23);		// 23 reprogram spot top left
		public static const TProgramTR		:tileEnums = new tileEnums(24);		// 24 reprogram spot top right
		public static const TProgramBL		:tileEnums = new tileEnums(25);		// 25 reprogram spot bottom left
		public static const TProgramBR		:tileEnums = new tileEnums(26);		// 26 reprogram spot bottom right
		public static const TProgram		:tileEnums = new tileEnums(27);		// 27 reprogram spot
		public static const TBreakableTL	:tileEnums = new tileEnums(28);		// 28 breakable top leftle
		public static const TBreakableTR	:tileEnums = new tileEnums(29);		// 29 breakable top right
		public static const TBreakableBL	:tileEnums = new tileEnums(30);		// 30 breakable bottom left
		public static const TBreakableBR	:tileEnums = new tileEnums(31);		// 31 breakable bottom right
		public static const TSolid			:tileEnums = new tileEnums(32);		// 32 Solid Block
		public static const TBreakable		:tileEnums = new tileEnums(33);		// 33 Solid Breakable Square
		public static const TStart			:tileEnums = new tileEnums(34);		// 34 start square
		public static const TEnd			:tileEnums = new tileEnums(35);		// 35 end square
		public static const TDoorTL			:tileEnums = new tileEnums(36);		// 36 door top left
		public static const TDoorTR			:tileEnums = new tileEnums(37);		// 37 door top right
		public static const TDoorBL			:tileEnums = new tileEnums(38);		// 38 door bottom left
		public static const TDoorBR			:tileEnums = new tileEnums(39);		// 39 door bottom right
		public static const TTeleport		:tileEnums = new tileEnums(40);		// 40 teleporter
			
		public function tileEnums(val:int)
		{
			_value = val;
		}
		
		public function toInt():int
		{
			return _value;
		}
		
	}
	
}