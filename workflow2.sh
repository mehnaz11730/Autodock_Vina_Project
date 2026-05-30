#!/bin/bash

for EX in 6 8 10 12 14 16 18 20 ; do
  for SEED in 100 200 300 400 500 600 700 800 900 1000 ; do
    OUTNAME=statin_2_${EX}_$SEED.pdbqt
    vina --exhaustiveness $EX --seed $SEED --config config.txt --out $OUTNAME --cpu 8
  done
done

