use strict;
use 5.010;
use utf8;

my $fname = 'access.log';

my @items;


open(my $fh, '<', $fname) or die "everything is bad'$fname' $!";
while (my $line = <$fh>)
{
	 if ($line =~ /^(\d+\.\d+\.\d+\.\d+)\s+([^\s])+\s+([^\s]+)\s+\[([^\s\]]+)\s+([^\s\]]+)\]\s+"(?:(get|head|post)\s+)?([^"]+)"\s+(\d+)\s+\d+\s+"([^"]+)"\s+"([^"]+)"/) {
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
		    "request" => $line,
		    "danger" => 0		
                };
        }
}



foreach my $item (@items)
    {
	if ($$item{'request'} == "91.196.50.33")
	{
		$$item{'danger'} ++	
	}
	#if ($$item{'timezone'} == '+0200')
	#{
	#	print "$$item{'timezone'} \n";
	#}
     
    }

print "$items[0]{danger} \n";


my $i = 0;
foreach my $j (sort {$a->{danger} <=> $b->{danger}} @items)
{
	print "$$j{danger} \n";
	$i++;
	if ($i>=5)
	{
		last;
	}
}
