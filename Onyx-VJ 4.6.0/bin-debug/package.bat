SET AIR_SDK=C:\Users\b.lane\Documents\flex_sdk_4.6.0.23201B
SET ANE_PATH=..\..\PenTabletLib\bin

"%AIR_SDK%\bin\adt.bat" -package -XnoAneValidate -storetype pkcs12 -keystore test.p12 -storepass test -target native PenTabletDemo PenTabletDemo-app.xml PenTabletDemo.swf -extdir "%ANE_PATH%"
pause