package MiddleLayer_test;
use strict;
use warnings;

sub Dummy
{
my %genes;
open my $file,'<','dummy.csv' or die "Cannot open: $!";
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


1;