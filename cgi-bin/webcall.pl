#!/usr/bin/perl
use CGI;
use strict;
use warnings;
my $cgi = new CGI;

my $cmd = $cgi->url_param('cmd');

if ($cmd eq "search") {
Search();
} elsif ($cmd eq "gene") {
Gene();
}


sub Search
{
my $searchString = $cgi->param('search');

print $cgi->header();
print <<EOF;
<html>
<head>
<link rel='stylesheet' type='text/css' href='../home.css'/>
</head>
<body>
<div id="container">This contains most everything.. I think</div>
<div id="Header">This is the header/title area - put an image maybe?</div>
<div id="LeftTab">This is the left toolbar/set of links</div>
<p>The Command is: $cmd</p>
<p>$searchString</p>
</body>
</html>
EOF

}

sub Gene
{
my $geneName = $cgi->url_param('geneName');

print $cgi->header();
print <<EOF;
<html>
<head>
<link rel='stylesheet' type='text/css' href='../home.css'/>
</head>
<body>
<p>The Command is: $cmd</p>
<p>$geneName</p>
</body>
</html>
EOF
}
