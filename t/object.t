use Modern::Perl;
use Test::More;
use utf8;

{
    package Foo;
    use Moose;
    extends 'XLIFF::Object';
    with 'XLIFF::Module';

    sub in {
        xml_in(q{
            <file datatype="plaintext">
                <header></header>
                <body>
                    <trans-unit>
                        <source>aspire</source>
                        <target>渴望</target>
                    </trans-unit>
                </body>
            </file>
        });
    }

    sub out {
        xml_out({
            xliff => {
                version => "1.0",
                file => {
                    header => {},
                    body   => {
                        'trans-unit' => [
                            {
                                id => 1,
                                source => { content => "credit card" },
                                target => { content => "信用卡" },
                            }
                        ]
                    },
                }
            }
        });
    }
}

is_deeply (
    Foo->in,
    {
        file => {
            datatype => "plaintext",
            header => {},
            body => {
                'trans-unit' => [
                    {
                        source => { content => "aspire" },
                        target => { content => "渴望" },
                    }
                ]
            }
        }
    },
    "xml_in() can work",
);

is (
    Foo->out,
    q{<xliff version="1.0">
  <file>
    <body>
      <trans-unit id="1">
        <source>credit card</source>
        <target>信用卡</target>
      </trans-unit>
    </body>
    <header></header>
  </file>
</xliff>
},
    "xml_out() can work",
);

done_testing;
