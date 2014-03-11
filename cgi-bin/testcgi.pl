#!/usr/bin/perl
use CGI;
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
<p>Your name is</p>
<p>$val</>
</body>
</html>
EOF
