#!/usr/bin/perl
#
# Version 1.02
#
# Usage : ./make_idx_thematique.pl --L1 <logiciels avec fiche vitrine> --L2 <logiciels sans fiche vitrine>
#
# L1 (fiche vitrine existante) et L2 (pas de fiche vitrine) sont les fichiers html générés par la BIL
#
# construit deux index thématique et alphabétique à partir des fichiers L1, L2 et idx_thematique.txt
# v1.02: 
#
use Getopt::Long;
use utf8;
#
$cnt_th = 0;          # compte des thématiques
$cnt_soft_bil_L1 = 0; # compte des logiciels issus du catalogue L1 de la BIL
$cnt_soft_bil_L2 = 0; # compte des logiciels issus du catalogue L2 de la BIL (pas de fiche vitrine)
$cnt_url_bil_L1 = 0;  # compte des url de logiciels issus du catalogue L1 BIL
$cnt_url_bil_L2 = 0;  # compte des url de logiciels issus du catalogue L2 BIL
$cnt_soft_idx = 0;    # compte des logiciels dans la table d'index thématique
$cnt_soft_idx_ok = 0; # compte des logiciels communs table d'index thématique / catalogue L1 de la BIL
$cnt_soft_url_ok = 0; # compte des logiciels communs table d'index thématique / catalogue L2 de la BIL
$delta_idx = 2;       # décalage des N° d'index pour tenir compte des premières pages du catalogue
#
my $L1 = '', $L2 = '', $opt_d;
GetOptions ('L1=s' => \$L1, 'L2=s' => \$L2, 'debug' => \$opt_d);
#
open (HTML_IDX_AL, ">:utf8", "index_alpha_catalogue_OSS.html");
open (INP_L1, "<:utf8", $L1);
open (INP_L2, "<:utf8", $L2);
#
foreach $i (<INP_L1> ) {
  if (($name) = $i =~ /bil-SoftName.*\/tab\">(.*)\<\/a\>/) {
    $cnt_soft_bil_L1++;
    $lc_name = lc($name);
    $real_idx = $cnt_soft_bil_L1 + $delta_idx;
    $rev_idx{$lc_name} = $real_idx;
  }
  elsif (($url) = $i =~ /bil-SoftWebSiteValue\"\>\<a href=\"(.*)\"\>http/) {
    $name2url{$lc_name} = $url;
    $cnt_url_bil_L1++;
  }
}
foreach $i (<INP_L2> ) {
  if (($name) = $i =~ /bil-SoftName.*\/tab\">(.*)\<\/a\>/) {
    $cnt_soft_bil_L2++;
    $lc_name = lc($name);
    $rev_idx{$lc_name} = -1;
  }
  elsif (($url) = $i =~ /bil-SoftWebSiteValue\"\>\<a href=\"(.*)\"\>http/) {
    $name2url{$lc_name} = $url;
    $cnt_url_bil_L2++;
  }
}
# construction liste html alphabétique
print HTML_IDX_AL "<html>\n<head>\n <title>Index alphabétique des logiciels open source d'Inria</title>\n</head>\n<ul>\n";
foreach $i (sort keys %name2url) {
  $real_idx = $rev_idx{$i};
  if ($real_idx == -1) {
    $url = $name2url{$i};
    print HTML_IDX_AL " <li class=\"alpha\"><a href=\" ${url} \">$i</a></li>\n";
  }
  else {
    print HTML_IDX_AL " <li class=\"alpha\"><a href=\"https://catalogue-floss.github.io/#/$real_idx\">$i</a></li>\n";
  }
}
print HTML_IDX_AL "</ul>\n</html>\n";
#
#  construction liste html thématique
open (INDEX_T, "<", "idx_thematique.txt");
open (HTML_IDX_TH, ">:utf8", "index_thematique_catalogue_OSS.html");
print HTML_IDX_TH "<html>\n<head>\n <title>Index thématique des logiciels open source d'Inria</title>\n</head>\n<ul>\n";
#
foreach $ligne (<INDEX_T>) {
  if ($ligne =~ /^#/) {next;}
  $cnt_th++;
  ($theme, $lst) = $ligne =~ /^(.*):(.*)$/;
  $lst =~ s/, /,/g;
  chop $lst;
  print HTML_IDX_TH " <details><summary>$theme</summary>\n  <ul>\n";
  foreach $j (split(/,/, $lst)){
    $cnt_soft_idx++;
    $lcj = lc($j);
    $num_soft = $rev_idx{$lcj};
    $url = $name2url{$lcj};
    if ($opt_d) {printf "DEBUG: theme:$theme, logiciel:$j, nul_soft: $num_soft, url: $url\n";}
    if ($num_soft ne -1) {
      $cnt_soft_idx_ok++;
      print HTML_IDX_TH "   <li><a href=\"https://catalogue-floss.github.io/#/$num_soft\">$j</a></li>\n";
    }
    elsif ($url ne '') {
      $cnt_soft_url_ok++;
      print HTML_IDX_TH "   <li><a href=\" ${url} \">$j</a></li>\n";
    }
    else {
      print HTML_IDX_TH "   <li>$j</li>\n";
    }
  }
  print HTML_IDX_TH "  </ul>\n </details>\n";
}
print HTML_IDX_TH "</ul>\n</html>\n";
print "Catalogue L1: $cnt_soft_bil_L1 logiciels ($cnt_url_bil_L1 URL), catalogue L2: $cnt_soft_bil_L2 logiciels, ($cnt_url_bil_L2 URL), Index thematique: $cnt_soft_idx logiciels ($cnt_soft_idx_ok indexes, $cnt_soft_url_ok pointés)\n";
