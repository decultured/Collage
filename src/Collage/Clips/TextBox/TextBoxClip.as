package Collage.Clips.TextBox
{
	import Collage.Clip.*;
	
	public class TextBoxClip extends Clip
	{
		private var _Text:String = "Default Text.";
		private var _BackgroundAlpha:Number = 1.0;
		private var _BackgroundColor:Number = 0xFFFFFF;
		
		[Bindable]
		public function get text():String {return _Text;}
		public function set text(newText:String):void {_Text = newText;}

		[Bindable]
		public function get backgroundAlpha():Number {return _BackgroundAlpha;}
		public function set backgroundAlpha(bgAlpha:Number):void {_BackgroundAlpha = bgAlpha;}

		[Bindable]
		public function get backgroundColor():Number {return _BackgroundColor;}
		public function set backgroundColor(bgColor:Number):void {_BackgroundColor = bgColor;}

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
	}
}