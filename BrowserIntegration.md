Making a new build of Onyx-VJ to run hosted in a browser

This project has been updated to be an AIR application 2 years ago to benefit from:
  * local file system integration
  * access to the 2nd screen for videoprojection

I am currently building a browser-based project relying on the Onyx-SDK, these are the steps:
  * Modify the Onyx-SDK to remove the AIR specific functions
  * Put that functions in a 'AIR adapter'
  * Create a new adapters for webservices ( videopong or razuna for instance )
  * Create modules for debugging ( local log files for AIR, trace calls for browser )
