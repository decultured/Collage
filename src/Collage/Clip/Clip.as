package Collage.Clip
{
	import mx.controls.Alert;
	import com.roguedevelopment.objecthandles.IMoveable;
	import com.roguedevelopment.objecthandles.IResizeable;

	public class Clip implements IResizeable, IMoveable
	{
		private var _UID:String;
		[Bindable] public var selected:Boolean = false;

		[Bindable] public var x:Number = 10;
		[Bindable] public var y:Number  = 10;
		[Bindable] public var height:Number = 150;
		[Bindable] public var width:Number = 150;
		[Bindable] public var rotation:Number = 0;
		
		public var verticalSizable:Boolean = true;
		public var horizontalSizable:Boolean = true;
		public var rotatable:Boolean = true;
		
		protected var _Editor:ClipEditor;
		protected var _View:ClipView;

       	public function get uid():String
		{
			if (!_UID)
				_UID = UIDUtil.createUID();
			return _UID;
		}
		public function set uid(uid:String):void {_UID = uid;}
		public function get editor():ClipEditor {return _Editor;}
		public function get view():ClipView {return _View;}

		public function Clip():void
		{
		}
		
		public function CreateView(newView:ClipView = null):void
		{
			if (newView)
				_View = newView;
			else {
				_View = new ClipView();
				_View.model = this;
			}
		}

		public function CreateEditor(newEditor:ClipEditor = null):void
		{
			if (newEditor)
				_Editor = newEditor;
			else {
				_Editor = new ClipEditor();
				_Editor.model = this;
			}
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
		
		public function LoadFromData(data:Object):Boolean
		{
			return false;
		}

		public function LoadFromXML():Boolean
		{
			return false;
		}
	}
}