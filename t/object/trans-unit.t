use Modern::Perl;
use Test::More;
use XLIFF::Object::TransUnit;
use utf8;

my $xml = q{
<trans-unit id="12" approved="yes">
  <note annotates="source" from="developer">Original text was Sorry we couldn't find any results for &lt;strong&gt;[% google_sitesearch.Q %]&lt;/strong&gt;, please try again.</note>
  <source>Sorry we couldn't find any results for &lt;strong&gt;[% search_result_xml.Q %][% search_result_json.Query %]&lt;/strong&gt;, please try again.</source>
  <target>很抱歉，我們無法找到任何 &lt;strong&gt;[% search_result_xml.Q %][% search_result_json.Query %]&lt;/strong&gt; 的結果，請再試一次。</target>
</trans-unit>
};

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

done_testing;
