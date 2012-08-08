package XLIFF::Object;

use Moose::Role;

use XML::Simple;

sub xml_in {
    my ($xml, ) = @_;
    XMLin(
        $xml,
        ForceContent => 1,
        KeepRoot     => 1,
        KeyAttr      => [],
        ForceArray   => ['trans-unit'],
    );
}

sub xml_out {
    my ($xml, ) = @_;
    XMLout(
        $xml,
        KeepRoot   => 1,
        KeyAttr    => [],
        ContentKey => 'content',
    );
}

no Moose;

1;

=pod

=head1 NAME

XLIFF::Object - base class of XLIFF objects

=cut
