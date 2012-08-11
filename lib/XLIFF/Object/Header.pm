package XLIFF::Object::Header;

use Moose;

extends qw( XLIFF::Object );
with qw( XLIFF::Module );

sub to_perl {
    my ($self, ) = @_;
    return (
        header => {
        }
    );
}

sub from_perl {
    my ($class, $hash) = @_;
    $class->new();
}

sub to_xml {
    my ($self, ) = @_;

}

sub from_xml {
    my ($self, ) = @_;

}

__PACKAGE__->meta->make_immutable;
no Moose;

1;

=pod

=head1 NAME

XLIFF::Object::Header - header section in XLIFF

=cut
