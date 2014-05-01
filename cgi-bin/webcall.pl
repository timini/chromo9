#!/usr/bin/perl
use CGI;
use CGI::Carp qw(warningsToBrowser fatalsToBrowser);
use strict;
use warnings;
use MiddleLayer;

#----------------------------------------------
# parameterise URIs to allow local machine development

# -- production server 
#my $cgiHome = "http://student.cryst.bbk.ac.uk/cgi-bin/cgiwrap/gseed01";
#my $webHome = "http://student.cryst.bbk.ac.uk/~gseed01/web";

# -- local test server
my $cgiHome = "http://localhost/cgi-bin/hgeorg02";
my $webHome = "http://localhost";

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
<link rel='stylesheet' type='text/css' href='$webHome/home2.css'/>
</head>
<body>
<container></container>
<header>
	<HeaderText>Chromosome Explorer</HeaderText>
</header>
<nav>
	<p><a href="$webHome/index.html">Return to home page?</a></p>
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
<link rel='stylesheet' type='text/css' href='$webHome/home2.css'/>
</head>
<body>
<container></container>
<header>
	<HeaderText>Chromosome Explorer</HeaderText>
</header>
<nav>
	<p><a href="$webHome/index.html">Return to home page?</a></p>
	<p><a href="#">Chromosome list.</a></p>
</nav>
<section>
	<p>Here is a list of genes generated using your search term ($searchString).</p>
	<p>This search looked through $searchOption.</p>
	<p>$results</p>
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
<link rel='stylesheet' type='text/css' href='$webHome/home2.css'/>
</head>
<body>
<container></container>
<header>
	<HeaderText>Chromosome Explorer</HeaderText>
</header>
<nav>
	<p><a href="$webHome/index.html">Return to home page?</a></p>
	<p><a href="#">Chromosome list.</a></p>
</nav>
<section>
	<p>Here is a list of genes generated using your search term ($searchString).</p>
	<p>This search looked through $searchOption.</p>
	<p>$results</p>
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
<link rel='stylesheet' type='text/css' href='$webHome/home2.css'/>
</head>
<body>
<container></container>
<header>
	<HeaderText>Chromosome Explorer</HeaderText>
</header>
<nav>
	<p><a href="$webHome/index.html">Return to home page?</a></p>
	<p><a href="#">Chromosome list.</a></p>
</nav>
<section>
	<p>Here is a list of genes generated using your search term ($searchString).</p>
	<p>This search looked through $searchOption.</p>
	<p>$results</p>
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
<link rel='stylesheet' type='text/css' href='$webHome/home2.css'/>
</head>
<body>
<container></container>
<header>
	<HeaderText>Chromosome Explorer</HeaderText>
</header>
<nav>
	<p><a href="$webHome/index.html">Return to home page?</a></p>
	<p><a href="#">Chromosome list.</a></p>
</nav>
<section>
	<p>Here is a list of genes generated using your search term ($searchString).</p>
	<p>This search looked through $searchOption.</p>
	<p>$results</p>
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
	<link rel='stylesheet' type='text/css' href='$webHome/home2.css'/>
</head>
<body>
<container></container>
<header>
	<HeaderText>Chromosome Explorer</HeaderText>
</header>
<nav>
	<p><a href="$webHome/index.html">Return to home page?</a></p>
	<p><a href="#">Chromosome list.</a></p>
</nav>
<section>
	<p>The following is a summary of all the genes found in the Chromosome 9 genbank data dump.</p>
</section>

<section>
	$results
</section>
</body>
</html>
EOF
}

#---------------------------------------------

sub RenderTable
{
	my $genes = $_[0];
	my $html = "<table><th>Gene ID</th><th>Name</th><th>Accession Number</th><th>Locus</th>";
	foreach my $row (@{$genes}) {
		my ($ID, $N, $ACC, $LOC) = @{$row};
	 	$html .= "<tr><td><a href='$cgiHome/webcall.pl?cmd=details&id=$ID'>$ID</a></td><td>$N</td><td>$ACC</td><td>$LOC</td></tr>";
	}
	$html .= "</table>";
	
}

sub GeneList
{
	my $genes = ReadGenes();
	my $html = RenderTable($genes);
	return $html;	
}

sub GetListByID
{
	my $searchID = $_[0];
	my $genes = ReadListByID($searchID);
	my $html = RenderTable($genes);
	return $html;	
}

sub GetListByN
{
	my $searchN = $_[0];
	my $genes = ReadListByN($searchN);
	my $html = RenderTable($genes);
	return $html;	
}

sub GetListByACC
{
	my $searchACC = $_[0];
	my $genes = ReadListByACC($searchACC);
	my $html = RenderTable($genes);
	return $html;	
}

sub GetListByLOC
{
	my $searchLOC = $_[0];
	my $genes = ReadListByLOC($searchLOC);
	my $html = RenderTable($genes);
	return $html;	
}