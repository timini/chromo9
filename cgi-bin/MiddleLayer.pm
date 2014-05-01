package MiddleLayer;
use DBI;
use strict;
use warnings;

#----------------------------------
#-- contracts
#
require Exporter;
BEGIN {
   use Exporter   ();
   use vars       qw($VERSION @ISA @EXPORT);
   $VERSION     = 1.00;
   @ISA         = qw(Exporter);
   @EXPORT      = qw(
   		&ReadGenes 
   		&ReadListByID 
   		&ReadListByLOC
   		&ReadListByN
   		&ReadListByACC
   		&ReadProteins
   		&ReadExons
   		&ReadNucleotides
   		&TranslateDNA
   		&RemoveExons
   		&ReadGenesWithProblemExons
   		&Ruler
   	);
}


#-----------------------------------------
# database connection config at the moment hard coded
# with development aspect also hardcoded
# maybe later add IOC (Inversion of Control) if there
# is time
#-

# -- local database for testing ---
my %localDB = ( 
	db_name     => "chromo9",
	db_user     => "gh001",
	db_password => "Hakim",
	db_host     => "localhost"
);

# -- main production db ---
my %prodDB = ( 
	db_name     => "chromo9",
	db_user     => "gseed01",
	db_password => "4ajy5q-si",
	db_host     => "localhost"
);

# -- database to use ---
#my %db = %prodDB;
my %db = %localDB;


# ----------------------------
# Codon translation map for DNA

my (%CodonMap) = (
	'TCA'=>'S', #Serine
	'TCC'=>'S', #Serine
	'TCG'=>'S',  #Serine
	'TCT'=>'S', #Serine
	'TTC'=>'F', #Phenylalanine
	'TTT'=>'F', #Phenylalanine
	'TTA'=>'L', #Leucine
	'TTG'=>'L', #Leucine
	'TAC'=>'Y', #Tyrosine
	'TAT'=>'Y', #Tyrosine
	'TAA'=>'_', #Stop
	'TAG'=>'_', #Stop
	'TGC'=>'C', #Cysteine
	'TGT'=>'C', #Cysteine
	'TGA'=>'_', #Stop
	'TGG'=>'W', #Tryptophan
	'CTA'=>'L', #Leucine
	'CTC'=>'L', #Leucine
	'CTG'=>'L', #Leucine
	'CTT'=>'L', #Leucine
	'CCA'=>'P', #Proline
	'CAT'=>'H', #Histidine
	'CAA'=>'Q', #Glutamine
	'CAG'=>'Q', #Glutamine
	'CGA'=>'R', #Arginine
	'CGC'=>'R', #Arginine
	'CGG'=>'R', #Arginine
	'CGT'=>'R', #Arginine
	'ATA'=>'T', #Isoleucine
	'ATC'=>'T', #Isoleucine
	'ATT'=>'T', #Isoleucine
	'ATG'=>'M', #Methionine
	'ACA'=>'T', #Threonine
	'ACC'=>'T', #Threonine
	'ACG'=>'T', #Threonine
	'ACT'=>'T', #Threonine
	'AAC'=>'N', #Asparagine
	'AAT'=>'N', #Asparagine
	'AAA'=>'K', #Lysine
	'AAG'=>'K', #Lysine
	'AGC'=>'S', #Serine#Valine
	'AGT'=>'S', #Serine
	'AGA'=>'R', #Arginine
	'AGG'=>'R', #Arginine
	'CCC'=>'P', #Proline
	'CCG'=>'P', #Proline
	'CCT'=>'P', #Proline
	'CAC'=>'H', #Histidine
	'GTA'=>'V', #Valine
	'GTC'=>'V', #Valine
	'GTG'=>'V', #Valine
	'GTT'=>'V', #Valine
	'GCA'=>'A', #Alanine
	'GCC'=>'A', #Alanine
	'GCG'=>'A', #Alanine
	'GCT'=>'A', #Alanine
	'GAC'=>'D', #Aspartic Acid
	'GAT'=>'D', #Aspartic Acid
	'GAA'=>'E', #Glutamic Acid
	'GAG'=>'E', #Glutamic Acid
	'GGA'=>'G', #Glycine
	'GGC'=>'G', #Glycine
	'GGG'=>'G', #Glycine
	'GGT'=>'G', #Glycine
	
	'XXX'=>'X', #undefined
	'EEE'=>'X', #undefined
	'...'=>'.', #undefined
);



#-----------------------------
# get  all gene summaries from database
#
sub ReadGenes
{
	my $qSelect = 
	"
	SELECT
		g.gene_identifier, p.name, a.accession_number, g.chromosome_location
	FROM
		genes g, proteins p, accession_numbers a
	WHERE
		(g.gene_identifier=p.gene_id) 
		AND (g.gene_identifier = a.gene_id)
	";

	my $dbh = DBI->connect("DBI:mysql:$db{db_name}:$db{db_host}", $db{db_user}, $db{db_password});
	my $sqlQuery  = $dbh->prepare($qSelect);
	my $rv = $sqlQuery->execute;
	my $ref = $sqlQuery->fetchall_arrayref;
	$dbh->disconnect();
	return $ref;
}


#-----------------------------
# search for proteins by ID
#
sub ReadListByID
{
	my $id = $_[0];
	my $qSelect = 
	"
	SELECT
		g.gene_identifier, p.name, a.accession_number, g.chromosome_location
	FROM
		genes g, proteins p, accession_numbers a
	WHERE
		(g.gene_identifier=p.gene_id) 
		AND (g.gene_identifier = a.gene_id)
		AND (g.gene_identifier = $id)
	";

	my $dbh = DBI->connect("DBI:mysql:$db{db_name}:$db{db_host}", $db{db_user}, $db{db_password});
	my $sqlQuery  = $dbh->prepare($qSelect);
	my $rv = $sqlQuery->execute;
	my $ref = $sqlQuery->fetchall_arrayref;
	$dbh->disconnect();
	return $ref;
}


#-----------------------------
# search for proteins by Name
# using like in select (maybe can also use soundex)
#
sub ReadListByN
{
	my $name = "'%".$_[0]."%'";
	my $qSelect = 
	"
	SELECT
		g.gene_identifier, p.name, a.accession_number, g.chromosome_location
	FROM
		genes g, proteins p, accession_numbers a
	WHERE
		(g.gene_identifier=p.gene_id) 
		AND (g.gene_identifier = a.gene_id)
		AND (p.name like $name)
	";

	my $dbh = DBI->connect("DBI:mysql:$db{db_name}:$db{db_host}", $db{db_user}, $db{db_password});
	my $sqlQuery  = $dbh->prepare($qSelect);
	my $rv = $sqlQuery->execute;
	my $ref = $sqlQuery->fetchall_arrayref;
	$dbh->disconnect();
	return $ref;
}

#-----------------------------
# search for proteins by Accession Number
#
sub ReadListByACC
{
	my $accNum = "'".$_[0]."'";
	my $qSelect = 
	"
	SELECT
		g.gene_identifier, p.name, a.accession_number, g.chromosome_location
	FROM
		genes g, proteins p, accession_numbers a
	WHERE
		(g.gene_identifier=p.gene_id) 
		AND (g.gene_identifier = a.gene_id)
		AND (a.accession_number = $accNum)
	";

	my $dbh = DBI->connect("DBI:mysql:$db{db_name}:$db{db_host}", $db{db_user}, $db{db_password});
	my $sqlQuery  = $dbh->prepare($qSelect);
	my $rv = $sqlQuery->execute;
	my $ref = $sqlQuery->fetchall_arrayref;
	$dbh->disconnect();
	return $ref;
}

#-----------------------------
# search for proteins by Locus
#
sub ReadListByLOC
{
	my $locus = "'".$_[0]."'";
	my $qSelect = 
	"
	SELECT
		g.gene_identifier, p.name, a.accession_number, g.chromosome_location
	FROM
		genes g, proteins p, accession_numbers a
	WHERE
		(g.gene_identifier=p.gene_id) 
		AND (g.gene_identifier = a.gene_id)
		AND (g.chromosome_location = $locus)	
	";

	my $dbh = DBI->connect("DBI:mysql:$db{db_name}:$db{db_host}", $db{db_user}, $db{db_password});
	my $sqlQuery  = $dbh->prepare($qSelect);
	my $rv = $sqlQuery->execute;
	my $ref = $sqlQuery->fetchall_arrayref;
	$dbh->disconnect();
	return $ref;
}


#-----------------------------
# search for proteins by gene identifier
#
sub ReadProteins
{
	my $id = $_[0];
	my $qSelect = 
	"
	SELECT
		p.id, p.name, p.sequence 
	FROM
		genes g, proteins p
	WHERE
		(g.gene_identifier = p.gene_id)
		AND (NOT ISNULL(p.sequence))
		AND (g.gene_identifier = $id)
	";

	my $dbh = DBI->connect("DBI:mysql:$db{db_name}:$db{db_host}", $db{db_user}, $db{db_password});
	my $sqlQuery  = $dbh->prepare($qSelect);
	my $rv = $sqlQuery->execute;
	my $ref = $sqlQuery->fetchall_arrayref;
	$dbh->disconnect();
	return $ref;
}


#-----------------------------
# read the Exon list for a specified gene id
#
sub ReadExons
{
	my $id = $_[0];
	my $qSelect = 
	"
	SELECT
		x.id, x.start, x.end 
	FROM
		genes g, exons x
	WHERE
		(g.gene_identifier = x.gene_id)
		AND (g.gene_identifier = $id)
	ORDER BY
		x.start, x.end
	";

	my $dbh = DBI->connect("DBI:mysql:$db{db_name}:$db{db_host}", $db{db_user}, $db{db_password});
	my $sqlQuery  = $dbh->prepare($qSelect);
	my $rv = $sqlQuery->execute;
	my $ref = $sqlQuery->fetchall_arrayref;
	$dbh->disconnect();
	return $ref;
}

#-----------------------------
# read the nucleotides sequence for a gene id
#
sub ReadNucleotides
{
	my $id = $_[0];
	my $qSelect = 
	"
	SELECT
		g.nucleotide_sequence
	FROM
		genes g
	WHERE
		(g.gene_identifier = $id)
	";

	my $dbh = DBI->connect("DBI:mysql:$db{db_name}:$db{db_host}", $db{db_user}, $db{db_password});
	my $sqlQuery  = $dbh->prepare($qSelect);
	my $rv = $sqlQuery->execute;
	my $ref = $sqlQuery->fetchall_arrayref;
	$dbh->disconnect();
	return $ref;
}

#-----------------------------
# translate a DNA sequence
# if codons are not multiple of 3
# then set remainder to X
#

sub TranslateDNA
{
	my $dna = $_[0];
	my $filler = $_[1];
	my $protein = "";
	my $term = "";
	
	# check if length is multiple of 3
	my $len = length($dna);
	if ($len % 3 > 0) {
		$len -= $len % 3;
		$term = "X".$filler.$filler;
	}
	
	for (my $i=0; $i < $len-2; $i+=3) {
		my $codon = substr($dna, $i, 3);
		$protein .= $CodonMap{$codon}.$filler.$filler;
	}
	return $protein.$term;
}

#------------------------------------------
# some genes have overlapping exon entries in the 
# database, this identifies all of them
#
sub ReadGenesWithProblemExons 
{
	my @invalid = ();
	my $genes = ReadGenes();
	foreach my $g (@{$genes}){
		my $valid = 1;
		my $geneId = $g->[0];
		my $exons = ReadExons($geneId);
		@$exons = sort { $a->[1] <=> $b->[1] } @$exons;
		my ($pStart, $pEnd) = (-1,-1);
		foreach my $r (@{$exons}){
			my ($xid, $xstart, $xend) = @{$r};
			if ($xstart <= $pEnd || $xend <= $pEnd ) {
				$valid = 0;
			}
			($pStart, $pEnd) = ($xstart,$xend);
		}
		if ($valid == 0) {
			my @inv = ();
			push(@inv, $geneId);
			push(@invalid, \@inv);
		}
	}
	return \@invalid;
}

#--------------------------------------------
# replqace Exon nucleotides with '.' 
# keeping rest as normal
# substitution and translation can be used easily
# on the result
#
sub RemoveExons
{
	my $dna = $_[0];
	my $len = length($dna);
	my $exon_ref = $_[1];

	# sort in reverse order to make life simpler	
	@$exon_ref = sort {$b->[1] <=> $a->[1] || $b->[2] <=> $a->[2] } @$exon_ref;
	foreach my $r (@{$exon_ref}){
		my ($xid, $xstart, $xend) = @{$r};
		if ($xend > $len-1) {
			$xend = $len-1;
		}
		my $dots = "." x ($xend-$xstart+1);
		substr($dna, $xstart, $xend-$xstart+1, $dots);
	}
	return $dna;
}

#------------------------------------------
# a numbered string used as a ruler for DNA 
# or protrein sequences

sub Ruler
{
	my $len = length($_[0]);
	my $rem = $len % 10;
	my $dec = ($len-$rem) / 10;
	my $rule = "....:....|" x $dec;
	$rule .= substr("....:....|",0,$rem);
	$rule .= "< $len";
	for (my $i=1; $i < $dec; ++$i) {
		my $n = "".($i*10);
		substr($rule, 10*$i, length($n), $n);
	}
	return $rule;
}

1;