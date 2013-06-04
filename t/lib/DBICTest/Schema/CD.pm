package # hide from PAUSE 
    DBICTest::Schema::CD;

use base 'DBIx::Class::Core';

__PACKAGE__->table('cd');
__PACKAGE__->add_columns(
  'cdid' => {
    data_type => 'integer',
    is_auto_increment => 1,
  },
  'artist' => {
    data_type => 'integer',
  },
  'title' => {
    data_type => 'varchar',
    size      => 100,
  },
  'year' => {
    data_type => 'varchar',
    size      => 100,
  },
  'genreid' => { 
    data_type => 'integer',
    is_nullable => 1,
  },
  'single_track' => {
    data_type => 'integer',
    is_nullable => 1,
    is_foreign_key => 1,
  }
);
__PACKAGE__->set_primary_key('cdid');
__PACKAGE__->add_unique_constraint([ qw/artist title/ ]);

__PACKAGE__->belongs_to( artist => 'DBICTest::Schema::Artist',
    {artistid => "artist"}, {
    is_deferrable => 1,
    accessor => "single",
});

# in case this is a single-cd it promotes a track from another cd
__PACKAGE__->belongs_to( single_track_row => 'DBICTest::Schema::Track', {'foreign.trackid'=>'self.single_track'} );

__PACKAGE__->has_many( tracks => 'DBICTest::Schema::Track' );
__PACKAGE__->has_many(
    tags => 'DBICTest::Schema::Tag', undef,
    { order_by => 'tag' },
);
__PACKAGE__->has_many(
    cd_to_producer => 'DBICTest::Schema::CD_to_Producer' => 'cd'
);

__PACKAGE__->might_have(
    liner_notes => 'DBICTest::Schema::LinerNotes', undef,
    { proxy => [ qw/notes/ ] },
);
__PACKAGE__->might_have(artwork => 'DBICTest::Schema::Artwork', 'cd_id');

__PACKAGE__->many_to_many( producers => cd_to_producer => 'producer' );
__PACKAGE__->many_to_many(
    producers_sorted => cd_to_producer => 'producer',
    { order_by => 'producer.name' },
);

__PACKAGE__->belongs_to('genre', 'DBICTest::Schema::Genre',
    { 'foreign.genreid' => 'self.genreid' },
    {
        join_type => 'left',
        on_delete => 'SET NULL',
        on_update => 'CASCADE',

    },
);

#__PACKAGE__->add_relationship('genre', 'DBICTest::Schema::Genre',
#    { 'foreign.genreid' => 'self.genreid' },
#    { 'accessor' => 'single' }
#);

__PACKAGE__->resultset_class( __PACKAGE__ . '::ResultSet');

package DBICTest::Schema::CD::ResultSet;

use base qw( DBIx::Class::ResultSet::RecursiveUpdate );


1;
