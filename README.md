# kPreproc

##Dependencies:

- SPM8

- from the wagerlab: SCN_Core_Support and diagnostics toolboxes (http://wagerlab.colorado.edu/tools)


##Steps
Create File Structure
- edit and run a__makeDirs.m. This will create the necessary file structure in an existing folder.

Import Dicoms
- open and edit the two files in the A_Import folder. These scripts convert the anatomical and functional dcm files to nii. They also rename the images and move them to appropriate folders. 

- this step also drops unwanted volumes from the beginning of each functional run. Take heed of this number and include it in a__PREPROC.m. 

a__PREPROC.m
This is the primary script for the toolbox. It will guide you through manual alignment of the imported nii’s, automate all remaining steps through smoothing, and then guide you through manual quality assurance of coregistration. QA info can be found in the sub qa directories (e.g. s001/qa).

###To run:
open and edit the “settings” section in a__PREPROC.m.  

- the first step is manual realignment. As this step is a bit difficult to get right in one shot, I typically run it in matlab cell mode. Note, if you mess-up the initial coregistration between  images, you may need to re-import.

- After manually aligning images, I typically comment out this section, and run the entire script. 

- Towards the end, it will ask you to check co-registration for each sub and run. As with manual alignment, this requires interacting with the gui and command window.

##Note about manual alignment
- the “new segment” tool is quite good at segmentation and normalization, given rough initial alignment (origin on the AC, and proper orientation along planes (sagittal= acpc plane) ). Accordingly, the first thing the script will do is open the SPM gui and load the first anatomical image. (Read the spm8 manual for how to use it). 

- After entering appropriate parameters, reorient all, and select every image for that sub (anat and all functionals for all runs). The script will pause at this point until you interact with the command window.  —Press “1” and then “enter” to confirm that everything looks good — the script will then run for a while and then bring up the next anat img.

- It is generally good practice to check alignment of the anat and funcs (1 per run) after each sub.


