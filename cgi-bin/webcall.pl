#!/usr/bin/perl
use CGI;
use strict;
use warnings;

my $search = "";
my $summary = "";

my $cgi = new CGI;
my $cmd = $cgi->url_param('cmd');

if ($cmd eq "search") {
Search();
} elsif ($cmd eq "summary") {
Summary();
} elsif ($cmd eq "details") {
Details();
}


sub FakeList
{
my $table = "<div id='table'>";
for (my $count = 10; $count >= 1; $count--) {
 	$table .= "<p><div class='row'><a href='http://student.cryst.bbk.ac.uk/cgi-bin/cgiwrap/gseed01/webcall.pl?cmd=details&id=AB98989'>Gene Name: AB98989</a>, gene ID, more details, etc, </div></p>";
	}
$table .= "</div>";
return $table;
} 

sub Details
{
my $id = $cgi->param('id');

print $cgi->header();
print <<EOF;
<html>
<head>
<link rel='stylesheet' type='text/css' href='http://student.cryst.bbk.ac.uk/~gseed01/web/home.css'/>
</head>
<body>
<div id="container"></div>
<div id="Header">
	<HeaderText>Chromosome Explorer</HeaderText>
</div>
<div id="LeftTab">
	<p><a href="http://student.cryst.bbk.ac.uk/~gseed01/web/index.html">Return to home page?</a></p>
</div>
<p>You successfully looked for gene $id</p>
</body>
</html>
EOF
}


sub Search
{
my $searchString = $cgi->param('search');
my $searchOption = $cgi->param('type');
my $results = FakeList();

print $cgi->header();
print <<EOF;
<html>
<head>
<link rel='stylesheet' type='text/css' href='http://student.cryst.bbk.ac.uk/~gseed01/web/home.css'/>
</head>
<body>
<div id="container"></div>
<div id="Header">
	<HeaderText>Chromosome Explorer</HeaderText>
</div>
<div id="LeftTab">
	<p><a href="http://student.cryst.bbk.ac.uk/~gseed01/web/index.html">Return to home page?</a></p>
</div>
<p>Here is a list of genes generated using your search term ($searchString).</p>
<p>This search looked through $searchOption.</p>
<fieldset>
<p>$results</p>
</fieldset>
</body>
</html>
EOF
}

sub Summary
{
my $request = $cgi->url_param('summary');

print $cgi->header();
print <<EOF;
<html>
<head>
<link rel='stylesheet' type='text/css' href='http://student.cryst.bbk.ac.uk/~gseed01/web/home.css'/>
</head>
<body>
<div id="container"></div>
<div id="Header">
	<HeaderText>Chromosome Explorer</HeaderText>
</div>
<div id="LeftTab">
	<p><a href="http://student.cryst.bbk.ac.uk/~gseed01/web/index.html">Return to home page?</a></p>
</div>
<fieldset>
<p>The Command is: $cmd</p>
<p>$summary</p>
</fieldset>
</body>
</html>
EOF
}




