#!/usr/bin/perl
# DEF: Redirects randomly to theuselessweb.com sites
########################################################################
# randomUseless.pl  --- Squid Script, random redirect to various useless
#                       web sites, taken from theuselessweb.com
# Joshua Wright
########################################################################
use IO::Handle;
use LWP::Simple;
use POSIX strftime;

$debug = 0;            # Debug mode - create log file
$ourIP = "10.0.0.1";                  # Our IP address
$baseURL = "http://".$ourIP;       # Location on websever
$redirURL = $baseURL."/random-useless.html";
$prob = 10;	# Chance of redirect, 1 in $prob

$|=1;

if ($debug == 1) { open (DEBUG, '>>/tmp/uselessWeb_debug.log'); }
autoflush DEBUG 1;

print DEBUG "########################################################################\n";
print DEBUG strftime ("%d%b%Y-%H:%M:%S\t uselessWeb\n",localtime(time()));
print DEBUG "########################################################################\n";
while (<>) {
   chomp $_;
   $dice = int (rand($prob)+1);
   if ($debug == 1) { print DEBUG "Dice: $dice\n"; }       

   if ($_ =~ /(.*\.(gif|png|bmp|tiff|ico|jpg|jpeg))/i || $_ =~ /(random-useless)/) {
      print "$_\n";  # Just let it go
      if ($debug == 1) { print DEBUG "Skipping image: $_\n"; }   
      next;
   }

   if ($dice == 4 ) { # Guaranteed random
        if ($debug == 1) { print DEBUG "Redirecting URL $_ to $redirURL\n"; }   
	print "$redirURL\n";
   } else {
      print "$_\n";  # Just let it go
      if ($debug == 1) { print DEBUG "Skipping: $_\n"; }   
   }
}
