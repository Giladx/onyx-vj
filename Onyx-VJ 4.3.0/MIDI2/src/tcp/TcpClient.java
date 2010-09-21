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
package tcp;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.Socket;
import java.util.Observable;

import javax.sound.midi.InvalidMidiDataException;
import javax.sound.midi.ShortMessage;

/**
 * TCP client for the TcpServer.
 *
 * Based on CSClient by Derek Clayton.
 *
 * @author  Ben Chun        ben@benchun.net
 * @version 1.0
 * 
 * Originally from the FLOSC project at http://www.benchun.net/flosc/
 */

public class TcpClient extends Observable implements Runnable {
	
	private int MAX_COUNT = 1000;
    private Socket socket;          // socket for connection
    private TcpServer server;      	// server to which the client is connected
    private String ip;              // the ip of this client
    protected InputStream in;    	// captures incoming messages
    protected OutputStream out;     // sends outgoing messages
    
    byte[] messageBuffer;
    byte[] backupBuffer;
    
    /**
     * Constructor for the TcpClient.  Initializes the TcpClient properties.
     * @param   server    The server to which this client is connected.
     * @param   socket    The socket through which this client has connected.
     */
    public TcpClient(TcpServer server, Socket socket) {
    	
    	this.addObserver(server.obs);
    	
        this.server = server;
        this.socket = socket;
        this.ip = socket.getInetAddress().getHostAddress();

        try {
        	in 	= socket.getInputStream();
            out = socket.getOutputStream();
            	    	
        } catch(IOException ioe) {
            killClient();
        }
    }
    
    /**
     * Thread run method.  Monitors incoming messages.
     */	
    public void run() {
    	
    	setChanged();
    	notifyObservers("Server started: "+server.clients.size()+ " clients");
    	clearChanged();
    	
    	int count 				= 0;
    	messageBuffer 			= new byte[3];
    	backupBuffer 			= new byte[3];
    	ShortMessage message 	= new ShortMessage();
    	
    	while(count<MAX_COUNT) {
    		
    		// workaround for the network breakdown
        	if(socket.isClosed())
        		count=MAX_COUNT;
        	
    		try {
    			backupBuffer = messageBuffer;
    			in.read(messageBuffer);
    			message.setMessage(	messageBuffer[0]&0xF0, 	// ShortMessage.CONTROL_CHANGE
    								messageBuffer[0]&0x0F, 	// 0
    								messageBuffer[1],		// 0
    								messageBuffer[2]);		// 60
    		} catch(IOException ioe) {
	        	ioe.printStackTrace();
	        	count=MAX_COUNT;
    		} catch(InvalidMidiDataException ioe) {
    			// this is thrown on each swf drop on layer
    			ioe.printStackTrace();
    			//count=MAX_COUNT;
    		} finally {
    			
    			if(backupBuffer==messageBuffer)	count++;
    			else  							count=0;
    			
				setChanged();
    	    	notifyObservers(message);
    	    	clearChanged();
	        }
	        
    	}
    	
    	// workaround for the network breakdown
    	if(count>=MAX_COUNT) {
    		setChanged();
    		notifyObservers("No connection!");
    		clearChanged();
    		killClient();
    	}
    }

    /**
     * Gets the ip of this client.
     * @return   ip    this client's ip
     */
    public String getIP() {
        return ip;
    }
    
    /**
     * Sends a message to this client. Called by the server's broadcast method.
     * @param   message    The message to send.
     */
    public void send(byte[] message) {
    	try {
    		out.write(message);
    	} catch(IOException e) {	
    	}
    }
 
    /**
     * Kills this client. 
     */   
    public void killClient() {
    	
    	// this fail on multiple clients
    	server.clients.removeElement(this);
    	this.deleteObservers();

        try {
        	in.close();
            out.close();
            socket.close();
            in = null;
            out = null;
            socket = null;
        } catch (IOException ioe) {
        }       
    }
    
}
