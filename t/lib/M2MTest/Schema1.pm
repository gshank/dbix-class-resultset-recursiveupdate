package M2MTest::Schema1;

use base 'DBIx::Class::Schema';

sub abstract { "rel_name == pk naming" } # DBSchema::Result::Dvd like

__PACKAGE__->load_namespaces( default_resultset_class => '+DBIx::Class::ResultSet::RecursiveUpdate' );

1;
