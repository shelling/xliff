use Modern::Perl;
use Test::More;
use XLIFF::Object::TransUnit;
use utf8;

my $xml = q{
<trans-unit approved="yes" id="12">
  <note annotates="source" from="developer">Original text was Sorry we couldn't find any results for &lt;strong&gt;[% google_sitesearch.Q %]&lt;/strong&gt;, please try again.</note>
  <source>Sorry we couldn't find any results for &lt;strong&gt;[% search_result_xml.Q %][% search_result_json.Query %]&lt;/strong&gt;, please try again.</source>
  <target>很抱歉，我們無法找到任何 &lt;strong&gt;[% search_result_xml.Q %][% search_result_json.Query %]&lt;/strong&gt; 的結果，請再試一次。</target>
</trans-unit>
};

# tests for from_xml()

my $trans_unit = XLIFF::Object::TransUnit->from_xml($xml);

is (
    $trans_unit->id,
    12,
    "id ok",
);

is (
    $trans_unit->approved,
    "yes",
    "approved ok",
);

like (
    $trans_unit->source->content,
    qr{^Sorry we could},
    "source content ok",
);

like (
    $trans_unit->target->content,
    qr{^很抱歉},
    "target content ok",
);

like (
    $trans_unit->note->content,
    qr{^Original text},
    "note content ok",
);

is (
    $trans_unit->note->get("annotates"),
    "source",
    "note annotates ok",
);

is (
    $trans_unit->note->get("from"),
    "developer",
    "note from ok",
);

is (
    "\n".$trans_unit->to_xml,
    $xml,
    "to_xml() ok",
);

# tests for from_perl()

my $from_perl = XLIFF::Object::TransUnit->from_perl(
    "trans-unit" => {
        id       => 1,
        approved => "yes",
        note     => { content => "筆記" },
        source   => { content => "hello" },
        target   => { content => "哈囉" },
    }
);

is (
    $from_perl->id,
    1,
    "from_perl() can set id",
);

is (
    $from_perl->approved,
    "yes",
    "from_perl() can set approved",
);

is (
    $from_perl->source->content,
    "hello",
    "from_perl() can initialize source",
);

is (
    $from_perl->target->content,
    "哈囉",
    "from_perl() can initialize target",
);

is (
    $from_perl->note->content,
    "筆記",
    "from_perl() can initialize note",
);

my $from_kv = XLIFF::Object::TransUnit->from_kv("sky" => "天空");

is_deeply (
    { $from_kv->to_perl },
    {
        "trans-unit" => {
            id       => undef,
            approved => "no",
            source   => { content => "sky" },
            target   => { content => "天空" },
        }
    },
    "from_kv() can work",
);

done_testing;
