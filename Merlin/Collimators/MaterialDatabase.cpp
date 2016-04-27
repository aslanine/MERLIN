#include <cstdlib>
#include <iostream>
#include <iomanip>
#include <map>
#include <algorithm>

#include "Collimators/MaterialDatabase.h"
#include "Collimators/MaterialMixture.h"
#include "Collimators/CompositeMaterial.h"

#include "NumericalUtils/PhysicalUnits.h"

using namespace std;
using namespace PhysicalUnits;

MaterialDatabase::MaterialDatabase()
{
/*
Here we create new materials, add their properties, then push them into a map for manipulation.
References: Particle data group: http://pdg.lbl.gov/2013/AtomicNuclearProperties/
*/

	// Use SixTrack reference cross sections for composites, or calculate them
	// using a weighted average of constituent cross sections
	bool ST_CS = 0;

	//ALL CROSS SECTIONS IN BARNS!

	//new Material(Name, symbol, A, Z, SE, SI, SR, dE, X, rho, sig);
	//Beryllium - using constructor rather than addinf each variable
	Material* Be = new Material("Beryllium", "Be", 9.012182, 4, 0.069, 0.199, 0.000035, 0.55, 651900, 1848, 3.08E7);	
	Be->SetSixtrackTotalNucleusCrossSection(0.268);
	Be->SetSixtrackNuclearSlope(74.7);
	Be->SetMeanExcitationEnergy(63.7*eV);
	Be->SetElectronDensity(Be->CalculateElectronDensity());
	Be->SetPlasmaEnergy(Be->CalculatePlasmaEnergy());
	db.insert(pair<string,Material*>(Be->GetSymbol(),Be));
/*
	//Obsolete due to constructor
	Material* Be = new Material();
	Be->SetAtomicNumber(4);
	Be->SetAtomicMass(9.012182);
	Be->SetName("Beryllium");
	Be->SetSymbol("Be");
	Be->SetSixtrackInelasticNucleusCrossSection(0.199);
	Be->SetSixtrackRutherfordCrossSection(0.000035);
	Be->SetConductivity(3.08E7);
	Be->SetRadiationLength(651900);
	Be->SetSixtrackdEdx(0.55);
	Be->SetDensity(1848);
*/
	
	//Boron
	Material* B = new Material();
	B->SetAtomicNumber(5);
	B->SetAtomicMass(10.811);
	B->SetName("Boron");
	B->SetSymbol("B");
	B->SetSixtrackTotalNucleusCrossSection(B->CalculateSixtrackTotalNucleusCrossSection());
	B->SetSixtrackInelasticNucleusCrossSection(B->CalculateSixtrackInelasticNucleusCrossSection());
	//~ B->SetSixtrackRutherfordCrossSection(B->CalculateSixtrackRutherfordCrossSection());
	B->SetSixtrackRutherfordCrossSection(0.000054);
	B->SetSixtrackdEdx(B->CalculateSixtrackdEdx());
	B->SetConductivity(-1);
	B->SetRadiationLength(B->CalculateRadiationLength());
	B->SetDensity(2370);
	B->SetSixtrackNuclearSlope(-1);
	B->SetMeanExcitationEnergy(76.0*eV);
	B->SetElectronDensity(B->CalculateElectronDensity());
	B->SetPlasmaEnergy(B->CalculatePlasmaEnergy());
	B->SetSixtrackNuclearSlope(66.2);
	db.insert(pair<string,Material*>(B->GetSymbol(),B));


	//Carbon (graphite)
	Material* C = new Material();
	C->SetAtomicNumber(6);
	C->SetAtomicMass(12.0107);
	C->SetName("Carbon");
	C->SetSymbol("C");
	C->SetSixtrackTotalNucleusCrossSection(0.331);
	C->SetSixtrackInelasticNucleusCrossSection(0.231);
	C->SetSixtrackRutherfordCrossSection(0.000076);
	C->SetSixtrackdEdx(0.68);
//	C->rho=2.265;		//Check
	C->SetConductivity(7.14E4);
	C->SetRadiationLength(427000);
//	C->SetRadiationLength(C->CalculateRadiationLength());
	C->SetDensity(2210);
	C->SetSixtrackNuclearSlope(70.0);
	C->SetMeanExcitationEnergy(78.0*eV);
	C->SetElectronDensity(C->CalculateElectronDensity());
//	C->SetElectronCriticalEnergy(81.74*MeV);
	C->SetPlasmaEnergy(C->CalculatePlasmaEnergy());
	db.insert(pair<string,Material*>(C->GetSymbol(),C));
	
	/**
	 * Carbon (C2)
	 **/
	Material* C2 = new Material();
	C2->SetAtomicNumber(6);
	C2->SetAtomicMass(12.0107);
	C2->SetName("Carbon2");
	C2->SetSymbol("C2");
	C2->SetSixtrackTotalNucleusCrossSection(0.337);
	C2->SetSixtrackInelasticNucleusCrossSection(0.232);
	C2->SetSixtrackRutherfordCrossSection(0.000077);
	C2->SetSixtrackdEdx(0.68);
	C2->SetConductivity(7.14E4);
	C2->SetRadiationLength(424900);
	C2->SetDensity(4520);
	C2->SetSixtrackNuclearSlope(70.0);
	C2->SetMeanExcitationEnergy(78.0*eV);
	C2->SetElectronDensity(C->CalculateElectronDensity());
	C2->SetPlasmaEnergy(C->CalculatePlasmaEnergy());
	db.insert(pair<string,Material*>(C2->GetSymbol(),C2));

	//Oxygen (note the density, etc is for liquid)!
	//Some of these parameters are rather invalid
	//Also note that bits of the scattering code currently are invalid for non-solids.
	Material* O = new Material();
	O->SetAtomicNumber(8);
	O->SetAtomicMass(15.9994);
	O->SetName("Oxygen");
	O->SetSymbol("O");
	O->SetSixtrackTotalNucleusCrossSection(O->CalculateSixtrackTotalNucleusCrossSection());
	O->SetSixtrackInelasticNucleusCrossSection(O->CalculateSixtrackInelasticNucleusCrossSection());
	O->SetSixtrackRutherfordCrossSection(O->CalculateSixtrackRutherfordCrossSection());
	O->SetSixtrackdEdx(O->CalculateSixtrackdEdx());
	O->SetConductivity(1);	//See here
	O->SetRadiationLength(O->CalculateRadiationLength());
	O->SetDensity(1140);	//And here
	O->SetSixtrackNuclearSlope(O->CalculateSixtrackNuclearSlope());
	O->SetMeanExcitationEnergy(95.0*eV);
	O->SetElectronDensity(O->CalculateElectronDensity());
//	O->SetElectronCriticalEnergy(66.82*MeV);
	O->SetPlasmaEnergy(O->CalculatePlasmaEnergy());
	db.insert(pair<string,Material*>(O->GetSymbol(),O));

	//Aluminium
	Material* Al = new Material();
	Al->SetAtomicNumber(13);
	Al->SetAtomicMass(26.9815386);
	Al->SetName("Aluminium");
	Al->SetSymbol("Al");
	Al->SetSixtrackTotalNucleusCrossSection(0.634);
	Al->SetSixtrackInelasticNucleusCrossSection(0.421);
	Al->SetSixtrackRutherfordCrossSection(0.00034);
	Al->SetSixtrackdEdx(0.81);
//	Al->rho=2.70;
	Al->SetConductivity(3.564E7);
	Al->SetRadiationLength(Al->CalculateRadiationLength());
	Al->SetDensity(2699);
	Al->SetSixtrackNuclearSlope(120.3);
	Al->SetMeanExcitationEnergy(166.0*eV);
	Al->SetElectronDensity(Al->CalculateElectronDensity());
//	Al->SetElectronCriticalEnergy(42.70*MeV);
	Al->SetPlasmaEnergy(Al->CalculatePlasmaEnergy());
	db.insert(pair<string,Material*>(Al->GetSymbol(),Al));

	//Iron
	Material* Fe = new Material();
	Fe->SetAtomicNumber(26);
	Fe->SetAtomicMass(55.845);
	Fe->SetName("Iron");
	Fe->SetSymbol("Fe");
	Fe->SetSixtrackTotalNucleusCrossSection(Fe->CalculateSixtrackTotalNucleusCrossSection());
	Fe->SetSixtrackInelasticNucleusCrossSection(Fe->CalculateSixtrackInelasticNucleusCrossSection());
	Fe->SetSixtrackRutherfordCrossSection(Fe->CalculateSixtrackRutherfordCrossSection());
	Fe->SetSixtrackdEdx(Fe->CalculateSixtrackdEdx());
//	Fe->rho=7.87;
	Fe->SetConductivity(1.04E7);
	Fe->SetRadiationLength(Fe->CalculateRadiationLength());
	Fe->SetDensity(7870);
	Fe->SetSixtrackNuclearSlope(Fe->CalculateSixtrackNuclearSlope());
	Fe->SetMeanExcitationEnergy(286.0*eV);
	Fe->SetElectronDensity(Fe->CalculateElectronDensity());
//	Fe->SetElectronCriticalEnergy(21.68*MeV);
	Fe->SetPlasmaEnergy(Fe->CalculatePlasmaEnergy());
	db.insert(pair<string,Material*>(Fe->GetSymbol(),Fe));

	//Nickel
	Material* Ni = new Material();
	Ni->SetAtomicNumber(28);
	Ni->SetAtomicMass(58.6934);
	Ni->SetName("Nickel");
	Ni->SetSymbol("Ni");
	Ni->SetSixtrackTotalNucleusCrossSection(Ni->CalculateSixtrackTotalNucleusCrossSection());
	Ni->SetSixtrackInelasticNucleusCrossSection(Ni->CalculateSixtrackInelasticNucleusCrossSection());
	//~ Ni->SetSixtrackRutherfordCrossSection(Ni->CalculateSixtrackRutherfordCrossSection());
	Ni->SetSixtrackRutherfordCrossSection(0.001329);
	Ni->SetSixtrackdEdx(Ni->CalculateSixtrackdEdx());
//	Ni->rho=8.90;
	Ni->SetConductivity(1.44E7);
	Ni->SetRadiationLength(Ni->CalculateRadiationLength());
	Ni->SetDensity(8900);
	Ni->SetSixtrackNuclearSlope(Ni->CalculateSixtrackNuclearSlope());
	Ni->SetMeanExcitationEnergy(311.0*eV);
	Ni->SetElectronDensity(Ni->CalculateElectronDensity());
//	Ni->SetElectronCriticalEnergy(20.05*MeV);
	Ni->SetPlasmaEnergy(Ni->CalculatePlasmaEnergy());
	db.insert(pair<string,Material*>(Ni->GetSymbol(),Ni));

	//Copper
	//~ Material* Cu = new Material();
	//~ Cu->SetAtomicNumber(29);
	//~ Cu->SetAtomicMass(63.546);
	//~ Cu->SetName("Copper");
	//~ Cu->SetSymbol("Cu");
	//~ Cu->SetSixtrackTotalNucleusCrossSection(1.232);
	//~ Cu->SetSixtrackInelasticNucleusCrossSection(0.782);
	//~ Cu->SetSixtrackRutherfordCrossSection(0.00153);
	//~ Cu->SetSixtrackdEdx(2.69);
//~ //	Cu->SetSixtrackdEdx(1.250776630157339);
//~ //	Cu->rho=8.96;
	//~ Cu->SetConductivity(5.98E7);
	//~ Cu->SetRadiationLength(Cu->CalculateRadiationLength());
	//~ Cu->SetDensity(8960);
	//~ Cu->SetSixtrackNuclearSlope(217.8);
	//~ Cu->SetMeanExcitationEnergy(322.0*eV);
	//~ Cu->SetElectronDensity(Cu->CalculateElectronDensity());
//~ //	Cu->SetElectronCriticalEnergy(19.42*MeV);
	//~ Cu->SetPlasmaEnergy(Cu->CalculatePlasmaEnergy());
	//~ db.insert(pair<string,Material*>(Cu->GetSymbol(),Cu));
	
	/** Updated Copper using latest SixTrack reference cross sections 
	 * HR April 2016
	 **/
	Material* Cu = new Material();
	Cu->SetAtomicNumber(29);
	Cu->SetAtomicMass(63.546);
	Cu->SetName("Copper");
	Cu->SetSymbol("Cu");
	Cu->SetSixtrackTotalNucleusCrossSection(1.253);
	Cu->SetSixtrackInelasticNucleusCrossSection(0.769);
	Cu->SetSixtrackRutherfordCrossSection(0.001523);
	Cu->SetSixtrackdEdx(2.69);
	Cu->SetConductivity(5.98E7);
	Cu->SetRadiationLength(Cu->CalculateRadiationLength());
	Cu->SetDensity(8960);
	Cu->SetSixtrackNuclearSlope(217.8);
	Cu->SetMeanExcitationEnergy(322.0*eV);
	Cu->SetElectronDensity(Cu->CalculateElectronDensity());
	Cu->SetPlasmaEnergy(Cu->CalculatePlasmaEnergy());
	db.insert(pair<string,Material*>(Cu->GetSymbol(),Cu));

	//~ //Molybdenum
	//~ Material* Mo = new Material();
	//~ Mo->SetAtomicNumber(42);
	//~ Mo->SetAtomicMass(95.96);
	//~ Mo->SetName("Molybdenum");
	//~ Mo->SetSymbol("Mo");
	//~ Mo->SetSixtrackTotalNucleusCrossSection(Mo->CalculateSixtrackTotalNucleusCrossSection());
	//~ Mo->SetSixtrackInelasticNucleusCrossSection(Mo->CalculateSixtrackInelasticNucleusCrossSection());
	//~ //Mo->SetSixtrackRutherfordCrossSection(Mo->CalculateSixtrackRutherfordCrossSection());
	//~ Mo->SetSixtrackRutherfordCrossSection(0.00264483);
	//~ Mo->SetSixtrackdEdx(Mo->CalculateSixtrackdEdx());
//~ //	Mo->rho=10.2;
	//~ Mo->SetConductivity(1.87E7);
	//~ Mo->SetRadiationLength(Mo->CalculateRadiationLength());
	//~ Mo->SetDensity(10200);
	//~ Mo->SetSixtrackNuclearSlope(Mo->CalculateSixtrackNuclearSlope());
	//~ Mo->SetMeanExcitationEnergy(424.0*eV);
	//~ Mo->SetElectronDensity(Mo->CalculateElectronDensity());
//~ //	Mo->SetElectronCriticalEnergy(13.85*MeV);
	//~ Mo->SetPlasmaEnergy(Mo->CalculatePlasmaEnergy());
	//~ db.insert(pair<string,Material*>(Mo->GetSymbol(),Mo));
	
	/** Updated Molybdenum using recent SixTrack nuclear cross sections
	 * HR April 2016
	 **/
	Material* Mo = new Material();
	Mo->SetAtomicNumber(42);
	Mo->SetAtomicMass(95.96);
	Mo->SetName("Molybdenum");
	Mo->SetSymbol("Mo");
	Mo->SetSixtrackTotalNucleusCrossSection(1.713);
	Mo->SetSixtrackInelasticNucleusCrossSection(1.023);
	Mo->SetSixtrackRutherfordCrossSection(0.002645);
	Mo->SetSixtrackdEdx(Mo->CalculateSixtrackdEdx());
	Mo->SetConductivity(1.87E7);
	Mo->SetRadiationLength(Mo->CalculateRadiationLength());
	Mo->SetDensity(10200);
	Mo->SetSixtrackNuclearSlope(273.895);
	Mo->SetMeanExcitationEnergy(424.0*eV);
	Mo->SetElectronDensity(Mo->CalculateElectronDensity());
//	Mo->SetElectronCriticalEnergy(13.85*MeV);
	Mo->SetPlasmaEnergy(Mo->CalculatePlasmaEnergy());
	db.insert(pair<string,Material*>(Mo->GetSymbol(),Mo));

	//Tungsten
	Material* W = new Material();
	W->SetAtomicNumber(74);
	W->SetAtomicMass(183.84);
	W->SetName("Tungsten");
	W->SetSymbol("W");
	W->SetSixtrackTotalNucleusCrossSection(2.767);
	W->SetSixtrackInelasticNucleusCrossSection(1.65);
	W->SetSixtrackRutherfordCrossSection(0.00768);
	W->SetSixtrackdEdx(5.79);
//	W->rho=19.3;
	W->SetConductivity(1.77E3);
	//W->SetRadiationLength(0.003504);
	W->SetRadiationLength(W->CalculateRadiationLength());
	W->SetDensity(19300);
	W->SetSixtrackNuclearSlope(440.3);
	W->SetMeanExcitationEnergy(727.0*eV);
	W->SetElectronDensity(W->CalculateElectronDensity());
//	W->SetElectronCriticalEnergy(7.97*MeV);
	W->SetPlasmaEnergy(W->CalculatePlasmaEnergy());
	db.insert(pair<string,Material*>(W->GetSymbol(),W));

	//Lead
	Material* Pb = new Material();
	Pb->SetAtomicNumber(82);
	Pb->SetAtomicMass(207.2);
	Pb->SetName("Lead");
	Pb->SetSymbol("Pb");
	Pb->SetSixtrackTotalNucleusCrossSection(2.960);
	Pb->SetSixtrackInelasticNucleusCrossSection(1.77);
	Pb->SetSixtrackRutherfordCrossSection(0.00907);
	Pb->SetSixtrackdEdx(3.40);
	Pb->SetConductivity(4.8077E6);
//	Pb->SetRadiationLength(0.005612);
	Pb->SetRadiationLength(Pb->CalculateRadiationLength());
	Pb->SetDensity(11350);
	Pb->SetSixtrackNuclearSlope(455.3);
	Pb->SetMeanExcitationEnergy(823.0*eV);
	Pb->SetElectronDensity(Pb->CalculateElectronDensity());
//	Pb->SetElectronCriticalEnergy(7.43*MeV);
	Pb->SetPlasmaEnergy(Pb->CalculatePlasmaEnergy());
	db.insert(pair<string,Material*>(Pb->GetSymbol(),Pb));

	/**
	* AC150K (CFC)
	* LHC TCP/TCSG collimator material
	* Graphite but different density etc.
	**/
	Material* AC150K = new Material();
	AC150K->SetAtomicNumber(6);
	AC150K->SetAtomicMass(12.0107);
	AC150K->SetName("AC150K");
	AC150K->SetSymbol("AC150K");
	AC150K->SetSixtrackTotalNucleusCrossSection(0.331);
	AC150K->SetSixtrackInelasticNucleusCrossSection(0.231);
	AC150K->SetSixtrackRutherfordCrossSection(0.000076);
	AC150K->SetSixtrackdEdx(0.68);		//Needs to be scaled
	AC150K->SetConductivity(0.14E6);	// HR update
	AC150K->SetRadiationLength(AC150K->CalculateRadiationLength());
	AC150K->SetDensity(1650);		//This is different - was 2210
	AC150K->SetSixtrackNuclearSlope(70.0);
	AC150K->SetMeanExcitationEnergy(78.0*eV);
	AC150K->SetElectronDensity(AC150K->CalculateElectronDensity());
	AC150K->SetPlasmaEnergy(AC150K->CalculatePlasmaEnergy());
	db.insert(pair<string,Material*>(AC150K->GetSymbol(),AC150K));

	/**
	* INERMET 180: LHC TCLA/TCT material
	* Tungsten alloy with Nickel and Copper
	* Updated using N. Mariani PhD thesis CERN-THESIS-2014-363
	**/
	CompositeMaterial* IT180 = new CompositeMaterial();
	IT180->SetName("INERMET180");
	IT180->SetSymbol("IT180");
	IT180->AddMaterialByMassFraction(W,0.95);
	IT180->AddMaterialByMassFraction(Ni,0.035);
	IT180->AddMaterialByMassFraction(Cu,0.015);

	IT180->SetDensity(18000);
	IT180->SetConductivity(8.6E6);
	IT180->Assemble();
	
	if(ST_CS){
		IT180->SetSixtrackTotalNucleusCrossSection(2.548);
		IT180->SetSixtrackInelasticNucleusCrossSection(1.473);
		IT180->SetSixtrackRutherfordCrossSection(0.005737);
	}
	
	IT180->VerifyMaterial();
	db.insert(pair<string,Material*>(IT180->GetSymbol(),IT180));

	/**
	* LHC TCLA/TCL material
	* Copper + Aluminium Oxide powder 
	* Glidcop - 99.72% Copper + 0.28% Aluminium Oxide (AL2O3) for Glidcop-15 by mass
	**/
	//~ CompositeMaterial* Glidcop = new CompositeMaterial();
	//~ Glidcop->SetName("Glidcop");
	//~ Glidcop->SetSymbol("GCOP");
	//~ double Al_M = 0.4 * Al->GetAtomicNumber();
	//~ double O_M = 0.6 * O->GetAtomicNumber();
	//~ Glidcop->AddMaterialByMassFraction(Cu,0.9972);
	//~ Glidcop->AddMaterialByMassFraction(Al,0.0028 * Al_M / (Al_M + O_M));
	//~ Glidcop->AddMaterialByMassFraction(O,0.0028 * O_M / (Al_M + O_M));

	//~ Glidcop->SetDensity(8930);
	//~ Glidcop->SetConductivity(5.38E7);	//CERN-ATS-2011-224	
	//~ Glidcop->Assemble();
	
	//~ if(ST_CS){
		//~ Glidcop->SetSixtrackTotalNucleusCrossSection(1.255);
		//~ Glidcop->SetSixtrackInelasticNucleusCrossSection(0.77);
		//~ Glidcop->SetSixtrackRutherfordCrossSection(0.001402);
	//~ }
	
	//~ Glidcop->VerifyMaterial();
	//~ Glidcop->VerifyMaterial();
	//~ db.insert(pair<string,Material*>(Glidcop->GetSymbol(),Glidcop));

	/**
	* LHC TCLA/TCL material
	* Copper + Aluminium Oxide powder 
	* Glidcop - 99.72% Copper + 0.28% Aluminium Oxide (AL2O3) for Glidcop-15 by mass
	**/
	// This is a messy material for testing only
	// First make an Al2O3 (don't have Rutherford cross section for O)
	Material* AlOx = new Material();
	AlOx->SetName("AluminiumOxide");
	AlOx->SetSymbol("Al2O3");
	AlOx->SetAtomicMass(20.392);
	AlOx->SetAtomicNumber(10);
	AlOx->SetSixtrackInelasticNucleusCrossSection(0.344);
	AlOx->SetSixtrackNuclearSlope(100.1);
	AlOx->SetSixtrackRutherfordCrossSection(0.000203);
	AlOx->SetSixtrackTotalNucleusCrossSection(0.517);
	//~ AlOx->SetSixtrackdEdx(AlOx->CalculateSixtrackdEdx()); //returns 1
	AlOx->SetSixtrackdEdx(0.81); // Value for Al
	AlOx->SetRadiationLength(279400);
	AlOx->SetDensity(3.97);
	AlOx->SetElectronDensity(AlOx->CalculateElectronDensity());
	AlOx->SetPlasmaEnergy(AlOx->CalculatePlasmaEnergy());
	AlOx->SetMeanExcitationEnergy(AlOx->CalculateMeanExcitationEnergy());
	
	CompositeMaterial* Glidcop = new CompositeMaterial();
	Glidcop->SetName("Glidcop");
	Glidcop->SetSymbol("GCOP");
	//~ double Al_M = 0.4 * Al->GetAtomicNumber();
	//~ double O_M = 0.6 * O->GetAtomicNumber();
	Glidcop->AddMaterialByMassFraction(Cu,0.997);
	Glidcop->AddMaterialByMassFraction(AlOx,0.003);

	Glidcop->SetDensity(8930);
	Glidcop->SetConductivity(5.38E7);	//CERN-ATS-2011-224	
	Glidcop->Assemble();
	
	if(ST_CS){
		Glidcop->SetSixtrackTotalNucleusCrossSection(1.246);
		Glidcop->SetSixtrackInelasticNucleusCrossSection(0.765);
		Glidcop->SetSixtrackRutherfordCrossSection(0.001385);
	}
	
	Glidcop->VerifyMaterial();
	db.insert(pair<string,Material*>(Glidcop->GetSymbol(),Glidcop));
	
	/**
	* New LHC TCS material
	* Mo-Graphite mix, density 2.6
	* Mo 21%, C 79%, by Mass
	* Source: Elena Quaranta - elena.quaranta@cern.ch
	* Updated using N. Mariani PhD thesis CERN-THESIS-2014-363
	**/
	//~ CompositeMaterial* MoGr = new CompositeMaterial();
	//~ MoGr->SetName("MoGr");
	//~ MoGr->SetSymbol("MoGr");
	//~ MoGr->AddMaterialByMassFraction(Mo,0.21);
	//~ MoGr->AddMaterialByMassFraction(C,0.79);
	//~ MoGr->Assemble();
	//~ MoGr->SetDensity(2690);
	//~ MoGr->SetConductivity(1E6);
	//~ MoGr->Assemble();
	//~ MoGr->VerifyMaterial();
	//~ db.insert(pair<string,Material*>(MoGr->GetSymbol(),MoGr));
	
	/**
	 * Molybdenum Carbide made using C2
	 * 2/3 Mo, 1/3 C by number fraction
	 **/
	 
	CompositeMaterial* Mo2C = new CompositeMaterial();
	Mo2C->SetName("MolybdenumCarbide");
	Mo2C->SetSymbol("Mo2C");
	Mo2C->AddMaterialByNumberFraction(Mo, 0.667);
	Mo2C->AddMaterialByNumberFraction(C2, 0.333);
	Mo2C->SetDensity(8400);
	Mo2C->SetConductivity(1.4E6);
	Mo2C->Assemble();
	
	if(ST_CS){
		Mo2C->SetSixtrackTotalNucleusCrossSection(1.255);
		Mo2C->SetSixtrackInelasticNucleusCrossSection(0.759);
		Mo2C->SetSixtrackRutherfordCrossSection(0.001475);
		//Mo2C->SetSixtrackNuclearSlope(218.9);
	}
	Mo2C->VerifyMaterial();
	db.insert(pair<string,Material*>(Mo2C->GetSymbol(),Mo2C));
	
	
	/**
	 * Updated molybdenum-carbide-graphite
	 * density 2.5
	 * Mass fractions: 12.8917% Mo, 87.1083% C
	 * Number fractions: 1.8% Mo, 98.2% C
	 **/
	 
	CompositeMaterial* MoGr = new CompositeMaterial();
	MoGr->SetName("MolybdenumCarbideGraphite");
	MoGr->SetSymbol("MoGr");
	
	// number frac
	double Mo_M = 0.667 * Mo->GetAtomicNumber();
	double C_M = 0.333 * C->GetAtomicNumber();
	double Mo_tot = 0.027 * Mo_M / (Mo_M + C_M);
	//MoGr->AddMaterialByNumberFraction(Mo,Mo_tot);
	// MoGr->AddMaterialByNumberFraction(C,(1 - Mo_tot));
	//MoGr->AddMaterialByNumberFraction(Mo,0.018);
	//MoGr->AddMaterialByNumberFraction(C,0.982);
	
	// test with pure carbon
	//~ MoGr->AddMaterialByNumberFraction(C2,(0.333*0.01698));	
	//~ MoGr->AddMaterialByNumberFraction(Mo,(0.667*0.01698));
	//~ MoGr->AddMaterialByNumberFraction(C,0.98302);
	
	// test with Mo2C
	//~ MoGr->AddMaterialByNumberFraction(Mo2C,0.027);
	//~ MoGr->AddMaterialByNumberFraction(C,0.973);
	
	// use	
	MoGr->AddMaterialByNumberFraction(Mo,0.01698);
	MoGr->AddMaterialByNumberFraction(C,0.98302);
	
	// mass frac
	//double Mo_M = 0.941 * Mo->GetAtomicNumber();
	//double C_M = 0.059 * C->GetAtomicNumber();
	//~ double Mo_tot = 0.128917 * 0.941;
	//~ MoGr->AddMaterialByMassFraction(Mo,Mo_tot);
	//~ MoGr->AddMaterialByMassFraction(C,(1 - Mo_tot));
			
	MoGr->SetDensity(2500);
	MoGr->SetConductivity(1E6);
	MoGr->Assemble();
	
	if(ST_CS){
		MoGr->SetSixtrackTotalNucleusCrossSection(0.362);
		MoGr->SetSixtrackInelasticNucleusCrossSection(0.247);
		MoGr->SetSixtrackRutherfordCrossSection(0.000094);
		//MoGr->SetSixtrackNuclearSlope(79.69);
	}
	
	MoGr->VerifyMaterial();
	db.insert(pair<string,Material*>(MoGr->GetSymbol(),MoGr));
	
	/**
	 * Carbon Diamond - similar to Carbon
	 * Used for Copper-Diamond composite
	 * data from E. Quaranta, private communication
	 * conductivity used is that of carbon fibre - probably incorrect
	 **/
	Material* CD = new Material();
	CD->SetAtomicNumber(6);
	CD->SetAtomicMass(12.0107);
	CD->SetName("CarbonDiamond");
	CD->SetSymbol("CD");
	CD->SetSixtrackTotalNucleusCrossSection(0.337);
	CD->SetSixtrackInelasticNucleusCrossSection(0.232);
	CD->SetSixtrackRutherfordCrossSection(0.000078);
	CD->SetSixtrackdEdx(0.68);
	CD->SetConductivity(7.14E4);
	CD->SetRadiationLength(427000);
	CD->SetDensity(3520);
	CD->SetSixtrackNuclearSlope(70.9);
	CD->SetMeanExcitationEnergy(CD->CalculateMeanExcitationEnergy());
	CD->SetElectronDensity(C->CalculateElectronDensity());
	CD->SetPlasmaEnergy(C->CalculatePlasmaEnergy());
	db.insert(pair<string,Material*>(CD->GetSymbol(),CD));
	
	/**
	 * Copper Carbon Diamond
	 * data from E. Quaranta, private communication
	 **/	
	CompositeMaterial* CuCD = new CompositeMaterial();
	CuCD->SetName("CopperCarbonDiamond");
	CuCD->SetSymbol("CuCD");
	

	//~ CuCD->AddMaterialByMassFraction(CD,0.349);
	//~ CuCD->AddMaterialByMassFraction(Cu,0.647);
	//~ CuCD->AddMaterialByMassFraction(B,0.00439);
	
	// normalised
	CuCD->AddMaterialByMassFraction(CD,0.3489);
	CuCD->AddMaterialByMassFraction(Cu,0.6467);
	CuCD->AddMaterialByMassFraction(B,0.0044);

	//~ CuCD->AddMaterialByNumberFraction(Cu,0.23598);
	//~ CuCD->AddMaterialByNumberFraction(CD,0.754589);
	//~ CuCD->AddMaterialByNumberFraction(B,0.009431);
	
	CuCD->SetDensity(5400);
	CuCD->SetConductivity(12.6E6);
	CuCD->Assemble();
	
	if(ST_CS){
		CuCD->SetSixtrackTotalNucleusCrossSection(0.572);
		CuCD->SetSixtrackInelasticNucleusCrossSection(0.370);
		CuCD->SetSixtrackRutherfordCrossSection(0.000279);
	}
	
	CuCD->VerifyMaterial();
	db.insert(pair<string,Material*>(CuCD->GetSymbol(),CuCD));
		
}

//Try and find the material we want
Material* MaterialDatabase::FindMaterial(string symbol)
{
	//Iterator for use with the material pointers map
	std::map<string,Material*>::iterator position;

	//Try to find the material required
	position = db.find(symbol);

	//did not find the material, this is bad.
	if(position == db.end())
	{
		std::cerr << "Requested aperture material not found. Exiting." << std::endl;
		exit(EXIT_FAILURE);
	}

	//This should return a pointer to the material we are interested in.
	return position->second;
}

bool MaterialDatabase::VerifyMaterials()
{
	bool verification = true;
	std::map<string,Material*>::const_iterator MaterialIt;
	MaterialIt = db.begin();
	while(MaterialIt != db.end())
	{
		bool test = MaterialIt->second->VerifyMaterial();
		if(test == false)
		{
			verification = false;
			std::cerr << "Material " << MaterialIt->second->GetName() << " failed to verify." << std::endl;
		}
		MaterialIt++;
	}
	return verification;
}

void MaterialDatabase::DumpMaterialProperties()
{
	std::cout.precision(5);
	std::cout << std::setw(15) << "Name" << std::setw(7) << "Symb" << std::setw(4) << "Z";
	std::cout << std::setw(7) << "A" << std::setw(6) << "dnsty" << std::setw(7) << "X0 mm";
	std::cout << std::setw(10) << "X0 m";
	std::cout << std::setw(11) << "n_e" << std::setw(11) << "E_plas";
	std::cout << std::setw(8) << "sig_tot" << std::setw(8) << "sig_in" << std::setw(8) << "sig_R";
	std::cout << std::setw(8) << "dEdx";
	std::cout << std::endl;

	std::map<string,Material*>::const_iterator MaterialIt;
	MaterialIt = db.begin();
	while(MaterialIt != db.end())
	{
		Material* m = MaterialIt->second;
		if(!m->IsMixture())
		{
			std::cout << std::setw(15)<< m->GetName();
			std::cout << std::setw(7) << m->GetSymbol();
			std::cout << std::setw(4) << m->GetAtomicNumber();
			std::cout << std::setw(7) << m->GetAtomicMass();
			std::cout << std::setw(6) << m->GetDensity();
			std::cout << std::setw(7) << m->GetRadiationLength()/m->GetDensity();
			std::cout << std::setw(10) << m->GetRadiationLengthInM();
			std::cout << std::setw(11)<< m->GetElectronDensity();
			std::cout << std::setw(11)<< m->GetPlasmaEnergy();

			std::cout << std::setw(8) << m->GetSixtrackTotalNucleusCrossSection();
			std::cout << std::setw(8) << m->GetSixtrackInelasticNucleusCrossSection();
			std::cout << std::setw(8) << m->GetSixtrackRutherfordCrossSection();
			std::cout << std::setw(8) << m->GetSixtrackdEdx();
			std::cout << std::endl;
		}
		MaterialIt++;
	}

	std::cout << "Mixtures:" <<  std::endl;
	std::cout << std::setw(15) << "Name" << std::setw(7) << "Symb";
	std::cout << std::setw(6) << "dnsty" << std::setw(7) << "X0 mm";
	std::cout << std::setw(10) << "X0 m";
	std::cout << std::setw(11) << "n_e" << std::setw(11) << "E_plas";
	std::cout << std::setw(8) << "dEdx";
	std::cout << std::endl;
	MaterialIt = db.begin();
	while(MaterialIt != db.end())
	{
		Material* m = MaterialIt->second;
		if(m->IsMixture())
		{
			std::cout << std::setw(15)<< m->GetName();
			std::cout << std::setw(7) << m->GetSymbol();
			std::cout << std::setw(6) << m->GetDensity();
			std::cout << std::setw(7) << m->GetRadiationLength()/m->GetDensity();
			std::cout << std::setw(10) << m->GetRadiationLengthInM();
			std::cout << std::setw(11) << m->GetElectronDensity();
			std::cout << std::setw(11) << m->GetPlasmaEnergy();
			std::cout << std::setw(8) << m->GetSixtrackdEdx();
			std::cout << std::endl;
		}
		MaterialIt++;
	}
}
