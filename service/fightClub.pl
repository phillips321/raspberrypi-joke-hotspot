#!/usr/bin/perl
# DEF: Adds animation with image from /var/www/frame.png
########################################################################
# fightClub.pl   --- Squid Script (Like the film, Add images to images)#
# g0tmi1k 2011-03-25             #
########################################################################
# Note ~ Requires ImageMagick and Ghostscript       #
#    sudo apt-get -y install imagemagick            #
########################################################################
use IO::Handle;
use LWP::Simple;
use POSIX strftime;

$debug = 0;            # Debug mode - create log file
$ourIP = "10.0.0.1";                  # Our IP address
$baseDir = "/var/www/tmp";                # Needs be writable by 'nobody'
$baseURL = "http://".$ourIP."/tmp";       # Location on websever
$image = "/var/www/frame.png";        # Image to use
$convert = "/usr/bin/convert";            # Path to convert
$identify = "/usr/bin/identify";          # Path to identify

$|=1;
$animate = 0;
$count = 0;
$pid = $$;

if ($debug == 1) { open (DEBUG, '>>/tmp/fightClub_debug.log'); }
autoflush DEBUG 1;

print DEBUG "########################################################################\n";
print DEBUG strftime ("%d%b%Y-%H:%M:%S\t Server: $baseURL/\n",localtime(time()));
print DEBUG "########################################################################\n";
system("killall convert 2>/dev/null");
while (<>) {
   chomp $_;
   if ($_ =~ /(.*\.(gif|png|bmp|tiff|ico|jpg|jpeg))/i) {      # Image format(s)
      $dice = int (rand(6)+1); #$dice = int (rand(6)+1);
      if ($debug == 1) { print DEBUG "Dice: $dice\n"; }       
      if ($dice == 6 ) { #$dice >= 3 and $dice <= 4           # So we don't do it to every image, every time...
         $url = $1;     # Get URL
         if ($debug == 1) { print DEBUG "Input: $url\n"; }    

         $file = "$baseDir/$pid-$count";   # Set filename + path
         $filename = "$pid-$count";        # Set filename

         getstore($url,$file);             # Save image
         system("chmod", "a+r", "$file");  # Allow access to the file
         if ($debug == 1) { print DEBUG "Fetched image: $file\n"; }              

         $animate = 1;  # We need to do something with the image
      }
      else {            # Everything not a image
         print "$_\n";  # Just let it go
         if ($debug == 1) { print DEBUG "Skipping: $_\n"; }   
      }
   }
   else {               # Everything not a image
      print "$_\n";     # Just let it go
      if ($debug == 1) { print DEBUG "Pass: $_\n"; }          
   }

   if ($animate == 1) {
      if ($_ !=~ /(.*\.gif)/i) {           # Select everything other image type to jpg
         system("$convert", "$file", "$file.gif");            # Convert images so they are all jpgs for jp2a
         #system("rm", "$file");           # Remove originals
         if ($debug == 1) { print DEBUG "Converted to gif: $file.gif\n"; }       
      }
      else {
         system("mv", "$file", "$file.gif");                  # No need to convert!
      }
      system("chmod", "a+r", "$file.gif"); # Allow access to the file

      $size = `$identify $file.gif | cut -d" " -f 3`;
      chomp $size;
      if ($debug == 1) { print DEBUG "Image size: $size ($file)\n";}

      system("$convert $image -resize $size\! $baseDir/$filename-flash.png"); #Layer on top maybe?!
      system("chmod", "a+r", "$baseDir/$filename-flash.png");
      if ($debug == 1) { print DEBUG "Resized image: $baseDir/$filename-flash.png\n";}

      system("$convert -delay 500 $file.gif -delay 50 $baseDir/$filename-flash.png -loop 0 -size $size $file-animation.gif");
      system("chmod", "a+r", "$file-animation.gif");
      #system("rm $file.gif $file-text.gif");
      if ($debug == 1) { print DEBUG "Animated gif: $url\n"; }

      print "$baseURL/$filename-animation.gif\n";
      if ($debug == 1) { print DEBUG "Output: $baseURL/$filename-animation.gif, From: $url\n"; }
   }
   $animate = 0;
   $count++;
}
