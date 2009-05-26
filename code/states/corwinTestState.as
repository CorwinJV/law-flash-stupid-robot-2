package code.states 
{
	/**
	 * ...
	 * @author Corwin VanHook
	 */

	import code.GameState;
	import code.GameStateManager;
	import code.LogicInterface;
	
	public class corwinTestState extends GameState
	{
		private var mInterface:LogicInterface;
		
		public function corwinTestState(gsm:GameStateManager) 
		{
			super(gsm);
			mInterface = new LogicInterface();
			mInterface.GetCurrentLevelBytes();
			this.addChild(mInterface);
			
			
		}
		
		public override function Update()
		{
			mInterface.Update();
		}
		public override function getStateName():String
		{
			return "corwinTestState";
		}
		public override function initMouse()
		{
			// Overloading the initMouse function  so
			// that we can init mInterface's mouse!
			mInterface.initEventListeners();
		}
	}
}