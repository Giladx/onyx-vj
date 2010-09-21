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
 * 
 * Credits: Mike Creighton, FLOSC project
 * 
 * Icons: http://www.famfamfam.com
 * 
 */
package ui;

import java.awt.Dimension;
import java.awt.FlowLayout;
import java.awt.Image;
import java.awt.MenuItem;
import java.awt.Point;
import java.awt.PopupMenu;
import java.awt.SystemTray;
import java.awt.Toolkit;
import java.awt.TrayIcon;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.MouseEvent;
import java.awt.event.MouseListener;
import java.awt.event.WindowEvent;
import java.awt.event.WindowListener;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.Observable;
import java.util.Observer;

import javax.sound.midi.MidiDevice;
import javax.sound.midi.MidiMessage;
import javax.sound.midi.MidiSystem;
import javax.sound.midi.MidiUnavailableException;
import javax.sound.midi.Receiver;
import javax.sound.midi.ShortMessage;
import javax.sound.midi.Transmitter;
import javax.swing.BorderFactory;
import javax.swing.BoxLayout;
import javax.swing.ImageIcon;
import javax.swing.JButton;
import javax.swing.JCheckBox;
import javax.swing.JComboBox;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.JSpinner;
import javax.swing.SpinnerModel;
import javax.swing.SpinnerNumberModel;
import javax.swing.SwingUtilities;
import javax.swing.UIManager;
import javax.swing.WindowConstants;
import javax.swing.border.BevelBorder;
import javax.swing.border.TitledBorder;

import midi.MonitoringReceiver;
import ui.ConsoleFrame;
import tcp.TcpClient;
import tcp.TcpServer;

public class MIDI2 extends JFrame implements Observer {
	
	private int 				SERVER_PORT = 100;
	private boolean 			isServerRunning;
	private boolean 			isMidiConnected;
	
	private ArrayList<String> 	midiInDevices;
	private ArrayList<String> 	midiOutDevices;
	private MidiDevice.Info 	inputInfo[];
	private MidiDevice.Info 	outputInfo[];
	private TcpServer 			server;
	private MidiDevice 			inputPort;  //  @jve:decl-index=0:
	private MidiDevice 			outputPort;
	private Transmitter 		inputTransmitter;
	private Receiver 			outputReceiver;
	private MonitoringReceiver 	inputRxTx;
	
	private JPanel 		midiPanel;
	private JButton 	serverButton;
	private JPanel 		buttonPanel;
	private JLabel 		tcpPortLabel;
	private JLabel 		statusLabel;
	private JPanel 		statusPanel;
	private JCheckBox 	wayCheckBox;
	private JPanel 		midiWayPanel;
	private JButton 	midiButton;
	private JPanel 		jPanel5;
	private JSpinner 	tcpPortSpinner;
	private JComboBox 	midiOutList;
	private JLabel 		midiOutLabel;
	private JPanel 		midiOutPanel;
	private JPanel 		midiInPanel;
	private JComboBox 	midiInList;
	private JLabel 		midiInLabel;
	private JPanel 		tcpPanel;
	private JButton 	testButton;
	
	private SystemTray 	tray = null;
	private TrayIcon 	trayIcon = null;
	
	private String 		labelServer;  //  @jve:decl-index=0:
	private String 		labelMIDI;  //  @jve:decl-index=0:
	
	
	public static void main(String[] args) {
		SwingUtilities.invokeLater(new Runnable() {
			public void run() {
				MIDI2 inst = new MIDI2();
				ConsoleFrame cf = new ConsoleFrame( "MIDI2 Console", 
	    				true, 
	    				false, 
	    				"", 
	    				0, 
	    				0, 
	    				400,
	    				200, 
	    				0);
				inst.setLocationRelativeTo(null);
				inst.setVisible(true);
				inst.setResizable(false);
				
				// position
				Dimension screenSize = Toolkit.getDefaultToolkit().getScreenSize();
				Dimension windowSize = inst.getSize();

				inst.setLocation(new Point(	screenSize.width  - windowSize.width,
											screenSize.height - windowSize.height - 30));
			}
		});
	}
	
	public MIDI2() {
		super();
		init();
		initGUI();
	}
	
	private void init() {
		
		isServerRunning = false;
		isMidiConnected = false;
		
		labelServer = "Server stopped (0 clients)";
		labelMIDI	= "MIDI off";
		
        MidiDevice.Info info[] = MidiSystem.getMidiDeviceInfo();
        
        inputInfo 	= filterInputDevices(info, true);
        outputInfo 	= filterOutputDevices(info, true);
        midiInDevices = new ArrayList<String>();
        for(int i = 0; i<inputInfo.length; i++) {
        	midiInDevices.add(inputInfo[i].getName());
        }
        midiOutDevices = new ArrayList<String>();
        for(int i = 0; i < outputInfo.length; i++) {
        	midiOutDevices.add(outputInfo[i].getName());
        }
        
	}
	
	private void initGUI() {
		
		this.addWindowListener(new MainJFrameListener());
		
		if(SystemTray.isSupported()) {
	         tray = SystemTray.getSystemTray();
	         Image image = new ImageIcon(getClass().getClassLoader().getResource("images/arrow_switch.png")).getImage();
	 	    
	         ActionListener actionListener = new ActionListener() {
	             public void actionPerformed(ActionEvent e) {
	            	 trayIcon.setToolTip("MIDI2: "+statusLabel.getText());	            	
	             }
	         };
	         
	         ActionListener aboutListener = new ActionListener() {
	             public void actionPerformed(ActionEvent e) {
	            	 trayIcon.displayMessage("MIDI/TCP 2Way Proxy",
	            	 					"� Stefano Cottafavi 2008 \n" +
	            	 					"Credits: Mike Craighton, FLOSC project",
	            	 					TrayIcon.MessageType.INFO);
	             }
	         };
	         
	         ActionListener exitListener = new ActionListener() {
	             public void actionPerformed(ActionEvent e) {
	            	 disconnectAll();
	            	 tray.remove(trayIcon);
	                 System.exit(0);
	             }
	         };
	         
	         MouseListener mouseListener = new MouseListener() {
	             public void mousePressed(MouseEvent e) {
	            	 if(e.getButton()==MouseEvent.BUTTON1) {
	            		 if(e.getClickCount()>=2) {
	            			 setVisible(true);
	            			 setState(JFrame.NORMAL);
				     		 tray.remove(trayIcon);
	            		 } else {
	            			 
	            		 }
	            	 } else if(e.getButton()==MouseEvent.BUTTON2) {
	            		 
	            	 }
	             };
	             public void mouseClicked(MouseEvent e) { 
	             };
	             public void mouseEntered(MouseEvent e) {
	             };
	             public void mouseExited(MouseEvent e) {
	             };
	             public void mouseReleased(MouseEvent e) {
	             };
	             
	         };
	         
	         PopupMenu popup = new PopupMenu();
	         MenuItem aboutItem = new MenuItem("About");
	         MenuItem exitItem = new MenuItem("Exit");
	         aboutItem.setFont(new java.awt.Font("Tahoma",0,10));
	         exitItem.setFont(new java.awt.Font("Tahoma",0,10));
	         aboutItem.addActionListener(aboutListener);
	         exitItem.addActionListener(exitListener);
	         popup.add(aboutItem);
	         popup.add(exitItem);
	         	         
	         trayIcon = new TrayIcon(image, "MIDI2", popup);
	         trayIcon.addActionListener(actionListener);
	         trayIcon.addMouseListener(mouseListener);
	         
	         // start iconified
//	         try {
//	        	 tray.add(trayIcon);
//	         } catch(AWTException eawt) {
//	        	 System.err.println(eawt);
//	         }
	         
	     }
	     // ...
	     // some time later
	     // the application state has changed - update the image
//	     if (trayIcon != null) {
//	         trayIcon.setImage(updatedImage);
//	     }
	     
		try {
			FlowLayout thisLayout = new FlowLayout();
			thisLayout.setVgap(0);
			thisLayout.setHgap(0);
			getContentPane().setLayout(thisLayout);
			setDefaultCloseOperation(WindowConstants.DISPOSE_ON_CLOSE);
			
			UIManager.setLookAndFeel(UIManager.getSystemLookAndFeelClassName());
			
			this.setTitle("MIDI2");
			{
				midiPanel = new JPanel();
				BoxLayout midiWayPanelLayout = new BoxLayout(midiPanel, javax.swing.BoxLayout.Y_AXIS);
				midiPanel.setLayout(midiWayPanelLayout);
				getContentPane().add(midiPanel);
				midiPanel.setPreferredSize(new java.awt.Dimension(210, 91));
				midiPanel.setBorder(BorderFactory.createTitledBorder(null, "MIDI", TitledBorder.LEADING, TitledBorder.TOP, new java.awt.Font("Tahoma",0,10)));
				midiPanel.setFont(new java.awt.Font("Tahoma",0,10));
				{
					midiWayPanel = new JPanel();
					midiPanel.add(midiWayPanel);
					FlowLayout jPanel1Layout = new FlowLayout();
					FlowLayout jPanelXLayout = new FlowLayout();
					jPanelXLayout.setAlignment(FlowLayout.LEFT);
					jPanelXLayout.setVgap(0);
					midiWayPanel.setLayout(jPanel1Layout);
					midiWayPanel.setPreferredSize(new java.awt.Dimension(198, 19));
					jPanel1Layout.setVgap(0);
					jPanel1Layout.setAlignOnBaseline(true);
					jPanel1Layout.setAlignment(FlowLayout.LEFT);
					jPanel1Layout.setHgap(3);
					{
						wayCheckBox = new JCheckBox();
						FlowLayout wayCheckBoxLayout = new FlowLayout();
						wayCheckBoxLayout.setVgap(0);
						wayCheckBox.setLayout(wayCheckBoxLayout);
						wayCheckBox.setText("2Way Mode");
						wayCheckBox.setFont(new java.awt.Font("Tahoma",0,10));
						wayCheckBox.setPreferredSize(new java.awt.Dimension(82, 21));
						wayCheckBox.setSelected(true);
						midiWayPanel.add(wayCheckBox);
						ActionListener wayCheckBoxListener = new ActionListener() {
							public void actionPerformed(ActionEvent e) {
								
								midiOutList.setEnabled(wayCheckBox.isSelected());
								
							}
						};
						wayCheckBox.addActionListener(wayCheckBoxListener);
					}
					
					//TODO
					wayCheckBox.setEnabled(false);

//					{
//						coupleCheckBox = new JCheckBox();
//						midiWayPanel.add(coupleCheckBox);
//						coupleCheckBox.setText("Link IN/OUT");
//						coupleCheckBox.setFont(new java.awt.Font("Tahoma",0,10));
//					}
				}
				{
					midiInPanel = new JPanel();
					FlowLayout jPanel3Layout = new FlowLayout();
					jPanel3Layout.setAlignment(FlowLayout.RIGHT);
					jPanel3Layout.setAlignOnBaseline(true);
					jPanel3Layout.setVgap(0);
					midiInPanel.setLayout(jPanel3Layout);
					midiPanel.add(midiInPanel);
					{
						midiInLabel = new JLabel();
						midiInLabel.setText("MIDI Input   ");
						midiInLabel.setFont(new java.awt.Font("Tahoma",0,10));
						midiInPanel.add(midiInLabel);
					}
					{
						String[] midiInDeviceList = new String[midiInDevices.size()];
						Iterator<String> midiIterator = midiInDevices.iterator();
						int count = 0;
						while(midiIterator.hasNext()){
							midiInDeviceList[count] = midiIterator.next();
							count++;
						}
						midiInList = new JComboBox(midiInDeviceList);
						midiInPanel.add(midiInList);
						midiInList.setFont(new java.awt.Font("Tahoma",0,10));
						midiInList.setPreferredSize(new java.awt.Dimension(120, 20));
					}
				}
				{
					midiOutPanel = new JPanel();
					midiPanel.add(midiOutPanel);
					FlowLayout jPanel4Layout = new FlowLayout();
					jPanel4Layout.setAlignment(FlowLayout.RIGHT);
					jPanel4Layout.setAlignOnBaseline(true);
					jPanel4Layout.setVgap(0);
					midiOutPanel.setLayout(jPanel4Layout);
					{
						midiOutLabel = new JLabel();
						midiOutLabel.setText("MIDI Output ");
						midiOutLabel.setFont(new java.awt.Font("Tahoma",0,10));
						midiOutPanel.add(midiOutLabel);
					}
					{
						String[] midiOutDeviceList = new String[midiOutDevices.size()];
						Iterator<String> midiIterator = midiOutDevices.iterator();
						int count = 0;
						while(midiIterator.hasNext()){
							midiOutDeviceList[count] = midiIterator.next();
							count++;
						}
						midiOutList = new JComboBox(midiOutDeviceList);
						midiOutList.setFont(new java.awt.Font("Tahoma",0,10));
						midiOutList.setPreferredSize(new java.awt.Dimension(120, 20));
						midiOutPanel.add(midiOutList);
					}
				}
			}
			{
				tcpPanel = new JPanel();
				BoxLayout jPanel2Layout = new BoxLayout(tcpPanel, javax.swing.BoxLayout.Y_AXIS);
				tcpPanel.setLayout(jPanel2Layout);
				getContentPane().add(tcpPanel);
				tcpPanel.setBorder(BorderFactory.createTitledBorder(null, "TCP", TitledBorder.LEADING, TitledBorder.TOP, new java.awt.Font("Tahoma",0,10)));
				tcpPanel.setFont(new java.awt.Font("Tahoma",0,10));
				tcpPanel.setPreferredSize(new java.awt.Dimension(210, 45));
				{
					jPanel5 = new JPanel();
					FlowLayout jPanel5Layout = new FlowLayout();
					jPanel5Layout.setAlignment(FlowLayout.LEFT);
					jPanel5Layout.setVgap(0);
					jPanel5.setLayout(jPanel5Layout);
					tcpPanel.add(jPanel5);
					jPanel5.setPreferredSize(new java.awt.Dimension(198, 20));
					{
						tcpPortLabel = new JLabel();
						jPanel5.add(tcpPortLabel);
						tcpPortLabel.setText("Port");
						tcpPortLabel.setFont(new java.awt.Font("Tahoma",0,10));
					}
					{
						SpinnerModel portModel = new SpinnerNumberModel(10000, //initial value
                                1, 		//min
                                65535, 	//max
                                1);     //step
						tcpPortSpinner = new JSpinner();
						jPanel5.add(tcpPortSpinner);
						tcpPortSpinner.setModel(portModel);
						tcpPortSpinner.setEditor(new JSpinner.NumberEditor(tcpPortSpinner, "######"));
						tcpPortSpinner.setPreferredSize(new java.awt.Dimension(57, 18));
						tcpPortSpinner.getEditor().setFont(new java.awt.Font("Tahoma",0,10));
						tcpPortSpinner.setFont(new java.awt.Font("Tahoma",0,10));
					}
				}
			}
			{
				buttonPanel = new JPanel();
				FlowLayout jPanel6Layout = new FlowLayout();
				jPanel6Layout.setVgap(0);
				jPanel6Layout.setHgap(2);
				jPanel6Layout.setAlignment(FlowLayout.LEFT);
				buttonPanel.setLayout(jPanel6Layout);
				getContentPane().add(buttonPanel);
				buttonPanel.setFont(new java.awt.Font("Tahoma",0,10));
				buttonPanel.setPreferredSize(new java.awt.Dimension(210, 30));
				buttonPanel.setBorder(BorderFactory.createEmptyBorder(2, 0, 0, 0));
				{
					serverButton = new JButton();
					buttonPanel.add(serverButton);
					serverButton.setText("START Server");
					serverButton.setPreferredSize(new java.awt.Dimension(104, 24));
					serverButton.setFont(new java.awt.Font("Tahoma",0,10));
					serverButton.setBorder(BorderFactory.createCompoundBorder(
							null, 
							BorderFactory.createEtchedBorder(BevelBorder.LOWERED)));
					serverButton.setIcon(new ImageIcon(getClass().getClassLoader().getResource("images/disconnect.png")));
					serverButton.setOpaque(false);
					serverButton.addActionListener(new ServerStartListener());
				}
				{
					midiButton = new JButton();
					buttonPanel.add(midiButton);
					midiButton.setText("Connect MIDI");
					midiButton.setFont(new java.awt.Font("Tahoma",0,10));
					midiButton.setPreferredSize(new java.awt.Dimension(100, 24));
					midiButton.setBorder(BorderFactory.createCompoundBorder(
							null, 
							BorderFactory.createEtchedBorder(BevelBorder.LOWERED)));
					midiButton.addActionListener(new MidiConnectListener());
					midiButton.setEnabled(false);
					midiButton.setIcon(new ImageIcon(getClass().getClassLoader().getResource("images/keyboard.png")));
				}
//				{
//					testButton = new JButton();
//					buttonPanel.add(testButton);
//					testButton.setText("T");
//					testButton.setFont(new java.awt.Font("Tahoma",0,10));
//					testButton.setPreferredSize(new java.awt.Dimension(24, 24));
//					testButton.setBorder(BorderFactory.createCompoundBorder(
//							null, 
//							BorderFactory.createEtchedBorder(BevelBorder.LOWERED)));
//					testButton.addActionListener(new TestListener());
//					testButton.setEnabled(true);
//					//testButton.setIcon(new ImageIcon(getClass().getClassLoader().getResource("images/keyboard.png")));
//				}
			}
			{
				statusPanel = new JPanel();
				getContentPane().add(statusPanel);
				BoxLayout statusPanelLayout = new BoxLayout(statusPanel, javax.swing.BoxLayout.Y_AXIS);
				statusPanel.setLayout(statusPanelLayout);
				statusPanel.setPreferredSize(new java.awt.Dimension(208, 17));
				statusPanel.setFont(new java.awt.Font("Tahoma",0,10));
				statusPanel.setBorder(BorderFactory.createBevelBorder(BevelBorder.LOWERED));
				{
					statusLabel = new JLabel();
					statusPanel.add(statusLabel);
					statusLabel.setText(labelServer+ " / " +labelMIDI );
					statusLabel.setFont(new java.awt.Font("Tahoma",0,10));
					statusLabel.setForeground(new java.awt.Color(60,60,60));
					statusLabel.setAlignmentX(0.1f);
					statusLabel.setAlignmentY(0.6f);
				}
			}
			pack();
			this.setSize(218, 211);
			this.setIconImage(new ImageIcon(getClass().getClassLoader().getResource("images/arrow_switch.png")).getImage());
			
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	/**
	 * Loops through all MidiDevice.Info instances and determines which ones are capable of transmitting data.
	 * 
	 * @param infoList Array of MidiDevice.Info instances
	 * @param select Boolean representing whether we want to include or exclude transmitting-capable devices
	 * @return an Array of MidiDevice.Info instances that are capable of transmitting data
	 */
    public static MidiDevice.Info[] filterInputDevices(MidiDevice.Info infoList[], boolean select)
    {
        boolean copyElement[] = new boolean[infoList.length];
        int deviceCount = 0;
        for(int index = 0; index < infoList.length; index++)
            try
            {
                MidiDevice device = MidiSystem.getMidiDevice(infoList[index]);
                boolean hasTransmitter = device.getMaxTransmitters() != 0;
                if(hasTransmitter == select)
                {
                    copyElement[index] = true;
                    deviceCount++;
                }
            }
            catch(MidiUnavailableException e) { }

        javax.sound.midi.MidiDevice.Info outList[] = new javax.sound.midi.MidiDevice.Info[deviceCount];
        int outIndex = 0;
        for(int index = 0; index < infoList.length; index++)
            if(copyElement[index])
            {
                outList[outIndex] = infoList[index];
                outIndex++;
            }

        return outList;
    }
    
    public static MidiDevice.Info[] filterOutputDevices(MidiDevice.Info infoList[], boolean select)
    {
        boolean copyElement[] = new boolean[infoList.length];
        int deviceCount = 0;
        for(int index = 0; index < infoList.length; index++) {
            try
            {
                MidiDevice device = MidiSystem.getMidiDevice(infoList[index]);
                boolean hasReceiver = device.getMaxReceivers() != 0;
                if(hasReceiver == select)
                {
                    copyElement[index] = true;
                    deviceCount++;
                }
            }
            catch(MidiUnavailableException e) { 
            }
        }

        MidiDevice.Info outList[] = new MidiDevice.Info[deviceCount];
        int outIndex = 0;
        for(int index = 0; index < infoList.length; index++)
            if(copyElement[index]) {
                outList[outIndex] = infoList[index];
                outIndex++;
            }

        return outList;
    }
    
	public void update(Observable o, Object arg) 
	{
		if(o instanceof MonitoringReceiver) {
			if(isServerRunning) {
				System.out.println(((ShortMessage)arg).getStatus()+" "+((ShortMessage)arg).getData1()+" "+((ShortMessage)arg).getData2());
				server.broadcastMessage(((MidiMessage)arg).getMessage());	
			}
		} else if(o instanceof TcpClient) {
			if(arg instanceof ShortMessage) {
				outputReceiver.send((ShortMessage)arg,-1);
				//System.out.println(((ShortMessage)arg).getStatus()+" "+((ShortMessage)arg).getData1()+" "+((ShortMessage)arg).getData2());
			} else {
				labelServer = (String)arg;
				statusLabel.setText(labelServer+ " / " +labelMIDI );
			}
		} else {
			//System.out.println("Disconnected");
			disconnectAll();
			midiInList.setEnabled(true);
			midiOutList.setEnabled(true);
			serverButton.setText("START Server");
			midiButton.setText("Connect MIDI");
			midiButton.setEnabled(true);
			serverButton.setIcon(new ImageIcon(getClass().getClassLoader().getResource("images/disconnect.png")));
			labelServer = "Server Stopped (0 clients)";
			labelMIDI	= "MIDI off";
			statusLabel.setText(labelServer+ " / " +labelMIDI );
		}
	}
	
	/**
	 * Inner class for receiving the SERVER START button events
	 */
	public class ServerStartListener implements ActionListener 
	{		
		public void actionPerformed(ActionEvent event)
		{
			if(!isServerRunning) {
				
				tcpPortSpinner.setEnabled(false);
				serverButton.setIcon(new ImageIcon(getClass().getClassLoader().getResource("images/connect.png")));
				serverButton.setText("STOP Server");
				midiButton.setSelected(false);
				midiButton.setEnabled(true);
				labelServer = "Server started: 0 clients";
				labelMIDI	= "MIDI off";
				statusLabel.setText(labelServer+ " / " +labelMIDI );
				
				SERVER_PORT = ((SpinnerNumberModel)tcpPortSpinner.getModel()).getNumber().intValue();
				startServer(SERVER_PORT);
				
				isServerRunning = true;
								
			} else {
				
				disconnectAll();
								
				wayCheckBox.setEnabled(true);
				midiInList.setEnabled(true);
				midiOutList.setEnabled(true);
				tcpPortSpinner.setEnabled(true);
				serverButton.setText("START Server");
				midiButton.setText("MIDI Connect");
				midiButton.setEnabled(false);
				serverButton.setIcon(new ImageIcon(getClass().getClassLoader().getResource("images/disconnect.png")));
				labelServer = "Server stopped: 0 clients";
				labelMIDI	= "MIDI off";
				statusLabel.setText(labelServer+ " / " +labelMIDI );
				
				isMidiConnected = false;
				isServerRunning = false;
			}
					
		}
		
	}
	
	private void startServer(int portNum) 
	{
		server = new TcpServer(portNum,this);
		server.start();
	}
		
	/**
	 * Inner class for receiving the MDII CONNECT button events
	 */
	public class MidiConnectListener implements ActionListener {		
		public void actionPerformed(ActionEvent event) {
		
			if(!isMidiConnected) {
				wayCheckBox.setEnabled(false);
				midiInList.setEnabled(false);
				midiOutList.setEnabled(false);
				midiButton.setText("MIDI Disconnect");
				labelServer = "Server started: 0 clients";
				labelMIDI	= "MIDI on " + (wayCheckBox.isSelected()?"(2way)":"(1way)");
				statusLabel.setText(labelServer+ " / " +labelMIDI );
				
				connectToSelectedDevice();
				
				isMidiConnected = true;
			} else {
				disconnectFromSelectedDevice();
				wayCheckBox.setEnabled(true);
				midiInList.setEnabled(true);
				midiOutList.setEnabled(true);
				midiButton.setText("MIDI Connect");
				labelServer = "Server started: 0 clients";
				labelMIDI	= "MIDI off";
				statusLabel.setText(labelServer+ " / " +labelMIDI );
				
				isMidiConnected = false;
				
			}
		
		}
	}
	
	public class TestListener implements ActionListener {		
		public void actionPerformed(ActionEvent event) {
		
			if(isMidiConnected) {
				//MidiCommon.testFader(outputReceiver); // TEST 2WAY
				//MonitoringReceiver.testFader();
			}
		}
	}
	private void connectToSelectedDevice() 
	{
		// Determine the IN device chosen.
		int selectedIndex = midiInList.getSelectedIndex();
		MidiDevice.Info inputDeviceInfo = inputInfo[selectedIndex];			
		try {
			inputPort = MidiSystem.getMidiDevice(inputDeviceInfo);
			inputPort.open();
			inputTransmitter = inputPort.getTransmitter();
			inputRxTx = new MonitoringReceiver();
			inputRxTx.addObserver(this);
			inputTransmitter.setReceiver(inputRxTx);
			
			//outputPort = MidiSystem.getMidiDevice(inputDeviceInfo);
			//outputPort.open();
			//outputReceiver = inputPort.getReceiver();
			//inputRxTx.setReceiver(outputReceiver);
						
		} catch (MidiUnavailableException e) {
			e.printStackTrace();
		}
		
		// Determine the OUT device chosen.
		if(wayCheckBox.isSelected()) {
			selectedIndex = midiOutList.getSelectedIndex();
			MidiDevice.Info outputDeviceInfo = outputInfo[selectedIndex];
			
			try {
				outputPort = MidiSystem.getMidiDevice(outputDeviceInfo);
				outputPort.open();
				outputReceiver = outputPort.getReceiver();
				
			} catch (MidiUnavailableException e) {
				e.printStackTrace();
			}
		}
		
	}
	
	private void disconnectFromSelectedDevice() 
	{
		if(inputPort != null) {
			if(inputPort.isOpen()) {
				inputPort.close();
				inputPort = null;
			}
		}
		if(inputRxTx != null) {
			inputRxTx.close();
			inputRxTx = null;
		}
		if(inputTransmitter != null) {
			inputTransmitter.close();
			inputTransmitter = null;
		}
		
		if(outputPort != null) {
			if(outputPort.isOpen()) {
				outputPort.close();
				outputPort = null;
			}
		}
		if(outputReceiver != null) {
			outputReceiver.close();
			outputReceiver = null;
		}
		
	}
	/**
	 * Inner class for receiving the MDII CONNECT button events
	 */
	public class MidiComboListener implements ActionListener 
	{
			
		public void actionPerformed(ActionEvent event)
		{
			
		}
		
	}
	
	public class MainJFrameListener implements WindowListener
	{
		public void windowActivated(WindowEvent e) {
		}

		public void windowClosed(WindowEvent e) {			
			disconnectAll();
			System.exit(0);
		}

		public void windowClosing(WindowEvent e) {
		}

		public void windowDeactivated(WindowEvent e) {
		}

		public void windowDeiconified(WindowEvent e) {
		}

		public void windowIconified(WindowEvent e) {
			
			/*setVisible(false);
	         
            try {
                tray.add(trayIcon);
            } catch(AWTException eawt) {
				System.err.println(eawt);
			}*/
		}

		public void windowOpened(WindowEvent e) {
		}
		
	}
	
	public void disconnectAll() {
		
		// server
		if(server != null) {
			server.killServer();
			server = null;
		}
		
		// out
		if(outputPort != null) {
			if(outputPort.isOpen()) {
				outputPort.close();
				outputPort = null;
			}
		}
		if(outputReceiver != null) {
			outputReceiver.close();
			outputReceiver = null;
		}
		
		// in
		if(inputPort != null) {
			if(inputPort.isOpen()) {
				inputPort.close();
				inputPort = null;
			}
		}
		if(inputRxTx != null) {
			inputRxTx.close();
			inputRxTx = null;
		}
		if(inputTransmitter != null) {
			inputTransmitter.close();
			inputTransmitter = null;
		}
		
	}

}
