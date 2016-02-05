#include <cstdlib>
#include <fstream>
#include <iostream>
#include <string>
#include <map>
#include <vector>

#include "AcceleratorModel/StdComponent/Collimator.h"

#include "BeamDynamics/ParticleTracking/ParticleBunch.h"

#include "Collimators/CollimatorSurvey.h"

#include "NumericalUtils/PhysicalUnits.h"

using namespace std;
using namespace PhysicalUnits;


CollimatorSurvey::CollimatorSurvey(AcceleratorModel* model, double emittance_x, double emittance_y, LatticeFunctionTable* twiss){

	AM = model;
	em_x = emittance_x;
	em_y = emittance_y;
	LFT = twiss;
}

void CollimatorSurvey::Output(std::ostream* os, int no_points){
	
	(*os) << "#name\ttype\tlength\tz\tap_px\tap_mx\tap_py\tap_my" << endl;
	
	for (AcceleratorModel::BeamlineIterator bi = AM->GetBeamline().begin(); bi != AM->GetBeamline().end(); bi++){
		
		AcceleratorComponent *ac = &(*bi)->GetComponent();

		//~ if (fabs(s - ac->GetComponentLatticePosition())> 1e-6){exit(1);}
		
		//~ Collimator* aCollimator = dynamic_cast<Collimator*>(ac);
		if(dynamic_cast<Collimator*>(ac)){

			Aperture* ap =	ac->GetAperture();
			
			//cout << "ap "<< s << " " << ac->GetName() << " " << ac->GetLength() << ((aCollimator!=NULL)?" Collimator":"");
			//if (ap != NULL) cout << " " << ap->GetMaterial();
			//cout << endl;
			
			int points = no_points;
			double lims[4];
			
			vector<double> zs;
			if (points > 0){
				for (size_t i=0; i<points; i++) {zs.push_back(i*ac->GetLength()*(1.0/(points-1)));}
			}
			//~ else{
				//~ cout << "last_sample = " << last_sample <<endl;
				//~ while (last_sample+step_size < s + ac->GetLength()){
					//~ last_sample += step_size;
					//cout << "add step " <<  last_sample << endl;
					//~ zs.push_back(last_sample-s);
				//~ }	
			//~ }
			for (size_t zi = 0; zi < zs.size(); zi++){
				double z = zs[zi];
				if (ap != NULL) {
					CollimatorSurvey::SurveyAperture(ap, z, lims);
				}
				else{
					lims[0] = lims[1] = lims[2]= lims[3] = 1;
				}
				(*os) << ac->GetName() << "\t";
				(*os) << ac->GetType() << "\t";
				(*os) << ac->GetComponentLatticePosition()+ac->GetLength() << "\t";
				(*os) << ac->GetLength() << "\t";
				(*os) << z << "\t";
				(*os) << lims[0] << "\t";
				(*os) << lims[1] << "\t";
				(*os) << lims[2] << "\t";
				(*os) << lims[3] << endl;
			}
		}

	}
	// Create a vector of all collimators
	
	// For each collimator we want to iterate along the length z and measure the half gap(s)
	// This is done by iterating x,y in PointInside(x,y,z)
	
	// at each z we output the half gaps
	
	
}



void CollimatorSurvey::SurveyAperture(Aperture* ap, double s, double *aps){
	//~ cout << "CheckAperture" << endl;
	const double step = 1e-6;
	const double max = 1.0;
	const double min = 0.0;
	
	// iterate through directions
	for (int dir=0; dir<4; dir++){
		double xdir=0, ydir=0;
		if (dir==0) {xdir=+1;}
		else if (dir==1) {xdir=-1;}
		else if (dir==2) {ydir=+1;}
		else if (dir==3) {ydir=-1;}
		
		aps[dir] = 0;
		
		// scan for limit
		double below=min, above=max;
		
		while(above-below > step){
			double guess = (above+below)/2;
			
			if (ap->PointInside(xdir*guess, ydir*guess, s)){
				below = guess;
			}
			else{
				above = guess;
			}
		}
		aps[dir] = (above+below)/2;
	}
}
