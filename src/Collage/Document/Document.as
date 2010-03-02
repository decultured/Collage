package Collage.Document
{
	import mx.controls.Alert;
	import Collage.Clip.*;
	import com.adobe.serialization.json.JSON;
	
	public class Document extends Clip
	{
		[Bindable] public var snap:Boolean = false;
		[Bindable] public var grid:Boolean = false;
		[Bindable] public var gridSize:Number = 10;
		[Bindable] public var gridColor:Number = 0xeeeeee;
		
		private var _URL:String = null;
		private var _BackgroundColor:Number = 0xFFFFFF;

		[Bindable]
		public function get url():String {return _URL;}
		public function set url(url:String):void {_URL = url;}

		[Bindable]
		public function get backgroundColor():Number {return _BackgroundColor;}
		public function set backgroundColor(bgColor:Number):void {_BackgroundColor = bgColor;}
		
		public function Document()
		{
			super();
			height = 768;
			width = 1024;
			CreateEditor();
		}
		
		public function CreateEditView(newView:ClipView = null):void
		{
			if (newView)
				_View = newView;
			else {
				_View = new EditDocumentView();
				_View.model = this;
			}
		}

		public override function CreateView(newView:ClipView = null):void
		{
			if (newView)
				_View = newView;
			else {
				_View = new DocumentView();
				_View.model = this;
			}
		}

		public override function CreateEditor(newEditor:ClipEditor = null):void
		{
			if (newEditor)
				_Editor = newEditor;
			else {
				_Editor = new DocumentEditor();
				_Editor.model = this;
			}
		}

		public override function LoadFromData(data:Object):Boolean
		{
			var view:DocumentView = _View as DocumentView;
			return view.LoadFromData(data);
		}

		public override function SaveToObject():Object
		{
			var newObject:Object = new Object();

			newObject["document"] = super.SaveToObject();
			newObject["document"]["type"] = "document";
			newObject["document"]["url"] = _URL;
			newObject["document"]["backgroundColor"] = _BackgroundColor;
			newObject["clips"] = new Array();

			var view:DocumentView = _View as DocumentView;
			for (var clipKey:String in view.clips) {
				newObject["clips"].push(view.clips[clipKey].SaveToObject());
			}

			return newObject;
		}

		public override function LoadFromObject(dataObject:Object):Boolean
		{
			if (!dataObject)
				return false;
			
			for (var key:String in dataObject)
			{
				if (key == "document") {
					super.LoadFromObject(dataObject[key]);
				} else if (key == "clips") {
					if (!dataObject[key] is Array)
						continue;
					
					var clipArray:Array = dataObject[key] as Array;
					for (var i:uint = 0; i < clipArray.length; i++) {
						var clipDataObject:Object = clipArray[i] as Object;

						if (!clipDataObject["type"]) {
							Alert.show("Clip Broke");
							continue;
						}
							
						var docView:DocumentView = view as DocumentView;
						if (docView)
							docView.AddClipByType(clipDataObject["type"], null, clipDataObject);
					}
				}
			}

			return true;
		}

	}
}