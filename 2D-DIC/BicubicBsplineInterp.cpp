#include <stdio.h>
#include "mex.h"
//#include <string.h>
#include <math.h>

using namespace std;
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    double M,N;
    int I,J;
    double *ImDef;
    double *PcoordPr;
    const mwSize *dim_ImDef;
    const mwSize *dim_Pcoord;

    double MBT[4*4] = {-1.0/6.0,  3.0/6.0, -3.0/6.0, 1.0/6.0,\
                        3.0/6.0, -6.0/6.0,  0.0/6.0, 4.0/6.0,\
                       -3.0/6.0,  3.0/6.0,  3.0/6.0, 1.0/6.0,\
                        1.0/6.0,  0.0/6.0,  0.0/6.0, 0.0/6.0};
    
    // get the first input
    dim_ImDef = mxGetDimensions(prhs[0]);
    ImDef = mxGetPr(prhs[0]);
    M     = *dim_ImDef; // size of the matrix
    N     = *(dim_ImDef+1);
    
    // get the second input
    dim_Pcoord = mxGetDimensions(prhs[1]);
    PcoordPr = mxGetPr(prhs[1]);
    I        = *dim_Pcoord+1; // size of the matrix
    J        = *(dim_Pcoord+1);
    
    double PcoordInt[I*J];
    double xInt[I*J];
    double deltaX[I*J];
    double deltaMatX[I*J];
    double deltaMatY[I*J];
    
    
    int indx;
    int indx1;
    for(int i=0; i<I-1;i++){
        for(int j=0; j<J;j++){
            indx = i*J+j;
            xInt[indx] = floor(PcoordPr[indx]);
            deltaX[indx] = PcoordPr[indx]-xInt[indx];
        }
    }
    int j1;
    for(int i=0; i<I;i++){
        for(int j=0; j<J;j++){
            indx = i*J+j;
            j1   = 3*j;
            deltaMatX[indx] = MBT[i*4]*deltaX[j1]*deltaX[j1]*deltaX[j1]+MBT[i*4+1]*deltaX[j1]*deltaX[j1]+MBT[i*4+2]*deltaX[j1]+MBT[i*4+3];
            deltaMatY[indx] = MBT[i*4]*deltaX[j1+1]*deltaX[j1+1]*deltaX[j1+1]+MBT[i*4+1]*deltaX[j1+1]*deltaX[j1+1]+MBT[i*4+2]*deltaX[j1+1]+MBT[i*4+3];
       }
    }
    
    // interpolation
    int indxImg;
    double Temp;
    double defIntp[J];
    for(int j=0; j<J; j++){
        Temp = 0;
        for(int k=-1; k<=2; k++){
            for(int t=-1; t<=2; t++){
                indxImg = (xInt[3*j+1]+k-1)*M+(xInt[3*j]+t-1);
                Temp = Temp+ImDef[indxImg]*deltaMatX[(t+1)*J+j]*deltaMatY[(k+1)*J+j];
            }
        }
        defIntp[j] = Temp;
    }
    
    // Ouput the results
    plhs[0] = mxCreateDoubleMatrix(J,1,mxREAL);
    double* pr = mxGetPr(plhs[0]); 
    for(int j=0; j<J;j++){
        pr[j] = defIntp[j];
    }
    
}
