package M2MTest::Schema3;

use base 'DBIx::Class::Schema';

sub abstract { "rel_name != pk naming" }

__PACKAGE__->load_namespaces( default_resultset_class => '+DBIx::Class::ResultSet::RecursiveUpdate' );

1;
