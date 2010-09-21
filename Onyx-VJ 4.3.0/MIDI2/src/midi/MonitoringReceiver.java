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

import javax.sound.midi.InvalidMidiDataException;
import javax.sound.midi.MidiMessage;
import javax.sound.midi.Receiver;
import javax.sound.midi.ShortMessage;
import javax.sound.midi.Transmitter;

public class MonitoringReceiver extends Observable implements Receiver,Transmitter {

	private long 	time 		= System.currentTimeMillis();
	private int		ctrlnumber 	= 0;
	static Receiver rcv 		= null;

	public void send(MidiMessage theMessage, long timeStamp) {

		boolean isValid = false;
		byte 	data[] 	= theMessage.getMessage();
		//    	byte message[] 	= new byte[3];
		//    	System.arraycopy(data, 0, message, 0, data.length);
		//    	    	
		//    	setChanged();
		//    	notifyObservers(theMessage);
		//    	clearChanged();

		if (data.length==3) {
			byte message[] = new byte[3];

			ShortMessage messageToSend 	= new ShortMessage();
			System.arraycopy(data, 0, message, 0, data.length);
			System.out.println("MonitoringReceiver: "+(System.currentTimeMillis()-time)+"ms");
			
			int stat 		= message[0];
			int cmd 		= data[0]&0xF0;
			int chan 		= data[0]&0x0F;
			int data1 		= data[1];
			int data2 		= data[2];
			
			if ( data1==0 && data2==0 ) {
				//System.out.println("OnyxMonitoringReceiver: datas==0, we send nothing");
			} else {
				//System.out.println("OnyxMonitoringReceiver:"+stat+" d1 "+data1+" d2 "+data2);
				//filter what is sent
				//noteon= 153 (channel 10)
				//korg es1 if (d1=0x62) d2=control number(0x63=edit1) and take next line
				// for value: if (d1=0x06) d2=0x0 to 0x7F 
				if ( cmd == ShortMessage.NOTE_ON ) {
					System.out.println("Sending noteOn " + cmd + " chan "+chan+" d1 "+data1+" d2 "+data2);
					try {
						messageToSend.setMessage( 	ShortMessage.NOTE_ON,
								chan,
								data1,
								data2);
					} catch (InvalidMidiDataException e) {
						System.out.println( "error messageToSend.setMessage:"+e.getMessage() );
						e.printStackTrace();
					}     	
					isValid = true;
				} else if ( cmd == ShortMessage.CONTROL_CHANGE ) {
					// if first message is 98 then store d2 for next message
					if ( data1 == 98 ) {
						ctrlnumber = data2;
						//System.out.println( "data1 == 98, ctrlnumber:"+ctrlnumber );
					}
					// if data1 == 6 it is the second message
					if ( data1 == 6 & data2 > 0 ) {
						//System.out.println( "dataentry d1 == 6, d2:"+data2 );
						try {
							messageToSend.setMessage( 	ShortMessage.CONTROL_CHANGE,
									chan,
									ctrlnumber,
									data2);
						} catch (InvalidMidiDataException e) {
							System.out.println( "error messageToSend.setMessage:"+e.getMessage() );
							e.printStackTrace();
						}     	
						//System.out.println("Sending cc " + cmd + " chan "+chan+" d1(ctrl#) "+ctrlnumber+" d2 "+data2);
						isValid = true;
					} else {
						
						
						/// SC: BYPASS!!!!
						isValid = true;
					}
					
				}
			}
			System.out.println("FromMIDI: cc " + cmd + " chan "+chan+" d1(ctrl#) "+ctrlnumber+" d1(RAW) "+data1+" d2 "+data2);
			
			// send only at certain intervals	
    		if ( System.currentTimeMillis() > time + 100 ) {
    			
    			if ( isValid == true ) {
    				isValid = false;
    				time =  System.currentTimeMillis();
    				setChanged();
    				notifyObservers(messageToSend);
    				clearChanged();	
    			}
    			
    		}
    		
		}
	}

	@Override
	public Receiver getReceiver() {
		return rcv;
	}

	@Override
	public void setReceiver(Receiver arg0) {	
		rcv = arg0;
	}

	public void close(){
	}

	public static void testFader() {
		ShortMessage sm = new ShortMessage();
		try {
			sm.setMessage(176, 1, 0, 50);
		} catch (InvalidMidiDataException e) {
			e.printStackTrace();
		} 
		rcv.send(sm,-1);
	}
}




//public void receive(MidiMessage theMessage, long timeStamp)
//{
//	byte data[] 	= theMessage.;
//	byte message[] 	= new byte[3];
//	System.arraycopy(data, 0, message, 0, data.length);
//	    	
//	setChanged();
//	notifyObservers(theMessage);
//	clearChanged();
//}
