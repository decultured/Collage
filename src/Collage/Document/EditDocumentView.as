package Collage.Document
{
	import flash.geom.*;
	import flash.display.*;
	import Collage.Clip.*;
	import mx.controls.Alert;
	import mx.events.PropertyChangeEvent;
	import flash.events.*;
	import mx.core.UIComponent;
	import com.roguedevelopment.objecthandles.*;
	import com.roguedevelopment.objecthandles.constraints.*;
	import com.roguedevelopment.objecthandles.decorators.AlignmentDecorator;
	import com.roguedevelopment.objecthandles.decorators.DecoratorManager;
	import Collage.Logger.*;

	public class EditDocumentView extends DocumentView
	{
		protected var _InspectorPane:UIComponent;
		protected var _OptionsBox:UIComponent;
		protected var _SelectionManager:ObjectHandlesSelectionManager;
		protected var _ObjectHandles:ObjectHandles;
		protected var _CurrentlySelected:Clip;
		public function set inspector(inspectorPane:UIComponent):void {_InspectorPane = inspectorPane;}
		public function get inspector():UIComponent {return _InspectorPane;}
		public function set optionsBox(optionsBox:UIComponent):void {_OptionsBox = optionsBox;}
		public function get optionsBox():UIComponent {return _OptionsBox;}

		private var _Grid:Shape = new Shape(); 
		protected var _DecoratorManager:DecoratorManager;
		
		public function EditDocumentView()
		{
			super();
			var newModel:Document = new Document();
			newModel.CreateEditView(this);
			model = newModel;
			_Grid.visible = false;
			this.rawChildren.addChild(_Grid);
			DrawGrid();
			
//			_BackgroundImage.addEventListener(MouseEvent.CLICK, BackgroundClick);
		}

		public function InitializeForEdit(newInspector:UIComponent, newOptionsBox:UIComponent):void
		{
			_InspectorPane = newInspector;
			_OptionsBox = newOptionsBox;
			InitObjectHandles();
			SelectDocument();
			ViewResized();
		}

		public override function NewDocument():void
		{
			var docModel:Document = _Model as Document;
			
			var childArray:Array = getChildren();
			for (var i:uint = 0; i < childArray.length; i++) {
				if (childArray[i] && childArray[i] is ClipView)
					_ObjectHandles.unregisterComponent(childArray[i]);
			}
			
			DrawGrid();
			super.NewDocument();
		}

		public function InitObjectHandles():void
		{
			_SelectionManager = new ObjectHandlesSelectionManager();
			_ObjectHandles = new ObjectHandles(this, _SelectionManager);
			var sizeConstraint:SizeConstraint = new SizeConstraint();
			sizeConstraint.minWidth = 20;
			sizeConstraint.minHeight = 20;
			sizeConstraint.maxWidth = this.width;
			sizeConstraint.maxHeight = this.height;
			_ObjectHandles.constraints.push(sizeConstraint);							

//			_DecoratorManager = new DecoratorManager( _ObjectHandles, this );
//			_DecoratorManager.addDecorator( new AlignmentDecorator() );				

			_SelectionManager.addEventListener(SelectionEvent.ADDED_TO_SELECTION, ObjectSelected);
			_SelectionManager.addEventListener(SelectionEvent.REMOVED_FROM_SELECTION, ObjectDeselected);
			_SelectionManager.addEventListener(SelectionEvent.SELECTION_CLEARED, ObjectDeselected);

			_ObjectHandles.addEventListener(ObjectChangedEvent.OBJECT_MOVED, ObjectChanged);
			_ObjectHandles.addEventListener(ObjectChangedEvent.OBJECT_MOVING, ObjectChanged);
			_ObjectHandles.addEventListener(ObjectChangedEvent.OBJECT_RESIZED, ObjectChanged);
			_ObjectHandles.addEventListener(ObjectChangedEvent.OBJECT_RESIZING, ObjectChanged);
			_ObjectHandles.addEventListener(ObjectChangedEvent.OBJECT_ROTATED, ObjectChanged);
		}		

		public override function ViewResized():void
		{
			super.ViewResized();
			if (_ObjectHandles) {
				
				_ObjectHandles.constraints = new Array();
				
				var sizeConstraint:SizeConstraint = new SizeConstraint();
				sizeConstraint.minWidth = 20;
				sizeConstraint.minHeight = 20;
				sizeConstraint.maxWidth = this.width;
				sizeConstraint.maxHeight = this.height;
				
				var moveConstraint:MovementConstraint = new MovementConstraint();
				moveConstraint.minX = 0;
				moveConstraint.minY = 0;
				moveConstraint.maxX = this.width;
				moveConstraint.maxY = this.height;
				
				_ObjectHandles.constraints.push(sizeConstraint);							
				_ObjectHandles.constraints.push(moveConstraint);	
				
				DrawGrid();				
			}
		}
		
		public function AddObjectHandles(newClip:Clip):void
		{
			if (newClip) {
				var handles:Array = [];

				if (newClip.verticalSizable && newClip.horizontalSizable) {
					handles.push( new HandleDescription( HandleRoles.RESIZE_UP + HandleRoles.RESIZE_LEFT, new Point(0,0), new Point(0,0)));
					handles.push( new HandleDescription( HandleRoles.RESIZE_UP + HandleRoles.RESIZE_RIGHT, new Point(100,0), new Point(0,0))); 
					handles.push( new HandleDescription( HandleRoles.RESIZE_DOWN + HandleRoles.RESIZE_RIGHT, new Point(100,100), new Point(0,0))); 
					handles.push( new HandleDescription( HandleRoles.RESIZE_DOWN + HandleRoles.RESIZE_LEFT, new Point(0,100), new Point(0,0))); 
				}
				if (newClip.verticalSizable) {
					handles.push( new HandleDescription( HandleRoles.RESIZE_UP, new Point(50,0), new Point(0,0))); 
					handles.push( new HandleDescription( HandleRoles.RESIZE_DOWN, new Point(50,100), new Point(0,0))); 
				}
				if (newClip.horizontalSizable) {
					handles.push( new HandleDescription( HandleRoles.RESIZE_LEFT, new Point(0,50), new Point(0,0))); 
					handles.push( new HandleDescription( HandleRoles.RESIZE_RIGHT, new Point(100,50), new Point(0,0))); 
				}
				if (newClip.moveFromCenter)
					handles.push( new HandleDescription( HandleRoles.MOVE, new Point(50,50), new Point(0,0))); 
				if (newClip.rotatable)
					handles.push( new HandleDescription( HandleRoles.ROTATE, new Point(100,50), new Point(20,0))); 
				
				_ObjectHandles.registerComponent(newClip, newClip.view, handles);
				ClearSelection();
				_ObjectHandles.selectionManager.addToSelected(newClip);
				DrawGrid();
			}
		}
		
		public override function AddClip(newClip:Clip):Boolean
		{
			if (!super.AddClip(newClip))
				return false;
			AddObjectHandles(newClip);
			Logger.Log("New clip", LogEntry.DEBUG, newClip);
			return true;
		}

		public override function AddClipByType(clipType:String, position:Rectangle = null, dataObject:Object = null):Clip
		{
			var newClip:Clip = super.AddClipByType(clipType, position, dataObject);
			//AddObjectHandles(newClip);
			return newClip;

		}

		public override function AddClipFromData(data:Object, position:Rectangle = null):Clip
		{
			var newClip:Clip = super.AddClipFromData(data);
			//AddObjectHandles(newClip);
			return newClip;
		}

		public function IsObjectSelected():Boolean {
			if (_CurrentlySelected && _CurrentlySelected.selected)
				return true;
			return false;
		}

		public function IsObjectAtFront():Boolean {
			if (_CurrentlySelected && _CurrentlySelected.selected && getChildren().length > 1 ) {
				var index:int = getChildIndex(_CurrentlySelected.view);
				var numChildren:uint = getChildren().length;
				if (index == numChildren - 1)
					return true;
			}
			return false;
		}

		public function IsObjectAtBack():Boolean {
			if (_CurrentlySelected && _CurrentlySelected.selected && getChildren().length > 1 ) {
				var index:int = getChildIndex(_CurrentlySelected.view);
				if (index == 0)
					return true;
			}
			return false;
		}

		public function MoveSelectedForward():Boolean {
			if (_CurrentlySelected && _CurrentlySelected.selected && getChildren().length > 1 ) {
				var index:int = getChildIndex(_CurrentlySelected.view);
				var numChildren:uint = getChildren().length;
				if (index < numChildren - 1) {
					setChildIndex(_CurrentlySelected.view, index + 1);
					return true;
				}
			}
			return false;
		}

		public function MoveSelectedBackward():Boolean {
			if (_CurrentlySelected && _CurrentlySelected.selected && getChildren().length > 1 ) {
				var index:int = getChildIndex(_CurrentlySelected.view);
				if (index > 0) {
					setChildIndex(_CurrentlySelected.view, index - 1);
					return true;
				}
			}
			return false;
		}

		public function MoveSelectedToBack():Boolean {
			if (_CurrentlySelected && _CurrentlySelected.selected && getChildren().length > 1 ) {
				var index:int = getChildIndex(_CurrentlySelected.view);
				if (index != 0) {
					setChildIndex(_CurrentlySelected.view, 0);
					return true;
				}
			}
			return false;
		}

		public function MoveSelectedToFront():Boolean {
			if (_CurrentlySelected && _CurrentlySelected.selected && getChildren().length > 1 ) {
				var index:int = getChildIndex(_CurrentlySelected.view);
				var numChildren:uint = getChildren().length;
				if (index < numChildren - 1) {
					setChildIndex(_CurrentlySelected.view, numChildren - 1);
					return true;
				}
			}
			return false;
		}

		protected function ObjectSelected(event:SelectionEvent):void {
			for each (var clip:Clip in event.targets) {
				clip.selected = true;
				_CurrentlySelected = clip;
				model.selected = false;
				PositionOptionsBox();
				if (_CurrentlySelected) {
					ShowClipEditor();
				}
			}
		}

		protected function ObjectDeselected(event:SelectionEvent):void {
			for each (var clip:Clip in event.targets) {
				_CurrentlySelected = null;
				PositionOptionsBox();
				clip.selected = false;
				HideClipEditor();
			}
		}


		private function ObjectChanged(event:ObjectChangedEvent):void{
			var num:Number = 0;
			var docModel:Document = _Model as Document;
			for each (var clip:Clip in event.relatedObjects) {
				if (event.type == ObjectChangedEvent.OBJECT_MOVED) {
					if (docModel.snap && docModel.gridSize)
					{
						num = (clip.x % docModel.gridSize) - (docModel.gridSize * 0.5);
						if (num)
							clip.x = clip.x - (clip.x % docModel.gridSize);
						else
							clip.x = clip.x - (clip.x % docModel.gridSize) + docModel.gridSize;
						
						num = (clip.y % docModel.gridSize) - (docModel.gridSize * 0.5);
						if (num)
							clip.y = clip.y - (clip.y % docModel.gridSize);
						else
							clip.y = clip.y - (clip.y % docModel.gridSize) + docModel.gridSize;
					}
					
					clip.Moved();
				}
				else if (event.type == ObjectChangedEvent.OBJECT_RESIZED) {
					if (docModel.snap && docModel.gridSize)
					{
						num = (clip.width % docModel.gridSize) - (docModel.gridSize * 0.5);
						if (num)
							clip.width = clip.width - (clip.width % docModel.gridSize);
						else
							clip.width = clip.width - (clip.width % docModel.gridSize) + docModel.gridSize;
						
						num = (clip.height % docModel.gridSize) - (docModel.gridSize * 0.5);
						if (num)
							clip.height = clip.height - (clip.height % docModel.gridSize);
						else
							clip.height = clip.height - (clip.height % docModel.gridSize) + docModel.gridSize;
					}
				
					clip.Resized();
					ClearSelection();
					_ObjectHandles.selectionManager.addToSelected(clip);
				}
				else if (event.type == ObjectChangedEvent.OBJECT_ROTATED) {clip.Rotated();}
				PositionOptionsBox();
			}
		}
		
		public function DrawGrid():void
		{
			var docModel:Document = _Model as Document;
			if (!docModel.grid || !docModel.gridSize) {
				_Grid.visible = false;
				return;
			}
			
			_Grid.visible = true;
			_Grid.graphics.clear();
			_Grid.graphics.lineStyle(1, docModel.gridColor);
			
			for (var xPos:Number = docModel.gridSize; xPos < docModel.width; xPos += docModel.gridSize) {
		    	_Grid.graphics.moveTo(xPos, 0); 
		    	_Grid.graphics.lineTo(xPos, docModel.height); 
			}

			for (var yPos:Number = docModel.gridSize; yPos < docModel.height; yPos += docModel.gridSize) {
		    	_Grid.graphics.moveTo(0, yPos); 
		    	_Grid.graphics.lineTo(docModel.width, yPos); 
			}

			this.rawChildren.setChildIndex(_Grid, 1);
		} 
		
		protected override function onModelChange( event:PropertyChangeEvent):void
		{
			ViewResized();
			super.onModelChange(event);
		}

		protected function PositionOptionsBox():void
		{
			if (!_OptionsBox) return;
			if (!_CurrentlySelected) {
				_OptionsBox.visible = false;
				return;
			}
			_OptionsBox.visible = true;
			
			if (owns(_OptionsBox))
				if (getChildIndex(_OptionsBox) < numChildren - 1)
					setChildIndex(_OptionsBox, numChildren - 1);
						
			if (_CurrentlySelected.y < 30) {
				_OptionsBox.y = _CurrentlySelected.y + _CurrentlySelected.height;
				_OptionsBox.x = _CurrentlySelected.x + _CurrentlySelected.width - optionsBox.width;
			} else {
				_OptionsBox.y = _CurrentlySelected.y - optionsBox.height;
				_OptionsBox.x = _CurrentlySelected.x + _CurrentlySelected.width - optionsBox.width;
			}
		}
		
		public function deleteSelected():void
		{
			if (_CurrentlySelected && _CurrentlySelected.view) {
				if (_Clips && _CurrentlySelected.uid)
					_Clips[_CurrentlySelected.uid] = null;
				var view:ClipView = _CurrentlySelected.view;
				_ObjectHandles.unregisterComponent(view);
				removeChild(view);
				Logger.Log("Clip Deleted", LogEntry.DEBUG, this);
			}
		}
		
		public function lockSelected():void
		{
			if (_CurrentlySelected && _CurrentlySelected.view) {
				var view:ClipView = _CurrentlySelected.view;
				_ObjectHandles.unregisterComponent(view);
			}
		}
		
		public override function OnClick(event:MouseEvent):void {

 		}
		
		public function BackgroundClick(event:MouseEvent):void
		{		
			if(event) {
				if (event.currentTarget is ClipView && !(event.currentTarget is DocumentView)) {
					event.stopPropagation();
					event.stopImmediatePropagation();
					return;
			 	} else {
					ClearSelection();
					event.stopPropagation();
					event.stopImmediatePropagation();
				}
			} else {
				ClearSelection();
			}
		}
		
		public function ClearSelection():void {
			_ObjectHandles.selectionManager.clearSelection();
			SelectDocument();
		}
		
		public function SelectDocument():void
		{
			if (!_InspectorPane || !model.editor)
				return;
			model.selected = true;
			HideClipEditor();
			_InspectorPane.addChild(model.editor);
		}
		
		public function ShowClipEditor():void
		{
			if (!_CurrentlySelected.editor || !_InspectorPane)
				return;
			HideClipEditor();
			_InspectorPane.addChild(_CurrentlySelected.editor);
		}
		
		public function HideClipEditor():void
		{
			if (!_InspectorPane)
				return;
			for (var i:uint = 0; i < _InspectorPane.numChildren; i++)
				_InspectorPane.removeChildAt(0);
		}
	}
}