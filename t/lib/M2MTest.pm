package # hide from PAUSE
    M2MTest;

use strict;
use warnings;
use Module::Runtime qw(require_module);

sub _sqlite_dbfilename {
    return "t/var/DBIxClass.db";
}

sub _sqlite_dbname {
    my $self = shift;
    my %args = @_;
    return $self->_sqlite_dbfilename if $args{sqlite_use_file} or $ENV{"DBICTEST_SQLITE_USE_FILE"};
	return ":memory:";
}

sub _database {
    my $self = shift;
    my %args = @_;
    my $db_file = $self->_sqlite_dbname(%args);

    unlink($db_file) if -e $db_file;
    unlink($db_file . "-journal") if -e $db_file . "-journal";
    mkdir("t/var") unless -d "t/var";

    my $dsn = $ENV{"DBICTEST_DSN"} || "dbi:SQLite:${db_file}";
    my $dbuser = $ENV{"DBICTEST_DBUSER"} || '';
    my $dbpass = $ENV{"DBICTEST_DBPASS"} || '';

    my @connect_info = ($dsn, $dbuser, $dbpass, { AutoCommit => 1 });

    return @connect_info;
}

sub init_schema {
    my $self = shift;
    my %args = @_;

    my $schema;
    $schema = $args{schema_class} || die;
    require_module $schema;
    $schema = $schema->connect($self->_database(%args));
    $schema->deploy;
    return $schema;
}

1;
