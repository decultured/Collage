package Collage.Clips.Picture
{
	import Collage.Clip.*;
	
	public class PictureClip extends Clip
	{
		[Bindable] public var aspectRatio:Number = 0;
		[Bindable] public var imageLoaded:Boolean = false;
		private var _URL:String = null;
		
		[Bindable]
		public function get url():String {return _URL;}
		public function set url(url:String):void
		{
			_URL = url;
		}
		
		public function PictureClip(dataObject:Object = null)
		{
			super(dataObject);
			CreateView();
			CreateEditor();
		}
		
		public override function CreateView(newView:ClipView = null):void
		{
			if (newView)
				_View = newView;
			else {
				_View = new PictureClipView();
				_View.model = this;
			}
		}

		public override function CreateEditor(newEditor:ClipEditor = null):void
		{
			if (newEditor)
				_Editor = newEditor;
			else {
				_Editor = new PictureClipEditor();
				_Editor.model = this;
			}
		}

		public override function Resized():void
		{
			if (!height || !aspectRatio)
				return;
				
			var modelRatio:Number = width / height;
		
			if (modelRatio > aspectRatio) {
				width = height * aspectRatio;
			} else if (modelRatio < aspectRatio) {
				height = width / aspectRatio;
			}
		}
		
		public override function LoadFromData(data:Object):Boolean
		{
			var view:PictureClipView = _View as PictureClipView;
			return view.LoadFromData(data);
		}
		
		public override function SaveToObject():Object
		{
			var newObject:Object = super.SaveToObject();

			newObject["type"] = "image";
			newObject["url"] = url;

			return newObject;
		}
		
		public override function LoadFromObject(dataObject:Object):Boolean
		{
			if (!dataObject)
				return false;
			super.LoadFromObject(dataObject);
			for (var key:String in dataObject)
			{
				if (key == "url") {
					url = dataObject[key];
				}
			}
			return true;
		}

	}
}