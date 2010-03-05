package Collage.DataEngine
{
	public class DataQueryField
	{
		public var sort:String = null;
		public var modifier:String = null;
		public var group:String = null;
		public var name:String = null;
		public var alias:String = null;
		
		public function DataQueryField(name:String, sort:String = null,  modifier:String = null, group:String = null, alias:String = null):void
		{
			this.name = name;
			this.sort = sort;
			this.modifier = modifier;
			this.group = group;
			this.alias = alias;
		}
	}
}