#!/usr/bin/perl
use CGI;
use strict;
use warnings;
use MiddleLayer_test;

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

#-------------------------------
 
sub Details
{
my $id = $cgi->param('id');

print $cgi->header();
print <<EOF;
<html>
<head>
<link rel='stylesheet' type='text/css' href='http://student.cryst.bbk.ac.uk/~gseed01/web/home2.css'/>
</head>
<body>
<container></container>
<header>
	<HeaderText>Chromosome Explorer</HeaderText>
</header>
<nav>
	<p><a href="http://student.cryst.bbk.ac.uk/~gseed01/web/index.html">Return to home page?</a></p>
	<p><a href="#">Chromosome list.</a></p>
</nav>
<section>
	<p>You successfully looked for gene $id</p>
</section>
</body>
</html>
EOF
}

sub Search
{
	my $searchString = $cgi->param('search');
	my $searchOption = $cgi->param('type');
	if ($searchOption eq "ID") {
		SearchID($searchString, $searchOption);
	} elsif ($searchOption eq "N") {
		SearchN($searchString, $searchOption);
	} elsif ($searchOption eq "ACC") {
		SearchACC($searchString, $searchOption);
	} elsif ($searchOption eq "LOC") {
		SearchLOC($searchString, $searchOption);
	}
}

sub SearchID
{
my $searchString = $_[0];
my $searchOption = $_[1];
my $results = GetListByID($searchString);

print $cgi->header();
print <<EOF;
<html>
<head>
<link rel='stylesheet' type='text/css' href='http://student.cryst.bbk.ac.uk/~gseed01/web/home2.css'/>
</head>
<body>
<container></container>
<header>
	<HeaderText>Chromosome Explorer</HeaderText>
</header>
<nav>
	<p><a href="http://student.cryst.bbk.ac.uk/~gseed01/web/index.html">Return to home page?</a></p>
	<p><a href="#">Chromosome list.</a></p>
</nav>
<section>
	<p>Here is a list of genes generated using your search term ($searchString).</p>
	<p>This search looked through $searchOption.</p>
	<fieldset>
		<p>$results</p>
	</fieldset>
</section>
</body>
</html>
EOF
}

sub SearchN
{
my $searchString = $_[0];
my $searchOption = $_[1];
my $results = GetListByN($searchString);

print $cgi->header();
print <<EOF;
<html>
<head>
<link rel='stylesheet' type='text/css' href='http://student.cryst.bbk.ac.uk/~gseed01/web/home2.css'/>
</head>
<body>
<container></container>
<header>
	<HeaderText>Chromosome Explorer</HeaderText>
</header>
<nav>
	<p><a href="http://student.cryst.bbk.ac.uk/~gseed01/web/index.html">Return to home page?</a></p>
	<p><a href="#">Chromosome list.</a></p>
</nav>
<section>
	<p>Here is a list of genes generated using your search term ($searchString).</p>
	<p>This search looked through $searchOption.</p>
	<fieldset>
		<p>$results</p>
	</fieldset>
</section>
</body>
</html>
EOF
}

sub SearchACC
{
my $searchString = $_[0];
my $searchOption = $_[1];
my $results = GetListByACC($searchString);

print $cgi->header();
print <<EOF;
<html>
<head>
<link rel='stylesheet' type='text/css' href='http://student.cryst.bbk.ac.uk/~gseed01/web/home2.css'/>
</head>
<body>
<container></container>
<header>
	<HeaderText>Chromosome Explorer</HeaderText>
</header>
<nav>
	<p><a href="http://student.cryst.bbk.ac.uk/~gseed01/web/index.html">Return to home page?</a></p>
	<p><a href="#">Chromosome list.</a></p>
</nav>
<section>
	<p>Here is a list of genes generated using your search term ($searchString).</p>
	<p>This search looked through $searchOption.</p>
	<fieldset>
		<p>$results</p>
	</fieldset>
</section>
</body>
</html>
EOF
}

sub SearchLOC
{
my $searchString = $_[0];
my $searchOption = $_[1];
my $results = GetListByLOC($searchString);

print $cgi->header();
print <<EOF;
<html>
<head>
<link rel='stylesheet' type='text/css' href='http://student.cryst.bbk.ac.uk/~gseed01/web/home2.css'/>
</head>
<body>
<container></container>
<header>
	<HeaderText>Chromosome Explorer</HeaderText>
</header>
<nav>
	<p><a href="http://student.cryst.bbk.ac.uk/~gseed01/web/index.html">Return to home page?</a></p>
	<p><a href="#">Chromosome list.</a></p>
</nav>
<section>
	<p>Here is a list of genes generated using your search term ($searchString).</p>
	<p>This search looked through $searchOption.</p>
	<fieldset>
		<p>$results</p>
	</fieldset>
</section>
</body>
</html>
EOF
}

sub Summary
{
my $request = $cgi->url_param('cmd');
my $results = GeneList();

print $cgi->header();
print <<EOF;
<html>
<head>
	<link rel='stylesheet' type='text/css' href='http://student.cryst.bbk.ac.uk/~gseed01/web/home2.css'/>
</head>
<body>
<container></container>
<header>
	<HeaderText>Chromosome Explorer</HeaderText>
</header>
<nav>
	<p><a href="http://student.cryst.bbk.ac.uk/~gseed01/web/index.html">Return to home page?</a></p>
	<p><a href="#">Chromosome list.</a></p>
</nav>
<section>
	<p>The Command is: $request</p>
</section>

<p>$results</p>
</body>
</html>
EOF
}

#---------------------------------------------

sub GeneList
{
my %genes = MiddleLayer_test::ReadGenes();
my $html = "<section>";
	while (my ($key,$val) = each %genes){
		$html .= "<p>";
		$html .= "<a href='#$key'>$key</a>\t\t";
		foreach (@$val) {
			 $html.=  "$_</br>";
		}
		$html .= "</p>";
	}
$html .= </section>;

sub GetListByID
{
	my $searchString = $_[0];

	my @genes = MiddleLayer_test::ReadListByID($searchString);
	
	my $table = "<div id='table'>";
	for (my $count = 10; $count >= 1; $count--) {
	 	$table .= "<p><div class='row'><a href='http://student.cryst.bbk.ac.uk/cgi-bin/cgiwrap/gseed01/webcall.pl?cmd=details&id=$genes[$count]'>Gene Name: $genes[$count]</a>, gene ID, more details, etc, </div></p>";
		}
	$table .= "</div>";
	return $table;
}

sub GetListByN
{
	my $searchString = $_[0];
	return MiddleLayer_test::FakeList($searchString);
}

sub GetListByACC
{
	my $searchString = $_[0];
	return MiddleLayer_test::FakeList($searchString);
}

sub GetListByLOC
{
	my $searchString = $_[0];
	return MiddleLayer_test::FakeList($searchString);
}
}