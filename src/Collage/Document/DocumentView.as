package Collage.Document
{
	import mx.controls.Alert;
	import mx.controls.Image;
	import flash.geom.*;
	import Collage.Clip.*;
	import mx.core.UIComponent;
	import flash.events.Event;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import mx.core.BitmapAsset;
	import mx.events.PropertyChangeEvent;

	public class DocumentView extends ClipView
	{
		protected var _BackgroundImage:Image;
		protected var _BackgroundLoaded:Boolean = false;
		protected var _BitmapData:BitmapData = null;
		
		protected var _Clips:Array;
		
		public function DocumentView()
		{
			_BackgroundImage = new Image();
			_BackgroundImage.setStyle("top", 0);
			_BackgroundImage.setStyle("left", 0);
			_BackgroundImage.setStyle("bottom", 0);
			_BackgroundImage.setStyle("right", 0);
			_BackgroundImage.setStyle("horizontalAlign", "center");
			_BackgroundImage.setStyle("verticalAlign", "middle");
			addChild(_BackgroundImage);
			ClipFactory.RegisterClipDefinitions();
			_Clips = new Array();
			super();
		}

		public function ViewResized():void
		{
			// TODO : Reposition all objects to fit in new size
		}
		
		public function AddClip(newClip:Clip):Boolean
		{
			if (newClip && !_Clips[newClip.uid]) {
				_Clips[newClip.uid] = newClip;
				addChild(newClip.view);
				return true;
			}
			return false;
		}

		public function AddClipByType(clipType:String, position:Rectangle = null):Clip
		{
			var newClip:Clip = ClipFactory.CreateByType(clipType);
			if (!newClip || !AddClip(newClip))
				return null;
			PositionClip(newClip, position);
			
			return newClip;
		}

		public function AddClipFromData(data:Object, position:Rectangle = null):Clip
		{
			var newClip:Clip = ClipFactory.CreateFromData(data);
			if (!newClip || !AddClip(newClip))
				return null;
			PositionClip(newClip, position);
			
			return newClip;
		}
		
		public function PositionClip(clip:Clip, position:Rectangle):void
		{
			if (!clip)
				return;

			if (!position)
				position = new Rectangle(0,0,300,300);
			
			clip.x = position.x;
			clip.y = position.y;
			clip.width = position.width;
			clip.height = position.height;
		}
		
		private function LoadImage():void
		{
			if (!_BackgroundImage || _BackgroundLoaded)
				return;
			
			var docModel:Document = _Model as Document;
			if (docModel.url) {
				_BackgroundImage.load(docModel.url);
				_BackgroundImage.addEventListener(Event.COMPLETE, Complete);
			} else if(_BitmapData) {
				var bitmap:BitmapAsset = new BitmapAsset(_BitmapData);
                if (bitmap != null && bitmap.smoothing == false) {
                    bitmap.smoothing = true;
                }
				_BackgroundImage.source = bitmap;
				super.onModelChange(null);
			} 
		}

		protected override function Reposition():void
		{
			drawFocus(false);
			width = _Model.width;
			height = _Model.height;
			rotation = _Model.rotation;
		}

		protected override function onModelChange( event:PropertyChangeEvent):void
		{
			if(event && event.property == "url")
				LoadImage();

			var docModel:Document = _Model as Document;
			setStyle("backgroundColor", docModel.backgroundColor);
			validateNow();

			super.onModelChange(event);
		}

		private function Complete(event:Event):void
		{
			_BackgroundLoaded = true;
			_BackgroundImage.removeEventListener(Event.COMPLETE, Complete);
			if (_BackgroundImage.content is Bitmap) {
                var bitmap:Bitmap = _BackgroundImage.content as Bitmap;
                if (bitmap != null && bitmap.smoothing == false) {
                    bitmap.smoothing = true;
                }
            }
			super.onModelChange(null);
		}

		public override function LoadFromData(data:Object):Boolean
		{
			if (data is BitmapData)
			{
				_BackgroundLoaded = false;
				_BitmapData = data as BitmapData;
				LoadImage();
				return true;
			}
			return false;
		}
	}
}