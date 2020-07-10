package M2MTest::Schema4::Result::DvdTag;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("PK::Auto", "Core");
__PACKAGE__->table("dvd_tag");
__PACKAGE__->add_columns(
    "dvd_id" => { data_type => 'integer' },
    "tag_id" => { data_type => 'integer' },
);
__PACKAGE__->set_primary_key("dvd_id", "tag_id");
__PACKAGE__->belongs_to("dvd", "M2MTest::Schema4::Result::Dvd", { id => "dvd_id" });
__PACKAGE__->belongs_to("tag", "M2MTest::Schema4::Result::Tag", { id => "tag_id" });

1;


