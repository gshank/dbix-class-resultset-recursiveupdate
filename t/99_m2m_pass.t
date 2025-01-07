use strict;
use warnings;
use Test::More;
use Test::Exception;
use lib qw(t/lib);
use M2MTest;

for (1..4) {
    my $schema_class = "M2MTest::Schema$_" ;
    my $schema       = M2MTest->init_schema( schema_class => $schema_class );
    my $rs           = $schema->resultset('Dvd');

    my $item;
    lives_and {
        $item = DBIx::Class::ResultSet::RecursiveUpdate::Functions::recursive_update(
            resultset => $rs,
            updates   => {
                name => 'name',
                tags => [
                    { name => 'tag1_name' },
                ],
            },
        );
        is $rs->count, 1;
        is $rs->first->tags->count, 1;
    } "$schema_class(@{[ $schema_class->abstract ]}) many_to_many create";

    lives_and {
        DBIx::Class::ResultSet::RecursiveUpdate::Functions::recursive_update(
            resultset => $rs,
            object    => $item,
            updates   => {
                name => 'name',
                tags => [
                    $item->tags->first->id,
                ],
            },
        );
        is $rs->count, 1;
        is $rs->first->tags->count, 1;
    } "$schema_class(@{[ $schema_class->abstract ]}) many_to_many update (tags => [ids])";

    lives_and {
        DBIx::Class::ResultSet::RecursiveUpdate::Functions::recursive_update(
            resultset => $rs,
            object    => $item,
            updates   => {
                name => 'name',
                tags => [
                    { id => $item->tags->first->id },
                ],
            },
        );
        is $rs->count, 1;
        is $rs->first->tags->count, 1;
    } "$schema_class(@{[ $schema_class->abstract ]}) many_to_many update (tags => [hashrefs])";
}

done_testing();
