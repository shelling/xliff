use Modern::Perl;
use Test::More;
use utf8;

use XLIFF::Object::Body;

my $body = XLIFF::Object::Body->new;

$body->push(
    XLIFF::Object::TransUnit->from_perl(
        "trans-unit" => {
            id => 1,
            approved => "yes",
            source => { content => "source" },
            target => { content => "target" },
        }
    )
);

$body->push(
    XLIFF::Object::TransUnit->from_perl(
        "trans-unit" => {
            id     => 2,
            source => { content => "source" },
            target => { content => "target" },
        }
    )
);

is_deeply (
    { $body->to_perl },
    {
        body => {
            "trans-unit" => [
                {
                    id       => 1,
                    approved => "yes",
                    source   => { content => "source" },
                    target   => { content => "target" },
                },
                {
                    id       => 2,
                    approved => "no",
                    source   => { content => "source" },
                    target   => { content => "target" },
                }
            ]
        }
    },
    "to_perl() can work",
);

is (
    $body->to_xml,
    q{<body>
  <trans-unit approved="yes" id="1">
    <source>source</source>
    <target>target</target>
  </trans-unit>
  <trans-unit approved="no" id="2">
    <source>source</source>
    <target>target</target>
  </trans-unit>
</body>
},
    "to_xml() can work",
);

my $from_perl = XLIFF::Object::Body->from_perl(
    body => {
        "trans-unit" => [
            {
                id       => 2,
                approved => "no",
                source   => { content =>"English" },
                target   => { content =>"英文" },
            }
        ]
    }
);

is_deeply (
    { $from_perl->shift->to_perl },
    {
        "trans-unit" => {
            id       => 2,
            approved => "no",
            source   => { content =>"English" },
            target   => { content =>"英文" },
        }
    },
    "from_perl() can work",
);

my $from_xml = XLIFF::Object::Body->from_xml(q{<body>
  <trans-unit approved="no" id="3">
    <source>illusion</source>
    <target>錯覺</target>
  </trans-unit>
</body>});

is_deeply (
    { $from_xml->to_perl },
    {
        body => {
            "trans-unit" => [
                {
                    id       => 3,
                    approved => "no",
                    source   => { content => "illusion" },
                    target   => { content => "錯覺" },
                }
            ]
        }
    },
    "from_xml() can work",
);

$from_xml->push(
    XLIFF::Object::TransUnit->from_perl(
        "trans-unit" => {
            id       => 2,
            approved => "no",
            source   => { content => "asssail" },
            target   => { content => "襲擊" },
        }
    )
);

is (
    $from_xml->next_id,
    4,
    "can get next id for trans-unit",
);

is (
    $from_xml->get(-1)->id,
    3,
    "next_id() should sort trans-unit with id",
);

$from_xml->push(
    XLIFF::Object::TransUnit->from_perl(
        "trans-unit" => {
            source => { content => "asseverate" },
            target => { content => "斷言" },
        }
    )
);

is (
    $from_xml->get(-1)->id,
    4,
    "push() can give next id",
);

$from_xml->push(
    XLIFF::Object::TransUnit->from_perl(
        "trans-unit" => {
            source => { content => "artifice" },
            target => { content => "詭計" },
        }
    )
);

is_deeply (
    [ $from_xml->map(sub { $_->id }) ],
    [2, 3, 4, 5],
    "correct id overview",
);

done_testing;
