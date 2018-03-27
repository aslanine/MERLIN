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
#include <algorithm>
#include <string>
#include <fstream>
#include <sstream>

#include "AcceleratorModel/AcceleratorComponent.h"
#include "AcceleratorModel/StdComponent/Collimator.h"
#include "AcceleratorModel/Apertures/CollimatorAperture.h"

#include "Collimators/PowerDeposition.h"

#include "Exception/MerlinException.h"

using namespace std;
namespace ParticleTracking {

PowerDeposition::PowerDeposition(double beam_energy, PowerOutputType ot)
{
	otype = ot;
	BeamEnergy = beam_energy;
}

void PowerDeposition::Dispose(AcceleratorComponent& currcomponent, double pos, Particle& particle, int turn)
{
	if (currentComponent != &currcomponent)
	{	
		currentComponent = &currcomponent;
	}
	temp.reset();

	temp.ElementName = currentComponent->GetQualifiedName().c_str();
	temp.s = currentComponent->GetComponentLatticePosition();
	// pos is the lost position within the element, position is the exact loss position in the lattice
	temp.position = (pos + temp.s);
	temp.length = currentComponent->GetLength();
	temp.lost = 1;
	double momentum = (1 + particle.dp()) * BeamEnergy;
	temp.energy = momentum - PhysicalConstants::ProtonMassGeV;

	//calculate 10cm interval - move to 10cm binning?
	double inter = 0.0;
	bool fin = 0;

	if(otype == nearest_element){BinSize = currentComponent->GetLength();}
	else if(otype == onem){BinSize = 1;}

        // Assume either collimator or cold element
        if(currentComponent->GetType() =="Collimator"){temp.temperature = 0;}				
        else {temp.temperature = 1;}	

	do
	{
		if ( (pos >= inter) && (pos < (inter + BinSize)) )
		{
			temp.interval = inter;
			fin = 1;
		}
		else 
		{
			inter += BinSize;
		}
	}
	while(fin == 0);
	
	temp.p = particle;
	//pushback vector
	DeadParticles.push_back(temp);
}

void PowerDeposition::Finalise()
{	
	//First sort DeadParticles according to s
	sort(DeadParticles.begin(), DeadParticles.end(), Compare_PowerData); 	

	cout << "POWERDEPOSITION:: DeadParticles.size() = " <<  DeadParticles.size() << endl;

	int outit = 0;
	int total = 0;

	switch(otype) 
	{
	case nearest_element:
		for(vector<PowerData>::iterator it = DeadParticles.begin(); it != DeadParticles.end(); ++it)
		{
			++total;
			// Start at s = min and push back the first LossData
			if (OutputLosses.size() == 0)
			{
				OutputLosses.push_back(*it); 
			}
			// If old element ++loss
			if (it->ElementName == OutputLosses[outit].ElementName)
			{
				OutputLosses[outit].lost +=1;
				// energy deposited in GeV
				OutputLosses[outit].deposition += OutputLosses[outit].energy;
			}
			// If new element OutputLosses.push_back
			else
			{
				OutputLosses.push_back(*it);
				outit++;
			}
		}
		for(vector<PowerData>::iterator it = DeadParticles.begin(); it != DeadParticles.end(); ++it)
		{
			std::pair <double,double> Ecorr;
			Ecorr.first = (*it).s;
			Ecorr.second = (*it).energy;
			EnergyCorrelation.push_back(Ecorr);
		}
	break;
	case onem:
		for(vector<PowerData>::iterator it = DeadParticles.begin(); it != DeadParticles.end(); ++it)
		{
			++total;
			//if no losses are yet stored
			if (OutputLosses.size() == 0)
			{
				OutputLosses.push_back(*it); 
				OutputLosses[outit].lost +=1;
				// energy deposited in GeV
				OutputLosses[outit].deposition += OutputLosses[outit].energy;
			}	
			// If in the same bin ++loss
			else if ((it->ElementName == OutputLosses[outit].ElementName) && (it->interval == OutputLosses[outit].interval))
			{
				OutputLosses[outit].lost +=1;
				// energy deposited in GeV
				OutputLosses[outit].deposition += OutputLosses[outit].energy;
			}
			// If new element outit.push_back and set loss to 1
			else
			{
				OutputLosses.push_back(*it);
				outit++;
				OutputLosses[outit].lost =1;
				// energy deposited in GeV
				OutputLosses[outit].deposition = OutputLosses[outit].energy;
			}
		}
		for(vector<PowerData>::iterator it = DeadParticles.begin(); it != DeadParticles.end(); ++it)
		{
			std::pair <double,double> Ecorr;
			Ecorr.first = (*it).s + (*it).interval;
			Ecorr.second = (*it).energy;
			EnergyCorrelation.push_back(Ecorr);
		}
	break;
	};
	cout << "POWERDEPOSITION:: OutputLosses.size() = " << OutputLosses.size() << endl;
	cout << "POWERDEPOSITION:: Total losses = " << total << endl;
}

void PowerDeposition::Output(std::ostream* os, double normalisation)
{
	switch(otype) 
	{	
		case nearest_element:
		(*os) << "#\tName\ts\tloss\tdeposition\ttemperature\tlength" << endl;
		for(vector <PowerData>::iterator its = OutputLosses.begin(); its != OutputLosses.end(); ++its)
		{
			(*os) << setw(34) << left << (*its).ElementName;
			(*os) << setw(34) << left << (*its).s;
			(*os) << setw(16) << left << ((*its).lost * normalisation);
			(*os) << setw(16) << left << ((*its).deposition * normalisation);
			(*os) << setw(16) << left << (*its).temperature;
			(*os) << setw(16) << left << (*its).length;
			(*os) << endl;
		}
		break;
		case onem:
		(*os) << "#\tName\ts\tbin_start\tloss\tdeposition\ttemperature\tlength" << endl;
		for(vector <PowerData>::iterator its = OutputLosses.begin(); its != OutputLosses.end(); ++its)
		{
			(*os) << setw(34) << left << (*its).ElementName;
			(*os) << setw(34) << setprecision(12) << left << ((*its).s + (*its).interval);
			(*os) << setw(16) << left << (*its).interval;
			(*os) << setw(16) << left << ((*its).lost * normalisation);
			(*os) << setw(16) << left << ((*its).deposition * normalisation);
			(*os) << setw(16) << left << (*its).temperature;
			(*os) << setw(16) << left << (*its).length;
			(*os) << endl;
		}
		break;
	}
}

void PowerDeposition::EnergyCorrelationOutput(std::ostream* os)
{
	(*os) << "#\ts\tenergy" << endl;
	for(vector < std::pair <double, double> >::iterator its = EnergyCorrelation.begin(); its != EnergyCorrelation.end(); ++its)
	{
		(*os) << setw(34) << left << (*its).first;
		(*os) << setw(34) << left << (*its).second;
		(*os) << endl;
	}
}

}; // End namespace ParticleTracking
