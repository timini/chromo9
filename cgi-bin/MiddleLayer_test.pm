package MiddleLayer_test;
use strict;
use warnings;


sub FakeList
{
my $fakeId = $_[0];
my @genes = ReadListByID($fakeId);


my $table = "<div id='table'>";
for (my $count = 10; $count >= 1; $count--) {
 	$table .= "<p><div class='row'><a href='http://student.cryst.bbk.ac.uk/cgi-bin/cgiwrap/gseed01/webcall.pl?cmd=details&id=$genes[$count]'>Gene Name: $genes[$count]</a>, gene ID, more details, etc, </div></p>";
	}
$table .= "</div>";
return $table;
} 



#=========================================
# data calls

sub ReadListByID
{
	my $id = $_[0];
	my @genes;
	for (my $count = 0; $count<=10; $count++) {
		push(@genes, $count.$id."byID");
	}
	return @genes;
}

sub ReadListByN
{
	my $id = $_[0];
	my @genes;
	for (my $count = 0; $count<=10; $count++) {
		push(@genes, $count.$id);
	}
	return @genes;
}

sub ReadListByACC
{
	my $id = $_[0];
	my @genes;
	for (my $count = 0; $count<=10; $count++) {
		push(@genes, $count.$id);
	}
	return @genes;
}

sub ReadListByLOC
{
	my $id = $_[0];
	my @genes;
	for (my $count = 0; $count<=10; $count++) {
		push(@genes, $count.$id);
	}
	return @genes;
}

sub ReadGenes
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
return %genes;
}

sub ReadGenes2
{
my @list;
open my $file, '<', 'genesummary.txt' or die "Cannot open: $!";
while (my $line = <$file>) {
	chomp $line;
	push @list, $line;
	}
close $file;
return @list;

}


1;