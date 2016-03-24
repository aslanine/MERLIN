#ifndef ScatteringModel_h
#define ScatteringModel_h 1

#include <iostream>
#include <cmath>
#include <map>

#include "merlin_config.h"

#include "BeamModel/PSvector.h"

#include "BeamDynamics/ParticleTracking/ParticleBunch.h"

#include "Collimators/Material.h"
#include "Collimators/CompositeMaterial.h"
#include "Collimators/ScatteringProcess.h"

#include "NumericalUtils/utils.h"
#include "NumericalUtils/PhysicalUnits.h"
#include "NumericalUtils/PhysicalConstants.h"
#include "NumericalUtils/NumericalConstants.h"

namespace Collimation {

	/**
	* Struct to handle JawInelastic plot data
	*/	
struct JawInelasticData{
	int turn;
	int ID;
	double x;
	double xp;
	double y;
	double yp;
	double ct;
	double dp;	
	double z;
	string name;
};
	/**
	* Struct to handle JawImpact plot data
	*/		
struct JawImpactData{
	int turn;
	int ID;
	double x;
	double xp;
	double y;
	double yp;
	double ct;
	double dp;	
	string name;
};
	/**
	* Struct to handle ScatterPlot data
	*/	
struct ScatterPlotData{
	int turn;
	int ID;
	double x;
	double xp;
	double y;
	double yp;
	double z;
	string name;	
	
	/**
	* == operator to compare ScatterPlotData
	*/	
	inline bool operator==(const ScatterPlotData& rhs){
		if( (this->z != rhs.z) )
		{ return 0;}
		else {return 1;}
	}
	/**
	* > operator to compare ScatterPlotData
	*/		
	inline bool operator>(const ScatterPlotData& rhs){
		if( (this->z > rhs.z) )
		{ return 0;}
		else {return 1;}
	}
	/**
	* < operator to compare ScatterPlotData
	*/	
	inline bool operator<(const ScatterPlotData& rhs){
		if( (this->z < rhs.z) )
		{ return 0;}
		else {return 1;}
	}
};

class ScatteringModel
{
	
public:

	/**
	* Constructor
	*/	
	ScatteringModel();
	/**
	* Overloaded constructor takes a bool to switch composites on or off
	*/
	ScatteringModel(bool composites);

	/**
	* Sets the scattering physics model
	* 0 = SixTrack
	* 1 = ST+Ad Ion
	* 2 = ST + Ad El
	* 3 = ST + Ad SD
	* 4 = MERLIN	
	*/
	void SetScatterType(int st);
	
	/**
	* Calculates the particle path length in a given material using 
	* the total cross section from the selected ScatteringProcesses.
	* @return Returns the path length in metres
	*/
	double PathLength(Material* mat, double E0);
	
	/**
	* Performs simple energy loss for a particle travelling through x metres 
	* in material mat.
	* @param[in] p the particle vector.
	* @param[in] x the path length.
	* @param[in] mat the material.
	* @param[in] E0 the reference momentum.
	* @param[in] E1 the particle momentum.
	*/
	void EnergyLoss(PSvector& p, double x, Material* mat, double E0, double E1);
	
	/**
	* Performs advance energy loss for a particle travelling through x 
	* metres in material mat. Includes density, and Mott corrections,
	* detailed in James Molson's PhD thesis.
	* @param[in] p the particle vector.
	* @param[in] x the path length.
	* @param[in] mat the material.
	* @param[in] E0 the reference momentum.
	* @param[in] E1 the particle momentum.
	*/
	void EnergyLoss(PSvector& p, double x, Material* mat, double E0);

	/**
	* Performs multiple Coulomb scattering using an average of the
	* particle momentum before and after EnergyLoss.
	* @param[in] p the particle vector.
	* @param[in] x the path length.
	* @param[in] mat the material.
	* @param[in] E1 the particle momentum before EnergyLoss.
	* @param[in] E2 the particle momentum after EnergyLoss.
	*/
	void Straggle(PSvector& p, double x, Material* mat, double E1, double E2);
	
	/**
	* Performs point like particle scattering process randomly
	* weighted using the cross section.
	* @param[in] p the particle vector.
	* @param[in] mat the material.
	* @param[in] E the particle momentum.
	* @return Returns true if inelastic, otherwise false
	*/
	bool ParticleScatter(PSvector& p, Material* mat, double E);

	/**
	* Used to store information for collimator losses and corresponding
	* sepcial output.
	* @param[in] p the particle vector.
	* @param[in] x the exact loss position in the collimator.
	* @param[in] position the s position of the collimator in the lattice.
	* @param[in] lost a vector containing the lost positions.
	*/
	void DeathReport(PSvector& p, double x, double position, vector<double>& lost);

	/**
	* Adds an individual ScatteringProcess.
	* @param[in] S the ScatteringProcess.
	*/
	void AddProcess(Collimation::ScatteringProcess* S){ Processes.push_back(S); fraction.push_back(0); }
	/**
	* Clears all stored ScatteringProcess.
	*/
	void ClearProcesses(){Processes.clear();}

	/**
	* Called in CollimateProtonProcess::DoScatter to store data for
	* ScatterPlot.
	* @param[in] p the particle vector.
	* @param[in] z the exact loss position in the collimator.
	* @param[in] turn the turn.
	* @param[in] name the collimator name.
	*/
	void ScatterPlot(ParticleTracking::Particle& p, double z, int turn, string name);
	
	/**
	* Used to select which collimators to store ScatterPlot data for
	* @param[in] name the collimator name.
	* @param[in] single_turn not currently used.
	*/
	void SetScatterPlot(string name, int single_turn = 0);
	
	/**
	* Used to output ScatterPlot data for previously named collimators
	* @param[in] directory the output directory.
	* @param[in] seed used if running multiple jobs, the seed will create an output file per collimator per seed.
	*/
	void OutputScatterPlot(string directory, int seed = 0);
		
	vector<string> ScatterPlotNames;
	bool ScatterPlot_on;
	vector <ScatterPlotData*> StoredScatterPlotData;
	
	/**
	* Called in CollimateProtonProcess::DoScatter to store data for
	* JawImpact.
	* @param[in] p the particle vector.
	* @param[in] turn the turn.
	* @param[in] name the collimator name.
	*/
	void JawImpact(ParticleTracking::Particle& p, int turn, string name);
	
	/**
	* Used to select which collimators to store JawImpact data for.
	* @param[in] name the collimator name.
	* @param[in] single_turn not currently used.
	*/
	void SetJawImpact(string name, int single_turn = 0);
	
	/**
	* Used to output JawImpact data for previously named collimators.
	* @param[in] directory the output directory.
	* @param[in] seed used if running multiple jobs, the seed will create an output file per collimator per seed.
	*/
	void OutputJawImpact(string directory, int seed = 0);
	
	vector<string> JawImpactNames;
	bool JawImpact_on;
	vector <JawImpactData*> StoredJawImpactData;
	
	/**
	* Called in CollimateProtonProcess::DoScatter to store data for.
	* JawInelastic
	* @param[in] p the particle vector.
	* @param[in] z the exact loss position in the collimator.
	* @param[in] turn the turn.
	* @param[in] name the collimator name.
	*/
	void JawInelastic(ParticleTracking::Particle& p, double z, int turn, string name);
	
	/**
	* Used to select which collimators to store JawInelastic data for.
	* @param[in] name the collimator name.
	* @param[in] single_turn not currently used.
	*/
	void SetJawInelastic(string name, int single_turn = 0);
	
	/**
	* Used to output JawInelastic data for previously named collimators.
	* @param[in] directory the output directory.
	* @param[in] seed used if running multiple jobs, the seed will create an output file per collimator per seed.
	*/
	void OutputJawInelastic(string directory, int seed = 0);
	
	vector<string> JawInelasticNames;
	bool JawInelastic_on;
	vector <JawInelasticData*> StoredJawInelasticData;

	/*** vector holding all scattering processes */
	vector <Collimation::ScatteringProcess*> Processes;
	/**
	* Used to configure individual ScatteringProcesses for a given material.
	* @param[in] CS CrossSection object containing required cross sections.
	* @param[in] mat the Material.
	*/
	void ConfigureProcesses(CrossSections* CS, Material* mat);
	
	std::map< string, vector <Collimation::ScatteringProcess*> > stored_processes;
	std::map< string, vector <Collimation::ScatteringProcess*> >::iterator P_iterator;
	
	/*** vector with fractions of the total scattering cross section assigned to each ScatteringProcess */
	vector <double> fraction;
	std::map< string, vector <double> > stored_fractions;
	std::map< string, vector <double> >::iterator F_iterator;
	
	/***  Store calculated CrossSections data to save time */
	std::map< string, Collimation::CrossSections* > stored_cross_sections;
	std::map< string, Collimation::CrossSections* >::iterator CS_iterator;	
	
	/**
	* Used to get the ScatteringPhysicsModel being used.
	* @return Returns an int corresponding to the current ScatteringPhysicsModel
	*/
	int GetScatteringPhysicsModel(){return ScatteringPhysicsModel;}
	
	/**
	* Used to set the flag useComposites
	* when on this will treat composites as a weighted mixture of
	* individual elements, when off this treats composites as a single
	* imaginary atom with properties that are a weighted average of all 
	* constituent elements
	*/	
	void SetCompositesOn(){useComposites = 1; cout << "\nScatteringModel::Composites On" << endl;}
		
protected:

private:
	/*** Used to switch between composite elements and the composite imaginary nucleus	*/
	bool useComposites;

	/*** 0 = SixTrack, 1 = ST+Ad Ion, 2 = ST + Ad El, 3 = ST + Ad SD, 4 = MERLIN	*/
    int ScatteringPhysicsModel;
};

}
#endif
