use IPC::Cmd qw(can_run run);
use Test::More tests => 1;

ok can_run('tiffcp'), 'tiffcp';
