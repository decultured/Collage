package Collage.DataEngine
{
	public class DataSet
	{
		[Bindable] public var uploaded:Boolean = false;
		[Bindable] public var title:String;
		[Bindable] public var changed:Number;
		[Bindable] public var created:Number;
		[Bindable] public var processed:Boolean = false;
		[Bindable] public var identifier:String;
		[Bindable] public var id:String;
		
		public static function DataSet():void
		{
		}
	}
}