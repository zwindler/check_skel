#!/usr/bin/perl
############################################################################
#Skeleton of nagios-like plugin using Perl
################################################################################

### Prerequisites ##############################################################

### Program main part###########################################################
#Nagios constants
my %ERRORS = ('OK', '0',
                'WARNING', '1',
                'CRITICAL', '2',
                'UNKNOWN', '3');

#Initialisation
BEGIN { $ENV{PATH} = '/bin:/usr/bin:/usr/local/bin:/usr/sbin' }
my $ignore_error_output = "2>/dev/null";
my $os = os_uname();

#Getting arguments
my $warn = shift || 100*1024*1024;
my $critical = shift || 200*1024*1024;

#Calling subroutines for real work
my @collected_data = collect_data();
process_data(@collected_data);

#The process should have ended at "print_nagios_output". This is wrong
print "UNKNOWN: There is a problem with the plugin. Exiting.\n";
exit $ERRORS{"UNKNOWN"};

### Subroutines ################################################################

#Usage
sub usage()
{
	print "\ncheck_skel.pl - v 1.0\n\n";
	print "usage:\n";
	exit $exit_codes{'UNKNOWN'}; 
}

#Useful function for OS dependant data collection
sub os_uname
{
	my $uname = ( -e '/usr/bin/uname' ) ? '/usr/bin/uname' : '/bin/uname';
	my $os = (`$uname 2>/dev/null`);
	chomp $os;
	return $os ? $os : undef;
}

#Collect data from monitored system
sub collect_data
{
	my @collected_data;

	if ($os eq "HP-UX")
	{
		#HP-UX specific code
	}
	elsif ($os eq "Linux")
	{
		#Linux specific code
	}
	else
	{
		#Unsupported or unrecognised OS
		print "CRITICAL : OS $os not yet supported or not recognised";
		exit $ERRORS{"CRITICAL"};
	}

	#Use this in case of unknown error in routine (e.g. command not returning expected output)
	#print "UNKNOWN : some generic error message?\n";
	#exit $ERRORS{"UNKNOW"};

	return @collected_data;
}

#Process the collected data, return state and additional useful information
sub process_data
{
	my $state;
	my @collected_data = @_;
	my $output;
	my $perfdata;
	my $print_answer;

	if ($state eq "OK")
	{
		$output = "OK: some message explaining everything is OK with your own variables";
	}
	elsif ($state eq "WARNING")
	{
		$output = "WARNING: some warning message with your own variables";
	}
	else
	{
		$output = "CRITICAL: some critical message with your own variables";
	}
		
	#Add perfdata if it exists
	if ($perfdata)
	{
		$print_answer .=  "| $perfdata";
	}
	$print_answer .=  "\n";	

	print $print_answer;
	exit $ERRORS{$state};
}