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
import java.net.ServerSocket;
import java.net.Socket;
import java.util.Enumeration;
import java.util.Observer;
import java.util.Vector;

/**
 * Originally from the FLOSC project at http://www.benchun.net/flosc/
 */
public class TcpServer extends Thread {
	
	public Vector<TcpClient> clients = new Vector<TcpClient>();  // all connected Flash clients
    private int port;                       // the TCP port
    ServerSocket server;                    // the TCP server
    public Observer obs;
    
    public TcpServer(int port) {
    	
    	this.port 	= port;
    }
    
    public TcpServer(int port, Observer obs) {
    	this.port 	= port;
    	this.obs 	= obs;
    }

    /**
     * Thread run method.  Monitors incoming messages.
    */	
    @SuppressWarnings("unchecked")
	public void run() {
        try {
            // --- create a new TCP server
            server = new ServerSocket(port);
            while(true) {
                // --- ...listen for new client connections
                Socket socket = server.accept();
                TcpClient client = new TcpClient(this, socket);
                clients.addElement(client);
                client.run();
               
            }
        } catch(IOException ioe) {
        	killServer();
        } 
    }
    
    /**
     * Broadcasts a message to all connected Flash clients.
     * Messages are terminated with a null character.
     *
     * @param   message    The message to broadcast.
    */   
    public synchronized void broadcastMessage(byte[] message) {
        Enumeration<TcpClient> e = clients.elements();
        while(e.hasMoreElements()) {
            TcpClient client = (TcpClient)e.nextElement();
            client.send(message);
        }
    }

    /**
     * Removes clients from the client list.
     *
     * @param   client    The TcpClient to remove.
     *
    */
    public void removeClient(TcpClient client) {
        
    	client.killClient();
    	
    }

    /**
     * Stops the TCP server.
    */
    public void killServer() {
        try {
        	Enumeration<TcpClient> e = clients.elements();
            while(e.hasMoreElements()) {
                TcpClient client = (TcpClient)e.nextElement();
                removeClient(client);
            } 
        	server.close();
        } catch (IOException ioe) {
        }
    }
}