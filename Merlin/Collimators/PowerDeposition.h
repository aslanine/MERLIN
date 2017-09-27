/////////////////////////////////////////////////////////////////////////
//
// Merlin C++ Class Library for Charged Particle Accelerator Simulations
//  
// Class library version 5.01 (2015)
// 
// Copyright: see Merlin/copyright.txt
//
// Created:		04.05.17 Haroon Rafique	
// Modified:	04.05.17 Haroon Rafique		
// Last Edited: 04.05.17 HR
// 
/////////////////////////////////////////////////////////////////////////
#ifndef PowerDeposition_h
#define PowerDeposition_h 1

#include <string>
#include <vector>
#include <utility>

#include "AcceleratorModel/AcceleratorComponent.h"

#include "BeamDynamics/ParticleTracking/ParticleBunch.h"

#include "BeamModel/PSTypes.h"

// PowerDeposition_h handles the output from the collimation process, 
// specifically lost particles, in order to plot energy correlation
// and power deposition loss maps.
// It is called from CollimateParticleProcess and 
// allows the user to create loss map output files, or 
// a user specified output format.

using namespace std;

namespace ParticleTracking {

// Struct used to store individual lost particle data
struct PowerData{
	string ElementName;
	PSvector p;
	double s;
	double interval;
	double position;
	double length;
	double lost;
	double deposition;
	double energy;
	int temperature;
	int turn;
	int coll_id;
	double angle;
	
	PowerData() : ElementName(), p(), s(), interval(), position(), length(), lost(), temperature(), turn(), coll_id(), angle() {}

	void reset(){ElementName="_"; s=0; interval=0; position=0; length=0; lost=0; temperature=4; turn=0; coll_id=0; angle=0;}
	
	bool operator<(PowerData other) const
	{
		return (s+position) > (other.s + other.position);
	}

	bool operator==(PowerData other) const
	{
		if(	(s+position)==(other.s + other.position)) {return true;}	
	}

	// Note that the + operator cannot preserve the particle PSvector p
	PowerData operator+(PowerData other)
	{
		// Create temporary LossData struct to hold final LossData object
		PowerData temp;
		
		// Check that the loss is in the same element
		if( ElementName == other.ElementName )
		{
			temp.ElementName = ElementName;
			temp.p = p;
			temp.s = s;
			temp.interval = interval;
			temp.position = position;
			temp.length = length;
			temp.temperature = temperature;
			temp.lost = lost + other.lost;

			return temp;
		}
		else { cout << "Warning: Dustbin Class: Cannot operator+ for losses in different elements, returning original LossData object" << endl;
		return (*this);
 		}		
	}

	PowerData operator++()
	{
		lost += 1;	
		return (*this);	
	}
};


// Comparison function used to sort losses in order of s position
inline bool Compare_PowerData (const PowerData &a, const PowerData &b){
	return (a.s + a.position + a.interval) < (b.s + b.position + a.interval);
}

inline bool Merge_PowerData(const PowerData &a, const PowerData &b){
	if ((a.s + a.position + a.interval) == (b.s + b.position + a.interval)){return true;}
}

// Possible output types for each class
typedef enum {nearest_element, onem} PowerOutputType;


class PowerDeposition
{

public:

	// Constructor
	PowerDeposition(double beam_energy, PowerOutputType otype = nearest_element);
	// Destructor
	~PowerDeposition();
	
	// Finalise will call any sorting algorithms and perform formatting for final output
	virtual void Finalise();
	
	// Perform the final output
	virtual void Output(std::ostream* os, double normalisation);
	
	// Perform energy correlation output
	virtual void EnergyCorrelationOutput(std::ostream* os);

	// Called from CollimateProtonProcess::DeathReport to add a particle to the dustbin
	virtual void Dispose(AcceleratorComponent& currcomponent, double pos, Particle& particle, int turn = 0);

	// Output type switch
	PowerOutputType otype;

	// Temporary LossData struct use to transfer data
	PowerData temp;

	// Vector to hold the loss data
	vector <PowerData> DeadParticles;

	// Vector to hold output data
	vector <PowerData> OutputLosses;
	
	// Vector to hold energy correlation losses
	vector < std::pair <double, double> > EnergyCorrelation;

protected:
    AcceleratorComponent* currentComponent;
    double BeamEnergy;
    double BinSize;

private:
};

} //End namespace ParticleTracking

#endif
