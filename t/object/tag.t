use Modern::Perl;
use Test::More;
use XLIFF::Object::Tag;

my $tag = XLIFF::Object::Tag->new(
    name       => "source",
    content    => "test content",
    "xml:lang" => "en",
);

$tag->set(info => "zh");

is (
    $tag->get("xml:lang"),
    "en",
    "constructor can set",
);

is (
    $tag->get("info"),
    "zh",
    "set() can set",
);

is (
    $tag->content,
    "test content",
    "can access content",
);

is (
    $tag->to_xml,
    qq{<source info="zh" xml:lang="en">test content</source>\n},
    "to_xml() ok",
);

my $from_xml = XLIFF::Object::Tag->from_xml(
    '<target info="info">content</target>'
);

is (
    $from_xml->name,
    "target",
    "from_xml() can set tag name",
);

is (
    $from_xml->get("info"),
    "info",
    "from_xml() can set attr",
);

is (
    $from_xml->content,
    "content",
    "from_xml() can set tag content",
);

is_deeply (
    $from_xml->to_perl,
    {
        "target" => {
            info    => "info",
            content => "content",
        }
    },
    "to_perl() can work",
);

my $from_perl = XLIFF::Object::Tag->from_perl(
    source => {
        "xml:lang" => "en",
        "content"  => "source string",
    }
);

is (
    $from_perl->name,
    "source",
    "from_perl() can set name",
);

is (
    $from_perl->content,
    "source string",
    "from_perl() can set content",
);

is (
    $from_perl->get("xml:lang"),
    "en",
    "from_perl() can set attr",
);

done_testing;
