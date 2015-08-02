Compiling Onyx-VJ 4 with Flash Builder

First, install Flex Builder 3.2 or later, or download the open source flex sdk.

Put the 3.2 SDK in 'C:\Program Files\Adobe\Flex Builder 3 Plug-in\sdks\3.2.0'

Create the 'E:\Projects\onyx' folder

If you are using Flex Builder, modify 'C:\Program Files\Adobe\Flex Builder 3\configuration\config.ini':
osgi.instance.area.default=E:/Projects/onyx
osgi.configuration.area=E:/Projects/onyx/configuration

Note that this will reinitialize your Flex Builder configuration and workspace.

Launch Flex Builder

To install SVN, Menu Help/Software Updates/Find and Install, and follow the instructions on http://subclipse.tigris.org/install.html

Then File/import/Other,
select Other/Checkout Projects from SVN,
Create a new repository location,
Url: http://onyx-vj.googlecode.com/svn/trunk/
Select Onyx-VJ 4.0.0\InstallerPackage
Check out as a new project
Finish

You can do the same to get 6 projects for BaseMacros, BasePlugins, OnyxSDK, OnyxVJ, Plugins

You are then ready to start compiling Onyx-VJ...

Open Onyx-VJ project and navigate to src/Main.as then run it!

When you first run Onyx-VJ, it will ask you for a folder to create the library, then after some files are copied, Onyx-VJ will run.

Screen captures are available on http://www.batchass.fr/code/onyxvj.html