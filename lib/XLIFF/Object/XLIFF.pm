package XLIFF::Object::XLIFF;

use Moose;

with qw( XLIFF::Object );

use XLIFF::Object::File;

has version => (
    is  => "rw",
    isa => "Str",
);

has file => (
    is  => "rw",
    isa => "XLIFF::Object::File",
);

sub to_xml {
    my ($self, ) = @_;
    xml_out({ $self->to_perl });
}

sub to_perl {
    my ($self, ) = @_;
    return (
        xliff => {
            version => $self->version,
            $self->file->to_perl,
        }
    );
}

sub from_xml {
    my ($class, $xml) = @_;
    $class->from_perl(%{ xml_in($xml) });
}

sub from_perl {
    my ($class, $name, $hash) = @_;
    $hash->{file} = XLIFF::Object::File->from_perl(file => $hash->{file});
    $class->new(%$hash);
}

__PACKAGE__->meta->make_immutable;
no Moose;

1;
