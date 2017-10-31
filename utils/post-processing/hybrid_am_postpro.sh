#!/bin/bash

filepath="$1"

perl /home/shienyanglee/Desktop/Slic3r/utils/post-processing/ultimus_extrusion.pl "$filepath"
echo "pneumatic extrusion substitution done"
perl /home/shienyanglee/Desktop/Slic3r/utils/post-processing/strip_drop_before_toolchange.pl "$filepath"
echo "strip drop before toolchange done"
perl /home/shienyanglee/Desktop/Slic3r/utils/post-processing/f_every_line.pl "$filepath"
echo "F every line done"