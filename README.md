# FEEMU-OPEN
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
1. Download this project and unzip it into a folder;
5. The bicubic B-spline interpolation C++ MEX file has already been created. However, if you have changed the source code, please create it again.
**On MacOS platform**
    * Install Xcode on your mac;
    * Type the following command in MATLAB command window;
  ``
            mex -v -setup C;
            mex -v -setup C++; 
  ``
    * Edit and save your C++ code in file `BicubicBsplineInterp.cpp`;
    * Copy the former file to your work directory, and then type the following command in the command window:
``
            mex BicubicBsplineInterp.cpp
``
    * You will get a file `BicubicBsplineInterp.mexmaci64` in your work directory. Finally you can use it like regular MATLAB function.

    **On Windows platform**
    * Install C and C++ compiler. Here the free MinGW-w64 C/C++ complier is recommended. Please check the compatible version from [MATLAB support](https://se.mathworks.com/matlabcentral/fileexchange/52848-matlab-support-for-mingw-w64-c-c-compiler). We have confirmed that MATLAB R2019a is compatable with [MinGW-w64 V6.3.0](https://sourceforge.net/projects/mingw-w64/files/Toolchains%20targetting%20Win64/Personal%20Builds/mingw-builds/6.3.0/threads-posix/seh/x86_64-6.3.0-release-posix-seh-rt_v5-rev2.7z/download) on windows 10.
     * Type the following command in MATLAB command window;
  ``
            mex -v -setup C;
            mex -v -setup C++; 
  ``
    * Edit and save your C++ code in file `BicubicBsplineInterp.cpp`;
    * Copy the former file to your work directory, and then type the following command in the command window:
``
            mex BicubicBsplineInterp.cpp
``
    * You will get a file `BicubicBsplineInterp.mexmaci64` in your work directory. Finally you can use it like regular MATLAB function.
1. Before running, you need to set some **key parameters in `paramset.m`**, such as **subset size**, **step size**. The variable you want to plot is controlled by ``param_Plot``.
2. You must pay attention on parameter **allRegion** in this script. It controls the ROI shape. It has a form of row vector with elements of 1 and/or 2. The number 1 and 2 denotes the selection of a rectangular region and a polygon region, respectively. 
   For instance, we set ``allRegion = [1,2,2]``. It means we first select a rectangular region. Then two polygon regions are removed from the selected rectangular ROI. Note that when you are selecting a rectangular region, you need hold the mouse and drag it.
3. Run `demo.m`. In the first pop-up window select one reference image, and in the second pop-up window select a deformed image or a set of deformed images. The number of elements in this vector should be more than 1. 
4. Select the ROIs following **Step 3**. After specifying all ROIs, you need to specify a seed points. It is recommended to put it at the place with smaller displacement.
5. Please wait for the software to run. The running information will display on the Command Window
 ```
 Matching method: IC-GN-RG; 
Subset size: 25 * 25;  
Step: 5;
Processing finished :100 % ...
Speed: 2.038e+03 points/s
Completed in 3.965 seconds
Mean iteration: 1.63
Img_Simu_0001.bmp is matching...
```
1. The results are saved in the same folder with the same file name but format of `.mat`;
2. If you want to rerun DIC, you need to remove ``Params.mat`` and the result file ``*.mat`` in the image folder. If you want to rerun but keep the same parameters, then you need to remove the result file ``*.mat`` while keeping ``Params.mat``.

***
## FEMU
1. The FEA solver used herein is COMSOL Multiphysics. The FEA project should be built in COMSOL.
   ![DIC](Figure/Comsol.jpg) 
    <center>Figure 2. Comsol interface</center>
2. First prepare the DIC results. The file could either from our open-source software. As mentioned before. The data file from VIC-2D (commercial software from Correlated solution) is also accepted as the input. However, the data file from VIC-2D should be prepared by running file ``Main_ConvertVICDataFormat.m``. To this aim, the data must be exported as ``.mat`` format in VIC-2D. The path where the DIC results are saved should be specified in variable ``folerName``. The reformated data will be saved in a subfolder ``folerName/formatVICData``. All file will be saved as the same file name but in the subfolder. Besides that, some key parameter in DIC are saved in ``Params.mat`` in the same subfolder. 
3. The mesh in COMSOL should be exported with format of ``.nas``. Save it at a certain folder and remember the file path. Please rename the mesh as ``Mesh.nas``. 
4. A key issue is the communication between COMSOL and MATLAB. To do that, we need to
  - Prepare the COMSOL project.
   - Right click ``Export`` in COMSOL and export ``Data``. Choose ``solid.elogxx``, ``solid.elogxy``, and ``solid.elogyy`` in the folder. Select one more folder and export ``u``, ``v``. 
  <p align="middle">
    <img src="Figure/ExportDataComsol.jpg" height="300" />
  </p>
    <center>Figure 3. Data exporting in COMSOL</center>
   
   - Save the project as a MATLAB script ``.m``.
   - Please check ``Orthotropic_model_demo.m`` carefully. You need to make some modification on this file. Please see all parameters passed through ``Params_FEMU``.
5. In order to run FEMU-OPEN successfully. You should not directly open MATLAB. Instead you need to run the codes through ``COMSOL with MATLAB``.
5. Several parameters need to be set in ``FEMU_OPEN_MAIN.m``.
   - ``Params_FEMU.folder_Model``, the path where the MATLAB version COMSOL model being saved.
   - ``Params_FEMU.file_params_DIC``, the DIC data file or the reformated DIC data from VIC-2D.
   -  ``Params_FEMU.optim_method``, It should be either 'GN' or 'NM'. The aim is to select different optimization algorithm.
   -  ``Params_FEMU.meshFile ``, the path of the exported mesh.
   -  ``Params_FEMU.fileDef_All``, cell structure of the DIC data file.
   -  ``Params_FEMU.SCALE``, the scale between the metric coordinate system (FEA model) and the pixel coordiante system (Speckle pattern image).
   -  `Params_FEMU.offset`, the offset of the origin between the two coordinate system (unit of pixels).
   -  ``R``, ``theta``, and ``L`` are the radius of the open hole, the off-axis angle of the sample and the length of the sample, respectively.
   -  ``p_Model``, the initial guess of the investigated constitutive material model parameters.
  1. Note that the COMSOL model is called in ``callComsol``.
  2. FEA displacement and strian results are saved in subfolder ``FEA_results``.
  3. If you are using ``GN`` algorithm, please check ``log.txt`` file for the parameter history.
  4. Run ``FEMU_OPEN_MAIN.m`` and wait for a while. The parameters are saved in parameter ``p_Model_optimum``. You can find it in the Workspace.

***
## Validation & Results
We euse the software to inversely identify the four orthotropic elastic parameters. The test is an uniaxial tensile test of perforated strip sample with thickness of 1 mm. The sample has an off-axis angle of 75°. The sample geometry information is given on Figure 4 (a). Force boundary condition with value of 950 N is applied. numerically generated Speckle pattern images are numerically generated to mimic the real test, see Figure 4 (b). The images are generated from the displacement fields simulated from FEA. The image size is 1501×601 pixels with a scale of 40 pixels/mm. The ground truths of the constitutive parameters E_1, E_2, ν, G_12 are 13.9 GPa, 5 GPa, 0.1, 2 GPa, respectively. In local DIC, the subset size, step size are set as 21×21 pixels, and 5 pixels respectively. The initial guess of these parameters is given as 0.9 times of the ground truths. The strain field involved in the images can be measured by DIC software. The strain fields measured by the open-source DIC software is shown in Figure 5 with a strain window size of 21×21 points.

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

## Practice the Software
We share the the orginal file to help you to practice the software. Please see the subfolder ``Demo``.
  - ``Orthotropic_model.mph``, the COMSOL Multiphysics project file.
  - ``Orthotropic_model_demo_original.m``, the MATLAB version project file.
  - ``Orthotropic_model_demo.m``, the MATLAB version project file. Some modification were made. The aim is to communicate with FEMU. The parameters can be updated in this file.
  - ``Mesh.nas``, the mesh of the FEA model. It is exported from COMSOL.
  - ``log.txt``, it saves the log information about the parameters.
  - ``VirtualImage``, the subfolder including the speckle pattern images for the open-source DIC software. You need to put your reference image and deformed image into this folder. After running the open-source DIC software, we get two files. ``Params.mat``, and ``Img_Simu_0001.mat`` in the same folder. ``Params.mat`` saves the DIC parameters. ``Img_Simu_0001.mat`` saves the DIC matching result of image ``Img_Simu_0001.bmp``.
  - ``VirtualImageVIC``, the subfolder that save speckle pattern images for VIC-2D. ``Img_Simu_0001.mat`` is the matching results exported from VIC-2D. We need to reformat the data from VIC-2D to match FEMU-OPEN requirement. Then, you need to run ``Main_ConvertVICDataFormat.m`` to reformat the data. The results are saved in a new subfolder ``formatVICData``, the data format are the same as the ones generated by our open-source DIC software.
  - ``FEA_results``, The results exported from COMSOL are saved in this subfolder. They are the displacement and strain data.
***

## Questions & Suggestions
If you wish to contribute code/algorithms to this project, or have any question or suggestion, please contact Bin Chen via binchen@kth.se. 

## Citation
Anyone who uses the code please cite: "Bin Chen, Sam Coppieters., Finite element model updating for identifying material parameters in constitutive models: a review (Draft)". If you need to redistribute the software, please keep the original author information.