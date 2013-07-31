package AnotherTestDB::Accessor::Schema::Result::RelatedItem;

use strict;
use warnings;
use base 'DBIx::Class';

__PACKAGE__->load_components("Core");
__PACKAGE__->table("relateditem");
__PACKAGE__->add_columns(
		"col_idcol",
		{ data_type => "INTEGER", is_auto_increment => 1,
		is_nullable => 0, accessor => "idcol" },
		"col_item_id",
		{
		data_type => "integer",
		is_foreign_key => 1,
		is_nullable => 0,
		accessor => "item_id",
		},
		"col_with_acc1",
		{
		data_type => "integer",
		is_nullable => 1,
		accessor => "with_acc1",
		},

		);


__PACKAGE__->belongs_to(
		'item',
		'AnotherTestDB::Accessor::Schema::Result::Item',
		{ col_idcol => 'col_item_id'},
		);

__PACKAGE__->has_many(
		"conditionitems",
		"AnotherTestDB::Accessor::Schema::Result::ConditionItem",
		{ "foreign.col_rel_item_id" => "self.col_idcol" },
		{ cascade_copy => 0, cascade_delete => 0 },
		);


__PACKAGE__->set_primary_key("col_idcol");

1;

