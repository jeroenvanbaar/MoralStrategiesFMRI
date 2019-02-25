# MoralStrategiesFMRI
Code accompanying the manuscript: Van Baar, J.M., Chang, L.J., & Sanfey, A.G. (in press). The computational and neural substrates of moral strategies in social decision-making. Nature Communications.

The data can be found at http://hdl.handle.net/11633/aabwlrrn.

For full descriptions of all data & analyses, please refer to the paper. For questions please contact Jeroen at jeroen_van_baar@brown.edu.


*** Contents

Code contains:
- All code used to fit & compare the utility models described in the paper
- All code used to run preprocessing and GLM analysis on the fMRI data
- All code used to carry out the inter-subject RSA analyses
- All code used to generate figures
- Specification of the Anaconda environment used to run the Python-based analyses

Data (http://hdl.handle.net/11633/aabwlrrn) contains:
- Behavioral data (Hidden Multiplier Trust Game task; Social Value Orientation slider measure; Guilt Inventory questionnaire; Demographics)
- HMTG task data from behavioral replication experiment
- fMRI data (raw DICOM files & experiment logs; GLM-derived beta maps used as inputs to all inter-subject representational similarity analyses described in the paper)
- 200-parcel brain parcellation from De la Vega and colleagues (parcellation map can be retrieved from https://neurovault.org/images/39711/, and see http://www.jneurosci.org/content/36/24/6553 for the parcellation method)


*** General notes on code

1. Preprocessing and GLM analysis on the fMRI data were done using SPM12 in Matlab. All other code was written in Python. Python package versions can be found in Anaconda environment specification. .ipynb files can be read as a Jupyter Notebook, which contains markdown cells with subheadings and some notes. Figures are generated in these notebooks.

2. Much of the heavy lifting in this code won't run immediately on your computer, since it was written to work with the high-performance computing cluster at the Donders Institute ('Torque'). If you have questions about how to modify the code to get it to work for you, don't hesitate to email JeroenÂ â€“Â but you will most likely be able to figure it out by reading the Matlab/SPM scripts, the Jupyter notebooks, and the .py function files.


*** Notes on fMRI data

1. The four HMTG task screens have different names in the dataset versus the paper. Here is the key:
'Face' in data set: called the 'player screen' in paper. Here, the Investor (player A) is introduced using a blurred face.
'Inv' in data set: 'investment screen' in paper.
'Mult' in data set: 'decision screen' in paper. 'Mult' refers to the multiplier, which is revealed on this screen â€“Â but more importantly this is the screen where participants are instructed to make their decision, hence 'decision screen'.
'Dec' in data set: 'response screen' in paper. 'Dec' refers to the participants' reporting their decision using the slider on the screen. Better captured by the term 'response'.

2. Each participant's fMRI data folder in Data/4.fMRI-preprocessed contains:
* Folder 'func' with the participant's preprocessed functional Niftis from run 1 and 2. These can be used directly in a GLM analysis. Preprocessing was applied as described in the paper's Methods section.
* Folder 'SOTS' with the stimulus onset times logged during the participant's fMRI experiment, in Matlab file format. These can be used when defining the GLM (see firstLevel.m in GLM code folder for example).
* Folder 'RPs' with the realignment parameters obtained during preprocessing of the functional images. These can be used as nuisance regressors in the GLM (see firstLevel.m in GLM code folder for example).
* Folder 'anat' with the participant's structural Nifti (defaced using mri_deface, https://surfer.nmr.mgh.harvard.edu/fswiki/mri_deface).

The raw multi-echo DICOM files are available upon reasonable request from the authors (email jeroen_van_baar@brown.edu). Since these files have been archived in a physical location, it will take a little while to retrieve them.
