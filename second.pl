use strict;
use 5.010;
use utf8;

my $fname = 'access.log';
my $typefile = '';

my $fh;
my $exec;

my @items;


if ($typefile eq '') {
	$exec = $fname;
	$typefile = '<';
} elsif ($typefile eq 'bz2') {
	$exec = "bzip2 -d \"${fname}\" --stdout";
	$typefile = '-|';
} elsif ($typefile eq 'gz') {
	$exec = "gzip -d \"${fname}\" --stdout";
	$typefile = '-|';
}



open(my $fh, $typefile, $exec) or die "everything is bad'$fname' $!";
while (my $line = <$fh>)
{
	 if ($line =~ /^(\d+\.\d+\.\d+\.\d+)\s+([^\s])+\s+([^\s]+)\s+\[([^\s\]]+)\s+([^\s\]]+)\]\s+"(?:(GET|HEAD|POST)\s+)?([^"]+)"\s+(\d+)\s+\d+\s+"([^"]+)"\s+"([^"]+)"/) {
            push @items, {
                    "ip" => $1,
                    "blank" => $2,
                    "user" => $3,
                    "datetime" => $4,
                    "timezone" => $5,
                    "method" => $6,
                    "request" => $7,
                    "status" => $8,
                    "referer" => $9,
                    "user-agent" => $10,
		    "record" => $line,
		    "danger" => 0		
                };
        }
}



foreach my $item (@items)
    {
	# first
	if ($$item{'method'} eq "")
	{
		$$item{danger}++
	}

	#second
	if (index($$item{'request'}, "x0") != -1)
	{
		$$item{danger}++
	}

	#third
	if ($$item{status} == 400)
	{
		$$item{danger}++;
	}   
	
	#fourth
	if (index($$item{'user-agent'}, "Python") != -1)
	{
		$$item{danger}++;
	}
	
	#fifth
	if ($$item{'ip'} eq "192.99.119.226")
	{
		$$item{danger}++;
	}
    }

# print "$items[0]{danger} \n";


my $i = 0;
foreach my $j (sort {$b->{danger} <=> $a->{danger}} @items)
{
	print "$$j{danger}, $$j{record} \n";
	$i++;
	if ($i>=50)
	{
		last;
	}
}
