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


sub GeneList
{
	my @genes = MiddleLayer_test::ReadGenes();
	my $html = "<table><th>Gene ID</th><th>Name</th><th>Accession Number</th><th>Locus</th>";
	foreach my $row (@genes) {
		my ($ID, $N, $ACC, $LOC) = split /\|\|/,$row;
	 	$html .= "<tr><td><a href='http://student.cryst.bbk.ac.uk/cgi-bin/cgiwrap/gseed01/webcall.pl?cmd=details&id=$ID'>$ID</a></td><td>$N</td><td>$ACC</td><td>$LOC</td></tr>";
	}
	$html .= "</table>";
	return $html;	
}

sub GetListByID
{
	my $searchString = $_[0];

	my @genes = MiddleLayer_test::ReadListByID();
	my $html = "<table><th>Gene ID</th><th>Name</th><th>Accession Number</th><th>Locus</th>";
	foreach my $row (@genes) {
		my ($ID, $N, $ACC, $LOC) = split /\|\|/,$row;
	 	$html .= "<tr><td><a href='http://student.cryst.bbk.ac.uk/cgi-bin/cgiwrap/gseed01/webcall.pl?cmd=details&id=$ID'>$ID</a></td><td>$N</td><td>$ACC</td><td>$LOC</td></tr>";
	}
	$html .= "</table>";
	return $html;	
}

sub GetListByN
{
	my $searchString = $_[0];

	my @genes = MiddleLayer_test::ReadListByN();
	my $html = "<table><th>Gene ID</th><th>Name</th><th>Accession Number</th><th>Locus</th>";
	foreach my $row (@genes) {
		my ($ID, $N, $ACC, $LOC) = split /\|\|/,$row;
	 	$html .= "<tr><td><a href='http://student.cryst.bbk.ac.uk/cgi-bin/cgiwrap/gseed01/webcall.pl?cmd=details&id=$ID'>$ID</a></td><td>$N</td><td>$ACC</td><td>$LOC</td></tr>";
	}
	$html .= "</table>";
	return $html;	
}

sub GetListByACC
{
	my $searchString = $_[0];

	my @genes = MiddleLayer_test::ReadListByACC();
	my $html = "<table><th>Gene ID</th><th>Name</th><th>Accession Number</th><th>Locus</th>";
	foreach my $row (@genes) {
		my ($ID, $N, $ACC, $LOC) = split /\|\|/,$row;
	 	$html .= "<tr><td><a href='http://student.cryst.bbk.ac.uk/cgi-bin/cgiwrap/gseed01/webcall.pl?cmd=details&id=$ID'>$ID</a></td><td>$N</td><td>$ACC</td><td>$LOC</td></tr>";
	}
	$html .= "</table>";
	return $html;	
}

sub GetListByLOC
{
	my $searchString = $_[0];

	my @genes = MiddleLayer_test::ReadListByLOC();
	my $html = "<table><th>Gene ID</th><th>Name</th><th>Accession Number</th><th>Locus</th>";
	foreach my $row (@genes) {
		my ($ID, $N, $ACC, $LOC) = split /\|\|/,$row;
	 	$html .= "<tr><td><a href='http://student.cryst.bbk.ac.uk/cgi-bin/cgiwrap/gseed01/webcall.pl?cmd=details&id=$ID'>$ID</a></td><td>$N</td><td>$ACC</td><td>$LOC</td></tr>";
	}
	$html .= "</table>";
	return $html;	
}