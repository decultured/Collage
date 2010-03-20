package Collage.Clip
{
	import flash.utils.*;
	import flash.events.*;
	import Collage.Logger.*;
	import mx.controls.Alert;
	import com.roguedevelopment.objecthandles.IMoveable;
	import com.roguedevelopment.objecthandles.IResizeable;
	import com.adobe.serialization.json.JSON;

	public class Clip extends EventDispatcher implements IResizeable, IMoveable
	{
		private var _UID:String;
		[Bindable] public var selected:Boolean = false;

		[Savable] public var type:String = "clip";
		[Bindable][Savable] public var x:Number = 10;
		[Bindable][Savable] public var y:Number  = 10;
		[Bindable][Savable] public var height:Number = 150;
		[Bindable][Savable] public var width:Number = 150;
		[Bindable][Savable] public var rotation:Number = 0;
		
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

		public function Resized():void { }
		public function Moved():void { }
 		public function Rotated():void { }
		public function LoadFromData(data:Object):Boolean { return false; }
		public function LoadFromXML():Boolean {	return false; }
		
		public function SaveToObject():Object
		{
			var typeDef:XML = describeType(this);
			
			var newObject:Object = new Object();

			for each (var metadata:XML in typeDef..metadata)
			{
				Logger.Log(metadata["@name"], LogEntry.DEBUG, this);
				if (metadata["@name"] != "Savable")
					continue;

				if (this.hasOwnProperty(metadata.parent()["@name"]))
					newObject[metadata.parent()["@name"]] = this[metadata.parent()["@name"]];
			}

			return newObject;
		}

		public function LoadFromObject(dataObject:Object):Boolean
		{
			if (!dataObject)
				return false;

			for(var obj_k:String in dataObject) {
				try {
					if(this.hasOwnProperty(obj_k))
						this[obj_k] = dataObject[obj_k];
				} catch(e:Error) {
					
				}
			}

			return true;
		}
	}
}