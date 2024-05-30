# FEEMU-DIC
The tutorial of this software will be uploaded after the acceptance of the manuscript.

This is an open-source finite element model updating (FEMU) software. **It includes a digital image correlation (DIC) software and a fundamental FEMU component.** The aim is to help the researchers who are ineterested to strain field measurement and/or inverse parameter identification. We also expect it to help the material scientists for their research. **Note that the DIC software introduced here can be used alone for strain fields measurement, and it works well.**
We may continue updating this software. More functions may be added into this software. You are welcome to star this project.
## Requirements
- Some knowledge about FEMU. We recommend you to read our review about FEMU.
- Basic knowledge about COMSOL and numerical simulation.
- Basic coding skills with MATLAB.
- Access to COMSOL and MATLAB.
- Camera and mechanical testing machine.
## Expected Outcomes
- Identify the orthotropic elastic parameters of your material.
- Develop your own software based on our code
- You can use the DIC software alone for strain measurement.
***
## DIC Software
<p align="middle">
  <img src="Figure/DIC.jpg" height="300" />
</p>
<center>Figure 1. Example of DIC matching</center>

### Usage
The tutorial of this software will be uploaded after the acceptance of the manuscript.

***
## Validation & Results
We use the software to inversely identify the four orthotropic elastic parameters. The test is an uniaxial tensile test of perforated strip sample with thickness of 1 mm. The sample has an off-axis angle of 75°. The sample geometry information is given on Figure 4 (a). Force boundary condition with value of 950 N is applied. numerically generated Speckle pattern images are numerically generated to mimic the real test, see Figure 4 (b). The images are generated from the displacement fields simulated from FEA. The image size is 1501×601 pixels with a scale of 40 pixels/mm. The ground truths of the constitutive parameters E_1, E_2, ν, G_12 are 13.9 GPa, 5 GPa, 0.1, 2 GPa, respectively. In local DIC, the subset size, step size are set as 21×21 pixels, and 5 pixels respectively. The initial guess of these parameters is given as 0.9 times of the ground truths. The strain field involved in the images can be measured by DIC software. The strain fields measured by the open-source DIC software is shown in Figure 5 with a strain window size of 21×21 points.

<p align="middle">
  <img src="Figure/Numerical test.jpg" height="300" />
</p>
<center>Figure 4. Numerical test configuaration: (a) sample geometry and boundary contition, (b) the synthetic speckle pattern images</center>
<p align="middle">
  <img src="Figure/DIC results.jpg" height="300" />
</p>
<center>Figure 4. Numerical test configuaration: (a) sample geometry and boundary contition, (b) the synthetic speckle pattern images</center>

In the inverse parameter identification, open-source DIC software and VIC-2D are used to calculate the strain fields, while GN and NM are used as the optimization algorithm, respectively. The identified parameters are given in Table 1. Different combinations of DIC software and optimization algorithm can all lead to decent estimation of the parameters. 

<center>Table 1. The parameter identification results with different combinations of DIC software and optimization algorithms</center>

|Parameters|	E<sub>1</sub>$~$(GPa)|	E<sub>2</sub>$~$(GPa)	|ν	|G<sub>12</sub>$~$(GPa)|	Running time (s)|
|----------|-------------|--------------|---|----------|--------------------|
|Reference value|	13.9|	5	|0.1	|2	|\\ |
|GN + Open-source DIC|	13.887|	5.3914|	0.1051|	2.0027|	76|
|GN + VIC-2D|	13.917	|5.0159	|0.0987|	1.9996|	71|
|NM + Open-source DIC|	13.735	|5.7786|	0.0879	|1.9933|	312|
|NM + VIC-2D|	13.824|	5.1887|	0.0873|	2.0069|	276|

## Questions & Suggestions
If you wish to contribute code/algorithms to this project, or have any question or suggestion, please contact Bin Chen via binchen@kth.se. 

## Citation
Anyone who uses the code please cite: "Bin Chen, Sam Coppieters., Finite element model updating for identifying material parameters in constitutive models: a review (Draft)". If you need to redistribute the software, please keep the original author information.
