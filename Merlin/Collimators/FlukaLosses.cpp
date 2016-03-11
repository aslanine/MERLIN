/////////////////////////////////////////////////////////////////////////
//
// Merlin C++ Class Library for Charged Particle Accelerator Simulations
//  
// Class library version 5.01 (2015)
// 
// Copyright: see Merlin/copyright.txt
//
// Created:		25.02.16 Haroon Rafique	
// Modified:		
// Last Edited: 
// 
/////////////////////////////////////////////////////////////////////////
#include <algorithm>
#include <string>
#include <fstream>
#include <sstream>

#include "AcceleratorModel/AcceleratorComponent.h"
#include "AcceleratorModel/StdComponent/Collimator.h"
#include "AcceleratorModel/Apertures/CollimatorAperture.h"

#include "Collimators/FlukaLosses.h"

#include "Exception/MerlinException.h"

namespace Collimation{

FlukaLosses::FlukaLosses()
 : on_0(0), on_1(1), on_2(0), on_3(0), on_4(1), on_5(0), on_6(0)
{
	
}
FlukaLosses::FlukaLosses(bool zero, bool one, bool two, bool three, bool four, bool five, bool six)
 : on_0(zero), on_1(one), on_2(two), on_3(three), on_4(four), on_5(five), on_6(six)
{
	// 0 = any interaction (all set to on)
	if(on_0){
		on_1 = 1; // 1 = nuclear inelastic
		on_2 = 1; // 2 = nuclear elastic
		on_3 = 1; // 3 = pp/pn elastic
		on_4 = 1; // 4 = pp/pn single diffractive
		on_5 = 1; // 5 = coulomb
		on_6 = 1; // 6 = Rutherford
	}	
}
void FlukaLosses::Record(AcceleratorComponent& currcomponent, double pos, Particle& particle, int turn)
{
	//~ cout << "\nFlukaLosss :: particle.type() = "<< particle.type() << endl;
	// Have to check p.type() to see if we are recording that type of loss
	if( on_0 || (particle.type() == 1 && on_1) || (particle.type() == 2 && on_2) || (particle.type() == 3 && on_3) || (particle.type() == 4 && on_4) || (particle.type() == 5 && on_5) || (particle.type() == 6 && on_6) ){
		
		//~ cout << "FlukaLosses : Storing loss " << particle.type() << endl;
		// If current component is a collimator we store the loss, otherwise we do not
		if (currentComponent != &currcomponent)
		{	
			currentComponent = &currcomponent;
		}
		temp.reset();
		
		Collimator* aCollimator = dynamic_cast<Collimator*>(&currcomponent);
		bool is_collimator = aCollimator;
	
		if(is_collimator){	
			temp.ElementName = currentComponent->GetQualifiedName().c_str();
			temp.s = currentComponent->GetComponentLatticePosition() + pos;
			temp.lost = 1;			
			temp.coll_id = currentComponent->GetCollID();
			temp.turn = turn;
			
			const CollimatorAperture* tap= dynamic_cast<const CollimatorAperture*> (currentComponent->GetAperture());
			temp.angle = tap->GetCollimatorTilt();
			temp.x_offset = tap->GetEntranceXOffset();
			temp.y_offset = tap->GetEntranceYOffset();
			
			temp.p = particle;
			
			//pushback vector
			RecordedInteractions.push_back(temp);
		}
	}

}

void FlukaLosses::Finalise()
{
	OutputInteractions = RecordedInteractions;
	// At the moment we require no further selection or sorting
	//~ for(vector <FlukaLossData>::iterator its = RecordedInteractions.begin(); its != RecordedInteractions.end(); ++its)
	//~ {
		//~ if( (*its).p.type() == 1 || (*its).p.type() == 4 ){
				//~ OutputInteractions.push_back(*its);
		//~ }		
	//~ }
}

void FlukaLosses::Output(std::ostream* os)
{
	cout << "\nFlukaLosses OutputInteractions size = " << OutputInteractions.size() << ", RecordedInteractions.size() = " << RecordedInteractions.size() << endl;
	(*os) << "#\t1=icoll\t2=c_rotation\t3=s[m]\t4=x[mm]\t5=xp[mrad]\t6=y[mm]\t7=yp[mrad]\t8=nabs\t9=np\t10=ntu" << endl;
	for(vector <FlukaLossData>::iterator its = OutputInteractions.begin(); its != OutputInteractions.end(); ++its)
	{
		(*os) << setw(16) << left << setprecision(12) << (*its).coll_id;
		(*os) << setw(20) << left << setprecision(12) << (*its).angle;
		(*os) << setw(20) << left << setprecision(12) << (*its).s;
		(*os) << setw(20) << left << setprecision(12) << ((*its).p.x() - (*its).x_offset)/1E3;
		(*os) << setw(20) << left << setprecision(12) << ((*its).p.xp())/1E3;
		(*os) << setw(20) << left << setprecision(12) << ((*its).p.y() - (*its).y_offset)/1E3;
		(*os) << setw(20) << left << setprecision(12) << ((*its).p.yp())/1E3;
		(*os) << setw(20) << left << setprecision(12) << (*its).p.type();
		(*os) << setw(20) << left << setprecision(12) << (*its).p.id();
		(*os) << setw(20) << left << setprecision(12) << (*its).turn;			
		(*os) << endl;
	}	
}

}
