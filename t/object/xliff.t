use Modern::Perl;
use Test::More;
use utf8;

use XLIFF::Object::XLIFF;

my $from_perl = XLIFF::Object::XLIFF->from_perl(
    xliff => {
        version => "1.0",
        file    => {
            'source-language' => "en",
            'target-language' => "zh",
            original          => "a.html",
            datatype          => "plaintext",
            header => {},
            body   => {
                'trans-unit' => [
                    {
                        id     => 1,
                        source => { content => "articulate" },
                        target => { content => "發音清晰" },
                    }
                ]
            }
        }
    }
);

is_deeply (
    { $from_perl->to_perl },
    {
        xliff => {
            version => "1.0",
            file    => {
                'source-language' => "en",
                'target-language' => "zh",
                original          => "a.html",
                datatype          => "plaintext",
                header => {},
                body   => {
                    'trans-unit' => [
                        {
                            id       => 1,
                            approved => "no",
                            source   => { content => "articulate" },
                            target   => { content => "發音清晰" },
                        },
                    ]
                },
            }
        }
    },
    "from_perl() can work",
);

my $from_xml = XLIFF::Object::XLIFF->from_xml(q{<xliff version="1.0">
  <file datatype="plaintext" original="foo.html" source-language="en" target-language="zh">
    <header></header>
    <body>
      <trans-unit id="1" approved="yes">
        <source>assimilate</source>
        <target>消化</target>
      </trans-unit>
    </body>
  </file>
</xliff>
});

is_deeply (
    { $from_xml->to_perl },
    {
        xliff => {
            version => "1.0",
            file => {
                original => "foo.html",
                datatype => "plaintext",
                'source-language' => "en",
                'target-language' => "zh",
                header  => {},
                body    => {
                    'trans-unit' => [
                        {
                            id       => 1,
                            approved => "yes",
                            source   => { content => "assimilate" },
                            target   => { content => "消化" },
                        }
                    ],
                },
            }
        }
    },
    "from_xml() can work",
);

done_testing;
