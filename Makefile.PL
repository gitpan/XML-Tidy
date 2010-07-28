use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
#   the contents of the Makefile that is written.
WriteMakefile(
  'NAME'         => 'XML::Tidy',
  'VERSION'      => '1.6.A7RJKwl',
  'ABSTRACT'     => 'tidy indenting of XML documents',
  'AUTHOR'       => 'Pip Stuart <Pip@CPAN.Org>',
  'EXE_FILES'    => [ 
                      'bin/xmltidy',
                    ],
  'PREREQ_PM'    => {
    'Math::BaseCnv'                  => 0,
    'Test'                           => 0,
    'Test::Pod'                      => 0,
    'Test::Pod::Coverage'            => 0,
    'XML::XPath'                     => 0,
    'XML::XPath::XMLParser'          => 0,
  }, # Module::Name => 1.1,
  'dist'         => { 'COMPRESS' => 'gzip', 'SUFFIX' => 'tgz' },
);