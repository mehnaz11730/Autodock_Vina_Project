#!/bin/bash

## 1HWJ crystal ligand redocking
## Ligand: cerivastatin, residue name 116, chain A

## Download 1HWJ
wget -N https://files.rcsb.org/download/1HWJ.pdb.gz
gunzip -kf 1HWJ.pdb.gz

## Extract crystal ligand A
awk 'substr($0,1,6)=="HETATM" && substr($0,18,3)=="116" && substr($0,22,1)=="A" {print}' 1HWJ.pdb > crystal_ligand_A.pdb

## Check ligand
echo "Crystal ligand atom count:"
wc -l crystal_ligand_A.pdb
head crystal_ligand_A.pdb

## Prepare receptor: remove ligand, ADP and water
grep '^ATOM' 1HWJ.pdb > 1HWJ_clean.pdb
echo "END" >> 1HWJ_clean.pdb

/home/mehnaz/app/mgltools_x86_64Linux2_1.5.7/bin/pythonsh \
/home/mehnaz/app/mgltools_x86_64Linux2_1.5.7/MGLToolsPckgs/AutoDockTools/Utilities24/prepare_receptor4.py \
-r 1HWJ_clean.pdb \
-o 1HWJ_clean.pdbqt

## Prepare ligand
obabel crystal_ligand_A.pdb -O ligand.pdb -h

/home/mehnaz/app/mgltools_x86_64Linux2_1.5.7/bin/pythonsh \
/home/mehnaz/app/mgltools_x86_64Linux2_1.5.7/MGLToolsPckgs/AutoDockTools/Utilities24/prepare_ligand4.py \
-l ligand.pdb \
-o ligand.pdbqt

## Run docking
vina --config config.txt --out docking.pdbqt --cpu 8

## Convert docking result to pdb
obabel docking.pdbqt -O docking.pdb

## Open result in PyMOL
pymol 1HWJ.pdb crystal_ligand_A.pdb docking.pdb

## Show docking score
less docking.pdbqt