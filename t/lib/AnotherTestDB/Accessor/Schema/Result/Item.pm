package AnotherTestDB::Accessor::Schema::Result::Item;

use strict;
use warnings;
use base 'DBIx::Class';

__PACKAGE__->load_components("Core");
__PACKAGE__->table("item");
__PACKAGE__->add_columns(
		"col_idcol",
		{ data_type => "INTEGER", is_auto_increment => 1,
		is_nullable => 0, accessor => "idcol" },
		"col_with_acc",
		{ data_type => "INTEGER", is_nullable => 1, accessor => 'with_acc' },
		);
__PACKAGE__->set_primary_key("col_idcol");


__PACKAGE__->has_many(
		"relateditems",
		"AnotherTestDB::Accessor::Schema::Result::RelatedItem",
		{ "foreign.col_item_id" => "self.col_idcol" },
		{ cascade_copy => 0, cascade_delete => 0 },
		);

__PACKAGE__->has_many(
		"true_relateditems",
		"AnotherTestDB::Accessor::Schema::Result::RelatedItem",
		{ "foreign.col_item_id" => "self.col_idcol" },
		{where => { 'conditionitems.col_condition' => 'true'},
		'join' => qq/conditionitems/,
		 cascade_copy => 0, cascade_delete => 0 },
		);
1;
