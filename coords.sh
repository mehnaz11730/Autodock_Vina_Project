#!/bin/bash

awk '$1=="HETATM"{
x=$6;y=$7;z=$8

if(n++==0){
xmin=xmax=x
ymin=ymax=y
zmin=zmax=z
}

if(x<xmin)xmin=x
if(x>xmax)xmax=x

if(y<ymin)ymin=y
if(y>ymax)ymax=y

if(z<zmin)zmin=z
if(z>zmax)zmax=z

}
END{
print "center_x =", (xmin+xmax)/2
print "center_y =", (ymin+ymax)/2
print "center_z =", (zmin+zmax)/2

print ""

print "size_x =", (xmax-xmin)
print "size_y =", (ymax-ymin)
print "size_z =", (zmax-zmin)
}' docking.pdbqt