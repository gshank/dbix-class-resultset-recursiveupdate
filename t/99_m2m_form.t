use strict;
use warnings;
use Test::More;
use Test::Exception;
use lib qw(t/lib);
use M2MTest;
use Module::Runtime qw(require_module);

eval "use HTML::FormHandler::TraitFor::Model::DBIC";
plan skip_all => "HTML::FormHandler::TraitFor::Model::DBIC required for testing"
    if $@;

for (1..4) {
    my $schema_class = "M2MTest::Schema$_" ;
    for (1..2) {
        my $schema = M2MTest->init_schema( schema_class => $schema_class );
        my $form_class = "M2MTest::Form::Dvd$_";
        require_module $form_class;

        lives_and {
            my $form = $form_class->new;

            my $dvd_rs = $schema->resultset('Dvd');
            my $tag_rs = $schema->resultset('Tag');

            is $dvd_rs->count, 0;
            is $tag_rs->count, 0;

            my $item = $dvd_rs->create( { name => "name1" } );
            $item->set_tags(
                [
                    { name => "tag1" },
                    { name => "tag2" },
                    { name => "tag3" },
                ]
            );

            is $dvd_rs->count, 1;
            is $tag_rs->count, 3;
            is $item->tags->count, 3;

            my $params = {
                name => "name1",
                tags => [1,2,3],
            };
            $form->process( item => $item, params => $params );
            ok $form->validated;

            is $dvd_rs->count, 1;
            is $tag_rs->count, 3;
            is $item->tags->count, 3;
        } "$schema_class(@{[ $schema_class->abstract ]}) $form_class(@{[ $form_class->abstract ]})";
    }
}

done_testing();
