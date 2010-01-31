package Collage.Snippet
{
	import mx.controls.Alert;
	import com.roguedevelopment.objecthandles.IMoveable;
	import com.roguedevelopment.objecthandles.IResizeable;

	public class Clip implements IResizeable, IMoveable
	{
		private var _UID:String;

		[Bindable] public var x:Number = 10;
		[Bindable] public var y:Number  = 10;
		[Bindable] public var height:Number = 150;
		[Bindable] public var width:Number = 150;
		[Bindable] public var rotation:Number = 0;
		
		private var _Editor:ClipEditor;
		private var _View:ClipView;

       	public function get uid():String {return _uid;}
		public function get editor():ClipEditor {return _Editor;}
		public function get view():ClipView {return _View;}

		// These should be overidden in child classes
		public static function get TypeName():String {return "Clip";}
		public static function get FileAssociations():Array {return null;}
		public static function get ObjectAssociations():Array {return null;}

		public function ClipModel():void
		{
			_uid = UIDUtil.createUID();
		}

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