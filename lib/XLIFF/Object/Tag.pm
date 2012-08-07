package XLIFF::Object::Tag;

use Moose;

use XML::Simple;

around BUILDARGS => sub {
    my $orig = shift;
    my $self = shift;

    my %args = @_;
    my ($name, $content) = delete @args{qw(name content)};

    $self->$orig(
        name    => $name,
        content => $content,
        attr    => {%args},
    );
};

has name => (
    is  => "rw",
    isa => "Str",
);

has attr => (
    is      => "rw",
    isa     => "HashRef",
    traits  => ['Hash'],
    handles => {
        set     => 'set',
        get     => 'get',
    },
);

has content => (
    is  => "rw",
);

sub to_xml {
    my ($self, ) = @_;
    return unless $self->content;
    return XMLout({
        %{$self->attr},
        content => $self->content,
    }, RootName => $self->name);
}

sub from_xml {
    my ($class, $xml) = @_;
    my ($name, $hash) = %{XMLin(
        $xml,
        ForceContent => 1,
        KeepRoot     => 1,
    )};
    $class->new(
        name => $name,
        %{$hash},
    );
}

sub to_perl {
    my ($self, ) = @_;
    return unless $self->content;
    return (
        $self->name => {
            content => $self->content,
            %{$self->attr},
        }
    );
}

sub from_perl {
    my ($class, $name, $hash) = @_;
    $class->new(
        name => $name,
        %{$hash},
    );
}

__PACKAGE__->meta->make_immutable;
no Moose;

1;

=pod

=head1 NAME

XLIFF::Object::Tag - 

=head1 SYNOPSIS



=head1 DESCRIPTION

This class define the conversion from xml and representation of a xml tag in XLIFF.
Consider a xml fragment as following.

    <tagname attr1="attr1" attr2="attr2">
        content string
    </tagname>

Invoking from_xml() would internally convert it as the perl data structure as following.

    tagname => {
        attr1   => "attr1",
        attr2   => "attr2",
        content => "content string",
    }

Then the you can retrive attributes.

    $tag->name            #=> "tagename"
    $tag->get('attr1')    #=> "attr1"
    $tag->get('attr2')    #=> "attr2"
    $tag->content         #=> "content string"

Using to_xml() to generate the same xml fragment

    my $tag = XLIFF::Object::Tag->new(
        name    => "tagname",
        content => "content string",
        attr1   => "attr1",
        attr2   => "attr2",
    );

    $tag->to_xml;

=cut
