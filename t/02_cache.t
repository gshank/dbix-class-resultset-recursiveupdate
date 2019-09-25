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

my $dvd = $schema->resultset('Dvd')->create({
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
        select => 1,
        update => 1,
    },
}, 'expected queries without cache');


my $rs_users_with_cache = $rs_users->search_rs({
    'me.id' => $user->id
}, {
    cache => 1,
});

diag("populate cache");
$rs_users_with_cache->all;

$queries->run(sub {
    $rs_users_with_cache->recursive_update({
        id => $user->id,
        name => 'updated name 2',
    });
});
$queries->test({
    usr => {
        update => 1,
    },
}, 'expected queries with cache');

$rs_users_with_cache = $rs_users->search_rs({
    'me.id' => $user->id
}, {
    prefetch => {
        owned_dvds => {
            'dvdtags' => 'tag'
        }
    },
    cache => 1,
});

diag("populate cache");
$rs_users_with_cache->all;

$queries->run(sub {
    $rs_users_with_cache->recursive_update({
        id => $user->id,
        owned_dvds => [
            {
                dvd_id => $dvd->id,
                name => 'existing DVD',
            },
            {
                name => 'new DVD',
            }
        ]
    });
});
$queries->test({
    dvd => {
        insert => 1,
        # one by 'find by pk' of the existing DVD
        # one by the discard_changes call for created rows
        select => 2,
        # this is the cleanup query which deletes all dvds of the user not
        # passed to owned_dvds even if there aren't any
        delete => 1,
    },
}, 'expected queries with relationships and cache');

done_testing;
