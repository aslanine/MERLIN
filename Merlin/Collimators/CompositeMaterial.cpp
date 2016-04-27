#include <cmath>
#include <iostream>
#include <vector>
#include <map>

#include "Collimators/CompositeMaterial.h"

#include "NumericalUtils/PhysicalUnits.h"
#include "NumericalUtils/PhysicalConstants.h"

#include "Random/RandomNG.h"

using namespace std;
using namespace PhysicalConstants;
using namespace PhysicalUnits;

/*
* This function adds materials by mass fraction
* i.e. if 5% of the material by mass is element x, the double here is 0.05, etc.
*/
bool CompositeMaterial::AddMaterialByMassFraction(Material* m ,double f)
{
	if(AssembledByNumber || AssembledByBoth)
	{
		std::cerr << "Already added a material to this mixture by number fraction or both. Adding by Mass fraction will break things." << std::endl;
		return false;
	}
	/*
	* Internally we want to keep track of the number density in order to generate a random nucleus for scattering
	* The other parameters are constant for the material.
	*/
	std::pair<double,double> p;
	p.first = 0.0;	//Number fraction (currently unknown)
	p.second = f;	//Mass fraction

	std::pair<std::map<Material*,std::pair<double,double> >::iterator,bool> test;
	test = MixtureMap.insert(std::pair<Material*,std::pair<double,double> >(m,p));
	AssembledByMass = true;
	return test.second;
}

/*
* This function adds materials by number density fraction
* i.e. if 5% of the component atoms are element m, the double here is 0.05, etc.
*/
bool CompositeMaterial::AddMaterialByNumberFraction(Material* m,double f)
{
	if(AssembledByMass || AssembledByBoth)
	{
		std::cerr << "Already added a material to this mixture by mass fraction or both. Adding by number fraction will break things." << std::endl;
		return false;
	}
	std::pair<double,double> p;
	p.first = f;	//Number fraction
	p.second = 0.0;	//Mass fraction (currently unknown)

	std::pair<std::map<Material*,std::pair<double,double> >::iterator,bool> test;
	test = MixtureMap.insert(std::pair<Material*, std::pair<double,double> >(m,p));
	AssembledByNumber = true;
	return test.second;
}

bool CompositeMaterial::AddMaterialByFractions(Material* m ,double m_f, double n_f)
{
	if(AssembledByNumber || AssembledByMass)
	{
		std::cerr << "Already added a material to this mixture by individual number or mass fraction. Adding by both fractions will break things." << std::endl;
		return false;
	}

	std::pair<double,double> p;
	p.first = n_f;	//Number fraction 
	p.second = m_f;	//Mass fraction

	std::pair<std::map<Material*,std::pair<double,double> >::iterator,bool> test;
	test = MixtureMap.insert(std::pair<Material*,std::pair<double,double> >(m,p));
	AssembledByBoth = true;
	return test.second;
}

double CompositeMaterial::CalculateElectronDensity()
{
	/*
	* 1: Get weighted mean of the AtomicNumber
	* 2: Get weighted mean of the AtomicMass
	*/
	double Z = 0.0;
	double A = 0.0;
	
        std::map<Material*,std::pair<double,double> >::const_iterator MaterialIt;
        MaterialIt = MixtureMap.begin();
        while(MaterialIt != MixtureMap.end())
	{
		Z += MaterialIt->second.first * MaterialIt->first->GetAtomicNumber();
		A += MaterialIt->second.first * MaterialIt->first->GetAtomicMass();
		MaterialIt++;
	}
	return Z * Avogadro * GetDensity() * 0.001 / (A * pow(centimeter,3)); // n_e m^-3 (1e6 conversion from cm^3)
}

//returns the Plasma energy in GeV
double CompositeMaterial::CalculatePlasmaEnergy()
{
	return (PlanckConstantBar * sqrt((ElectronDensity * pow(ElectronCharge,2)) / (ElectronMass * FreeSpacePermittivity)))/ElectronCharge*eV;
}

double CompositeMaterial::CalculateMeanExcitationEnergy()
{
	/*
	* Here we follow the form given in:
	* "Evaluation of the collision stopping power of elements and compounds for electrons and positrons, Stephen M. Seltzer, Martin J. Berger"
	* The International Journal of Applied Radiation and Isotopes
	* Volume 33, Issue 11, November 1982, Pages 1189–1218
	* http://dx.doi.org/10.1016/0020-708X(82)90244-7
	* Note eq 10,11
	* Also note: "The reccomendation in Table 6 is to use I-values for these other constituents which are 13% larger than the correponding I-values for condensed elemental substances in Table 2"
	* Thus we use I -> 1.13*Ii
	*
	* The below is not valid for organic compounds with H,C,N,O,F,Cl.
	* Look at the values in Table 6 of the above paper instead.
	*/

	double ISum = 0.0;
	double ZA = 0.0;

        std::map<Material*,std::pair<double,double> >::const_iterator MaterialIt;
        MaterialIt = MixtureMap.begin();
        while(MaterialIt != MixtureMap.end())
	{
		double A = MaterialIt->first->GetAtomicMass();
		double Z = MaterialIt->first->GetAtomicNumber();
		double I_el = 1.13 * MaterialIt->first->GetMeanExcitationEnergy();
		double w = MaterialIt->second.second;
		ZA += w * Z/A; 
		ISum += w * (Z/A) * log(I_el);

		MaterialIt++;
	}
	return exp(ISum/ZA);
}

double CompositeMaterial::CalculateSixtrackdEdx()
{
	/*
	* pdg states for a mixture the following is an appoximation:
	* dE/dx = \sum (w_i * (dE/dx)_i)
	* where w_i is the mass fraction
	*/

	double dEdx = 0.0;
	
        std::map<Material*,std::pair<double,double> >::const_iterator MaterialIt;
        MaterialIt = MixtureMap.begin();
        while(MaterialIt != MixtureMap.end())
	{
		dEdx += (MaterialIt->second.second * MaterialIt->first->GetSixtrackdEdx());
		MaterialIt++;
	}
	return dEdx;
}

double CompositeMaterial::CalculateRadiationLength()
{
/*
* pdg states for a mixture the following is an appoximation:
* 1/X_0 = \sum (w_i / X_i)
* where w_i is the mass fraction
*/

	double X0 = 0.0;
	
        std::map<Material*, std::pair<double,double> >::const_iterator MaterialIt;
        MaterialIt = MixtureMap.begin();
        while(MaterialIt != MixtureMap.end())
	{
		X0 += (MaterialIt->second.second / MaterialIt->first->GetRadiationLength());
		MaterialIt++;
	}
	return 1.0/X0;
}

/*
* Set parameters
*/
void CompositeMaterial::SetName(string p)
{
	Name = p;
}

void CompositeMaterial::SetSymbol(string p)
{
	Symbol = p;
}

void CompositeMaterial::SetConductivity(double p)
{
	Conductivity = p;
}

void CompositeMaterial::SetRadiationLength(double p)
{
	X0 = p;
}

void CompositeMaterial::SetDensity(double p)
{
	Density = p;
}

void CompositeMaterial::SetElectronDensity(double p)
{
	ElectronDensity = p;
}
/*
void CompositeMaterial::SetElectronCriticalEnergy(double p)
{
	ElectronCriticalEnergy = p;
}
*/
void CompositeMaterial::SetMeanExcitationEnergy(double p)
{
	MeanExcitationEnergy = p;
}

void CompositeMaterial::SetPlasmaEnergy(double p)
{
	PlasmaEnergy = p;
}

void CompositeMaterial::SetSixtrackdEdx(double p)
{
	dEdx = p;
}

/*
* Accessors
*/
string CompositeMaterial::GetName() const
{
	return Name;
}

string CompositeMaterial::GetSymbol() const
{
	return Symbol;
}

double CompositeMaterial::GetConductivity() const
{
	return Conductivity;
}

double CompositeMaterial::GetRadiationLength() const
{
	return X0;
}

double CompositeMaterial::GetRadiationLengthInM() const
{
	return X0*0.001/Density;
}

double CompositeMaterial::GetDensity() const
{
	return Density;
}

double CompositeMaterial::GetElectronDensity() const
{
	return ElectronDensity;
}
/*
double CompositeMaterial::GetElectronCriticalEnergy() const
{
	return ElectronCriticalEnergy;
}
*/
double CompositeMaterial::GetMeanExcitationEnergy() const
{
	return MeanExcitationEnergy;
}

double CompositeMaterial::GetPlasmaEnergy() const
{
	return PlasmaEnergy;
}

double CompositeMaterial::GetSixtrackdEdx() const
{
	return dEdx;
}

double CompositeMaterial::GetAtomicNumber() const
{
	//~ return CurrentMaterial->GetAtomicNumber();
	return AtomicNumber;
}

double CompositeMaterial::GetAtomicMass() const
{
	//~ return CurrentMaterial->GetAtomicMass();
	return AtomicMass;
}

double CompositeMaterial::GetSixtrackTotalNucleusCrossSection() const
{
	//~ return CurrentMaterial->GetSixtrackTotalNucleusCrossSection();
	return sigma_pN_total;
}

double CompositeMaterial::GetSixtrackInelasticNucleusCrossSection() const
{
	//~ return CurrentMaterial->GetSixtrackInelasticNucleusCrossSection();
	return sigma_pN_inelastic;
}

double CompositeMaterial::GetSixtrackRutherfordCrossSection() const
{
	//~ return CurrentMaterial->GetSixtrackRutherfordCrossSection();
	return sigma_Rutherford;
}

double CompositeMaterial::GetSixtrackNuclearSlope() const
{
	//~ return CurrentMaterial->GetSixtrackNuclearSlope();
	return b_N;
}

/*
 * Verifies that all the material entries exist and make sense.
 * returns true if the material is good.
 * returns false if the material is bad.
 */
bool CompositeMaterial::VerifyMaterial() const
{
        bool verification = true;

	//Check the mixture related bits
	if(GetName().size() <1){return false;}
	if(GetSymbol().size() <1){return false;}

	//Then check the component materials
	//Here we need to loop over the component materials
	double MassFraction = 0;
	double NumberFraction = 0;

        std::map<Material*,std::pair<double,double> >::const_iterator MaterialIt;
        MaterialIt = MixtureMap.begin();
        while(MaterialIt != MixtureMap.end())
        {
		//Pull the number and mass fractions
		NumberFraction+=MaterialIt->second.first;
		MassFraction+=MaterialIt->second.second;

                bool test = MaterialIt->first->VerifyMaterial();
                if(test == false)
                {
                        verification = false;
                        std::cerr << "Material " << GetName() << " subcomponent: "  << MaterialIt->first->GetName() << " failed to verify." << std::endl;
                }
                MaterialIt++;
        }

	if(GetConductivity() <=0){std::cerr << "Failed to verify Conductivity for " << GetName() << ": " << GetConductivity() << std::endl; verification = false;}
	if(GetRadiationLength() <=0){std::cerr << "Failed to verify RadiationLength for " << GetName() << ": " << GetRadiationLength() << std::endl; verification = false;}
	if(GetDensity() <=0){std::cerr << "Failed to verify Density for " << GetName() << ": " << GetDensity() << std::endl; verification = false;}
	if(GetElectronDensity() <=0){std::cerr << "Failed to verify ElectronDensity for " << GetName() << ": " << GetConductivity() << std::endl; verification = false;}
	//if(GetElectronCriticalEnergy() <=0){std::cerr << "Failed to verify ElectronCriticalEnergy for " << GetName() << ": " << GetElectronCriticalEnergy() << std::endl; verification = false;}
	if(GetMeanExcitationEnergy() <=0){std::cerr << "Failed to verify MeanExcitationEnergy for " << GetName() << ": " << GetMeanExcitationEnergy() << std::endl; verification = false;}
	if(GetPlasmaEnergy() <=0){std::cerr << "Failed to verify PlasmaEnergy for " << GetName() << ": " << GetPlasmaEnergy() << std::endl; verification = false;}

	//Verify that the mass and number fraction components sum to 1
	unsigned int oldprec = cerr.precision(16);
	double tol = 1e-12;
	if(std::fabs(MassFraction - 1.0) > tol){std::cerr << "Invalid mass fraction sum for: " << GetName() << " - " << MassFraction << endl; verification = false;}
	if(std::fabs(NumberFraction - 1.0) > tol){std::cerr << "Invalid number fraction sum for: " << GetName() << " - " << NumberFraction << endl; verification = false;}
	cerr.precision(oldprec);
        return verification;
}

bool CompositeMaterial::Assemble()
{
	if(Assembled){return true;}
	
    std::map<Material*,std::pair<double,double> >::iterator MaterialIt;
    MaterialIt = MixtureMap.begin();
	unsigned int count = MixtureMap.size();

	std::vector<double>::iterator FractionVectorIt;
	std::vector<double> FractionVector;
	FractionVector.reserve(count);

	double CurrentFraction,Total = 0.0;
	double wA = 0.0;
	double wZ = 0.0;
	double fraction = 0.0;
		
	/*
	* MassFraction = NumberFraction * AtomicMass
	* NumberFraction = MassFraction / AtomicMass
	*/

	if(AssembledByMass)
	{
		//Set CurrentMaterial with the first element listed
		CurrentMaterial = MaterialIt->first;

		//Want the number fraction here - needs 2 passes
        while(MaterialIt != MixtureMap.end())
		{
			//~ CurrentFraction = MaterialIt->second.second / MaterialIt->first->GetAtomicNumber();
			CurrentFraction = MaterialIt->second.second / MaterialIt->first->GetAtomicMass();
			Total += CurrentFraction;
			FractionVector.push_back(CurrentFraction);
			MaterialIt++;
		}

		MaterialIt = MixtureMap.begin();
		FractionVectorIt = FractionVector.begin();
		
		while(MaterialIt != MixtureMap.end())
		{
			MaterialIt->second.first = *FractionVectorIt / Total;
			cout << "Calculating number fractions from mass fractions: " << MaterialIt->first->GetSymbol() << " n = " << MaterialIt->second.first << " m = " << MaterialIt->second.second << endl;
			MaterialIt++;
			FractionVectorIt++;
		}
		
	    CalculateAllWeightedVariables();
	    Assembled = true;
		return true;
	}
	else if(AssembledByNumber)
	{
		//Set CurrentMaterial with the first element listed
		CurrentMaterial = MaterialIt->first;

		// First need to set A and Z
		while(MaterialIt != MixtureMap.end())
		{
			fraction = MaterialIt->second.first;
			wA += (fraction * MaterialIt->first->GetAtomicMass());			
			wZ += (fraction * MaterialIt->first->GetAtomicNumber());
			
			cout << "\nCompositeMaterial " << GetSymbol() << " constituent: " << MaterialIt->first->GetSymbol() << " wA = " << wA << endl;
			cout << "\nCompositeMaterial " << GetSymbol() << " constituent: " << MaterialIt->first->GetSymbol() << " wZ = " << wZ << endl;
			MaterialIt++;
		}
		
		SetAtomicMass(wA);
		SetAtomicNumber(wZ);
		MaterialIt = MixtureMap.begin();
		
		//Want the mass fraction here - needs 2 passes
        while(MaterialIt != MixtureMap.end())
		{
			//~ CurrentFraction = MaterialIt->second.second / MaterialIt->first->GetAtomicNumber();
			CurrentFraction = MaterialIt->second.first * MaterialIt->first->GetAtomicMass();
			Total += CurrentFraction;
			FractionVector.push_back(CurrentFraction);
			MaterialIt++;
		}

		MaterialIt = MixtureMap.begin();
		FractionVectorIt = FractionVector.begin();
		
		while(MaterialIt != MixtureMap.end())
		{
			MaterialIt->second.second = *FractionVectorIt / Total;
			cout << "Calculating mass fractions from number fractions: " << MaterialIt->first->GetSymbol() << " n = " << MaterialIt->second.first << " m = " << MaterialIt->second.second << endl;
			MaterialIt++;
			FractionVectorIt++;
		}
		
	    CalculateAllWeightedVariables();
	    Assembled = true;
		return true;
	}
	else
	{
		std::cerr << "Add materials before using Assemble()"  << std::endl;
		return false;
	}
}

Material* CompositeMaterial::SelectRandomMaterial()
{
	// This is not weighted
	double x = RandomNG::uniform(0,1);
	std::map<Material*,std::pair<double,double> >::const_iterator MaterialIt;
	MaterialIt = MixtureMap.begin();
	while(x > 0)
	{
		x-= MaterialIt->second.first;
		if(x > 0)
		MaterialIt++;
	}
	//std::cout << "x = " << x << "\t material first =" << MaterialIt->first->GetName() << "\t material second =" << MaterialIt->second.first << std::endl;
	CurrentMaterial = MaterialIt->first;
	return CurrentMaterial;
}


string CompositeMaterial::GetRandomMaterialSymbol(){
	
	// Using the map and our mass fractions we simply return a random 
	double x = RandomNG::uniform(0,1);
	std::map<Material*,std::pair<double,double> >::const_iterator MaterialIt;
	MaterialIt = MixtureMap.begin();
	while(x > 0)
	{
		x-= MaterialIt->second.first;
		if(x > 0)
		MaterialIt++;
	}
	//std::cout << "x = " << x << "\t material first =" << MaterialIt->first->GetName() << "\t material second =" << MaterialIt->second.first << std::endl;
	return MaterialIt->first->GetSymbol();	
}

Material* CompositeMaterial::GetCurrentMaterial()
{
	return CurrentMaterial;
}

bool CompositeMaterial::IsMixture() const
{
	return true;
}

vector< pair<string,double> > CompositeMaterial::GetConstituentElements()
{
	std::map< Material*,std::pair<double,double> >::const_iterator MaterialIt;
	
	vector< pair<string,double> > elements;
	std::pair<string,double> test;
	
	for(MaterialIt = MixtureMap.begin(); MaterialIt != MixtureMap.end(); ++MaterialIt){		
		test = make_pair(MaterialIt->first->GetSymbol(), MaterialIt->second.second);
		elements.push_back(test);
	}
	
	return elements;	
}

void CompositeMaterial::CalculateAllWeightedVariables()
{	
	double wb_n, wsig_R, wsig_tot, wsig_E, wsig_I, wA, wZ, wrad= 0.0;
	
	std::map<Material*,std::pair<double,double> >::const_iterator MaterialIt;
	MaterialIt = MixtureMap.begin();
	
	cout << "\nCompositeMaterial " << GetSymbol() << " MixtureMap.size() = " << MixtureMap.size() << endl;
		
	double fraction = 0;
	
	while(MaterialIt != MixtureMap.end())
	{

		// A and Z must be calculated using the number fraction
		if(AssembledByMass){ // if Assembled by number - already done in Assemble()
			fraction = MaterialIt->second.first;
			wA += (fraction * MaterialIt->first->GetAtomicMass());			
			wZ += (fraction * MaterialIt->first->GetAtomicNumber());
			//~ wA += (fraction / MaterialIt->first->GetAtomicMass());			
			//~ wZ += (fraction / MaterialIt->first->GetAtomicNumber());
			
			cout << "\nCompositeMaterial " << GetSymbol() << " constituent: " << MaterialIt->first->GetSymbol() << " wA = " << wA << endl;
			cout << "\nCompositeMaterial " << GetSymbol() << " constituent: " << MaterialIt->first->GetSymbol() << " wZ = " << wZ << endl;
		}
		// The rest is calculated using the mass fraction
		//~ fraction = MaterialIt->second.second;
		fraction = MaterialIt->second.first;
		
		wsig_R += (fraction * MaterialIt->first->GetSixtrackRutherfordCrossSection());
		wsig_tot += (fraction * MaterialIt->first->GetSixtrackTotalNucleusCrossSection());
		wsig_E += (fraction * MaterialIt->first->GetSixtrackElasticNucleusCrossSection());
		wsig_I += (fraction * MaterialIt->first->GetSixtrackInelasticNucleusCrossSection());
		
		//~ wrad += (MaterialIt->second.second / MaterialIt->first->GetRadiationLength());
		
	
		MaterialIt++;
	}
		
	// Set weighted values	
	SetSixtrackRutherfordCrossSection(wsig_R);
	SetSixtrackTotalNucleusCrossSection(wsig_tot);
	SetSixtrackInelasticNucleusCrossSection(wsig_I);
	SetSixtrackElasticNucleusCrossSection(wsig_E);
	//~ SetRadiationLength(1/wrad);
	
	if(AssembledByMass){
		SetAtomicMass(wA);
		SetAtomicNumber(wZ);	
	}	
	
	// already done
	SetElectronDensity(CalculateElectronDensity());
	SetPlasmaEnergy(CalculatePlasmaEnergy());
	SetMeanExcitationEnergy(CalculateMeanExcitationEnergy());
	SetRadiationLength(CalculateRadiationLength());
	SetSixtrackdEdx(CalculateSixtrackdEdx());
	SetSixtrackNuclearSlope(CalculateSixtrackNuclearSlope());
	
}

void CompositeMaterial::StartMIT(){
	MixtureMapIterator = MixtureMap.begin();
	CurrentMaterial = MixtureMapIterator->first;
	cout << "\nCompositeMaterial::MixtureMapIterator started, current element : " << CurrentMaterial->GetSymbol() << endl;
}

bool CompositeMaterial::IterateMIT(){
	if(MixtureMapIterator != MixtureMap.end()){
		MixtureMapIterator++; 
		CurrentMaterial = MixtureMapIterator->first;
		cout << "\nCompositeMaterial::MixtureMapIterator ++ : " << CurrentMaterial->GetSymbol() << endl;
		return true;
	}
	else{ return false;}
}	
