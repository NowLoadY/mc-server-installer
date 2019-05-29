#!/bin/sh

# ARCH VARIABLES

if [ "$SNAP_ARCH" = "amd64" ]; then
  ARCH="x86_64-linux-gnu"
elif [ "$SNAP_ARCH" = "armhf" ]; then
  ARCH="arm-linux-gnueabihf"
else
  ARCH="$SNAP_ARCH-linux-gnu"
fi

# DEFINE LATEST JAR
LATEST=`curl -fsSL 'https://launchermeta.mojang.com/mc/game/version_manifest.json' |jq -r '.latest.release'`

# DEFINE URL
MANIFEST_URL=`curl -fsSL 'https://launchermeta.mojang.com/mc/game/version_manifest.json' |jq -r '.versions[] |select(.id=="'"$LATEST"'") |.url'`

# URL CONT'D
JAR_URL=`curl -fsSL "$MANIFEST_URL" |jq -r '.downloads.server.url'`

# java paths
export JAVA_HOME=$SNAP/usr/lib/jvm/java-1.8.0-openjdk-$SNAP_ARCH
export PATH=$JAVA_HOME/bin:$JAVA_HOME/jre/bin:$PATH

cd $SNAP_USER_DATA


# START THE INSTALLER
echo "--------------------------------"
echo ""
echo " Welcome to MC-SERVER-INSTALLER"
echo ""
echo "             v1.2"
echo ""
echo "          MIT LICENSE"
echo ""
echo "--------------------------------"
sleep 2s
echo "

"
echo "              NOTE"
echo "            --------"
echo "YOU MUST AGREE TO THE EULA PRIOR"
echo "    TO RUNNING THE SERVER!"
echo ""
sleep 5s

while [ answer != "0" ]  
do 
clear 

echo "-------------------------------------"
echo ""
echo "     MINECRAFT SERVER INSTALLER"
echo "               MENU              "
echo ""
echo "-------------------------------------"
echo ""
echo "Select from the following options: " 
echo ""
echo "1) Download latest server.jar"
echo "2) Agree to the EULA"
echo "3) Edit the server.properties file"
echo "4) Run MC server with max 2GB of RAM"
echo "5) Run MC server with max 4GB of RAM"
echo "6) Run MC server with max 6GB of RAM"
echo "7) Run MC server with max 8GB of RAM"
echo "8) Run MC server with max 16GB of RAM"
echo "9) View README"
echo "10) Quit"
echo "" 
read -p "Choice: " answer 
clear
    case $answer in 
       1) echo "Downloading the latest server.jar..."
       echo "" 
       curl -so server.jar $JAR_URL 
       echo ""
       echo "Setting things up..."
       java -Xmx2048M -Xmx1024M -jar server.jar nogui
       ;; 
       2) echo "Agreeing to EULA..."
       echo ""
       sed -ie s/false/true/g eula.txt
       ;; 
       3) echo "Opening the server.properties file..."
       echo ""
       nano ~/snap/mc-server-installer/current/server.properties
       echo ""
       ;;
       4) echo "Starting server with 2GB of RAM..."
       echo ""
       java -Xmx2048M -Xmx1024M -jar server.jar nogui
       ;; 
       5) echo "Starting server with 4GB of RAM..."
       echo ""
       java -Xmx4096M -Xms1024M -jar server.jar nogui
       ;;
       6) echo "Starting server with 6GB of RAM..."
       echo ""
       java -Xmx6144M -Xms1024M -jar server.jar nogui       
       ;;
       7) echo "Starting server with 8GB of RAM..."
       echo ""
       java -Xmx9192M -Xms1024M -jar server.jar nogui       
       ;;
       8) echo "Starting server with 16GB of RAM..."
       echo ""
       java -Xmx16384 -Xms1024M -jar server.jar nogui
       ;;
       9) echo ""
          echo "MC-SERVER-INSTALLER is not an officially"
          echo "supported or licensed application of "
          echo "Mojang."
          echo ""
          echo "The first time you run the installer,"
          echo "you'll need to download the .jar file"
          echo "(i.e. select option #1) and "
          echo "MC-SERVER-INSTALLER will perform a first"
          echo "run."
          echo "Now you may select option #2 to agree to" 
          echo "the EULA."
          echo ""
          echo "       NO. THIS WON'T BE CHANGED!" 
          echo "          BECAUSE LEGAL STUFF"
          echo ""
          echo "After selecting option #2, you can proceed"
          echo "with choosing any of the other options or"
          echo "setting up your server's configuration"
          echo "which is located in:"
          echo "~/snap/mc-server-installer/current"
          echo ""
          echo "This snap package was built from scratch"
          echo "with an MIT License, by kz6fittycent:"
          echo ""
          echo "github.com/kz6fittycent/mc-server-installer"
          echo ""
          ;;
       10) break ;; 
   esac  
   echo "press RETURN for menu" 
   read key 
done 
exit 0
