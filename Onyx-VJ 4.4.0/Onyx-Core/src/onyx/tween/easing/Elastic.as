/**
 * Copyright (c) 2003-2008 "Onyx-VJ Team" which is comprised of:
 *
 * Daniel Hai
 * Stefano Cottafavi
 *
 * All rights reserved.
 *
 * Licensed under the CREATIVE COMMONS Attribution-Noncommercial-Share Alike 3.0
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at: http://creativecommons.org/licenses/by-nc-sa/3.0/us/
 *
 * Please visit http://www.onyx-vj.com for more information
 * 
 */
////////////////////////////////////////////////////////////////////////////////
//
//  Copyright (C) 2003-2006 Adobe Macromedia Software LLC and its licensors.
//  All Rights Reserved. The following is Source Code and is subject to all
//  restrictions on such code as contained in the End User License Agreement
//  accompanying this product.
//
////////////////////////////////////////////////////////////////////////////////

package onyx.tween.easing {

/**
 *  The Elastc class defines three easing functions to implement 
 *  motion with Flex effect classes, where the motion is defined by 
 *  an exponentially decaying sine wave. 
 *
 *  For more information, see http://www.robertpenner.com/profmx.
 */  
final public class Elastic
{
	

	//--------------------------------------------------------------------------
	//
	//  Class methods
	//
	//--------------------------------------------------------------------------

    /**
     *  The <code>easeIn()</code> method starts motion slowly, 
     *  and then accelerates motion as it executes. 
     *
     *  @param t Specifies time.
	 *
     *  @param b Specifies the initial position of a component.
	 *
     *  @param c Specifies the total change in position of the component.
	 *
     *  @param d Specifies the duration of the effect, in milliseconds.
     *
     *  @param a Specifies the amplitude of the sine wave.
     *
     *  @param p Specifies the period of the sine wave.
     *
     *  @return Number corresponding to the position of the component.
     */  
	public static function easeIn(t:Number, b:Number,
								  c:Number, d:Number,
								  a:Number = 0, p:Number = 0):Number
	{
		if (t == 0)
			return b;
		
		if ((t /= d) == 1)
			return b + c;
		
		if (!p)
			p = d * 0.3;
		
		var s:Number;
		if (!a || a < Math.abs(c))
		{
			a = c;
			s = p / 4;
		}
		else
		{
			s = p / (2 * Math.PI) * Math.asin(c / a);
		}

		return -(a * Math.pow(2, 10 * (t -= 1)) *
				 Math.sin((t * d - s) * (2 * Math.PI) / p)) + b;
	}

    /**
     *  The <code>easeOut()</code> method starts motion fast, 
     *  and then decelerates motion as it executes. 
     *
     *  @param t Specifies time.
	 *
     *  @param b Specifies the initial position of a component.
	 *
     *  @param c Specifies the total change in position of the component.
	 *
     *  @param d Specifies the duration of the effect, in milliseconds.
     *
     *  @param a Specifies the amplitude of the sine wave.
     *
     *  @param p Specifies the period of the sine wave.
     *
     *  @return Number corresponding to the position of the component.
     */  
	public static function easeOut(t:Number, b:Number,
								   c:Number, d:Number,
								   a:Number = 0, p:Number = 0):Number
	{
		if (t == 0)
			return b;
			
		if ((t /= d) == 1)
			return b + c;
		
		if (!p)
			p = d * 0.3;

		var s:Number;
		if (!a || a < Math.abs(c))
		{
			a = c;
			s = p / 4;
		}
		else
		{
			s = p / (2 * Math.PI) * Math.asin(c / a);
		}

		return a * Math.pow(2, -10 * t) *
			   Math.sin((t * d - s) * (2 * Math.PI) / p) + c + b;
	}

    /**
     *  The <code>easeInOut()</code> method combines the motion
     *  of the <code>easeIn()</code> and <code>easeOut()</code> methods
	 *  to start the motion slowly, accelerate motion, then decelerate. 
     *
     *  @param t Specifies time.
	 *
     *  @param b Specifies the initial position of a component.
	 *
     *  @param c Specifies the total change in position of the component.
	 *
     *  @param d Specifies the duration of the effect, in milliseconds.
     *
     *  @param a Specifies the amplitude of the sine wave.
     *
     *  @param p Specifies the period of the sine wave.
     *
     *  @return Number corresponding to the position of the component.
     */  
	public static function easeInOut(t:Number, b:Number,
									 c:Number, d:Number,
									 a:Number = 0, p:Number = 0):Number
	{
		if (t == 0)
			return b;
			
		if ((t /= d >> 1) == 2)
			return b + c;
			
		if (!p)
			p = d * (0.3 * 1.5);

		var s:Number;
		if (!a || a < Math.abs(c))
		{
			a = c;
			s = p / 4;
		}
		else
		{
			s = p / (2 * Math.PI) * Math.asin(c / a);
		}

		if (t < 1)
		{
			return -0.5 * (a * Math.pow(2, 10 * (t -= 1)) *
				  Math.sin((t * d - s) * (2 * Math.PI) /p)) + b;
		}
		
		return a * Math.pow(2, -10 * (t -= 1)) *
			   Math.sin((t * d - s) * (2 * Math.PI) / p ) * 0.5 + c + b;
	}
}

}
