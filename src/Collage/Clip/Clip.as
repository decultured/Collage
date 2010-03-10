package Collage.Clip
{
	import mx.controls.Alert;
	import com.roguedevelopment.objecthandles.IMoveable;
	import com.roguedevelopment.objecthandles.IResizeable;
	import com.adobe.serialization.json.JSON;

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
		public var moveFromCenter:Boolean = false;
		public var rotatable:Boolean = false;
		
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

		public function Clip(dataObject:Object = null):void
		{
			if (dataObject)
				LoadFromObject(dataObject);
		}
		
		public function CreateView(newView:ClipView = null):void
		{
			if (newView) {
				_View = newView;
				_View.model = this;
			} else {
				_View = new ClipView();
				_View.model = this;
			}
		}

		public function CreateEditor(newEditor:ClipEditor = null):void
		{
			if (newEditor) {
				_Editor = newEditor;
				_Editor.model = this;
			} else {
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
		
		public function SaveToObject():Object
		{
			var newObject:Object = new Object();

			newObject["type"] = "clip";
			newObject["x"] = x;
			newObject["y"] = y;
			newObject["height"] = height;
			newObject["width"] = width;
			newObject["rotation"] = rotation;

			return newObject;
		}

		public function LoadFromObject(dataObject:Object):Boolean
		{
			if (!dataObject)
				return false;

			for (var key:String in dataObject)
			{
				if (key == "x") {
					x = parseInt(dataObject[key]);
				} else if (key == "y") {
					y = parseInt(dataObject[key]);
				} else if (key == "height") {
					height = parseInt(dataObject[key]);
				} else if (key == "width") {
					width = parseInt(dataObject[key]);
				} else if (key == "rotation") {
					rotation = parseFloat(dataObject[key]);
				} 
			}
			return true;
		}
	}
}