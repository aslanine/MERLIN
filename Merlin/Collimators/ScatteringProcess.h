#ifndef _h_ScatteringProcess
#define _h_ScatteringProcess 1

#include <iostream>
#include <cmath>

#include "merlin_config.h"

#include "BeamModel/PSvector.h"

#include "Collimators/Material.h"
#include "Collimators/DiffractiveScatter.h"
#include "Collimators/ElasticScatter.h"
#include "Collimators/CrossSections.h"

#include "NumericalUtils/utils.h"
#include "NumericalUtils/PhysicalUnits.h"
#include "NumericalUtils/PhysicalConstants.h"
#include "NumericalUtils/NumericalConstants.h"

/*

Definition of the virtual ScatteringProcess class and
also several child classes derived from it
 
Created RJB 23 October 2012
Modified HR 07.09.2015

*/

namespace Collimation {
	
class ScatteringProcess {
public:

	//~ ScatteringProcess(){sigma = 0; mat = NULL; cs = NULL; t = 0; E0 = 0;}
	ScatteringProcess(){}
	//~ ScatteringProcess(const ScatteringProcess& sp){sigma = sp.sigma
	
	// The first function must be provided for all child classes, and probably the second as well
	virtual bool Scatter(PSvector& p, double E)=0;
	virtual void Configure(Material* matin, CrossSections* CSin){mat=matin; cs=CSin;}
	virtual std::string GetProcessType() const {return "ScatteringProcess";}
	double sigma; 					// Integrated cross section for this process
	//~ virtual ScatteringProcess* getCopy(){return new ScatteringProcess(*this);}
	virtual ScatteringProcess* getCopy(){ cout << "ScatteringProcess::getCopy(): Warning: returning NULL pointer" << endl; return NULL;}
	//~ virtual ScatteringProcess* getCopy();

protected:
	double E0;							// Reference energy
	Material* mat; 						// Material of the collimator being hit	
	CrossSections* cs;					// CrossSections object holding all configured cross sections
	double t;							// Momentum transfer
	
};

// Rutherford
class Rutherford:public ScatteringProcess
{
	double tmin;
public:
	Rutherford(){}
	Rutherford* getCopy(){return new Rutherford(*this);}
	
	void Configure(Material* matin, CrossSections* CSin);
	bool Scatter(PSvector& p, double E);
	std::string GetProcessType() const{return "Rutherford";}
};

class SixTrackRutherford:public ScatteringProcess
{	
	double tmin;
public:
	SixTrackRutherford(){}	
	SixTrackRutherford* getCopy(){return new SixTrackRutherford(*this);}
	
	void Configure(Material* matin, CrossSections* CSin);
	bool Scatter(PSvector& p, double E);
	std::string GetProcessType() const{return "SixTrackRutherford";}
};

// Elastic pn
class Elasticpn:public ScatteringProcess
{	
	double b_pp; //slope
public:
	Elasticpn(){}
	Elasticpn* getCopy(){return new Elasticpn(*this);}
	
	void Configure(Material* matin, CrossSections* CSin);
	bool Scatter(PSvector& p, double E);
	std::string GetProcessType() const {return "Elastic_pn";}
};

class SixTrackElasticpn:public ScatteringProcess
{	
	double b_pp; //slope
public:	
	SixTrackElasticpn(){}
	SixTrackElasticpn* getCopy(){return new SixTrackElasticpn(*this);}
	
	void Configure(Material* matin, CrossSections* CSin);
	bool Scatter(PSvector& p, double E);
	std::string GetProcessType() const{return "SixTrackElasic_pn";}	
};

// Elastic pN
class ElasticpN:public ScatteringProcess
{	
	double b_N; //slope
public:
	ElasticpN(){}
	ElasticpN* getCopy(){return new ElasticpN(*this);}
	
	void Configure(Material* matin, CrossSections* CSin);
	bool Scatter(PSvector& p, double E);
	std::string GetProcessType() const {return "Elastic_pN";}
};

class SixTrackElasticpN:public ScatteringProcess
{	
	double b_N; //slope
public:	
	SixTrackElasticpN(){}
	SixTrackElasticpN* getCopy(){return new SixTrackElasticpN(*this);}
	
	void Configure(Material* matin, CrossSections* CSin);
	bool Scatter(PSvector& p, double E);
	std::string GetProcessType() const{return "SixTrackElasic_pN";}	
};

// Single Diffractive
class SingleDiffractive:public ScatteringProcess
{	
	double m_rec; //recoil mass
public:
	SingleDiffractive(){}
	SingleDiffractive* getCopy(){return new SingleDiffractive(*this);}
	
	void Configure(Material* matin, CrossSections* CSin);
	bool Scatter(PSvector& p, double E);
	std::string GetProcessType() const{return "SingleDiffractive";}	
	
};

class SixTrackSingleDiffractive:public ScatteringProcess
{	
	double m_rec; //recoil mass
	double dp;
public:
	SixTrackSingleDiffractive(){}
	SixTrackSingleDiffractive* getCopy(){return new SixTrackSingleDiffractive(*this);}
	
	void Configure(Material* matin, CrossSections* CSin);
	bool Scatter(PSvector& p, double E);
	std::string GetProcessType() const{return "SixTrackSingleDiffractive";}	
	
};

// Inelastic
class Inelastic:public ScatteringProcess
{	
public:
	Inelastic(){}
	Inelastic* getCopy(){return new Inelastic(*this);}
	
	void Configure(Material* matin, CrossSections* CSin);
	bool Scatter(PSvector& p, double E);
	std::string GetProcessType() const {return "Inelastic";}
};

} //end namespace Collimation

#endif
