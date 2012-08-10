use Modern::Perl;
use Test::More;
use utf8;

{
    package Foo;
    use Moose;
    with 'XLIFF::Object';

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

done_testing;
