package M2MTest::Schema1::Result::Dvd;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components(qw/Core/);
__PACKAGE__->table('dvd');
__PACKAGE__->add_columns(
  'dvd_id' => {
    data_type => 'integer',
    is_auto_increment => 1
  },
  'name' => {
    data_type => 'varchar',
    size      => 100,
    is_nullable => 1,
  },
);
__PACKAGE__->set_primary_key('dvd_id');
__PACKAGE__->has_many('dvdtags', 'M2MTest::Schema1::Result::Dvdtag', { 'foreign.dvd' => 'self.dvd_id' });
__PACKAGE__->many_to_many('tags', 'dvdtags' => 'tag');

1;
