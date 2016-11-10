#!/usr/bin/perl
#
# Version 1.01
#
# Usage : ./make_idx_thematique.pl < <fichier html de la BIL>
#
# construit un index thématique à partir d'un fichier catalogue créé par la BIL et du fichier idx_thematique.txt
use Getopt::Std;
use utf8;
#
$cnt_th = 0;          # compte des thématiques
$cnt_soft_bil = 0;    # compte des logiciels issus du catalogue BIL
$cnt_soft_idx = 0;    # compte des logiciels dans la table d'index thématique
$cnt_soft_idx_ok = 0; # compte des logiciels communs table d'index thématique / catalogue BIL
$delta_idx = 2;       # décalage des N° d'index pour tenir compte des premières pages du catalogue
#
if (!getopts('dh' || $opt_h)) {
  print "
Usage : $0  -dh <fichier html de la BIL>
        d : debug
        h : aide
 ";
  exit;
}
open (HTML_IDX_AL, ">:utf8", "index_alpha_catalogue_OSS.html");
print HTML_IDX_AL "<html>\n<head>\n <title>Index alphabétique des logiciels open source d'Inria</title>\n</head>\n<ul>\n";
foreach $i (<> ) {
  if (($name) = $i =~ /bil-SoftName.*\/tab\">(.*)\<\/a\>/) {
    $cnt_soft_bil++;
    $lc_name = lc($name);
#    print "N°$cnt_soft_bil $name, $lc_name/ ";
    $real_idx = $cnt_soft_bil + $delta_idx;
    $rev_idx{$lc_name} = $real_idx;
    print HTML_IDX_AL " <li class=\"alpha\"><a href=\"https://catalogue-floss.github.io/#/$real_idx\">$name</a></li>\n";
  }
}
print HTML_IDX_AL "</ul>\n</html>\n";
#
# création de la TOC thématique
open (INDEX_T, "<:utf8", "idx_thematique.txt");
open (HTML_IDX_TH, ">:utf8", "index_thematique_catalogue_OSS.html");
print HTML_IDX_TH "<html>\n<head>\n <title>Index thématique des logiciels open source d'Inria</title>\n</head>\n<ul>\n";
#
foreach $ligne (<INDEX_T>) {
  if ($ligne =~ /^#/) {next;}
  $cnt_th++;
  ($theme, $lst) = $ligne =~ /^(.*):(.*)$/;
  $lst =~ s/ //g;
  chop $lst;
  print HTML_IDX_TH " <details><summary>$theme</summary>\n  <ul>\n";
  foreach $j (split(/,/, $lst)){
    $cnt_soft_idx++;
    $lcj = lc($j);
    $num_soft = $rev_idx{$lcj};
    if ($opt_d) {printf "DEBUG: theme:$theme, logiciel:$j, index: $rev_idx{$lcj}\n";}
    if ($num_soft ne '') {
      $cnt_soft_idx_ok++;
      print HTML_IDX_TH "   <li><a href=\"https://catalogue-floss.github.io/#/$num_soft\">$j</a></li>\n";
    }
    else {
      print HTML_IDX_TH "   <li>$j (fiche vitrine à faire)</li>\n";
    }
  }
  print HTML_IDX_TH "  </ul>\n </details>\n";
}
print HTML_IDX_TH "</ul>\n</html>\n";
print "Compte logiciels: $cnt_soft_bil dans le catalogue BIL, $cnt_soft_idx dans l'index thematique, $cnt_soft_idx_ok indexes\n";
