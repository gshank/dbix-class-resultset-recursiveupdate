use strict;
use warnings;

use lib 't/lib';
use Test::More;
use Test::Exception;

use_ok 'AnotherTestDB::Accessor::Schema';

my $schema = AnotherTestDB::Accessor::Schema->connect('dbi:SQLite:dbname=:memory:');

isa_ok $schema, 'DBIx::Class::Schema';

lives_ok( sub{
	#$schema->deploy({add_drop_table => 1});
	$schema->deploy();
	$schema->populate('Item', [
		[ qw/col_idcol col_with_acc/ ],
		[ 1,10 ],
	]);
	$schema->populate('RelatedItem', [
		[ qw/col_idcol col_item_id col_with_acc1/ ],
		[ 1, 1, 11 ],
		[ 2, 1, 12 ],
	]);
	$schema->populate('ConditionItem', [
		[ qw/col_idcol col_rel_item_id col_condition/ ],
		[ 1, 1, 'false' ],
		[ 2, 1, 'true' ],
		[ 3, 2, 'true' ],
		[ 4, 2, 'false' ],
	]);
}, 'creating and populating test database'
);

is($schema->resultset('Item')->find(1)->relateditems->count, 2);
is($schema->resultset('Item')->find(1)->true_relateditems->count, 2);

lives_ok(sub{
	$schema->resultset('Item')->recursive_update({
		idcol => 1,
		true_relateditems => [{ idcol => 1}],
	});
});

is($schema->resultset('Item')->find(1)->relateditems->count, 1);
is($schema->resultset('Item')->find(1)->true_relateditems->count, 1);

done_testing;
