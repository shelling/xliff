use Modern::Perl;
use Test::More;
use utf8;

use XLIFF::Object::File;

my $file = XLIFF::Object::File->new(
    original          => "index.html",
    datatype          => "plaintext",
    "source-language" => "en",
    "target-language" => "zh",
);

$file->body->push(
    XLIFF::Object::TransUnit->from_perl(
        "trans-unit" => {
            id       => 1,
            approved => "no",
            source   => { content => "exemplary" },
            target   => { content => "模範的" },
        }
    )
);

is_deeply (
    { $file->to_perl },
    {
        file => {
            header            => {},
            body              => { "trans-unit" => [
                {
                    id       => 1,
                    approved => "no",
                    source   => { content => "exemplary" },
                    target   => { content => "模範的" },
                }
            ] },
            original          => "index.html",
            datatype          => "plaintext",
            "source-language" => "en",
            "target-language" => "zh",
        }
    },
    "to_perl() can work",
);

is (
    $file->to_xml,
    q{<file datatype="plaintext" original="index.html" source-language="en" target-language="zh">
  <body>
    <trans-unit approved="no" id="1">
      <source>exemplary</source>
      <target>模範的</target>
    </trans-unit>
  </body>
  <header></header>
</file>
},
    "to_xml() can work",
);

my $from_perl = XLIFF::Object::File->from_perl(
    file => {
        header            => {},
        datatype          => "plaintext",
        original          => "",
        'source-language' => "en",
        'target-language' => "zh",
        body              => {
            'trans-unit' => [
                {
                    id     => 1,
                    source => { content => "hello" },
                    target => { content => "哈囉" },
                }
            ]
        },

    }
);

is (
    $from_perl->datatype,
    "plaintext",
    "from_perl() can set datatype",
);

is_deeply (
    { $from_perl->body->to_perl },
    {
        body => {
            'trans-unit' => [
                {
                    id       => 1,
                    approved => "no",
                    source   => { content => "hello" },
                    target   => { content => "哈囉" }
                }
            ]
        }
    },
    "from_perl() can handle body",
);

my $from_xml = XLIFF::Object::File->from_xml(q{<file datatype="plaintext" original="a.html" source-language="en" target-language="zh">
  <header></header>
  <body>
    <trans-unit id="1">
      <source>astronaut</source>
      <target>太空人</target>
    </trans-unit>
  </body>
</file>
});

is_deeply (
    { $from_xml->to_perl },
    {
        file => {
            "source-language" => "en",
            "target-language" => "zh",
            original          => "a.html",
            datatype          => "plaintext",
            header            => {},
            body              => {
                'trans-unit' => [
                    {
                        id       => 1,
                        approved => "no",
                        source   => { content => 'astronaut' },
                        target   => { content => '太空人' },
                    }
                ]
            }
        }
    },
    "from_xml() can work",
);

done_testing;

1;
