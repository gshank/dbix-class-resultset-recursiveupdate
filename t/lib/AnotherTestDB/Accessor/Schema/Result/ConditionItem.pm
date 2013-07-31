package AnotherTestDB::Accessor::Schema::Result::ConditionItem;

use strict;
use warnings;
use base 'DBIx::Class';

__PACKAGE__->load_components("Core");
__PACKAGE__->table("conditionitem");
__PACKAGE__->add_columns(
		"col_idcol",
		{ data_type => "INTEGER", is_auto_increment => 1,
		is_nullable => 0, accessor => "idcol" },
		"col_condition",
		{ data_type => "TEXT", is_nullable => 0, accessor => "condition" },
		"col_rel_item_id",
		{
		data_type => "integer",
		is_foreign_key => 1,
		is_nullable => 0,
		accessor => "rel_item_id",
		},

		);

__PACKAGE__->belongs_to(
	'related_item',
	'AnotherTestDB::Accessor::Schema::Result::RelatedItem',
	{ col_idcol => 'col_rel_item_id'},
);

__PACKAGE__->set_primary_key("col_idcol");

1;

