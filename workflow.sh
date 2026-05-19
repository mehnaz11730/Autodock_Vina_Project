#!/bin/bash

## Download
# COMPLEX OF THE CATALYTIC PORTION OF HUMAN HMG-COA REDUCTASE WITH HMG AND COA
wget -N https://files.rcsb.org/download/1DQ8.pdb1.gz
gunzip -kf 1DQ8.pdb1.gz

# Cerivastatin Conformer3D_COMPOUND_CID_446156.sdf from https://pubchem.ncbi.nlm.nih.gov/compound/446156
wget -O Conformer3D_COMPOUND_CID_446156.sdf \
"https://pubchem.ncbi.nlm.nih.gov/rest/pug/compound/CID/446156/SDF?record_type=3d"
echo Conformer3D_COMPOUND_CID_446156.sdf

## Prep protein
grep -v HOH 1DQ8.pdb1 > 1DQ8_clean.pdb
#./MGLToolsPckgs/AutoDockTools/Utilities24/prepare_receptor4.py
/home/mehnaz/app/mgltools_x86_64Linux2_1.5.7/bin/pythonsh \
/home/mehnaz/app/mgltools_x86_64Linux2_1.5.7/MGLToolsPckgs/AutoDockTools/Utilities24/prepare_receptor4.py \
-r 1DQ8_clean.pdb \
-o 1DQ8_clean.pdbqt


## Prep ligand
obabel Conformer3D_COMPOUND_CID_446156.sdf -O Conformer3D_COMPOUND_CID_446156.sdf.pdb --gen3d
# Preparing the python script from ~/app/mgltools folder
/home/mehnaz/app/mgltools_x86_64Linux2_1.5.7/bin/pythonsh \
/home/mehnaz/app/mgltools_x86_64Linux2_1.5.7/MGLToolsPckgs/AutoDockTools/Utilities24/prepare_ligand4.py \
-l ligand.pdb \
-o ligand.pdbqt

obabel Conformer3D_COMPOUND_CID_446156.sdf -O ligand.pdb --gen3d && /home/mehnaz/app/mgltools_x86_64Linux2_1.5.7/bin/pythonsh /home/mehnaz/app/mgltools_x86_64Linux2_1.5.7/MGLToolsPckgs/AutoDockTools/Utilities24/prepare_ligand4.py -l ligand.pdb -o ligand.pdbqt
# run pymol to get the bounds
conda activate pymol_env
pymol 1DQ8_clean.pdb

# run the docking analysis
vina --config config.txt --out docking.pdbqt --cpu 8
pymol -c -docking 1DQ8_clean_model.pdb Conformer3D_COMPOUND_CID_446156.sdf
pymol docking.pdbq

#CONVERTED DOCKING_PDBQT_FILE TO_PDB
obabel docking.pdbqt -O docking.pdb

less docking.pdbqt

