use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# # the contents of the Makefile that is written.
WriteMakefile(
  'NAME'         => 'XML::Tidy',
  'VERSION'      => '1.2.4CCJW4G',
  'ABSTRACT'     => 'tidy indenting of XML documents',
  'AUTHOR'       => 'Pip Stuart <Pip@CPAN.Org>',
  'EXE_FILES'    => [ 
                      'bin/xmltidy',
                    ],
  'PREREQ_PM'    => {
    'XML::XPath::XMLParser'          => 0,
    'XML::XPath'                     => 0,
  }, # Module::Name => 1.1,
  'dist'         => { 'COMPRESS' => 'gzip', 'SUFFIX' => 'tgz' },
);