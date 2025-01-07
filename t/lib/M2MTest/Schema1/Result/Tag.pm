package M2MTest::Schema1::Result::Tag;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("PK::Auto", "Core");
__PACKAGE__->table("tag");
__PACKAGE__->add_columns(
  "id" => {
    data_type => 'integer',
    is_auto_increment => 1
  },
  'name' => {
    data_type => 'varchar',
    size      => 100,
    is_nullable => 1,
  },
  'file' => {
    data_type => 'text',
    is_nullable => 1,
  }
);
    
__PACKAGE__->set_primary_key("id");
__PACKAGE__->has_many("dvdtags", "M2MTest::Schema1::Result::Dvdtag", { "foreign.tag" => "self.id" });
__PACKAGE__->many_to_many('dvds', 'dvdtags' => 'dvd');

1;

