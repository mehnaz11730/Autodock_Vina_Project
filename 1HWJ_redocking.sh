#!/bin/bash

mkdir 1HWJ_redocking
cd 1HWJ_redocking

#Download 1HWJ
curl -o 1hwj.pdb https://files.rcsb.org/download/1HWJ.pdb
ls
#PYMOL_CODE
#load 1hwj.pdb
#show cartoon
#select cerivastatin, resn 116
#show sticks, cerivastatin
#select adp, resn ADP
#show sticks, adp
#SAVING OG CODE
#select crystal_cerivastatin, resn 116
#save 1hwj_crystal_cerivastatin.pdb, crystal_cerivastatin
#remove resn 116
#remove solvent
#remove resn ADP
#save 1hwj_receptor_clean.pdb

#PREPARING THE RECEPTOR
~/app/mgltools_x86_64Linux2_1.5.7/bin/pythonsh \
~/app/mgltools_x86_64Linux2_1.5.7/MGLToolsPckgs/AutoDockTools/Utilities24/prepare_receptor4.py \
-r 1hwj_receptor_clean.pdb \
-o 1hwj_receptor_clean.pdbqt \
-A hydrogens

#CALCULATING GRID CENTRE FROM THE CRYSTAL CERIVASTATIN

awk '/^HETATM/ {
x=substr($0,31,8)+0;
y=substr($0,39,8)+0;
z=substr($0,47,8)+0;
if(n++==0){xmin=xmax=x; ymin=ymax=y; zmin=zmax=z}
if(x<xmin)xmin=x; if(x>xmax)xmax=x;
if(y<ymin)ymin=y; if(y>ymax)ymax=y;
if(z<zmin)zmin=z; if(z>zmax)zmax=z
}
END{
print "center_x = "(xmin+xmax)/2;
print "center_y = "(ymin+ymax)/2;
print "center_z = "(zmin+zmax)/2;
print "size_x = "(xmax-xmin)+10;
print "size_y = "(ymax-ymin)+10;
print "size_z = "(zmax-zmin)+10;
}' 1hwj_crystal_cerivastatin.pdb

