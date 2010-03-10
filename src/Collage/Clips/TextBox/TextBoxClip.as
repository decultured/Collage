package Collage.Clips.TextBox
{
	import Collage.Clip.*;
	
	public class TextBoxClip extends Clip
	{
		[Bindable]public var text:String = "Default Text.";
		[Bindable]public var backgroundAlpha:Number = 1.0;
		[Bindable]public var backgroundColor:Number = 0xFFFFFF;

		public function TextBoxClip(dataObject:Object = null)
		{
			rotatable = false;
			super(dataObject);
			CreateView();
			CreateEditor();
		}

		public override function CreateView(newView:ClipView = null):void
		{
			if (newView)
				_View = newView;
			else {
				_View = new TextBoxClipView();
				_View.model = this;
			}
		}

		public override function CreateEditor(newEditor:ClipEditor = null):void
		{
			if (newEditor)
				_Editor = newEditor;
			else {
				_Editor = new TextBoxClipEditor();
				_Editor.model = this;
			}
		}

		public override function LoadFromData(data:Object):Boolean
		{
			if (data is String)
			{
				this.text = data as String;
				return true;
			}
			return false;
		}
		
		public override function SaveToObject():Object
		{
			var newObject:Object = super.SaveToObject();

			newObject["type"] = "textbox";
			newObject["text"] = text;
			newObject["backgroundAlpha"] = backgroundAlpha;
			newObject["backgroundColor"] = backgroundColor;

			return newObject;
		}

		public override function LoadFromObject(dataObject:Object):Boolean
		{
			if (!dataObject)
				return false;
			super.LoadFromObject(dataObject);
			for (var key:String in dataObject)
			{
				if (key == "text") {
					text = dataObject[key];
				} else if (key == "backgroundColor") {
					backgroundColor = parseInt(dataObject[key]);
				} else if (key == "backgroundAlpha") {
					backgroundAlpha = parseInt(dataObject[key]);
				}
			}
			dispatchEvent(new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE));
			return true;
		}
		
	}
}