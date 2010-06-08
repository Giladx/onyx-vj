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

package onyx.tween.easing
{

/**
 *  The Bounce class defines three easing functions to implement 
 *  bounce motion with Flex effect classes. 
 *
 *  For more information, see http://www.robertpenner.com/profmx.
 */  
final public class Bounce
{
	

	//--------------------------------------------------------------------------
	//
	//  Class methods
	//
	//--------------------------------------------------------------------------

    /**
     *  The <code>easeIn()</code> method starts the bounce motion slowly, 
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
     *  @return Number corresponding to the position of the component.
     */  
	public static function easeOut(t:Number, b:Number,
								   c:Number, d:Number):Number
	{
		if ((t /= d) < (1 / 2.75))
			return c * (7.5625 * t * t) + b;
		
		else if (t < (2 / 2.75))
			return c * (7.5625 * (t -= (1.5 / 2.75)) * t + 0.75) + b;
		
		else if (t < (2.5 / 2.75))
			return c * (7.5625 * (t -= (2.25 / 2.75)) * t + 0.9375) + b;
		
		else
			return c * (7.5625 * (t -= (2.625 / 2.75)) * t + 0.984375) + b;
	}

    /**
     *  The <code>easeOut()</code> method starts the bounce motion fast, 
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
     *  @return Number corresponding to the position of the component.
     */  
	public static function easeIn(t:Number, b:Number,
								  c:Number, d:Number):Number
	{
		return c - easeOut(d - t, 0, c, d) + b;
	}

    /**
     *  The <code>easeInOut()</code> method combines the motion
     *  of the <code>easeIn()</code> and <code>easeOut()</code> methods
	 *  to start the bounce motion slowly, accelerate motion, then decelerate. 
     *
     *  @param t Specifies time.
	 *
     *  @param b Specifies the initial position of a component.
	 *
     *  @param c Specifies the total change in position of the component.
	 *
     *  @param d Specifies the duration of the effect, in milliseconds.
     *
     *  @return Number corresponding to the position of the component.
     */  
	public static function easeInOut(t:Number, b:Number,
									 c:Number, d:Number):Number
	{
		if (t < d/2)
			return easeIn(t << 1, 0, c, d) * 0.5 + b;
		else
			return easeOut(t << 1 - d, 0, c, d) * 0.5 + c * 0.5 + b;
	}
}

}
