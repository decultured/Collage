package Collage.DataEngine
{
	public class DataSetField
	{
		//[{"label": "My Field", "internal": "field_0", "type": "string"}]
		
		public var label:String;
		public var internalLabel:String;
		// The "type" paramter can be: string, numeric, datetime, boolean, or url
		public var type:String;
		
		public static function DataSetField():void
		{
		}
	}
}