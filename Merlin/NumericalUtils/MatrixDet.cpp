/////////////////////////////////////////////////////////////////////////
//
// Merlin C++ Class Library for Charged Particle Accelerator Simulations
//  
// Class library version 5.01 (2015)
// 
// Copyright: see Merlin/copyright.txt
//
// Created:		16.06.15 Haroon Rafique
// Modified:	18.06.15 HR
// Last Edited: 18.06.15 HR
// 
/////////////////////////////////////////////////////////////////////////
#include "NumericalUtils/MatrixPrinter.h"

#include "TLAS/LinearAlgebra.h"

using namespace std;

//	Recursive definition of determinate using expansion by minors

//	Determinant is a recursive reduction function. For an nxn matrix it calls itself repeatedly
//	each time with an (n-1)x(n-1) sub-matrix of the previous matrix until a 2X2 matrix is found
//	and a simple determinant can be computed.

double Determinant(RealMatrix M){
	
	if(M.nrows() != M.ncols()){cout << "\n\tMatrixDet.cpp: Error: Not Square Matrix!" << endl; throw TLAS::NonSquareMatrix();}
        
	int n = M.nrows();
	int i,j,j1,j2;
	double det = 0;
	RealMatrix A(n-1);
	//~ MatrixForm(M, std::cout);
	//~ MatrixForm(A, std::cout);
	
	if (n<1){cout << "\n\tMatrixDet.cpp: Error: n<1" << endl;}
	else if (n == 1){cout << "\n\tMatrixDet.cpp: Error: n==1 should never be called" << endl;}
	else if (n == 2){det = M(0,0)*M(1,1) - M(1,0)*M(0,1);}
	else{
		det = 0;
		for(j1=0; j1<n; j1++){				// for each column in sub-matrix
			
			for(i=1; i<n; i++){				// build sub-matrix with minor elements excluded
				
				j2 = 0;						// start at first sum-matrix column position
				for(j=0; j<n; j++){			// loop to copy source matrix less one column
					
					if(j == j1){continue;}	// don't copy the minor column element
					A(i-1, j2) = M(i,j); 	// copy source element into new sub-matrix i-1 because new sub-matrix is one row (and column) smaller with excluded minors

					j2++;					// move to next submatrix column position
				}
			}
			
			det += pow(-1, 2+j1) * M(0,j1) * Determinant(A);
		}
	}
	
	return det;		
}
