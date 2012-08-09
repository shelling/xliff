use inc::Module::Install;
name 'XLIFF';
all_from 'lib/XLIFF.pm';

# requires '';
requires 'Moose';
requires 'XML::Simple';

tests 't/*.t t/*/*.t';
author_tests 'xt';

test_requires 'Test::More';
auto_set_repository;
auto_include;
WriteAll;
