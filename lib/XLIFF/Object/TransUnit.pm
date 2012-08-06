package XLIFF::Object::TransUnit;

use Moose;

use XML::Simple;

has id => (
    is  => "rw",
    isa => "Num",
);

has source => (
    is       => "rw",
    isa      => "HashRef",
    required => 1,
    default  => sub{
        { content => undef }
    },
);

has target => (
    is       => "rw",
    isa      => "HashRef",
    required => 0,
    default  => sub{
        { content => undef }
    },
);

has note => (
    is  => "rw",
    isa => "HashRef",
    default => sub {
        { content => undef }
    },
);

has approved => (
    is      => "rw",
    isa     => "Str",
    default => "no",
);

sub from_xml {
    my ($class, $xml) = @_;
    my $options = XMLin(
        $xml,
        ForceContent => 1,
        KeyAttr      => undef
    );
    $class->new(%$options);
}

sub to_xml {
    my ($self, ) = @_;
    XMLout({
        id       => $self->id,
        source   => $self->source,
        target   => $self->target,
        note     => $self->note,
        approved => $self->approved,
    }, RootName => 'trans-unit' );
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
