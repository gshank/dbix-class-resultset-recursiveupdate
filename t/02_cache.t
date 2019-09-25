use strict;
use warnings;
use Test::More;
use Test::DBIC::ExpectedQueries;
use DBIx::Class::ResultSet::RecursiveUpdate;

use lib 't/lib';
use DBSchema;

my $schema = DBSchema->get_test_schema();
my $queries = Test::DBIC::ExpectedQueries->new({ schema => $schema });

my $rs_users = $schema->resultset('User');

my $user = $rs_users->create({
  name       => 'cache name',
  username   => 'cache username',
  password   => 'cache username',
});

$schema->resultset('Dvd')->create({
    name => 'existing DVD',
    owner => $user->id,
    dvdtags => [{
        tag => 1,
    },
    {
        tag => {
            name => 'crime'
        },
    }],
});

my $rs_users_without_cache = $rs_users->search_rs({
    'me.id' => $user->id
});
$queries->run(sub {
    $rs_users_without_cache->recursive_update({
        id => $user->id,
        name => 'updated name',
    });
});
$queries->test({
    usr => {
        select => 2,
        update => 1,
    },
});


my $rs_users_with_cache = $rs_users->search_rs({
    'me.id' => $user->id
}, {
    cache => 1,
});
# populate cache
$rs_users_with_cache->all;

$queries->run(sub {
    $rs_users_with_cache->recursive_update({
        id => $user->id,
        name => 'updated name 2',
    });
});
$queries->test({
    usr => {
        select => 1,
        update => 1,
    },
});

done_testing;
