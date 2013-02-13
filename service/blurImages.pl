#!/usr/bin/perl
# DEF: Progressively blurs images using val in /tmp/blur.dat
########################################################################
# blurImages.pl        --- Squid Script (Makes images harder to see)   #
# g0tmi1k 2011-03-25   --- Original Idea: http://www.ex-parrot.com/pete#
# jwright 2013-01-05   --- Added blur amount file for manipulation
########################################################################
# Note ~ Requires ImageMagick                                          #
#    sudo apt-get -y install imagemagick                               #
########################################################################
use IO::Handle;
use LWP::Simple;
use POSIX strftime;

$debug = 0;                               # Debug mode - create log file
$ourIP = "10.0.0.1";                  # Our IP address
$baseDir = "/var/www/tmp";                # Needs be writable by 'nobody'
$baseURL = "http://".$ourIP."/tmp";       # Location on websever
$mogrify = "/usr/bin/mogrify";            # Path to mogrify
$blurscalarfile = "/tmp/blur.dat"; 	  # Blur amount value location

$|=1;
$blur = 0;
$count = 0;
$pid = $$;

if ($debug == 1) { open (DEBUG, '>>/tmp/blurImages_debug.log'); }
autoflush DEBUG 1;

print DEBUG "########################################################################\n";
print DEBUG strftime ("%d%b%Y-%H:%M:%S\t Server: $baseURL/\n",localtime(time()));
print DEBUG "########################################################################\n";

open FILE, ">$blurscalarfile" or die $!;
print FILE "01"; # A little blurry to start
close FILE;

while (<>) {
   chomp $_;
   if ($_ =~ /(.*\.(gif|png|bmp|tiff|ico|jpg|jpeg))/i) {                         # Image format(s)
      $url = $1;                                                                 # Get URL
      if ($debug == 1) { print DEBUG "Input: $url\n"; }                          # Let the user know

      $ext = ($url =~ m/([^.]+)$/)[0];                                           # Get the file extension
      $file = "$baseDir/$pid-$count.$ext";                                       # Set filename + path (Local)
      $filename = "$pid-$count.$ext";                                            # Set filename        (Remote)

      getstore($url,$file);                                                      # Save image
      system("chmod", "a+r", "$file");                                           # Allow access to the file
      if ($debug == 1) { print DEBUG "Fetched image: $file\n"; }                 # Let the user know

      $blur = 1;                                                                 # We need to do something with the image
   }
   else {                                                                        # Everything not a image
      print "$_\n";                                                              # Just let it go
      if ($debug == 1) { print DEBUG "Pass: $_\n"; }                             # Let the user know
   }

   if ($blur == 1) {                                                             # Do we need to do something?
      # Read blur file value
      open FILE, $blurscalarfile;
      binmode FILE;
      $readlen = read FILE, $blurscalar, 2;
      if ($readlen != 2) { $blurscalar = 1; }
      close FILE;
      $blur = $blurscalar * 0.1;
      if ($debug == 1) { print DEBUG "Blur: $blurscalar ($blur)\n"; }

      for ($count=1; $count<11; $count++){
         system("$mogrify -blur $blur" . "x" . "$blur $file");
      }
      system("chmod", "a+r", "$file");                                           # Allow access to the file
      if ($debug == 1) { print DEBUG "Blurred: $file\n"; }

      print "$baseURL/$filename\n";
      if ($debug == 1) { print DEBUG "Output: $baseURL/$filename, From: $url\n"; }
   }
   $blur = 0;
   $count++;
}

close (DEBUG);
