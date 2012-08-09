package XLIFF::Object::TransUnit;

use Moose;

with qw( XLIFF::Object );

use Modern::Perl;
use XML::Simple;

use XLIFF::Object::Tag;

has id => (
    is  => "rw",
    isa => "Num",
);

# "source" should not have default value
# to force user to provide it when initializing
has source => (
    is       => "rw",
    isa      => "XLIFF::Object::Tag",
    required => 1,
);

has target => (
    is       => "rw",
    isa      => "XLIFF::Object::Tag",
    required => 0,
    default  => sub{
        XLIFF::Object::Tag->new(name => "target")
    },
);

has note => (
    is  => "rw",
    isa => "XLIFF::Object::Tag",
    default => sub {
        XLIFF::Object::Tag->new(name => "note")
    },
);

has approved => (
    is      => "rw",
    isa     => "Str",
    default => "no",
);

sub from_xml {
    my ($class, $xml) = @_;

    my $hash = xml_in($xml)->{"trans-unit"}->[0];

    die "not a <trans-unit></trans-unit> tag" unless $hash;

    $class->from_perl( "trans-unit" => $hash );
}

sub from_perl {
    my ($class, $name, $hash) = @_;

    $hash->{$_} = XLIFF::Object::Tag->from_perl($_ => $hash->{$_}) for (qw(source target note));

    $class->new(%$hash);
}

sub to_xml {
    my ($self, ) = @_;
    xml_out({ $self->to_perl });
}

sub to_perl {
    my ($self, ) = @_;
    return (
        "trans-unit" => {
            id       => $self->id,
            approved => $self->approved,
            $self->source->to_perl,
            $self->target->to_perl,
            $self->note->to_perl,
        }
    );
}

sub from_kv {
    my ($class, $source, $target) = @_;
    $class->from_perl(
        "trans-unit" => {
            source => { content => $source },
            target => { content => $target },
        }
    );
}

__PACKAGE__->meta->make_immutable;
no Moose;

1;

=pod

=head1 NAME

XLIFF::Object::TransUnit - trans-unit segment in XLIFF

=head1 INTERFACE

=head2 new(%options)

Constructor. Available attributes are id(Num), source(HashRef), target(HashRef), note(HashRef), approved(Str).

=head2 from_xml($xml_string)

Class method. Parsed with XML

=head2 to_xml()

Instance method. Generate XML from attributes.

=cut
