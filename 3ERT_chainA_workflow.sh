#!/bin/bash

## 3ERT crystal ligand redocking
## Protein: human estrogen receptor alpha ligand-binding domain
## Ligand: OHT, 4-hydroxytamoxifen
## Receptor preparation removes ligand and water because they are HETATM records

## Download 3ERT
wget -N https://files.rcsb.org/download/3ERT.pdb.gz
gunzip -kf 3ERT.pdb.gz

## Check ligand and chain information
echo "HETATM residue names:"
grep "^HETATM" 3ERT.pdb | awk '{print $4}' | sort | uniq -c

echo "Protein chains:"
grep "^ATOM" 3ERT.pdb | awk '{print $5}' | sort | uniq

## Extract crystal ligand OHT from chain A
awk 'substr($0,1,6)=="HETATM" && substr($0,18,3)=="OHT" && substr($0,22,1)=="A" {print}' \
3ERT.pdb > crystal_ligand_3ERT_A.pdb

echo "Crystal ligand atom count:"
wc -l crystal_ligand_3ERT_A.pdb
head crystal_ligand_3ERT_A.pdb

## Prepare receptor: chain A protein only
## This removes OHT, HOH and other HETATM records
awk 'substr($0,1,4)=="ATOM" && substr($0,22,1)=="A" {print}' \
3ERT.pdb > 3ERT_chainA_clean.pdb

echo "END" >> 3ERT_chainA_clean.pdb

echo "Receptor atom count:"
wc -l 3ERT_chainA_clean.pdb
head 3ERT_chainA_clean.pdb

## Convert receptor to PDBQT
/home/mehnaz/app/mgltools_x86_64Linux2_1.5.7/bin/pythonsh \
/home/mehnaz/app/mgltools_x86_64Linux2_1.5.7/MGLToolsPckgs/AutoDockTools/Utilities24/prepare_receptor4.py \
-r 3ERT_chainA_clean.pdb \
-o 3ERT_chainA_clean.pdbqt

## Prepare ligand: add hydrogens using OpenBabel
obabel crystal_ligand_3ERT_A.pdb -O ligand_3ERT_A.pdb -h

## Convert ligand to PDBQT
/home/mehnaz/app/mgltools_x86_64Linux2_1.5.7/bin/pythonsh \
/home/mehnaz/app/mgltools_x86_64Linux2_1.5.7/MGLToolsPckgs/AutoDockTools/Utilities24/prepare_ligand4.py \
-l ligand_3ERT_A.pdb \
-o ligand_3ERT_A.pdbqt

## Run docking
vina --config 3ERT_config_full.txt --out 3ERT_docking_full.pdbqt --cpu 8

## Convert docking result to PDB
obabel 3ERT_docked.pdbqt -O 3ERT_docked.pdb

## Show docking score
head -30 3ERT_docked.pdbqt