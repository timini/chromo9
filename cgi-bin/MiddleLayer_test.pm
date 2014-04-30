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
my @list;
open my $file, '<', 'genesummary.txt' or die "Cannot open: $!";
while (my $line = <$file>) {
	chomp $line;
	push @list, $line;
	}
close $file;
return @list;
}

sub ReadListByN
{
my $id = $_[0];
my @list;
open my $file, '<', 'genesummary.txt' or die "Cannot open: $!";
while (my $line = <$file>) {
	chomp $line;
	push @list, $line;
	}
close $file;
return @list;
}

sub ReadListByACC
{
my $id = $_[0];
my @list;
open my $file, '<', 'genesummary.txt' or die "Cannot open: $!";
while (my $line = <$file>) {
	chomp $line;
	push @list, $line;
	}
close $file;
return @list;
}

sub ReadListByLOC
{
my $id = $_[0];
my @list;
open my $file, '<', 'genesummary.txt' or die "Cannot open: $!";
while (my $line = <$file>) {
	chomp $line;
	push @list, $line;
	}
close $file;
return @list;
}


sub ReadGenes
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