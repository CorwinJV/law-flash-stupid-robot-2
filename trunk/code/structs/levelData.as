package code.structs
{
	public class levelData
	{
		var levelName:String;
		var description:String;
		var fileName:String;
						
		public function levelData(lvlName:String, desc:String, file:String)
		{
			levelName = lvlName;
			description = desc;
			fileName = file;
		}
					
		public function getName():String
		{
			return levelName;
		}
						
		public function getDesc():String
		{
			return description;	
		}
		
		public function getFile():String
		{
			return fileName;
		}
	}
}