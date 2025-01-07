package M2MTest::Schema1::Result::Dvdtag;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("PK::Auto", "Core");
__PACKAGE__->table("dvdtag");
__PACKAGE__->add_columns(
    "dvd" => { data_type => 'integer' },
    "tag" => { data_type => 'integer' },
);
__PACKAGE__->set_primary_key("dvd", "tag");
__PACKAGE__->belongs_to("dvd", "M2MTest::Schema1::Result::Dvd", { dvd_id => "dvd" });
__PACKAGE__->belongs_to("tag", "M2MTest::Schema1::Result::Tag", { id => "tag" });

1;

