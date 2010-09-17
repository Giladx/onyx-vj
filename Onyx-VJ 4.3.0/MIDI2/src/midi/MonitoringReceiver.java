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
 */
package midi;

import java.util.Observable;

import javax.sound.midi.MidiMessage;
import javax.sound.midi.Receiver;

public class MonitoringReceiver extends Observable implements Receiver {
	
	private long time =  System.currentTimeMillis();
    public void send(MidiMessage theMessage, long timeStamp)
    {
    	byte data[] 	= theMessage.getMessage();
    	byte message[] 	= new byte[3];
    	System.arraycopy(data, 0, message, 0, data.length);
    	    	
    	if ( System.currentTimeMillis() > time + 10000 )	
    	{
    		time =  System.currentTimeMillis();
    		setChanged();
    		notifyObservers(theMessage);
    		clearChanged();
    		
    	}
    }
    public void close(){
    }
}
