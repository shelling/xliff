package XLIFF::Object::File;

use Moose;

with qw( XLIFF::Object );

use XLIFF::Object::Header;
use XLIFF::Object::Body;

around BUILDARGS => sub {
    my $orig = shift;
    my $self = shift;
    my %args = @_;

    $args{'source_language'} = delete $args{'source-language'};
    $args{'target_language'} = delete $args{'target-language'};

    $self->$orig(%args);
};

has header => (
    is      => "rw",
    isa     => "XLIFF::Object::Header",
    default => sub {
        XLIFF::Object::Header->new,
    },
);

has body => (
    is  => "rw",
    isa => "XLIFF::Object::Body",
    default => sub {
        XLIFF::Object::Body->new;
    },
);

has original => (
    is  => "rw",
    isa => "Str",
);

has ["source_language", "target_language"] => (
    is  => "rw",
    isa => "Str",
);

has datatype => (
    is  => "rw",
    isa => "Str",
);

sub from_perl {
    my ($class, $name, $hash) = @_;

    $hash->{header} = XLIFF::Object::Header->from_perl( "header" => $hash->{header});
    $hash->{body}   = XLIFF::Object::Body->from_perl( "body" => $hash->{body});

    $class->new(%$hash);
}

sub from_xml {
    my ($class, $xml) = @_;
    $class->from_perl(%{ xml_in($xml) });
}

sub to_perl {
    my ($self, ) = @_;
    return (
        file => {
            original          => $self->original,
            'source-language' => $self->source_language,
            'target-language' => $self->target_language,
            'datatype'        => $self->datatype,
            $self->header->to_perl,
            $self->body->to_perl,
        }
    )
}

sub to_xml {
    my ($self, ) = @_;
    xml_out({ $self->to_perl });
}

__PACKAGE__->meta->make_immutable;
no Moose;

1;


=pod

=head1 NAME

XLIFF::Object::File - file section in XLIFF

=cut
