use Test;
BEGIN { plan tests => 15 }
use XML::Tidy;
my $tobj; ok(1);
sub diff { # test for difference between memory Tidy objects
  my $tidy = shift() || return(0);
  my $tstd = shift();   return(0) unless(defined($tstd) && $tstd);
  my($root)= $tidy->findnodes('/');
  my $xdat = qq(<?xml version="1.0" encoding="utf-8"?>\n);
  $xdat .= $_->toString() for($root->getChildNodes());
  if($xdat eq $tstd) { return(1); } # 1 == files same
  else               { return(0); } # 0 == files diff
}
my $tst0 = qq|<?xml version="1.0" encoding="utf-8"?>
<root att0="kaka">
  <kid0 />
  <kid1 />
</root>|;
my $tstA = qq|<?xml version="1.0" encoding="utf-8"?>
<root att0="kaka">
  <kid0 />
  <kid1 />
</root>|;
my $tstB = qq|<?xml version="1.0" encoding="utf-8"?>
<root att0="kaka"><kid0 /><kid1 /></root>|;
my $tstC = qq|<?xml version="1.0" encoding="utf-8"?>
<root att0="kaka">
  <kid0 />
  <kid1 />
</root>|;
my $tstD = qq|<?xml version="1.0" encoding="utf-8"?>
<root att0="kaka">
	<kid0 />
	<kid1 />
</root>|;  $tobj = XML::Tidy->new($tst0) ;
ok(defined($tobj                       ));
ok(   diff($tobj,                 $tst0));
ok(        $tobj->get_xml(),      $tst0 );
           $tobj->reload();
ok(defined($tobj                       ));
ok(   diff($tobj,                 $tst0));
ok(        $tobj->get_xml(),      $tst0 );
ok(   diff($tobj,                 $tstA));
           $tobj->strip();
ok(defined($tobj                       ));
ok(   diff($tobj,                 $tstB));
           $tobj->tidy();
ok(defined($tobj                       ));
ok(   diff($tobj,                 $tstC));
           $tobj->tidy("\t");
ok(defined($tobj                       ));
ok(        $tobj->get_xml(),      $tstD );
ok(   diff($tobj,                 $tstD));
