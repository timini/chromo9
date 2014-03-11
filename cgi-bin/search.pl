#!/usr/bin/perl
use CGI;
use BC2;
use strict;
use warnings;
my $cgi = new CGI;
my $val = $cgi->param('test');

print $cgi->header();
print <<EOF;
<html>
<head>
<title>Hello there.</title>
</head>
<body>
<p>Your results are:</p>
<p>$val</>
</body>
</html>
EOF
