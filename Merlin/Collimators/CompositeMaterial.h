#ifndef _CompositeMaterial_h_
#define _CompositeMaterial_h_

#include <string>
#include <map>
#include <vector>

#include "Collimators/Material.h"
#include "Collimators/CrossSections.h"

using namespace std;

// A CompositeMaterial is a composite of assorted materials
// and contains a map of constituent materials. It is similar to a 
// MaterialMixture however it uses bulk material properties as well 
// as mass fraction weighted values for atomic mass, number, etc, 
// and all cross sections.

// This makes the CompositeMaterial compatible with CrossSections.

// CompositeMaterial may be used in two ways, the first is to
// imitate SixTrack, where scattering will be performed from imaginary
// composite nuclei rather than the constituent nuclei of the composite.

// The second way is for CollimateProtonProcess to calculate a new 
// CrossSection classes for each constitutent element, store them in 
// the CompositeMaterial class, and select one by random weight using 
// the GetRandomMaterialSymbol() function, which returns only the symbol
// for that element.

class CompositeMaterial : public Material
{
public:
	CompositeMaterial() : Material(),Assembled(false),AssembledByNumber(false),AssembledByMass(false) {};

	double CalculateElectronDensity();
	double CalculatePlasmaEnergy();
	double CalculateMeanExcitationEnergy();

	double CalculateRadiationLength();
	double CalculateSixtrackdEdx();
	
	//This calculates and sets all variables using mass fraction weighting
	void CalculateAllWeightedVariables();
	
	//New weighed calculate functions
	double CalculateWeightedA();
	double CalculateWeightedZ();
	double CalculateSixTrackElasticNucleusCrossSection();

	void SetName(std::string);
	void SetSymbol(std::string);
	void SetConductivity(double);
	void SetRadiationLength(double);
	void SetDensity(double);
	void SetElectronDensity(double);
//	void SetElectronCriticalEnergy(double);
	void SetMeanExcitationEnergy(double);
	void SetPlasmaEnergy(double);

	void SetSixtrackdEdx(double);

	//~ void SetAtomicMass(double);
	//~ void SetAtomicNumber(double);
	//~ void SetSixtrackTotalNucleusCrossSection(double);
	//~ void SetSixtrackInelasticNucleusCrossSection(double);
	//~ void SetSixtrackRutherfordCrossSection(double);
	//~ void SetSixtrackNuclearSlope(double);
    
    // Define accessors    
	double GetAtomicNumber() const;
	string GetName() const;
	string GetSymbol() const;
	double GetAtomicMass() const;
	double GetConductivity() const;
	double GetRadiationLength() const;
	double GetRadiationLengthInM() const;
	double GetDensity() const;
	double GetElectronDensity() const;
//	double GetElectronCriticalEnergy() const;
	double GetMeanExcitationEnergy() const;
	double GetPlasmaEnergy() const;

	double GetSixtrackTotalNucleusCrossSection() const;
	double GetSixtrackInelasticNucleusCrossSection() const;
	double GetSixtrackRutherfordCrossSection() const;
	double GetSixtrackdEdx() const;
	double GetSixtrackNuclearSlope() const;

	
	// Check that the material properties make some sort of sense
	bool VerifyMaterial() const;

	// This function adds materials by mass fraction
	// i.e. if 5% of the material by mass is element m, the double here is 0.05, etc.
	bool AddMaterialByMassFraction(Material*,double);

	// This function adds materials by number density fraction
	// i.e. if 5% of the component atoms are element m, the double here is 0.05, etc.
	bool AddMaterialByNumberFraction(Material*,double);

	// Returns a random element and sets CurrentElement to this element also.
	Material* SelectRandomMaterial();
	
	// Returns CurrentElement.
	Material* GetCurrentMaterial();
	
	// Assembles the material
	bool Assemble();
	
	// Is this material ready to be used?
	bool IsAssembled();
	
	// Is this a compound material?
	// true for compounds, false for elements
	virtual bool IsMixture() const;
	
	// Return list of constitutent element symbols as strings
	vector< pair<string,double> > GetConstituentElements();
	
	// Return a random Material symbol
	string GetRandomMaterialSymbol();
	
	// Make an iterator to access the map	
	std::map<Material*,std::pair<double,double> >::const_iterator MixtureMapIterator;
	void StartMIT();
	bool IterateMIT();	
	int GetMapSize(){return MixtureMap.size();}
	
	// A map of number density fractions in the material, along with the material pointer.
	// In the double pair:
	// first = number fraction
	// second = mass fraction
	std::map<Material*,std::pair<double,double> > MixtureMap;

private:
	// Current element selected
	Material* CurrentMaterial;

	bool Assembled;
	bool AssembledByNumber;
	bool AssembledByMass;
};
#endif
