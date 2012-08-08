package XLIFF::Object::Body;

use Moose;

use Modern::Perl;

use XML::Simple;

use XLIFF::Object::TransUnit;

has trans_unit => (
    is      => "rw",
    isa     => "ArrayRef[XLIFF::Object::TransUnit]",
    traits  => ['Array'],
    handles => {
        map     => "map",
        sort    => "sort",
        pop     => "pop",
        push    => "push",
        shift   => "shift",
        unshift => "unshift",
        first   => "first",
    },
);

sub to_xml {
    my ($self, ) = @_;
    XMLout(
        { $self->to_perl },
        KeepRoot   => 1,
        KeyAttr    => [],
        ContentKey => 'content',
    );
}

sub from_xml {
    my ($class, $xml) = @_;
    my $hash = XMLin(
        $xml,
        ForceContent => 1,
        KeepRoot     => 1,
        KeyAttr      => [],
        ForceArray   => ['trans-unit'],
    );
}

sub to_perl {
    my ($self, ) = @_;
    my %content = $self->map(sub { $_->to_perl });
    # $_ is a XLIFF::Object::TransUnit
    # its to_perl() return ( "trans-unit" => { ... } )
    return (
        body => {
            "trans-unit" => [
                values(%content)
            ]
        }
    );
}

sub from_perl {
    my ($class, $name, $hash) = @_;

    my $self = $class->new;

    for (@{$hash->{"trans-unit"}}) {
        $self->push(
            XLIFF::Object::TransUnit->from_perl("trans-unit" => $_)
        );
    }

    $self;
}

__PACKAGE__->meta->make_immutable;
no Moose;

1;

=pod

=head1 NAME

XLIFF::Object::Body - body section in XLIFF

=cut
