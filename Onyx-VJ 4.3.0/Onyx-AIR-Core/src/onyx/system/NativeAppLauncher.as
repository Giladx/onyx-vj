package onyx.system {
	import flash.desktop.*;
	import flash.events.ProgressEvent;
	import flash.filesystem.*;
	import flash.system.Capabilities;
	
	import onyx.core.Console;
	
	public class NativeAppLauncher 
	{
		
		private var nativeProcess:NativeProcess;
		private var pathToExe:String;
		private var receivedText:String = 'AppLaunch';
		private var cnt:int = 0;
		// 2010.06.11 SC: TODO "apps/bin/VCTRLv1.5"
		public function NativeAppLauncher(exeFilename:String) 
		{
			pathToExe = exeFilename;
			if (NativeProcess.isSupported)
			{
				checkExe();
			}
			else
			{
				Console.output("NativeProcess not supported.");
			}
		}
		public function checkExe():void
		{	 
			var folder:File = File.applicationStorageDirectory.resolvePath( 'native' );
			var folderPath:String = folder.nativePath.toString();
			// creates folder if it does not exists
			if (!folder.exists) 
			{
				Console.output('Creating folder: ' + folderPath);
				// create the directory
				folder.createDirectory();
			}
			
			var file:File = File.applicationStorageDirectory.resolvePath( 'native' + File.separator + pathToExe );
			
			if( file.exists )
			{
				launchExe(file);
			}
			
		}
		public function launchExe(file:File):void
		{	 			
			var nativeProcessStartupInfo:NativeProcessStartupInfo = new NativeProcessStartupInfo();
			nativeProcessStartupInfo.executable = file;
			//KO nativeProcessStartupInfo.workingDirectory = new File("/");
			
			nativeProcess = new NativeProcess();
			nativeProcess.start(nativeProcessStartupInfo);
			
			nativeProcess.addEventListener(ProgressEvent.STANDARD_OUTPUT_DATA, onOutputData);
			nativeProcess.addEventListener(ProgressEvent.STANDARD_INPUT_PROGRESS, inputProgressListener);
		}
		public function writeData(text:String):void
		{
			nativeProcess.standardInput.writeUTFBytes(text + "\n");
		}
		public function inputProgressListener(event:ProgressEvent):void
		{
			nativeProcess.closeInput();
		}
		public function onOutputData(event:ProgressEvent):void
		{
			cnt++;
			receivedText = nativeProcess.standardOutput.readUTFBytes(nativeProcess.standardOutput.bytesAvailable)
			Console.output(receivedText + cnt.toString());
			//needed? launchExe();
			
		}
		public function readAppOutput():String
		{
			return receivedText;
		}
	}
}