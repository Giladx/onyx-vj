To compile Onyx-AIR-Main project, the export release wizard must be run **twice**!

start the export release
> export to any folder (bin-release ok)

the 1st wizard:
specify a certificate
then next, etc
there is an error : the icons are missing...
so cancel this 1st time wizard
BUT it has created the bin-release folder:

in that folder I copy the folder structure from install package: icons, assets, library, root

(I have to mention here that all the swfs in that folder are RELEASE built from the other projects!)

then start the 2nd time export release wizard
then it should go to the Finish button, which should generate the AIR file