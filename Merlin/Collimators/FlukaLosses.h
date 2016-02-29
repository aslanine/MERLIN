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
#ifndef FlukaLosses_h
#define FlukaLosses_h 1

#include <string>
#include <vector>

#include "AcceleratorModel/AcceleratorComponent.h"

#include "BeamDynamics/ParticleTracking/ParticleBunch.h"

#include "BeamModel/PSTypes.h"

// FlukaLosses allows the user to record every interaction of a tracked
// proton with all collimator jaws. For Fluka coupling only inelastic
// and single diffractive interactions need to be recorded, however this 
// class allows the user to specify which type of interactions should be
// recorded.
// -1 = no interaction
// 0 = any interaction
// 1 = nuclear inelastic
// 2 = nuclear elastic
// 3 = pp/pn elastic
// 4 = pp/pn single diffractive
// 5 = coulomb
// 6 = Rutherford
// Note that s [m], x [mm], and xp [mrad]

using namespace std;
using namespace ParticleTracking;

namespace Collimation {
	
struct FlukaLossData{
	int coll_id;
	double angle;
	double s;
	PSvector p;
	int turn;
	double lost;
	double x_offset;
	double y_offset;
	
	string ElementName;
	//~ double interval;
	//~ double position;
	//~ double length;
	
	//~ int temperature;	
	
	//~ FlukaLossData() : ElementName(), p(), s(), interval(), position(), length(), lost(), temperature(), turn(), coll_id(), angle() {}
	FlukaLossData() : ElementName(), p(), s(), lost(), turn(), coll_id(), angle() {}

	//~ void reset(){ElementName="_"; s=0; interval=0; position=0; length=0; lost=0; temperature=4; turn=0; coll_id=0; angle=0;}
	void reset(){ElementName="_"; s=0; lost=0; turn=0; coll_id=0; angle=0;}
	
	bool operator<(FlukaLossData other) const
	{
		return (s) > (other.s);
	}

	bool operator==(FlukaLossData other) const
	{
		if(	(s)==(other.s)) {return true;}	
	}

	FlukaLossData operator++()
	{
		lost += 1;	
		return (*this);	
	}
};	

class FlukaLosses
{

public:

	// Constructor
	FlukaLosses();
	FlukaLosses(bool zero, bool one, bool two, bool three, bool four, bool five, bool six);
	
	// Destructor
	~FlukaLosses();
	
	// Finalise will call any sorting algorithms and perform formatting for final output
	virtual void Finalise();
	
	// Perform the final output
	virtual void Output(std::ostream* os);

	// Called from CollimateProtonProcess::DeathReport to add a particle to the dustbin
	virtual void Record(AcceleratorComponent& currcomponent, double pos, Particle& particle, int turn = 0);

	// Temporary LossData struct use to transfer data
	FlukaLossData temp;

	// Vector to hold the loss data
	vector <FlukaLossData> RecordedInteractions;

	// Vector to hold output data
	vector <FlukaLossData> OutputInteractions;

protected:
    AcceleratorComponent* currentComponent;
    
	bool on_0; // 0 = any interaction (all set to on)
	bool on_1; // 1 = nuclear inelastic
	bool on_2; // 2 = nuclear elastic
	bool on_3; // 3 = pp/pn elastic
	bool on_4; // 4 = pp/pn single diffractive
	bool on_5; // 5 = coulomb
	bool on_6; // 6 = Rutherford

private:	
};

	
	
}
#endif
