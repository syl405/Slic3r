#!/bin/bash

filepath="$1"

perl /home/shienyanglee/Desktop/Slic3r/utils/post-processing/ultimus_extrusion.pl "$filepath"
echo "pneumatic extrusion substitution done"
perl /home/shienyanglee/Desktop/Slic3r/utils/post-processing/strip_drop_before_toolchange.pl "$filepath"
echo "strip drop before toolchange done"
perl /home/shienyanglee/Desktop/Slic3r/utils/post-processing/f_every_line.pl "$filepath"
echo "F every line done"
perl /home/shienyanglee/Desktop/Slic3r/utils/post-processing/hyrel_move_object_offsets.pl "$filepath"
echo "move object-specific offsets done"
perl /home/shienyanglee/Desktop/Slic3r/utils/post-processing/pause_lift_unlift.pl "$filepath"
echo "pause lift unlift done"
perl /home/shienyanglee/Desktop/Slic3r/utils/post-processing/material_refills.pl "$filepath"
echo "material refills done"
perl /home/shienyanglee/Desktop/Slic3r/utils/post-processing/dribble_debuggin.pl "$filepath"
echo "debug done"