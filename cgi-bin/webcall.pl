#!/usr/bin/perl
use CGI;
use strict;
use warnings;

my $cgi = new CGI;
my $cmd = $cgi->url_param('cmd');

if ($cmd eq "search") {
Search();
} elsif ($cmd eq "detail") {
GeneDetails();
}


sub Search
{
my $searchString = $cgi->param('query');
my $searchOption = $cgi->param('type');
print $cgi->header();
print <<EOF;
<html>
<head>
<link rel='stylesheet' type='text/css' href='http://student.cryst.bbk.ac.uk/~gseed01/web/home.css'/>
</head>
<body>
<div id="container"></div>
<div id="Header">This is the header/title area - put an image maybe?</div>
<div id="LeftTab">This is the left toolbar/set of links</div>
<p>The Command is: $cmd</p>
<p>$searchString</p>
<p>searchoption = $searchOption</p>
</body>
</html>
EOF
}

sub GeneDetails
{
my $geneName = $cgi->url_param('details');

print $cgi->header();
print <<EOF;
<html>
<head>
<link rel='stylesheet' type='text/css' href='http://student.cryst.bbk.ac.uk/~gseed01/web/home.css'/>
</head>
<body>
<div id="container"></div>
<div id="Header">This is the header/title area - put an image maybe?</div>
<div id="LeftTab">This is the left toolbar/set of links</div>
<p>The Command is: $cmd</p>
<p>$geneName</p>
</body>
</html>
EOF
}
