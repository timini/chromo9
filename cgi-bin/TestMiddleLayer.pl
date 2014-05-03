#!/usr/bin/perl
use CGI;
use MiddleLayer;
use strict;
use warnings;

#my $res = getGenes();
#my $res = ReadListByID(36147);
#my $res = ReadListByN("inter");
#my $res = ReadListByACC("X67309");
#my $res = ReadListByLOC("AL162253");
#my $res = ReadNucleotides("24527508");
my $res = ReadProteins("24527508");
#my $res = ReadExons("28579");


print "Content-type: text/html\n\n";
print "<html>\n";
print "<head><link rel='stylesheet' type='text/css' href='home2.css'/></head>\n";
print "<title> PERL CGI</title>\n";
print "<body>";
#print "hello hakim ",@{$res};
print "<table>";
my $i = 0;
#foreach my $r (@{$res}){
#	print "<tr>";
#	print "<td>",++$i,"</td>";
#	foreach my $c (@{$r}) {
#		print "<td>",$c,"</td>";
#	}
#	print "</tr>";	
#}

#my $dna = ReadNucleotides("24527508");
#foreach my $r (@{$dna}){
#	print "<tr>";
#	my ($nuc) = @{$r};
#	print "<td><pre>",$nuc,"</pre></td>";
#	print "</tr>";	
#	print "<tr>";
#	my ($protein) = TranslateDNA($nuc,".");
#	print "<td><pre>",$protein,"</pre></td>";
#	print "</tr>";	
#}

#my $dna = ReadNucleotides("338858094");
#my $exons = ReadExons("338858094");
#@$exons = sort { $b->[1] <=> $a->[1] || $b->[2] <=> $a->[2] } @$exons;
#foreach my $r (@{$exons}){
#	my ($xid, $xstart, $xend) = @{$r};
#	print "<tr>";
#	print "<td>$xstart</td><td>$xend</td>";
#	print "</tr>";	
#}

#my $invalidGenes = ReadGenesWithProblemExons();
#foreach my $r (@{$invalidGenes}){
#	my ($gid) = @{$r};
#	print "<tr>";
#	print "<td>$gid</td>";
#	print "</tr>";	
#}

#my $exons = ReadExons("338858094");
#@$exons = sort { $b->[1] <=> $a->[1] || $b->[2] <=> $a->[2] } @$exons;
#foreach my $r (@{$exons}){
#	my ($xid, $xstart, $xend) = @{$r};
#	my $mult = ($xend-$xstart+1) %3 ;
#	print "<tr><td>$xstart,$xend ($mult)</td></tr>";
#}
#
#print "</table>";
#
#print "<div class=\"sequence\">";
#    print "<div class=\"sequence\" style=\"border : solid 2px #ff0000; padding : 4px; width : 900px; height : 150px; overflow-x : auto; \">";
#	print "<table>";
#	my $dna = ReadNucleotides("338858094");
#	foreach my $r (@{$dna}){
#		my ($dna) = @{$r};
#		print "<tr><td><pre>",Ruler($dna),"</pre></td></tr>";
#		print "<tr><td><pre>",$dna,"</pre></td></tr>";
#		my $replaced = RemoveExons($dna,$exons);
#		$replaced =~ tr/ACGT./....E/;
#		print "<tr><td><pre>",$replaced,"</pre></td></tr>";
#	}
#	print "</table>";
#    print "</div>";
#print "</div>";

my $id = "338858094";
my $dna = GetNucleotides($id);
my $exons = ExtractExons($dna,GetExons($id));
my $trans = TranslateExons($exons);
my $rule  = Ruler($exons);
my ($cut, $cutName) = CuttingSites($dna,ReadStickyEnds());
print "<tr><td><pre>",$cutName,"</pre></td></tr>";
print "<tr><td><pre>",$cut,"</pre></td></tr>";
print "<tr><td><pre>",$dna,"</pre></td></tr>";
print "<tr><td><pre>...&#x259F&#x2599&#x2584&#x2584&#x2584.&#x230A...&#x259F&#x2599....&#x230A...&#x259F&#x2599....&#x230A...&#x259F&#x2599....&#x230A...&#x21B0&#x21B1....&#x230A...&#x21B0&#x21B1....</pre></td></tr>";
print "<tr><td><pre>",$rule,"</pre></td></tr>";
print "<tr><td><pre>",$exons,"</pre></td></tr>";
print "<tr><td><pre>",$trans,"</pre></td></tr>";
print "</table>";

print "</body>";
print "</html>\n";

my $cgi = new CGI;
my $cmd = $cgi->url_param('cmd');

if ($cmd eq "search") {
	Search();
} elsif ($cmd eq "summary") {
	# Summary();
} elsif ($cmd eq "details") {
	# Details();
}

sub GetNucleotides
{
	my $id = $_[0];
	my $dna = ReadNucleotides($id);
	foreach my $row (@{$dna}){
		my ($seq) = @{$row};
		return $seq;
	} 
}

sub GetExons
{
	my $id = $_[0];
	my $exons = ReadExons($id);
	@$exons = sort {$b->[1] <=> $a->[1] || $b->[2] <=> $a->[2] } @$exons;
	return $exons;
}


sub Search
{
	my $searchString = $cgi->param('search');
	my $searchOption = $cgi->param('type');
	
	if ($searchOption eq "ID") {
		# SearchID($searchString, $searchOption);
	} elsif ($searchOption eq "N") {
		# SearchN($searchString, $searchOption);
	} elsif ($searchOption eq "ACC") {
		# SearchACC($searchString, $searchOption);
	} elsif ($searchOption eq "LOC") {
		# SearchLOC($searchString, $searchOption);
	}
}

