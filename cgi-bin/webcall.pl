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

#-------------------------------


sub FakeList
{
my $table = "<div id='table'>";
for (my $count = 10; $count >= 1; $count--) {
 	$table .= "<p><div class='row'><a href='http://student.cryst.bbk.ac.uk/cgi-bin/cgiwrap/gseed01/webcall.pl?cmd=details&id=AB98989'>Gene Name: AB98989</a>, gene ID, more details, etc, </div></p>";
	}
$table .= "</div>";
return $table;
} 

sub List
{
my %genes;
open my $file, '<', 'dummy.csv' or die "Cannot open: $!";
while (my $line = <$file>) {
  $line =~ s/\s*\z//;
  my @array = split /,/, $line;
  my $integer = shift @array;
  my $key = shift @array;
  $genes{$key} = \@array;
	}
close $file;
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
}

#-------------------------------
 
sub Search
{
	my $searchString = $cgi->param('search');
	my $searchOption = $cgi->param('type');
	if ($searchOption eq "ID") {
		SearchByID();
	} elsif ($searchOption eq "N") {
		SearchByN();
	} elsif ($searchOption eq "ACC") {
		SearchByACC();
	} elsif ($searchOption eq "LOC") {
		SearchByLOC();
	}
}

sub SearchByID
{
#my $results = IDSearch();
my $results = Fakelist();

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
	<p>Gene ID search:</p>
	<fieldset>
		<p>$results</p>
	</fieldset>
</section>
</body>
</html>
EOF
}

sub SearchByN
{
#my $results = NSearch();
my $results = Fakelist();

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
	<p>Gene Name search:</p>
	<fieldset>
		<p>$results</p>
	</fieldset>
</section>
</body>
</html>
EOF
}

sub SearchByACC
{
#my $results = ACCSearch();
my $results = Fakelist();

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
	<p>Accession number search:</p>
	<fieldset>
		<p>$results</p>
	</fieldset>
</section>
</body>
</html>
EOF
}

sub SearchByLOC
{
#my $results = LOCSearch();
my $results = Fakelist();

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
	<p>Gene Locus search:</p>
	<fieldset>
		<p>$results</p>
	</fieldset>
</section>
</body>
</html>
EOF
}


------

sub Summary
{
my $request = $cgi->url_param('cmd');
my $results = List();

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


------

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
