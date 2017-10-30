#!/bin/bash

perl /home/shienyanglee/Desktop/Slic3r/utils/post-processing/ultimus_extrusion.pl $1
perl /home/shienyanglee/Desktop/Slic3r/utils/post-processing/strip_drop_before_toolchange.pl $1
