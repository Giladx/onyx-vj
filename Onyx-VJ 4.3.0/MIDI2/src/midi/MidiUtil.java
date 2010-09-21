package midi;

import javax.sound.midi.MidiDevice;
import javax.sound.midi.MidiSystem;
import javax.sound.midi.MidiUnavailableException;

public class MidiUtil {

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
    
    /**
	 * Retrieve a MidiDevice.Info for a given name.
	 * 
	 * This method tries to return a MidiDevice.Info whose name matches the
	 * passed name. If no matching MidiDevice.Info is found, null is returned.
	 * If bForOutput is true, then only output devices are searched, otherwise
	 * only input devices.
	 * 
	 * @param strDeviceName
	 *            the name of the device for which an info object should be
	 *            retrieved.
	 * @param bForOutput
	 *            If true, only output devices are considered. If false, only
	 *            input devices are considered.
	 * @return A MidiDevice.Info object matching the passed device name or null
	 *         if none could be found.
	 */
	public static MidiDevice.Info getMidiDeviceInfo(String strDeviceName,
			boolean bForOutput) {
		MidiDevice.Info[] aInfos = MidiSystem.getMidiDeviceInfo();
		for (int i = 0; i < aInfos.length; i++) {
			if (aInfos[i].getName().equals(strDeviceName)) {
				try {
					MidiDevice device = MidiSystem.getMidiDevice(aInfos[i]);
					boolean bAllowsInput = (device.getMaxTransmitters() != 0);
					boolean bAllowsOutput = (device.getMaxReceivers() != 0);
					if ((bAllowsOutput && bForOutput)
							|| (bAllowsInput && !bForOutput)) {
						return aInfos[i];
					}
				} catch (MidiUnavailableException e) {
					// TODO:
				}
			}
		}
		return null;
	}

}
