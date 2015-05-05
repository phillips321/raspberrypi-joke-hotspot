# RaspberryPi-Joke-HotSpot #
## What this does ##
So this creates an open wireless access point, when clients connect they can browse the web as normal; but there's a difference. We can change the way the HTML gets sent to them using various scripts:
  * asciiImages.pl: Converts images to ASCII art
  * blurImages.pl: Progressively blurs images using val in /tmp/blur.dat
  * fightClub.pl: Adds animation with image from /var/www/frame.png
  * flipImages.pl: Flips all images veritcally
  * flopImages.pl: Flips all images horizontally (flop)
  * kittenWar.pl: Sends people to kittenwar.com randomly
  * nogoogleBing.pl: Forbids use of google.com, redirecting to bing.com
  * replaceImages.pl: Replaces all images with cat-on-computer pic
  * rickrollYoutube.pl: Obligatory Rick Roll
  * timeMachine.pl: Uses archive.org to show old versions of pages
  * touretteImages.pl: Adds animation to pictures with happy words
  * uselessWeb.pl: Redirects randomly to theuselessweb.com sites

## How it does it ##
All you need is an uplink plugged into the Ethernet and a USB WiFi card capable of Access Point mode. (Note: the pi isn't the fastest device for converting images so it feels like 56k modem using some of the scripts!)
After boot login as root via SSH using the credentials root:toor
And run the /root/neighbours.sh script for the usage instructions.
An example is ./neightbours wlan0 eth0 replaceImages.pl

## More info ##
### Should you wish to run this on something different ###
Should you wish to build this yourself (on any debian box) read my blogpost here:
http://www.phillips321.co.uk/2013/02/12/raspberry-pi-as-a-joke-hotspot/ ‎