package ui;

import java.awt.*;
import javax.swing.JFrame;
import javax.swing.ImageIcon;

import java.io.OutputStream;
import java.io.FilterOutputStream;
import java.io.PrintStream;
import java.io.ByteArrayOutputStream;
import java.io.FileWriter;
import java.io.IOException;

@SuppressWarnings("serial")
public class ConsoleFrame extends JFrame {

    // Class information
    protected boolean catchErrors;
    protected boolean logFile;
    protected String fileName;
    protected int width;
    protected int height;
    protected int closeOperation;
    
    public static String MODE_OVERWRITE = "overwrite";
    public static String MODE_APPEND 	= "append";
    private String mode					= MODE_APPEND;
    private String backup;
    
    TextArea aTextArea 			= new TextArea();
    PrintStream aPrintStream  	= new PrintStream(new FilteredStream(new ByteArrayOutputStream()));

    /** Creates a new RedirectFrame.
     *  From the moment it is created,
     *  all System.out messages and error messages (if requested)
     *  are diverted to this frame and appended to the log file 
     *  (if requested)
     *
     * for example:
     *  RedirectedFrame outputFrame =
     *       new RedirectedFrame
                (false, false, null, 700, 600, JFrame.DO_NOTHING_ON_CLOSE);
     * this will create a new RedirectedFrame that doesn't catch errors,
     * nor logs to the file, with the dimentions 700x600 and it doesn't 
     * close this frame can be toggled to visible, hidden by a controlling 
     * class by(using the example) outputFrame.setVisible(true|false)
     *  @param catchErrors set this to true if you want the errors to 
     *         also be caught
     *  @param logFile set this to true if you want the output logged
     *  @param fileName the name of the file it is to be logged to
     *  @param x the horiz position of the frame
     *  @param y the vert position of the frame
     *  @param width the width of the frame
     *  @param height the height of the frame
     *  @param closeOperation the default close operation
     *        (this must be one of the WindowConstants)
     */
    public ConsoleFrame( String title, 
    				boolean catchErrors, 
    				boolean logFile, 
    				String fileName, 
    				Number x, 
    				Number y, 
    				int width,
    				int height, 
    				int closeOperation) {
    	
    	//this.setUndecorated(true);
    	
        this.catchErrors = catchErrors;
        this.logFile = logFile;
        this.fileName = fileName;
        if(x!=null && y!=null) {
        	this.setLocation(x.intValue(), y.intValue());
        }
        this.width = width;
        this.height = height;
        this.closeOperation = closeOperation;

        Container c = getContentPane();

        setTitle(title);
        setSize(width,height);
        c.setLayout(new BorderLayout());
        c.add("Center" , aTextArea);
        aTextArea.setFont(new java.awt.Font("Tahoma",0,10));
        aTextArea.append("Ready\n");
        setVisible(true);

        this.logFile = logFile;

        System.setOut(aPrintStream); // catches System.out messages
        if (catchErrors)
            System.setErr(aPrintStream); // catches error messages

        // set the default closing operation to the one given
        setDefaultCloseOperation(closeOperation);
        //this.setIconImage(new ImageIcon(getClass().getClassLoader().getResource("stefanocottafavi/images/terminal.png")).getImage());

    }



    class FilteredStream extends FilterOutputStream {
        public FilteredStream(OutputStream aStream) {
            super(aStream);
          }

        public void write(byte b[]) throws IOException {
            String aString = new String(b);
            if(mode==MODE_OVERWRITE) {
            	aTextArea.setText(aString);
            } else if(mode==MODE_APPEND) {
            	aTextArea.append(aString);
            }
        }

        public void write(byte b[], int off, int len) throws IOException {
            String aString = new String(b , off , len);
            
            if(mode==MODE_OVERWRITE) {
            	aTextArea.setText(aString);
            } else if(mode==MODE_APPEND) {
            	aTextArea.append(aString);
            }
            
            if (logFile) {
                FileWriter aWriter = new FileWriter(fileName, true);
                aWriter.write(aString);
                aWriter.close();
            }
        }
    }
    
    public void setMode(String value) {
    	mode = value;
    	if(mode==MODE_OVERWRITE) {
    		backup = aTextArea.getText();
    	} else {
    		aTextArea.setText(backup+"\n"+aTextArea.getText());
    	}
    }
    public String getMode() {
    	return mode;
    }

}