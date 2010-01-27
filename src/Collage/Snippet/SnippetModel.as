package Collage.Snippet
{
	import mx.controls.Alert;
	import com.roguedevelopment.objecthandles.IMoveable;
	import com.roguedevelopment.objecthandles.IResizeable;

	public class SnippetModel implements IResizeable, IMoveable
	{
		[Bindable] public var x:Number = 10;
		[Bindable] public var y:Number  = 10;
		[Bindable] public var height:Number = 50;
		[Bindable] public var width:Number = 50;
		[Bindable] public var rotation:Number = 0;
		
		public function Resized():void
		{
		}
		public function Moved():void
		{
		}
		public function Rotated():void
		{
		}
	}
}