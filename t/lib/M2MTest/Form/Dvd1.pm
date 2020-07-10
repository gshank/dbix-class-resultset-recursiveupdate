package M2MTest::Form::Dvd1;

use HTML::FormHandler::Moose;
extends 'HTML::FormHandler';
with 'HTML::FormHandler::TraitFor::Model::DBIC';

sub abstract { "HFH with DBIC containing many_to_many. tags => [ids]" }

has_field name => (
    type     => "Text",
    required => 1,
);

has_field tags => (
    type     => "Multiple",
    widget   => 'CheckboxGroup',
);

# before update_model => sub {
#     my $self = shift;
#     use YAML::Syck;
#     warn Dump $self->values;
#     # ---
#     # name: name1
#     # tags:
#     #   - 1
#     #   - 2
#     #   - 3
# };

1;
