#!/usr/bin/perl -w
# 4C3HOH1 - XML::Tidy.pm created by Pip Stuart <Pip@CPAN.Org>
#   to tidy XML documents as parsed XML::XPath objects.

=head1 NAME

XML::Tidy - tidy indenting of XML documents

=head1 VERSION

This documentation refers to version 1.2.51HM2ae of 
XML::Tidy, which was released on Mon Jan 17 22:02:36:40 2005.

=head1 SYNOPSIS

  use XML::Tidy;

  # create new   XML::Tidy object from         MainFile.xml
  my $tidy_obj = XML::Tidy->new('filename' => 'MainFile.xml');

  # Tidy up the indenting
     $tidy_obj->tidy();

  # Write out changes back to MainFile.xml
     $tidy_obj->write();

=head1 DESCRIPTION

This module creates XML document objects (with inheritance from
L<XML::XPath>) to tidy mixed-content (ie. non-data) text node
indenting.

=head1 2DO

=over 2

=item - add tests for XML::XPath::Node wrappers

=item - add tests for toString

=item - fix compress() comment bug

=item - add tests for compress() && expand()

=item - imp namespace option in compress()

=item - mk tidy keep doc order when duping attz, namespaces,
          (hopefully someday PIs) into temp $docu && $tnod

=item - fix reload() from messing up unicode escaped &XYZ; components like
          Copyright &#xA9; -> © && Registered &#xAE; -> ®

=item -     What else does Tidy need?

=back

=head1 USAGE

=head2 new()

This is the standard Tidy object constructor.  It can take
the same parameters as an L<XML::XPath> object constructor to
initialize the XML document object.  These can be any one of:

  'filename' => 'SomeFile.xml'
  'xml'      => $variable_which_holds_a_bunch_of_XML_data
  'ioref'    => $file_InputOutput_reference
  'context'  => $existing_node_at_specified_context_to_become_new_obj

=head2 reload()

The reload() member function causes the latest data contained in
a Tidy object to be re-parsed which re-indexes all nodes.
This can be necessary after modifications have been made to nodes
which impact the tree node hierarchy because L<XML::XPath>'s find()
member preserves state info which can get out-of-sync.  reload() is
probably rarely useful by itself but it is needed by strip() &&
prune() so it is exposed as a method in case it comes in handy for
other uses.

=head2 strip()

The strip() member function searches the Tidy object for all
mixed-content (ie. non-data) text nodes && empties them out.
This will basically unformat any markup indenting.  strip() is
used by compress() && tidy() but it is exposed because it could be
worthwhile by itself.

=head2 tidy()

The tidy() member function can take a single optional parameter as
the string that should be inserted for each indent level.  Some
examples:

  # Tidy up indenting with default two  (2) spaces per indent level
     $tidy_obj->tidy();

  # Tidy up indenting with         four (4) spaces per indent level
     $tidy_obj->tidy('    ');

  # Tidy up indenting with         one  (1) tab    per indent level
     $tidy_obj->tidy("\t");

The default behavior is to use two (2) spaces (ie. '  ') for each
indent level.  The Tidy object gets all mixed-content (ie. non-data)
text nodes reformatted to appropriate indent levels according to tree
nesting depth.

NOTE: There seems to be a bug in L<XML::XPath> which does not allow
finding XML processing instructions (PIs) properly so they have been
commented out of tidy().  This means that tidy() unfortunately
removes processing instructions from files it operates on.  I hope
this shortcoming can be repaired in the near future.  tidy() also
disturbs some XML escapes in whatever ways L<XML::XPath> does.

=head2 compress()

The compress() member function calls strip() on the Tidy object
then creates comments ahead of the root element which contain the
names of elements && attributes as they occurred with their
respective element && attribute names represented as just an index
throughout the document.

compress() can accept a parameter describing which node types to
attempt to shrink down as abbreviations.  This parameter should be
a string of just the first letters of each node type you wish to
include as in the following mapping:

  e = elements
  a = attribute keys
  v = attribute values *EXPERIMENTAL*
  t = text      nodes  *EXPERIMENTAL*
  c = comment   nodes  *EXPERIMENTAL*
  n = namespace nodes  *not-yet-implemented*

Attribute values ('v') && text nodes ('t') both seem to work fine as
they are tokenized.  I have some bugs in the comment node compression
which I haven't been able to find yet so that one should be avoided
for now.  Since these three node types ('vtc') all require tokenization,
they are not included in default compression ('ea').  An example call
which includes values && text would be:

  $tidy_obj->compress('eatv');

The original document structure (ie. node hierarchy) is preserved.
compress() significantly reduces the file size of most XML documents
for when size matters more than immediate human readability.
expand() performs the opposite conversion.

=head2 expand()

The expand() member function reads any XML::Tidy::compress comments
from the Tidy object && uses them to reconstruct the document
that was passed to compress().  These utilities together seem like
a mildly useful way to tidy XML documents so they earned inclusion
in this module.  compress() && expand() should be considered
experimental.

=head2 prune()

The prune() member function takes an XPath location to remove (along
with all attributes && child nodes) from the Tidy object.  For
example, to remove all comments:

  $tidy_obj->prune('//comment()');

or to remove the third baz (XPath indexing is 1-based):

  $tidy_obj->prune('/foo/bar/baz[3]');

Pruning your XML tree is a form of tidying too so it snuck in here. =)
It seems L<XML::XPath> objects are dramatically more useful when they
all have access to this class of additional member functions.

=head2 write()

The write() member function can take an optional filename parameter
to write out any changes to the Tidy object.  If no parameters
are given, write() overwrites the original XML document file (if
a 'filename' parameter was given to the constructor).

write() will croak() if no filename can be found to write to.

write() can also take a secondary parameter which specifies an XPath
location to be written out as the new root element instead of the
Tidy object's root.  Only the first matching element is written.

=head2 toString()

The toString() member function is almost identical to write() except
that it takes no parameters && simply returns the equivalent XML
string as a scalar.  It is a little weird because normally only
XML::XPath::Node objects have a toString member but I figure it makes
sense to extend the same syntax to the parent object as well since
it is a useful option.

=head1 createNode Wrappers

The following are just aliases to Node constructors.  They'll work with
just the unique portion of the node type as the member function name.

=head2 e() or el() or elem() or createElement()

wrapper for XML::XPath::Node::Element->new()

=head2 a() or at() or attr() or createAttribute()

wrapper for XML::XPath::Node::Attribute->new()

=head2 c() or cm() or cmnt() or createComment()

wrapper for XML::XPath::Node::Comment->new()

=head2 t() or tx() or text() or createTextNode()

wrapper for XML::XPath::Node::Text->new()

=head2 p() or pi() or proc() or createProcessingInstruction()

wrapper for XML::XPath::Node::PI->new()

=head2 n() or ns() or nspc() or createNamespace()

wrapper for XML::XPath::Node::Namespace->new()

=head1 EXPORTED CONSTANTS

XML::Tidy also exports the same node constants as L<XML::XPath::Node>
(which correspond to DOM values).  These include:

  UNKNOWN_NODE
  ELEMENT_NODE
  ATTRIBUTE_NODE
  TEXT_NODE
  CDATA_SECTION_NODE
  ENTITY_REFERENCE_NODE
  ENTITY_NODE
  PROCESSING_INSTRUCTION_NODE
  COMMENT_NODE
  DOCUMENT_NODE
  DOCUMENT_TYPE_NODE
  DOCUMENT_FRAGMENT_NODE
  NOTATION_NODE
  ELEMENT_DECL_NODE
  ATT_DEF_NODE
  XML_DECL_NODE
  ATTLIST_DECL_NODE
  NAMESPACE_NODE

XML::Tidy also exports:

  STANDARD_XML_DECL

which returns a reasonable default XML declaration string.

=head1 CHANGES

Revision history for Perl extension XML::Tidy:

=over 4

=item - 1.2.51HM2ae  Mon Jan 17 22:02:36:40 2005

* added compress() && expand()

* added toString()

=item - 1.2.4CKBHxt  Mon Dec 20 11:17:59:55 2004

* added exporting of XML::XPath::Node (DOM) constants

* added node object creation wrappers (like LibXML)

=item - 1.2.4CCJW4G  Sun Dec 12 19:32:04:16 2004

* added optional 'xpath_loc' => to prune()

=item - 1.0.4CAJna1  Fri Dec 10 19:49:36:01 2004

* added optional 'filename' => to write()

=item - 1.0.4CAAf5B  Fri Dec 10 10:41:05:11 2004

* removed 2nd param from tidy() so that 1st param is just indent string

* fixed pod errors

=item - 1.0.4C9JpoP  Thu Dec  9 19:51:50:25 2004

* added xplc option to write()

* added prune()

=item - 1.0.4C8K1Ah  Wed Dec  8 20:01:10:43 2004

* inherited from XPath so that those methods can be called directly

* original version (separating Tidy.pm from Merge.pm)

=back

=head1 INSTALL

From the command shell, please run:

    `perl -MCPAN -e "install XML::Tidy"`

or uncompress the package && run the standard:

    `perl Makefile.PL; make; make test; make install`

=head1 FILES

XML::Tidy requires:

L<Carp>                  to allow errors to croak() from calling sub

L<XML::XPath>            to use XPath statements to query && update XML

L<XML::XPath::XMLParser> to parse XML documents into XPath objects

=head1 LICENSE

Most source code should be Free!
  Code I have lawful authority over is && shall be!
Copyright: (c) 2004, Pip Stuart.
Copyleft : This software is licensed under the GNU General Public
  License (version 2), && as such comes with NO WARRANTY.  Please
  consult the Free Software Foundation (http://FSF.Org) for
  important information about your freedom.

=head1 AUTHOR

Pip Stuart <Pip@CPAN.Org>

=cut

package XML::Tidy;
use warnings;
use strict;
require      XML::XPath;
use base qw( XML::XPath Exporter );
use vars qw( $AUTOLOAD @EXPORT   );
use Carp;
use Exporter;
use Math::BaseCnv qw(:b64);
use XML::XPath::XMLParser;
our $VERSION     = '1.2.51HM2ae'; # major . minor . PipTimeStamp
our $PTVR        = $VERSION; $PTVR =~ s/^\d+\.\d+\.//; # strip major and minor
# Please see `perldoc Time::PT` for an explanation of $PTVR.
@EXPORT = qw(
    UNKNOWN_NODE
    ELEMENT_NODE
    ATTRIBUTE_NODE
    TEXT_NODE
    CDATA_SECTION_NODE
    ENTITY_REFERENCE_NODE
    ENTITY_NODE
    PROCESSING_INSTRUCTION_NODE
    COMMENT_NODE
    DOCUMENT_NODE
    DOCUMENT_TYPE_NODE
    DOCUMENT_FRAGMENT_NODE
    NOTATION_NODE
    ELEMENT_DECL_NODE
    ATT_DEF_NODE
    XML_DECL_NODE
    ATTLIST_DECL_NODE
    NAMESPACE_NODE
    STANDARD_XML_DECL
);
sub UNKNOWN_NODE                () { 0;}
sub ELEMENT_NODE                () { 1;}
sub ATTRIBUTE_NODE              () { 2;}
sub TEXT_NODE                   () { 3;}
sub CDATA_SECTION_NODE          () { 4;}
sub ENTITY_REFERENCE_NODE       () { 5;}
sub ENTITY_NODE                 () { 6;}
sub PROCESSING_INSTRUCTION_NODE () { 7;}
sub COMMENT_NODE                () { 8;}
sub DOCUMENT_NODE               () { 9;}
sub DOCUMENT_TYPE_NODE          () {10;}
sub DOCUMENT_FRAGMENT_NODE      () {11;}
sub NOTATION_NODE               () {12;}
# Non core DOM stuff
sub ELEMENT_DECL_NODE           () {13;}
sub ATT_DEF_NODE                () {14;}
sub XML_DECL_NODE               () {15;}
sub ATTLIST_DECL_NODE           () {16;}
sub NAMESPACE_NODE              () {17;}
# Standard XML Declaration
my $xmld = qq(<?xml version="1.0" encoding="utf-8"?>\n);
sub STANDARD_XML_DECL           () {$xmld;}

my $DBUG = 0;

sub new {
  my $clas = shift();
  my $xpob = XML::XPath->new(@_);
  my $self = bless($xpob, $clas);
  #   self just a new XPath obj blessed into Tidy class
  return($self);
}

sub reload { # dump XML text && re-parse object to re-index all nodes cleanly
  my $self = shift();
  if(defined($self)) {
    my($root)= $self->findnodes('/');
    my $data = $xmld;
    $data .= $_->toString() foreach($root->getChildNodes());
    $self->set_xml($data);
    my $prsr = XML::XPath::XMLParser->new('xml' => $data);
    $self->set_context($prsr->parse());
  }
}

sub strip { # strips out all text nodes from any mixed content
  my $self = shift();
  if(defined($self)) {
    my @nodz = $self->findnodes('//*');
    foreach(@nodz) {
      if($_->getNodeType() eq XML::XPath::Node::ELEMENT_NODE) {
        my @kidz = $_->getChildNodes();
        foreach my $kidd (@kidz) {
          if($kidd->getNodeType() eq XML::XPath::Node::TEXT_NODE &&
             @kidz > 1 && $kidd->getValue() =~ /^\s*$/) {
            $kidd->setValue(''); # empty them all out
          }
        }
      }
    }
    $self->reload(); # reload all XML as text to re-index nodes
  }
}

# tidy XML indenting with a certain indent string
sub tidy {
  my $self = shift(); my $ndnt = shift() || '  ';
  $ndnt = "\t" if($ndnt =~ /tab/i ); # allow some indent_type descriptions
  $ndnt = '  ' if($ndnt =~ /spac/i);
  $self->strip(); # strips all object's text nodes from mixed content
  # now insert new nodes with newlines && indenting by tree nesting depth
  my $dpth = 0; # keep track of element nest depth
  my $docu = XML::XPath::Node::Element->new(); # temporary document root node
  if(defined($self)) {
    # NOTE: There's a bug in XML::XPath that doesn't let you find PIs! =(
    foreach(#$self->findnodes('processing-instruction()'),
            $self->findnodes('comment()')) {
      print "NodeType:" . $_->getNodeType() . " = " . $_->toString() .
             "\n  pos:" . $_->get_pos() .
           " Glob_pos:" . $_->get_global_pos() . "\n" if($DBUG);
      $docu->appendChild($_); # consider insertBefore($posi) to keep order
    }
    my($root)= $self->findnodes('/*');
    print "RT  Found new      elem:" . $root->getName() . "\n" if($DBUG);
    if($root->getChildNodes()) { # recursively tidy children
      $root = $self->_rectidy($root, ($dpth + 1), $ndnt);
    }
    $docu->appendChild($root);
    ($root)= $docu->findnodes('/');
    my $data = $xmld;
    $data .= $_->toString() foreach($root->getChildNodes());
    $self->set_xml($data);
    my $prsr = XML::XPath::XMLParser->new('xml' => $data);
    $self->set_context($prsr->parse());
  }
}

sub _rectidy { # recursively tidy up indent formatting of elements
  my $self = shift(); my $node = shift();
  my $dpth = shift(); my $ndnt = shift();
  my $tnod = undef; # temporary node which will get nodes surrounding children
  $tnod = XML::XPath::Node::Element->new($node->getName());
  foreach($node->findnodes('@*')) { # copy all attributes
    print "NR  Found new      attr:" . $_->getName() . "\n" if($DBUG);
    $tnod->appendAttribute($_);
  }
  foreach($node->getNamespaces()) { # copy all namespaces
    print "NR  Found new namespace:" . $_->toString() .
                          "\n  pos:" . $_->get_pos() .
                        " Glob_pos:" . $_->get_global_pos() . "\n" if($DBUG);
    $tnod->appendNamespace($_);
  }
  my @kidz = $node->getChildNodes(); my $lkid;
  foreach my $kidd (@kidz) {
    if($kidd->getNodeType() ne XML::XPath::Node::TEXT_NODE && (!$lkid ||
       $lkid->getNodeType() ne XML::XPath::Node::TEXT_NODE)) {
      $tnod->appendChild(XML::XPath::Node::Text->new("\n" . ($ndnt x $dpth)));
    }
    if($kidd->getNodeType() eq XML::XPath::Node::ELEMENT_NODE) {
      print "NR  Found new      elem:" . $kidd->getName() . " dpth:$dpth\n" if($DBUG);
      my @gkdz = $kidd->getChildNodes();
      if(@gkdz    && ($gkdz[0]->getNodeType() ne XML::XPath::Node::TEXT_NODE ||
        (@gkdz > 1 && $gkdz[1]->getNodeType() ne XML::XPath::Node::TEXT_NODE))) {
        $kidd = $self->_rectidy($kidd, ($dpth + 1), $ndnt); # recursively tidy
      }
    }
    $tnod->appendChild($kidd);
    $lkid = $kidd;
  }
  $tnod->appendChild(XML::XPath::Node::Text->new("\n" . ($ndnt x ($dpth - 1))));
  return($tnod);
}

sub compress { # compress an XML::Tidy object into look-up tables
  my $self = shift(); my $flgz = shift(); # options of node types to include
  my @elut =      (); my @alut =      (); # element && attribute look-up-tables
  my %efou =      (); my %afou =      (); # element && attribute found flags
  my @vlut =      (); my @tlut =      (); # attribute value && text
  my %vfou =      (); my %tfou =      ();
  my @nlut =      (); my @clut =      (); # namespace && comment
  my %nfou =      (); my %cfou =      ();
  my $cstr = "XML::Tidy::compress v$VERSION";
  my $ntok = qr/[\(\)\[\]\{\}\/\*\+\?]/; # non-token quoted regex
  $flgz = 'ea'     unless(defined($flgz)); # Default flags: just elemz && attrz
  $flgz = 'eatvnc' if($flgz eq 'all'); # AttValz && Text seem to work alright
                                       #   but beware of bugs in Comment I
                                       #   haven't been able to squash yet.
  $self->strip(); # remove non-data text nodes
  my($root)= $self->findnodes('/');
  if($flgz =~ /e[^E]*$/) { # elements
    foreach($root->findnodes('//*')) {
      my $name = $_->getName();
      unless(exists($efou{$name})) {
        push(@elut, $name);
        $efou{$name} = $#elut;
      }
      # 5 below is the index of XML::XPath::Node::Element's node_name field
      ${$_}->[5] = 'e' . b64($efou{$name}); # $_->setName(...
    }
    $cstr .= "\ne:@elut" if(@elut);
  }
  if($flgz =~ /(a[^A]*|v[^V]*)$/) { # attributes (keys or values)
    foreach($root->findnodes('//@*')) {
      if($flgz =~ /a[^A]*$/) { # attribute keys
        my $name = $_->getName();
        if(exists($efou{$name})) { # reuse element keys matching attributes
          # 4 is the index of XML::XPath::Node::Attribute's node_key   field
          ${$_}->[4] = 'e' . b64($efou{$name}); # $_->setName(...
        } else {
          unless(exists($afou{$name})) {
            push(@alut, $name);
            $afou{$name} = $#alut;
          }
          ${$_}->[4] = 'a' . b64($afou{$name}); # $_->setName(...
        }
      }
      if($flgz =~ /v[^V]*$/) { # attribute values
        my $wval = $_->getNodeValue(); $wval = '' unless(defined($wval));
        foreach my $valu (split(/\s+/, $wval)) {
          my $repl = '';
          if     (exists($efou{$valu})) { # reuse elem keys matching attr valz
            $repl = 'e' . b64($efou{$valu});
          } elsif(exists($afou{$valu})) { # reuse attr keys matching attr valz
            $repl = 'a' . b64($afou{$valu});
          } elsif($valu !~ $ntok) {
            unless(exists($vfou{$valu})) {
              push(@vlut, $valu);
              $vfou{$valu} = $#vlut;
            }
            $repl = 'v' . b64($vfou{$valu});
          }
          # 5 is the index of XML::XPath::Node::Attribute's node_value field
          ${$_}->[5] =~ s/(^|\s+)$valu(\s+|$)/$1$repl$2/g if($valu !~ $ntok);
        }
      }
    }
    $cstr .= "\na:@alut" if(@alut);
    $cstr .= "\nv:@vlut" if(@vlut);
  }
  if($flgz =~ /t[^T]*$/) { # text
    foreach($root->findnodes('//text()')) {
      my $wtxt = $_->getNodeValue();
      foreach my $text (split(/\s+/, $wtxt)) {
        my $repl = '';
        if     (exists($efou{$text})) { # reuse elem keys matching text token
          $repl = 'e' . b64($efou{$text});
        } elsif(exists($afou{$text})) { # reuse attr keys matching text token
          $repl = 'a' . b64($afou{$text});
        } elsif(exists($afou{$text})) { # reuse attr valz matching text token
          $repl = 'v' . b64($vfou{$text});
        } elsif($text !~ $ntok) {
          unless(exists($tfou{$text})) {
            push(@tlut, $text);
            $tfou{$text} = $#tlut;
          }
          $repl = 't' . b64($tfou{$text});
        }
        # 3 is the index of XML::XPath::Node::Text's node_text field
        ${$_}->[3] =~ s/(^|\s+)$text(\s+|$)/$1$repl$2/g if($text !~ $ntok);
      }
    }
    $cstr .= "\nt:@tlut" if(@tlut);
  }
  if($flgz =~ /c[^C]*$/) { # comment
    foreach($root->findnodes('//comment()')) {
      my $wcmt = $_->getNodeValue();
      foreach my $cmnt (split(/\s+/, $wcmt)) {
        my $repl = '';
        if     (exists($efou{$cmnt})) { # reuse elem keys matching cmnt token
          $repl = 'e' . b64($efou{$cmnt});
        } elsif(exists($afou{$cmnt})) { # reuse attr keys matching cmnt token
          $repl = 'a' . b64($afou{$cmnt});
        } elsif(exists($afou{$cmnt})) { # reuse attr valz matching cmnt token
          $repl = 'v' . b64($vfou{$cmnt});
        } elsif(exists($tfou{$cmnt})) { # reuse text valz matching cmnt token
          $repl = 't' . b64($tfou{$cmnt});
        } elsif($cmnt !~ $ntok) {
          unless(exists($cfou{$cmnt})) {
            push(@clut, $cmnt);
            $cfou{$cmnt} = $#clut;
          }
          $repl = 'c' . b64($cfou{$cmnt});
        }
        # 3 is the index of XML::XPath::Node::Comment's node_comment field
        ${$_}->[3] =~ s/(^|\s+)$cmnt(\s+|$)/$1$repl$2/g if($cmnt !~ $ntok);
      }
    }
    $cstr .= "\nc:@clut" if(@clut);
  }
  $root->appendChild($self->c($cstr));
  $self->reload();
}

sub expand { # uncompress an XML::Tidy object from look-up tables
  my $self = shift(); my $flgz = shift(); # options of node types to include
  my @elut =      (); my @alut =      (); # element && attribute look-up-tables
  my @vlut =      (); my @tlut =      (); # attribute value && text
  my @nlut =      (); my @clut =      (); # namespace && comment
  my $ntok = qr/[\(\)\[\]\{\}\/\*\+\?]/; # non-token quoted regex
  my($root)= $self->findnodes('/');
  foreach($root->findnodes('//comment()')) {
    my $text = $_->getNodeValue();
    if($text =~ s/^XML::Tidy::compress v(\d+)\.(\d+)\.([0-9A-Za-z._]{7})//) {
      # may need to test $1, $2, $3 for versions later
      while($text =~ s/^\n([eatvnc]):([^\n]+)//) {
        my $ntyp = $1; my $lutd = $2;
        if     ($ntyp eq 'e') {
          push(@elut, split(/\s+/, $lutd));
        } elsif($ntyp eq 'a') {
          push(@alut, split(/\s+/, $lutd));
        } elsif($ntyp eq 't') {
          push(@tlut, split(/\s+/, $lutd));
        } elsif($ntyp eq 'v') {
          push(@vlut, split(/\s+/, $lutd));
        } elsif($ntyp eq 'n') {
#          push(@nlut, split(/\s+/, $lutd));
        } elsif($ntyp eq 'c') {
          push(@clut, split(/\s+/, $lutd));
        }
      }
      $root->removeChild($_);
    }
  }
  if(@elut) {
    foreach($root->findnodes('//*')) {
      my $name = $_->getName();
      my $coun = $name;
      if($coun =~ s/^e// && b10($coun) < @elut) {
        $coun = b10($coun);
        # 5 below is the index of XML::XPath::Node::Element's node_name field
        ${$_}->[5] = $elut[$coun]; # $_->setName($elut[$coun]);
      } else {
        croak "!*EROR*! expand() cannot find look-up element:$name!\n";
      }
    }
  }
  if(@alut) {
    foreach($root->findnodes('//@*')) {
      my $name = $_->getName();
      my $coun = $name;
      if     ($coun =~ s/^e// && b10($coun) < @elut) {
        $coun = b10($coun);
        # 4 below is the index of XML::XPath::Node::Attribute's node_key field
        ${$_}->[4] = $elut[$coun]; # $_->setName($elut[$coun]);
      } elsif($coun =~ s/^a// && b10($coun) < @alut) {
        $coun = b10($coun);
        ${$_}->[4] = $alut[$coun]; # $_->setName($alut[$coun]);
      } else {
        croak "!*EROR*! expand() cannot find look-up attribute key:$name!\n";
      }
      if(@vlut) {
        my $wval = $_->getNodeValue();
        foreach my $valu (split(/\s+/, $wval)) {
          unless($valu =~ $ntok) {
            $coun = $valu;
            if     ($coun =~ s/^e// && b10($coun) < @elut) {
              $coun = b10($coun);
              # 5 is the index of XML::XPath::Node::Attribute's node_value field
              ${$_}->[5] =~ s/(^|\s+)$valu(\s+|$)/$1$elut[$coun]$2/g;
            } elsif($coun =~ s/^a// && b10($coun) < @alut) {
              $coun = b10($coun);
              ${$_}->[5] =~ s/(^|\s+)$valu(\s+|$)/$1$alut[$coun]$2/g;
            } elsif($coun =~ s/^v// && b10($coun) < @vlut) {
              $coun = b10($coun);
              ${$_}->[5] =~ s/(^|\s+)$valu(\s+|$)/$1$vlut[$coun]$2/g;
            } else {
              croak "!*EROR*! expand() cannot find look-up attribute value:$valu!\n";
            }
          }
        }
      }
    }
  }
  if(@tlut) {
    foreach($root->findnodes('//text()')) {
      my $wtxt = $_->getNodeValue();
      foreach my $text (split(/\s+/, $wtxt)) {
        unless($text =~ $ntok) {
          my $coun = $text;
          if     ($coun =~ s/^e// && b10($coun) < @elut) {
            $coun = b10($coun);
            # 3 is the index of XML::XPath::Node::Text's node_text field
            ${$_}->[3] =~ s/(^|\s+)$text(\s+|$)/$1$elut[$coun]$2/g;
          } elsif($coun =~ s/^a// && b10($coun) < @alut) {
            $coun = b10($coun);
            ${$_}->[3] =~ s/(^|\s+)$text(\s+|$)/$1$alut[$coun]$2/g;
          } elsif($coun =~ s/^t// && b10($coun) < @tlut) {
            $coun = b10($coun);
            ${$_}->[3] =~ s/(^|\s+)$text(\s+|$)/$1$tlut[$coun]$2/g;
          } elsif($coun =~ s/^v// && b10($coun) < @vlut) {
            $coun = b10($coun);
            ${$_}->[3] =~ s/(^|\s+)$text(\s+|$)/$1$vlut[$coun]$2/g;
          } else {
            croak "!*EROR*! expand() cannot find look-up text token:$text!\n";
          }
        }
      }
    }
  }
  if(@clut) {
    foreach($root->findnodes('//comment()')) {
      my $wcmt = $_->getNodeValue();
      foreach my $cmnt (split(/\s+/, $wcmt)) {
        unless($cmnt =~ $ntok) {
          my $coun = $cmnt;
          if     ($coun =~ s/^e// && b10($coun) < @elut) {
            $coun = b10($coun);
            # 3 is the index of XML::XPath::Node::Comment's node_comment field
            ${$_}->[3] =~ s/(^|\s+)$cmnt(\s+|$)/$1$elut[$coun]$2/g;
          } elsif($coun =~ s/^a// && b10($coun) < @alut) {
            $coun = b10($coun);
            ${$_}->[3] =~ s/(^|\s+)$cmnt(\s+|$)/$1$alut[$coun]$2/g;
          } elsif($coun =~ s/^v// && b10($coun) < @vlut) {
            $coun = b10($coun);
            ${$_}->[3] =~ s/(^|\s+)$cmnt(\s+|$)/$1$vlut[$coun]$2/g;
          } elsif($coun =~ s/^t// && b10($coun) < @tlut) {
            $coun = b10($coun);
            ${$_}->[3] =~ s/(^|\s+)$cmnt(\s+|$)/$1$tlut[$coun]$2/g;
          } elsif($coun =~ s/^c// && b10($coun) < @clut) {
            $coun = b10($coun);
            ${$_}->[3] =~ s/(^|\s+)$cmnt(\s+|$)/$1$clut[$coun]$2/g;
          } else {
            croak "!*EROR*! expand() cannot find look-up comment token:$cmnt!\n";
          }
        }
      }
    }
  }
  $self->reload();
  $self->tidy();
}

sub prune { # remove a section of the tree at the xpath location parameter
  my $self = shift(); my $xplc = shift() || return(); # can't prune root node
  if(defined($xplc) && $xplc && $xplc =~ /^[-_]?(xplc$|xpath_loc)/) {
     $xplc = shift() || undef;
  }
  if(defined($self) && defined($xplc) && length($xplc) && $xplc ne '/') {
    $self->reload(); # update all nodes && internal XPath indexing before find
    foreach($self->findnodes($xplc)) {
      print "Pruning:$xplc\n" if($DBUG);
      my $prnt = $_->getParentNode();
      $prnt->removeChild($_) if(defined($prnt));
    }
  }
}

sub write { # write out an XML file to disk from a Tidy object
  my $self = shift(); my $root; my $xplc;
  my $flnm = shift() || $self->get_filename();
  if(defined($flnm) && $flnm) {
    if($flnm =~ /^[-_]?(xplc$|xpath_loc)/) {
      $xplc = shift() || undef;
      $flnm = shift() || $self->get_filename();
    }
    if($flnm =~ /^[-_]?(flnm|filename)$/) {
      $flnm = shift() || $self->get_filename();
    }
  }
  unless(defined($xplc) && $xplc) {
    $xplc = shift() || undef;
  }
  if(defined($xplc) && $xplc && $xplc =~ /^[-_]?(xplc$|xpath_loc)/) {
    $xplc = shift() || undef;
  }
  if(defined($self) && defined($flnm)) {
    if(defined($xplc) && $xplc) {
         $root = XML::XPath::Node::Element->new();
      my($rtnd)= $self->findnodes($xplc);
         $root->appendChild($rtnd);
    } else {
        ($root)= $self->findnodes('/');
    }
    open( FILE, ">$flnm");
    print FILE $xmld;
    print FILE $_->toString() , "\n" foreach($root->getChildNodes());
    close(FILE);
  } else {
    croak("!*EROR*! No filename could be found to write() to!\n");
  }
}

sub toString { # write out an XML file to disk from a Tidy object
  my $self = shift(); my $root;
  my $xplc = shift(); my $xmls = $xmld;
  if(defined($xplc) && $xplc && $xplc =~ /^[-_]?(xplc$|xpath_loc)/) {
    $xplc = shift() || undef;
  }
  if(defined($self)) {
    if(defined($xplc) && $xplc) {
         $root = XML::XPath::Node::Element->new();
      my($rtnd)= $self->findnodes($xplc);
         $root->appendChild($rtnd);
    } else {
        ($root)= $self->findnodes('/');
    }
    $xmls .= $_->toString() . "\n" foreach($root->getChildNodes());
  } else {
    croak("!*EROR*! No XML::Tidy could be found for toString()!\n");
  }
  return($xmls);
}

sub AUTOLOAD { # methods (created as necessary)
  no strict 'refs';
  my $self = shift();
  if($AUTOLOAD =~ /.*::(new|create)?([eactpn])/i) { # createNode Wrappers
    my $node = lc($2);
    *{$AUTOLOAD} = sub { # add called sub to function table
      my $self = shift();
      if   ($node eq 'e') { return(XML::XPath::Node::Element  ->new(@_)); }
      elsif($node eq 'a') { return(XML::XPath::Node::Attribute->new(@_)); }
      elsif($node eq 'c') { return(XML::XPath::Node::Comment  ->new(@_)); }
      elsif($node eq 't') { return(XML::XPath::Node::Text     ->new(@_)); }
      elsif($node eq 'p') { return(XML::XPath::Node::PI       ->new(@_)); }
      elsif($node eq 'n') { return(XML::XPath::Node::Namespace->new(@_)); }
    };
    return($self->$AUTOLOAD(@_));
  } else {
    croak "No such method: $AUTOLOAD\n";
  }
}

sub DESTROY { } # do nothing but define in case && to calm test warnings

127;
