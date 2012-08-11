package XLIFF::Object::Body;

use Moose;

extends qw( XLIFF::Object );
with qw( XLIFF::Module );

use Modern::Perl;

use XML::Simple;

use XLIFF::Object::TransUnit;

has trans_unit => (
    is      => "rw",
    isa     => "ArrayRef[XLIFF::Object::TransUnit]",
    default => sub {
        []
    },
    traits  => ['Array'],
    handles => {
        get     => "get",
        map     => "map",
        sort    => "sort_in_place",
        pop     => "pop",
        push    => "push",
        shift   => "shift",
        unshift => "unshift",
        first   => "first",
        count   => "count",
    },
);

sub to_xml {
    my ($self, ) = @_;
    xml_out({ $self->to_perl });
}

sub from_xml {
    my ($class, $xml) = @_;
    $class->from_perl(%{ xml_in($xml) });
}

sub to_perl {
    my ($self, ) = @_;
    return (
        body => {
            "trans-unit" => [
                $self->map(sub { pop [$_->to_perl] })
            ],
            # $_ is a XLIFF::Object::TransUnit
            # its to_perl() return ( "trans-unit" => { ... } )
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

sub next_id {
    my ($self, ) = @_;
    return 1 unless $self->count;
    $self->sort(
        sub {
            $_[0]->id <=> $_[1]->id
        }
    );
    return 1+$self->get(-1)->id;
}

around push => sub {
    my $orig = shift;
    my $self = shift;

    $_[0]->id($self->next_id) unless $_[0]->id;

    $self->$orig(@_);
};

__PACKAGE__->meta->make_immutable;
no Moose;

1;

=pod

=head1 NAME

XLIFF::Object::Body - body section in XLIFF

=cut
