#!/usr/bin/perl
# DEF: Forbids use of google.com, redirecting to bing.com
########################################################################
# nogoogleBing.pl   --- Force all access to Google to Bing
########################################################################
use IO::Handle;
use POSIX strftime;

$debug = 0;                               # Debug mode - create log file
$replaceDomain = "google.com";          # Which site to replace (Dont add: http://wwww)
$ourIP = "10.0.0.1";                  # Our IP address
$baseURL = "http://".$ourIP."/bing-redir.html";       # Location on websever

$|=1;

if ($debug == 1) { open (DEBUG, '>>/tmp/replacePages_debug.log'); }
autoflush DEBUG 1;

print DEBUG "########################################################################\n";
print DEBUG strftime ("%d%b%Y-%H:%M:%S\t Server: $baseURL/\n",localtime(time()));
print DEBUG "########################################################################\n";
while (<>) {
   chomp $_;
   if ($debug == 1) { print DEBUG "Input: $_\n"; }
   if ($_ =~ m/$replaceDomain/) {
      print "$baseURL\n";
      if ($debug == 1) { print DEBUG "Output: Fail whale'd ($_)\n"; }
   } else {
      print "$_\n";
      if ($debug == 1) { print DEBUG "Output: $_\n"; }
   }
}

close (DEBUG);
