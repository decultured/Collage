package Collage.DataEngine
{
	public class DataQueryField
	{
		public var sort:Boolean = false;
		public var modifier:String;
		public var group:Boolean = false;
		public var name:String;
		
		public function DataQueryField(name:String, sort:Boolean = false,  modifier:String = null, group:Boolean = false):void
		{
			this.name = name;
			this.sort = sort;
			this.modifier = modifier;
			this.group = group;
		}
	}
}