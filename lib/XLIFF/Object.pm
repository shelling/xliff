package XLIFF::Object;

use Moose;

with qw( XLIFF::Module );

__PACKAGE__->meta->make_immutable;
no Moose;

1;

=pod

=head1 NAME

XLIFF::Object - base class of XLIFF objects

=cut
