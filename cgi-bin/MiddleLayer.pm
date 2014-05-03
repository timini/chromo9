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
   		&AminoAcid
   		&ReadGenes 
   		&ReadListByID 
   		&ReadListByLOC
   		&ReadListByN
   		&ReadListByACC
   		&ReadProteins
   		&ReadExons
   		&ReadNucleotides
   		&ReadStickyEnds
   		&CuttingSites
   		&TranslateDNA
   		&RemoveExons
		&ExtractExons
		&TranslateExons
		&CodonFrequencies
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
	db_name     => "gseed01",
	db_user     => "gseed01",
	db_password => "4ajy5q-si",
	db_host     => "localhost"
);

# -- database to use ---
my %db = %prodDB;
#my %db = %localDB;


# ----------------------------
# Codon translation map for DNA

my (%CodonMap) = (
	# the usual codons
	'TCA'=>'S', #Serine
	'TCC'=>'S', #Serine
	'TCG'=>'S', #Serine
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
	
	# undefined codons
	'XXX'=>'X', #undefined
	'EEE'=>'X', #undefined
	'...'=>'.', #undefined
	
	# incomplete codons
	'A..'=>'X', #incomplete
	'C..'=>'X', #incomplete
	'G..'=>'X', #incomplete
	'T..'=>'X', #incomplete
	'AA.'=>'X', #incomplete
	'AC.'=>'X', #incomplete
	'AG.'=>'X', #incomplete
	'AT.'=>'X', #incomplete
	'CA.'=>'X', #incomplete
	'CC.'=>'X', #incomplete
	'CG.'=>'X', #incomplete
	'CT.'=>'X', #incomplete
	'GA.'=>'X', #incomplete
	'GC.'=>'X', #incomplete
	'GG.'=>'X', #incomplete
	'GT.'=>'X', #incomplete
	'TA.'=>'X', #incomplete
	'TC.'=>'X', #incomplete
	'TG.'=>'X', #incomplete
	'TT.'=>'X', #incomplete
);

# maps a codon to an amino acid based on the table above
sub AminoAcid
{
	return $CodonMap{$_[0]};
}

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
# read the sticky end
# this simulated a database read
# for future refactor into a database
# at the moment it is hard coded
# ideally should be from http://en.wikipedia.org/wiki/List_of_restriction_enzyme_cutting_sites
#
sub ReadStickyEnds
{
	my @stickyEnds = [
		["EcoRI", "GAATTC", 1, "CTTAAG", 5],		
		["BamHI", "GGATCC", 1, "CCTAGG", 5],		
		["BsuMI", "CTCGAG", 1, "GAGCTC", 5],
		["AsiSI","GCGATCGC",5, "CGCTAGCG",4],		
	];
	return @stickyEnds;
}

#---------------------------------------------
# generate a ruler showing cutting sites for dna
# Params: DNA sequence string, array reference to cutting site data
# Returns: two populated strings same length as the DNA, first contains
# markers of where the cut and extent, and the other contains its name
sub CuttingSites
{
	my $dna = $_[0];
	my $sites = $_[1];
	my $result = " " x length($dna);	
	my $annot = " " x length($dna);	
	
	# for each cutting site 
	foreach my $r (@{$sites}){
		# get cutting site data
		my ($name, $codeL, $posL, $codeR, $posR) = @{$r};
		my $cut = "-" x length($codeL);
		substr($cut, $posL-1, 2, "||");
		
		# match all codes and populate
		my @matches;
		while ($dna =~ m/\Q$codeL/g) {  # notice the quote meta
			my $loc = $-[0];
			substr($result, $loc, length($cut), $cut);
			substr($annot,   $loc, length($name), $name);
		}
	}
	return ($result, $annot);	
}

#-----------------------------
# translate a DNA sequence
# if codons are not multiple of 3
# then set remainder to X
#
# Params: DNA sequence string, padding string
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
# returns: array reference to all start/end exons that have a problem
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
# Extract Exon nucleotides with '.' 
# keeping rest as normal
# substitution and translation can be used easily
# on the result
#
sub ExtractExons
{
	my $dna = $_[0];
	my $len = length($dna);
	my $exon_ref = $_[1];

	# prepare empty result
	my $result = '.' x length($dna);

	# sort in reverse order to make life simpler	
	@$exon_ref = sort {$b->[1] <=> $a->[1] || $b->[2] <=> $a->[2] } @$exon_ref;
	
	# for each exon region pipulate its nucleotides 
	foreach my $r (@{$exon_ref}){
		my ($xid, $xstart, $xend) = @{$r};
		if ($xend > $len-1) {
			$xend = $len-1;
		}
		substr($result, $xstart, $xend-$xstart+1, substr($dna, $xstart, $xend-$xstart+1));
	}
	return $result;
}

#--------------------------------------------
# Translate Coding Regions 
# impartial codons will be set to X
#
sub TranslateExons
{
	my $dna = $_[0];
	my $len = length($dna);
	my $result = '.' x length($dna);
	
	# match all exon starts 
    my @matches;
    if (substr($dna,0,1) ne '.') {
    	push @matches, 1;
    }
    while ($dna =~ /\.[ACGT]/g) {
        push @matches, [ $+[0] ];
    }
    
    # for each exon start matched translate until a terminator is reached
	foreach my $m (@matches) {
		my $startLoc = $m->[0];
		my $i = $startLoc-1;	
		my $codon = substr($dna, $i, 3);
		while ($codon ne "..." && length($codon)==3) {
			my $protein = " ".$CodonMap{$codon}." ";
			substr($result, $i, 3, $protein);
			$i += 3;
			$codon = substr($dna, $i, 3);
		}
	}
	
	return $result;
}



#--------------------------------------------
# Calculate Frequencies of Coding Regions 
# returns: hash reference to codon frequencies
sub CodonFrequencies
{
	my $dna = $_[0];
	my $len = length($dna);

	# fill counts of valid codons includind stop codon	
	my %codonUsage;
	while (my ($key, $value) = each %CodonMap )
	{
		if (-1 < index("ACDEFGHIKLMNPQRSTVWY_",$value)) {
			$codonUsage{$key} += 0;
		}
	}
	
	# match all exon starts 
    my @matches;
    if (substr($dna,0,1) ne '.') {
    	push @matches, 1;
    }
    while ($dna =~ /\.[ACGT]/g) {
        push @matches, [ $+[0] ];
    }
    
    # for each matched exon start, count frequency
	foreach my $m (@matches) {
		my $startLoc = $m->[0];
		my $i = $startLoc-1;	
		my $codon = substr($dna, $i, 3);
		while ($codon ne "..." && length($codon)==3) {
			my $protein = $CodonMap{$codon};
			if (-1 < index("ACDEFGHIKLMNPQRSTVWY_",$protein)) {
				$codonUsage{$codon} += 1;
			}

			$i += 3;
			$codon = substr($dna, $i, 3);
		}
	}
	return \%codonUsage;
}


#------------------------------------------
# a numbered string used as a ruler for DNA 
# or protein sequences

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
