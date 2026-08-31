#!/bin/bash

## 1M17 crystal ligand redocking
## Ligand: erlotinib, residue name AQ4, chain A

## Download 1M17
wget -N https://files.rcsb.org/download/1M17.pdb.gz
gunzip -kf 1M17.pdb.gz

## Extract crystal ligand AQ4 from chain A
awk 'substr($0,1,6)=="HETATM" && substr($0,18,3)=="AQ4" && substr($0,22,1)=="A" {print}' 1M17.pdb > 1M17_crystal_ligand_A.pdb

## Check ligand
echo "Crystal ligand atom count:"
wc -l 1M17_crystal_ligand_A.pdb
head 1M17_crystal_ligand_A.pdb

## Prepare receptor protein: remove ligand and water
grep '^ATOM' 1M17.pdb > 1M17_clean.pdb
echo "END" >> 1M17_clean.pdb

/home/mehnaz/app/mgltools_x86_64Linux2_1.5.7/bin/pythonsh \
/home/mehnaz/app/mgltools_x86_64Linux2_1.5.7/MGLToolsPckgs/AutoDockTools/Utilities24/prepare_receptor4.py \
-r 1M17_clean.pdb \
-o 1M17_clean.pdbqt

## Prepare ligand
obabel 1M17_crystal_ligand_A.pdb -O 1M17_ligand.pdb -h

/home/mehnaz/app/mgltools_x86_64Linux2_1.5.7/bin/pythonsh \
/home/mehnaz/app/mgltools_x86_64Linux2_1.5.7/MGLToolsPckgs/AutoDockTools/Utilities24/prepare_ligand4.py \
-l 1M17_ligand.pdb \
-o 1M17_ligand.pdbqt

## Run docking
vina --config 1M17_config_ligand.txt --out 1M17_docking_ligand.pdbqt --cpu 8

## Convert docking result to pdb
obabel 1M17_docking_full.pdbqt -O 1M17_docking_full.pdb

## Open result in PyMOL
#pymol 1M17.pdb 1M17_crystal_ligand_A.pdb 1M17_docking_full.pdb

## Show docking score
#less 1M17_docking_full.pdbqt