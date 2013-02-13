#!/usr/bin/perl
# DEF: Sends people to kittenwar.com randomly
########################################################################
# kittenWars.pl  --- Squid Script, random redirect to Kitten Wars
# Joshua Wright
########################################################################
use IO::Handle;
use LWP::Simple;
use POSIX strftime;

$debug = 0;            # Debug mode - create log file
$ourIP = "10.0.0.1";                  # Our IP address
$baseURL = "http://".$ourIP;       # Location on websever
$redirURL = $baseURL."/kittenwar-redir.html";
$prob = 10;	# Chance of redirect, 1 in $prob

$|=1;

if ($debug == 1) { open (DEBUG, '>>/tmp/uselessWeb_debug.log'); }
autoflush DEBUG 1;

print DEBUG "########################################################################\n";
print DEBUG strftime ("%d%b%Y-%H:%M:%S\t kittenWars\n",localtime(time()));
print DEBUG "########################################################################\n";
while (<>) {
   chomp $_;
   $dice = int (rand($prob)+1);
   if ($debug == 1) { print DEBUG "Dice: $dice\n"; }       

   if ($_ =~ /(.*\.(gif|png|bmp|tiff|ico|jpg|jpeg))/i || $_ =~ /(kittenwar)/) {
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
