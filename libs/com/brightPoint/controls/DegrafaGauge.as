/*
Gauge Component v.04 7/28/08

Copyright (c) 2008, Thomas W. Gonzalez

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

www.brightpointinc.com

*/		
package com.brightPoint.controls
{
	import com.brightPoint.controls.gauge.GaugeSkin;
	import com.brightPoint.controls.gauge.events.GaugeEvent;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.BitmapFilter;
	import flash.filters.DropShadowFilter;
	
	//import mx.charts.LogAxis;
	//import mx.charts.chartClasses.CartesianTransform;
	import mx.controls.Label;
	import mx.core.IFlexDisplayObject;
	import mx.core.IInvalidating;
	import mx.core.IProgrammaticSkin;
	import mx.core.UIComponent;
	import mx.effects.Rotate;
	import mx.effects.easing.Bounce;
	import mx.events.EffectEvent;
	import mx.formatters.Formatter;
	import mx.styles.ISimpleStyleClient;

	/** faceSkin
	 * The skin class for the background of the gauge. The default class
	 * is gauge.GaugeSkin.
	 */
	[Style(name="faceSkin",type="Class",inherit="no")]
	
	/** highlightSkin
	 * The skin class for the indicator indicatorCrown. The default class is
	 * is gauge.GaugeSkin.
	 */
	[Style(name="highlightSkin",type="Class",inherit="no")]
	
	/** indicatorSkin
	 * The skin class for the indicator. The default class is
	 * is gauge.GaugeSkin.
	 */
	[Style(name="indicatorSkin",type="Class",inherit="no")]
	
	/** indicatorCrownSkin
	 * The skin class for the indicator center. The default class is
	 * is gauge.GaugeSkin.
	 */
	[Style(name="indicatorCrownSkin",type="Class",inherit="no")]
	
	/** backgroundColor
	 * The color for the background of the frame. Default: white
	 */
	[Style(name="backgroundColor",type="Number",format="Color",inherit="no")]
	
	/** backgroundAlpha
	 * The transparency of the background of the frame. Default: 1
	 */
	[Style(name="backgroundAlpha",type="Number",inherit="no")]
	
	/** indicatorColor
	 * The color of the indicator. Default: black
	 */
	[Style(name="indicatorColor",type="Number",format="Color",inherit="no")]
	
	/** indicatorCrownColor
	 * The color of the indicator indicatorCrown. Default: dark gray
	 */
	[Style(name="indicatorCrownColor",type="Number",format="Color",inherit="no")]
	
	/** measureMarksColor
	 * The color of the tick marks around the gauge:. Default: white
	 */
	[Style(name="measureMarksColor",type="Number",format="Color",inherit="no")]
	
	/** measureMarksAlpha
	 * The alpha of the tick marks around the gauge:. Default: 1
	 */
	[Style(name="measureMarksAlpha",type="Number",inherit="no")]
	
	
	/** bezelColor
	 * The color of the rim around the gauge. Default: dark gray
	 */
	[Style(name="bezelColor",type="Number",format="Color",inherit="no")]
	
	
	 /** startAngle
	 *  the starting angle for the indicator
	 */
	[Style(name="startAngle",type="Number",inherit="no")]
	
	 /** endAngle
	 *  the starting angle for the indicator
	 */
	[Style(name="endAngle",type="Number",inherit="no")]
	
	/** indicatorFilter
	* The type of filter to apply to the indicator, setting NULL will result in no filter.
	* Default: true (shadow)
	*/
	[Style(name="indicatorFilter",type="flash.filters.BitmapFilter",inherit="no",default="flash.filters.DropShadowFilter")]
	
	
	/** labelYOffsetRatio
	* Indicates the vertical position of the label relative to the diameter, defaults to 70% of the diameter
	*/
	[Style(name="labelYOffsetRatio",type="Number",inherit="no", default=".87")]
	
	/** labelXOffsetRatio
	* Indicates the pixel offset for the label control
	*/
	[Style(name="labelXOffset",type="Number",inherit="no", default="0")]
	
	/** showLabel
	* Indicates whehter the value label is visible
	*/
	[Style(name="showLabel",type="Boolean",inherit="no", default="true")]
	
	/** labelStyleName
	* Indicates the style name of the value label
	*/
	[Style(name="labelStyleName",type="String",inherit="no")]
	
	/** useBounceEffect 
	* Indicates if gauge will use Bounce.easeOut easing effect
	*/
	[Style(name="useBounceEffect",type="Boolean",inherit="no", default="true")]
	
	/** alertValues
	* Values used to create sequential alert ranges
	*/
	[Style(name="alertValues",type="Array",inherit="no", default="[]")]
	
	/** alertColors
	* Colors used to create sequential alert ranges
	*/
	[Style(name="alertColors",type="Array",inherit="no", default="[]")]
	
	/** alertAlphas
	* Alphas used to create sequential alert ranges
	*/
	[Style(name="alertAlphas",type="Array",inherit="no", default="[]")]
	
	/** gaugeClick (event)
	 * Fired when the mouse is clicked over the gauge. The value property of the
	 * GaugeEvent contains the approximate value between the minimum and maximum
	 * of the Gauge values.
	 */
	[Event(name="gaugeClick",type="gauge.events.GaugeEvent")]
	
	public class DegrafaGauge extends UIComponent
	{		
		
		public static const SCALE_LINEAR:String="linear";
		public static const SCALE_LOG:String="log";
		
		   
        /**
         * PROPERTIES
         *
         * When a property is set, its value is copied to the class variable (eg,
         * _value) and then invalidateDisplayList is called. This allows the Flex framework
         * to call updateDisplayList at the proper time. For example, it is possible
         * to set a property before there are any graphics present; calling updateDisplayList
         * then would lead to an error.
         */
        
        /***
        * value
        * 
        * The value of the gauge; guaranteed to be between the minimum
        * and maximum values.
        */
        private var _value:Number = 0;
        
        [Bindable(event="valueChanged")]
        public function get value() : Number
        {
        	return _value;
        }
        
        public function set value( n:Number ) : void
        {
        	_value = n;
        	invalidateDisplayList();
        	dispatchEvent( new Event("valueChanged") );
        }
        
         /***
        * minimumAngle
        * 
        * The smallest allowed value for the gauge; default=0. If you think
        * of the gauge's face as a clock, the minimumAngle is mapped to the 8 o'clock
        * position.
        */
        private var _minimumAngle:Number = 45;

         /***
        * maximumAngle
        * 
        * The largest allowed value for the gauge; default=100. The maximumAngle
        * value is mapped to the 4 o'clock position.
        */
        private var _maximumAngle:Number = 315;

       
        
        /***
        * minimum
        * 
        * The smallest allowed value for the gauge; default=0. If you think
        * of the gauge's face as a clock, the minimum is mapped to the 8 o'clock
        * position.
        */
        private var _minimum:Number = 0;
        
        [Bindable]
        public function get minimum() : Number { return _minimum; }
        
        public function set minimum( n:Number ) : void
        {
        	_minimum = n;
        	invalidateDisplayList();
        }
        
        /***
        * maximum
        * 
        * The largest allowed value for the gauge; default=100. The maximum
        * value is mapped to the 4 o'clock position.
        */
        private var _maximum:Number = 100;

		[Bindable]
		public function get maximum() : Number 	{ return _maximum}
		
        public function set maximum( n:Number ) : void
        {
        	_maximum = n;
        	invalidateDisplayList();
        }
        
       	public var labelFormatter:Formatter;
		
		/***
		 * liveDragging
		 * 
		 * Sets a flag to indicate that the indicator should track the mouse.
		 */
		private var _liveDragging:Boolean = false;
		
		[Bindable]
		public function get liveDragging() : Boolean
		{
			return _liveDragging;
		}
		
		public function set liveDragging( b:Boolean ) : void
		{
			_liveDragging = b;
		}
		
		[Bindable]
		public function get valueScale() : String
		{
			return _valueScale;
		}
		
		public function set valueScale(value:String) : void
		{
			_valueScale=value;
			this.regenerateStyleCache(true);
		}
		
		private var _valueScale:String=SCALE_LINEAR;
		
		/** PROTECTED Variables
		 */
		
		// Variables holding the skin instances
		protected var faceSkin:IFlexDisplayObject;
		protected var highlightSkin:IFlexDisplayObject;
		protected var indicatorSkin:IFlexDisplayObject;
		protected var indicatorCrownSkin:IFlexDisplayObject;
		protected var indicatorFilter:BitmapFilter;
		protected var label:Label;

		
		// Single Rotate effect used to move the indicator.
		private var rotate:Rotate;
		
		/***
		 * Constructor
		 * 
		 */
		public function DegrafaGauge()
		{ 
			super();
			
			// and handlers for mouse events to make the component
			// interactive. Add event handlers for keyboard, too.
//			addEventListener( MouseEvent.CLICK, clickHandler );
//			addEventListener( MouseEvent.MOUSE_DOWN, mouseHandler );
//			addEventListener( MouseEvent.MOUSE_MOVE, mouseHandler );
		}
		
		override public function setStyle(styleProp:String, newValue:*):void {
			super.setStyle(styleProp,newValue);
			if (styleProp=="startAngle") { _minimumAngle=Number(newValue); invalidateDisplayList(); }
			if (styleProp=="endAngle") { _maximumAngle=Number(newValue); invalidateDisplayList(); }
			if (styleProp=="labelStyleName") { label.styleName=newValue; invalidateDisplayList(); }
		}
		
		override public function set styleName(value:Object):void {
			super.styleName=value;
		}
		
		override public function regenerateStyleCache(recursive:Boolean):void {
			super.regenerateStyleCache(recursive);
			
			if (this.numChildren>0) {  //This is expensive, but we want to refresh the skins by removing all children and starting over
				for (var i:int=this.numChildren-1;i>=0;i--) {
					this.removeChildAt(i);
				}
				this.createChildren();
				this.invalidateDisplayList();
			}
		}
		
		override public function set height(value:Number):void {
			diameter=value;
		}
		
		override public function set width(value:Number):void {
			diameter=value;
		}
		
		public function set diameter(value:Number):void {
			super.width=value;
			super.height=value;
		}
		
		[Bindable]
		public function get diameter():Number { return width; }
		
		/***
		 * createChildren
		 * 
		 * This method is invoked by the Flex framework when it is time for
		 * the component to create any children. In this case, it is time
		 * to create the skins.
		 */
		override protected function createChildren():void
		{
			super.createChildren();
			indicatorFilter=new DropShadowFilter();
			
			label=new Label();
			label.truncateToFit=false;
			faceSkin  = createSkin( "faceSkin", com.brightPoint.controls.gauge.GaugeSkin ); 
			addChild(DisplayObject(faceSkin));
			indicatorSkin = createSkin( "indicatorSkin", com.brightPoint.controls.gauge.GaugeSkin ); 
			addChild(DisplayObject(indicatorSkin));
			indicatorCrownSkin  = createSkin( "indicatorCrownSkin", com.brightPoint.controls.gauge.GaugeSkin );
			addChild(DisplayObject(indicatorCrownSkin));
			addChild(label); 
			highlightSkin  = createSkin( "highlightSkin", com.brightPoint.controls.gauge.GaugeSkin ); 
			addChild(DisplayObject(highlightSkin));
			
			rotate = new Rotate(indicatorSkin);
		}
		
		/***
		 * createSkin
		 * 
		 * Creates the given skin. The skin will either have been specified
		 * by the skin style or, if not present, the skin will default to
		 * the one given.
		 * 
		 */
		protected function createSkin( skinName:String, defaultSkin:Class ) : IFlexDisplayObject
		{
			// Look up the skin by its name to see if it is already created. Note
			// below where addChild() is called; this makes getChildByName possible.
			var newSkin:IFlexDisplayObject =
				IFlexDisplayObject(getChildByName(skinName));
				
			// if the skin needs to be created it will be null...
			
			if (!newSkin)
			{
				// Attempt to get the class for the skin. If one has not been supplied
				// by a style, use the default skin.
				
				var newSkinClass:Class = Class(getStyle(skinName));
				if( !newSkinClass ) newSkinClass = defaultSkin;
				
				if (newSkinClass)
				{
					// Create an instance of the class.
					newSkin = IFlexDisplayObject(new newSkinClass());
					if( !newSkin ) newSkin = new defaultSkin();
					
					// Set its name so that we can find it in the future
					// using getChildByName().
					newSkin.name = skinName;

					// Make the getStyle() calls in the skin class find the styles
					// for this Gauge instance. In other words, but setting the styleName
					// to 'this' it allows the skin to query the component for styles. For
					// example, when the skin code does getStyle('backgroundColor') it 
					// retrieves the style from this Gauge and not from the skin.
					var styleableSkin:ISimpleStyleClient = newSkin as ISimpleStyleClient;
					if (styleableSkin)
						styleableSkin.styleName = this;
						
					// If the skin is programmatic, and we've already been
	                // initialized, update it now to avoid flicker.
	                if (newSkin is IInvalidating)
	                { 
	                    IInvalidating(newSkin).validateNow();
	                }
	                else if (newSkin is IProgrammaticSkin && initialized)
	                {
	                    IProgrammaticSkin(newSkin).validateDisplayList()
	                }
					
				}
			}
			
			return newSkin;
		}
		
		/***
		 * measure
		 * 
		 * Define the default size of the component. Here the minimum size
		 * will be 50x50.
		 */
        override protected function measure():void 
        {
            super.measure();

            measuredWidth = measuredMinWidth = 50;
            measuredHeight = measuredMinHeight = 50;
        }
        
        // This component uses a RotateEffect to position the indicator; _prevAngle
        // holds the last known value.
        private var _prevAngle:Number = 135;
        
        /***
        * updateDisplayList
        * 
        * Draws the skin and its elements. This method is called by the Flex 2 framework
        * at the appropriate time. Never call this method directly. You can indicate the
        * need for it to be called by using invalidateDisplayList().
        */
        override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
        {
        	super.updateDisplayList(unscaledWidth,unscaledHeight);
        	
        	if (labelFormatter)
        		label.text=labelFormatter.format(value);
        	else
        		label.text=String(value); 
        
        	label.styleName=getStyle("labelStyleName");
			label.validateNow();
			label.width=label.textWidth+5;
			label.height=label.textHeight;

        	label.x=(unscaledWidth-label.width)/2 + ((getStyle("labelXOffset"))?getStyle("labelXOffset"):0);
 
        	label.y=(getStyle("labelYOffsetRatio")!=null) ? unscaledHeight*Number(getStyle("labelYOffsetRatio")) : unscaledHeight*.8;

        	label.visible=getStyle("showLabel");
        	label.visible=true;
        	
        	var indicatorDropShadowEnabled:Object = getStyle("indicatorDropShadowEnabled");

        	faceSkin.setActualSize(unscaledWidth,unscaledHeight);
        	indicatorSkin.setActualSize(unscaledWidth,unscaledHeight);
        	indicatorCrownSkin.setActualSize(unscaledWidth,unscaledHeight);
        	highlightSkin.setActualSize( unscaledWidth, unscaledHeight);
        	
        	if( indicatorFilter !=null) {
        		//indicatorFilter=new DropShadowFilter(diameter/100,45,0,.4,diameter/66,diameter/66);
        		DisplayObject(indicatorSkin).filters = [ indicatorFilter ];
	        	DisplayObject(indicatorCrownSkin).filters= [indicatorFilter ];
	        }
	        
	        // adjust the value to make sure it is within bounds.
        	if( _value < _minimum ) _value = _minimum;
        	if( _value > _maximum ) _value = _maximum;
        	
        	// determine the angle of the indicator based on the current
        	// value and minimum and maximum values.
        	var angle:Number = calculateAngleFromValue(_value);
        	
        	// Use a Rotate effect to spin the indicator from its previous
        	// position.

        	if( rotate.isPlaying ) {
        		if ((this.isDown && this.liveDragging))  {
        			rotate.end();
        		}
        		else {
        			rotate.addEventListener(EffectEvent.EFFECT_END,rotate_onEnd);
        			return;	
        		}
        		
        	}

			//Only use the rotate effect if we are enabled to do so.
			if (this.getStyle("useBounceEffect")==null || this.getStyle("useBounceEffect")==true) {
        		rotate.easingFunction=Bounce.easeOut;
        		rotate.angleFrom = _prevAngle;
	        	rotate.angleTo = angle;
	        	rotate.originX = 0;
	        	rotate.originY = 0;
	        	rotate.play();
	 		}
        	else
				indicatorSkin.rotation=angle;
        		
        
        	_prevAngle = angle;

        
        }
        
        private function rotate_onEnd(e:Event):void {
        	rotate.removeEventListener(EffectEvent.EFFECT_END,rotate_onEnd);
        	invalidateDisplayList();
        }
                
        /***
        * calculateAngleFromValue
        * 
        * Determines the angle of the indicator based on the value
        * and minimum and maximum properties.
        * 
        * Note: it is tempting to put the two statements of this function
        * directly into the updateDisplayList function. However, should someone
        * want to extend this class, they can use this method to do the same
        * calculation from the extended class' updateDisplayList.
        */
        public function calculateAngleFromValue(v:Number) : Number
        {
        	
        	//trace('value='+v);
        	var ratio:Number = (v-_minimum)/(_maximum-_minimum); //percentage value
        	
        	if (valueScale==SCALE_LOG) {       		
        		//On less than 1 values set to 1 otherwise log function gets out-of-whack.
        		if (v<1) v=1;      		
        		var computedMaximum:Number=Math.ceil(Math.log(_maximum) / Math.LN10);
        		var computedMinimum:Number=Math.floor(Math.log(_minimum) / Math.LN10);
        		ratio=(Math.log(v)*Math.LOG10E)/(computedMaximum-computedMinimum);
	       	}
	 
	 		var angle:Number = (_maximumAngle-_minimumAngle)* ratio + _minimumAngle;  
	 		
		
 		//	trace("computedMax=" + computedMaximum + " minAngle=" + _minimumAngle + " computedMinimum=" + computedMinimum + " value=" + v + " ratio=" + ratio + " angle=" + angle);
 			
        	return angle;
        }
        
        /**
         * INTERACTIVITY
         *
         * The code in this section makes it possible to move the gauge indicator using
         * mouse events. You can extend this to keyboard events if that makes sense.
         *
         *
         */
		
		// isDown is a flag to make sure no mouse motion events are sent if the mouse
		// button isn't already down.
		private var isDown:Boolean = false;
		
		/***
		 * clickHandler
		 * 
		 * This clickHandler is detecting a mouseClick on the component. This is then
		 * converted into a GaugeEvent and dispatched.
		 * 
		 * Note that the indicator is NOT moved here. Rather its new position is calculated
		 * and invalidateDisplayList is called to flag the update. 
		 */
		private function clickHandler( event:flash.events.MouseEvent ) : void
		{
			// we don't really want click events to come from this control.
			event.stopImmediatePropagation();
			
			// calculate the angle of the mouse click with respect to the center
			// of the component.
			var xpos:Number = event.localX - width/2;
			var ypos:Number = event.localY - height/2;
			var radius:Number = Math.sqrt( xpos*xpos + ypos*ypos );
			var radianSin:Number = 0;
			var radianCos:Number = 0;
			if( radius > 0 ) {
				radianCos = Math.acos( ypos/radius );
				radianSin = Math.asin( xpos/radius );
			}
			
			var angle:Number = radianCos*180/Math.PI;
			if( radianSin > 0 ) angle = 360 - angle;
			
			// now compute the value based on the angle and the min and max values
			// given to the component.
			var newValue:Number = -1;
		
			if( angle >= _minimumAngle && angle <= _maximumAngle) {
       
				newValue = (angle-_minimumAngle)/(_maximumAngle-_minimumAngle)*(_maximum-_minimum)+_minimum;
				
				//If we are using a log scale we need to set our value using a log algorithm
				if (valueScale==SCALE_LOG) {		
					var computedMaximum:Number=Math.ceil(Math.log(_maximum)/Math.LN10);
	        		var computedMinimum:Number=Math.floor(Math.log(_minimum)/Math.LN10);
					newValue = Math.pow(10,(angle-_minimumAngle)/(_maximumAngle-_minimumAngle) * (computedMaximum - computedMinimum) + computedMinimum);
				}	
			}
			else {
				return;
			}

			// create the event and dispatch it.
			var gEvent:GaugeEvent = new GaugeEvent( value, newValue, event.localX, event.localY );
			dispatchEvent( gEvent );
			
			// if liveDragging, update the value and invalidate the display list
			// to reposition the indicator.
			if( _liveDragging ) value = newValue;

			invalidateDisplayList();
		}
		
		/***
		 * mouseHandler
		 * 
		 * This is the event handler for mouse events as set in the component's constructor
		 * function. This reuses the clickHandler for the calculations and repositioning
		 * of the indicator.
		 */
		private function mouseHandler( event:flash.events.MouseEvent ) : void
		{
			if( event.type == MouseEvent.MOUSE_DOWN && _liveDragging ) {
				isDown = true;
				this.stage.addEventListener(MouseEvent.MOUSE_UP,mouseHandler);  //need to capture up events outside of ourselves
				clickHandler( event );
			}
			else if( event.type == MouseEvent.MOUSE_UP ) {
				this.stage.removeEventListener(MouseEvent.MOUSE_UP,mouseHandler);
				isDown = false;
			}
			else if( event.type == MouseEvent.MOUSE_MOVE && isDown && _liveDragging ) {
				clickHandler( event );
			}
		}
     
		
	}
}