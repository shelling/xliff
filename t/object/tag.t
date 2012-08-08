use Modern::Perl;
use Test::More;
use XLIFF::Object::Tag;

# tests for constructor new()

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

# tests for to_xml()

is (
    $tag->to_xml,
    qq{<source info="zh" xml:lang="en">test content</source>\n},
    "to_xml() ok",
);

# tests for from_xml()

my $from_xml = XLIFF::Object::Tag->from_xml(
    '<target info="info" from="developer">content</target>'
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
    $from_xml->get("from"),
    "developer",
    "from_xml() can set more attr",
);

is (
    $from_xml->content,
    "content",
    "from_xml() can set tag content",
);

# tests for to_perl()

is_deeply (
    {$from_xml->to_perl},
    {
        "target" => {
            content => "content",
            info    => "info",
            from    => "developer",
        }
    },
    "to_perl() can work",
);

# tests for from_perl()

my $from_perl = XLIFF::Object::Tag->from_perl(
    source => {
        "content"  => "source string",
        "xml:lang" => "en",
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
