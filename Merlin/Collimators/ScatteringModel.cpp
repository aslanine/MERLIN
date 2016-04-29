/////////////////////////////////////////////////////////////////////////
//
// Merlin C++ Class Library for Charged Particle Accelerator Simulations
//  
// Class library version 5.01 (2015)
// 
// Copyright: see Merlin/copyright.txt
//
// Created:		
// Modified:	07.09.15 Haroon Rafique		
// Last Edited: 07.09.15 HR
// 
/////////////////////////////////////////////////////////////////////////
#include <iostream>
#include <fstream>
#include <iomanip>
#include <string>
#include <sstream>
#include <cstring>

#include "Collimators/ScatteringModel.h"
#include "Collimators/DiffractiveScatter.h"
#include "Collimators/ElasticScatter.h"

#include "NumericalUtils/utils.h"
#include "NumericalUtils/PhysicalUnits.h"
#include "NumericalUtils/PhysicalConstants.h"
#include "NumericalUtils/NumericalConstants.h"

#include "Random/RandomNG.h"

using namespace ParticleTracking;
using namespace PhysicalUnits;
using namespace PhysicalConstants;
using namespace Collimation;
using namespace std;

ScatteringModel::ScatteringModel()
{
	useComposites = 1;	
	ScatterPlot_on = 0;
	JawImpact_on = 0;
	JawInelastic_on = 0;
}

ScatteringModel::ScatteringModel(bool composites)
{
	useComposites = composites;
	ScatterPlot_on = 0;
	JawImpact_on = 0;
	JawInelastic_on = 0;
}

double ScatteringModel::PathLength(Material* mat, double E0){ 
	
	// Note that this is called for every individual particle, each time it is outside a collimator aperture
	// i.e. inside a collimator jaw, or each time it has travelled past the bin_size in said jaw
	
	//~ std::cout << "\nScatteringModel::PathLength: Start PathLength()" << std::endl;
	
	// Perform a dynamic cast to check if our material is a Composite
	CompositeMaterial* aComposite = dynamic_cast<CompositeMaterial*>(mat);
	bool composite = 0;
	if(aComposite){composite = 1;}
	bool composite_stored = 0;
	bool not_at_end = 1;
	
	static double lambda; 
	CrossSections* CurrentCS;
			
	// Pre-check to store the composite imaginary nucleus - this is a marker when using composites
	// i.e. it simply indicates that the CrossSections for each constituent has been calculated and stored
	if(composite && useComposites){		
		// Check if the composite has already been stored
		CS_iterator = stored_cross_sections.find(mat->GetSymbol());	
		
		// If it hasn't we must store the imaginary composite nucleus as a marker to indicate that the rest of the constituents have been stored
		if (CS_iterator == stored_cross_sections.end() ){			
			//~ std::cout << "\tScatteringModel::PathLength: Composite stored cross section not found for : " << mat->GetSymbol() << endl;		
			CurrentCS = new CrossSections(mat, E0, ScatteringPhysicsModel);		
			stored_cross_sections.insert(std::map< string, Collimation::CrossSections* >::value_type((mat->GetSymbol()), CurrentCS));
			CS_iterator = stored_cross_sections.find(mat->GetSymbol());	
			//~ std::cout << "\tScatteringModel::PathLength: Composite CrossSection stored for : " << mat->GetSymbol() << endl;		
			
			// Now we must configure the ScatteringProcesses for this element
			ConfigureProcesses(CurrentCS, mat);			
		}
		else{composite_stored = 1;}				
	}
	
	// If the composite hasn't already been stored, we have to add a CrossSection for each individual element
	if(composite && useComposites && !composite_stored){		
		std::cout << "\tScatteringModel::PathLength: Iterating through composite sub-elements for : " << mat->GetSymbol() << endl;		
		// Iterate through composite list to see if the elements are stored in our stored cross sections
		aComposite->MixtureMapIterator = aComposite->MixtureMap.begin();
		
		while(aComposite->MixtureMapIterator != aComposite->MixtureMap.end()){		
					
			std::cout << "\tScatteringModel::PathLength: Iterator pass element : " << aComposite->MixtureMapIterator->first->GetSymbol();
			std::cout << ", in material : " << mat->GetSymbol() << endl;
			CS_iterator = stored_cross_sections.find( aComposite->MixtureMapIterator->first->GetSymbol() );

			// Constituent element of composite is not stored, have to create and store it
			if (CS_iterator == stored_cross_sections.end() ){

				CurrentCS = new CrossSections(aComposite->MixtureMapIterator->first, E0, ScatteringPhysicsModel);
				stored_cross_sections.insert(std::map< string, Collimation::CrossSections* >::value_type((aComposite->MixtureMapIterator->first->GetSymbol()), CurrentCS));
				
				std::cout << "\tScatteringModel::PathLength: Calculating fractions in composite sub-element: " << aComposite->MixtureMapIterator->first->GetSymbol();
				std::cout << ", in material : " << mat->GetSymbol() << endl;	
				ConfigureProcesses(CurrentCS, aComposite->MixtureMapIterator->first);	
				
				string CounterName = mat->GetSymbol();
				CounterName += "_";
				CounterName += aComposite->MixtureMapIterator->first->GetSymbol();
				
				CompCounter.insert(std::map<string, int>::value_type(CounterName,0));
							
			}
			++aComposite->MixtureMapIterator;
		}
		
		// Select a weighted random element		
		string RandomElement = aComposite->GetRandomMaterialSymbol();
		//~ cout << "ScatteringModel::PathLength: Selected random element from composite : " << RandomElement << endl;
		CS_iterator = stored_cross_sections.find(RandomElement);
		if (CS_iterator == stored_cross_sections.end() ){
			cout << "ERROR: ScatteringModel::PathLength: Composite Constituent not found" << endl;
		}
	}
	
	else{
		// Check stored cross sections for a stored CrossSection for this symbol
		CS_iterator = stored_cross_sections.find(mat->GetSymbol());				
				
		// If find gets to the end of the stored_cross_sections map, there is no value stored
		if (CS_iterator == stored_cross_sections.end() ){	
					
			std::cout << "\nScatteringModel::PathLength: Stored CrossSection not found " << endl;
		
			// Create a CrossSections, store it, and set the iterator to the correct position
			CurrentCS = new CrossSections(mat, E0, ScatteringPhysicsModel);
			stored_cross_sections.insert(std::map< string, Collimation::CrossSections* >::value_type(mat->GetSymbol(), CurrentCS));
			CS_iterator = stored_cross_sections.find(mat->GetSymbol());			
			
			std::cout << "\nScatteringModel::PathLength: Calculating fractions " << endl;
			
			// Now we must configure the ScatteringProcesses for this element
			ConfigureProcesses(CurrentCS, mat);
		}
		// Otherwise we already have a stored value for that element
		else{				
			//~ std::cout << "\nScatteringModel::PathLength: Stored cross sections found " << endl;
		
			//Should return a pointer to the CrossSections we require
			CurrentCS = CS_iterator->second;
			
			//Make sure that the CrossSections are for the same case (scattering etc)
			if (CurrentCS == CS_iterator->second){
				//~ cout << "\n\tScatteringModel::PathLength: CurrentCS == NewCS"<< endl;
			}	
			else {
				cout <<  "\n\tWarning: ScatteringModel::PathLength: CurrentCS != StoredCS, recalculating CrossSections" << endl;
				CurrentCS = new CrossSections(mat, E0, ScatteringPhysicsModel);			
				stored_cross_sections.insert(std::map< string, Collimation::CrossSections* >::value_type(mat->GetSymbol(), CurrentCS));		
				
				//Set iterator to correct position
				CS_iterator = stored_cross_sections.find(mat->GetSymbol());				
			}	
		}	
	}
	
	//Calculate mean free path
	lambda = CurrentCS->GetTotalMeanFreePath();
	//~ std::cout << "ScatteringModel::PathLength: lambda = " << lambda << endl;
	return -(lambda)*log(RandomNG::uniform(0,1));
}             

void ScatteringModel::ConfigureProcesses(CrossSections* CS, Material* mat){			
			double sigma = 0;
			int process_i = 0;
			
			// We have to make a new vector of pointers to ScatteringProcess for every material
			// otherwise we will always have the last configured materials when performing
			// scattering processes
			vector <Collimation::ScatteringProcess*> New_Processes;
			New_Processes.clear();
			vector<ScatteringProcess*>::iterator p;
			
			for(p = Processes.begin(); p != Processes.end(); ++p){
				cout << "Creating new ScatteringProcess::" << (*p)->GetProcessType() << endl;				
				New_Processes.push_back((*p)->getCopy());				
			}
			
			std::cout << "ScatteringModel::ConfigureProcesses: MATERIAL = " << mat->GetSymbol() <<", configuring ScatteringProcesses"  << std::endl;
			for(p = New_Processes.begin(); p != New_Processes.end(); p++){
				(*p)->Configure(mat, CS);
				fraction[process_i] = (*p)->sigma;
				cout << (*p)->GetProcessType() << "\t\t sigma = " << (*p)->sigma << " barns" << endl;
				sigma+= fraction[process_i];
				++process_i;
			}

			for(int j=0;j<fraction.size();j++){
				cout << " Process " << j << " total sigma " << setw(10) << setprecision(4) << sigma << "barns";
				fraction[j] /= sigma;
				cout << " fraction " << setw(10) << setprecision(4) << fraction[j] << endl;
			}
			
			stored_processes.insert(std::map< string, vector <Collimation::ScatteringProcess*> >::value_type(mat->GetSymbol(), New_Processes)); 
			stored_fractions.insert(std::map< string, vector <double> >::value_type(mat->GetSymbol(), fraction)); 
}

//Simple energy loss
void ScatteringModel::EnergyLoss(PSvector& p, double x, Material* mat, double E0, double E1){
	double dp = x * (mat->GetSixtrackdEdx());
    p.dp() = ((E1 - dp) - E0) / E0;
}

//Advanced energy loss
void ScatteringModel::EnergyLoss(PSvector& p, double x, Material* mat, double E0){
	
	double E1 = E0 * (1 + p.dp());
	double gamma = E1/(ProtonMassMeV*MeV);
	double beta = sqrt(1 - ( 1 / (gamma*gamma)));
	double I = mat->GetMeanExcitationEnergy()/eV;
	
	double land = RandomNG::landau();	
	
	double tmax = (2*ElectronMassMeV * beta * beta * gamma * gamma ) / (1 + (2 * gamma * (ElectronMassMeV/ProtonMassMeV)) + pow((ElectronMassMeV/ProtonMassMeV),2))*MeV;
	
	static const double xi1 = 2.0 * pi * pow(ElectronRadius,2) * ElectronMass * pow(SpeedOfLight,2);
	double xi0 = xi1 * mat->GetElectronDensity();	
	double xi = (xi0 * x /(beta*beta)) / ElectronCharge * (eV/MeV);

	double C = 1 + 2*log(I/(mat->GetPlasmaEnergy()/eV));
	double C1 = 0;
	double C0 = 0;

	if((I/eV) < 100)
	{
		if(C <= 3.681)
		{
			C0 = 0.2;
			C1 = 2.0;
		}
		else
		{
			C0 = 0.326*C - 1.0;
			C1 = 2.0;
		}
	}
	else	//I >= 100eV
	{
		if(C <= 5.215)
		{
			C0 = 0.2;
			C1 = 3.0;
		}
		else
		{
			C0 = 0.326*C - 1.5;
			C1 = 3.0;
		}
	}
	double delta = 0;
	
	//Density correction
	double ddx = log10(beta*gamma);
	if(ddx > C1)
	{
		delta = 4.606*ddx - C;
	}
	else if(ddx >= C0 && ddx <= C1)
	{
		double m = 3.0;
		double xa = C /4.606;
		double a = 4.606 * (xa - C0) / pow((C1-C0),m);
		delta = 4.606*ddx -C + a*pow((C1 - ddx),m);
	}
	else
	{
		delta = 0.0;
	}

	double tcut = 2.0*MeV;
	tcut = tmax;
	
	//Mott Correction
	double G = pi*FineStructureConstant*beta/2.0;
	double q = (2*(tmax/MeV)*(ElectronMassMeV) )/(pow((0.843/MeV),2));
	double S = log(1+q);
	double L1 = 0.0;
	double yL2 = FineStructureConstant/beta;

	double L2sum = 1.202001688211;	//Sequence limit calculated with mathematica
	double L2 = -yL2*yL2*L2sum;

	double F = G - S + 2*(L1 + L2);
	double deltaE = xi * (log(2 * ElectronMassMeV * beta*beta * gamma*gamma * (tcut/MeV)/pow(I/MeV,2)) - (beta*beta)*(1 + ((tcut/MeV)/(tmax/MeV))) - delta + F - 1.0 - euler);
	deltaE = xi * (log(2 * ElectronMassMeV * beta*beta * gamma*gamma * xi /pow(I/MeV,2)) - (beta*beta) - delta + F + 0.20);

	double dp = ((xi * land) - deltaE) * MeV;

    p.dp() = ((E1 - dp) - E0) / E0;
    // Set scatter type to any interaction
    if (p.type() == (-1 || 5))
    p.type() = 0;
}

//HR 29Aug13
void ScatteringModel::Straggle(PSvector& p, double x, Material* mat, double E1, double E2){

	static const double root12 = sqrt(12.0);
	double scaledx=x/mat->GetRadiationLengthInM();
	double Eav = (E1+E2)/2.0;
	double theta0 = 13.6*MeV * sqrt (scaledx) * (1.0 + 0.038 * log(scaledx)) / Eav; 
	
	double theta_plane_x = RandomNG::normal(0,1) * theta0;
	double theta_plane_y = RandomNG::normal(0,1) * theta0;
	
	double x_plane = RandomNG::normal(0,1) * x * theta0 / root12 + x * theta_plane_x / 2;
	double y_plane = RandomNG::normal(0,1) * x * theta0 / root12 + x * theta_plane_y / 2;
	
	p.x ()  += x_plane;
	p.xp () += theta_plane_x; 
	p.y ()  += y_plane;
	p.yp () += theta_plane_y; 
	// Set scatter type to Coulomb
	if (p.type() == -1 || p.type() == 0)
		p.type() = 5;
	
 }

bool ScatteringModel::ParticleScatter(PSvector& p, Material* mat, double E){ 

	// First check if we have a composite
	CompositeMaterial* aComposite = dynamic_cast<CompositeMaterial*>(mat);
	bool composite = 0;
	if(aComposite){composite = 1;}
	
	// string for the randomelement, and a material to hold it
	string RandomElement;
	Material* material;	
		
	// print the current processes and fractions, these should be the last configured
	//~ std::cout << "\n" << endl;
	//~ vector<ScatteringProcess*>::iterator pit;
	//~ int process_i = 0;	
	//~ for(pit = Processes.begin(); pit != Processes.end(); pit++){
		//~ cout << (*pit)->GetProcessType() << "\t sigma = " << (*pit)->sigma << " barns, fraction["<<process_i<<"] = " << fraction[process_i] << endl;
		//~ ++process_i;
	//~ }
	
	// Set fraction and Processes to that of a weighted random composite element
	// or that for the material
	if(composite && useComposites){
		RandomElement = aComposite->GetRandomMaterialSymbol();
		
		P_iterator = stored_processes.find(RandomElement);
		Processes = P_iterator->second;
		F_iterator = stored_fractions.find(RandomElement);
		fraction = F_iterator->second;
		
		string matstring = mat->GetSymbol();
		string ccstring = matstring+"_"+RandomElement;
		
		CC_it=CompCounter.find(ccstring);
		CC_it->second +=1;		
	}
	else{
		material = mat;
		P_iterator = stored_processes.find(material->GetSymbol());
		Processes = P_iterator->second;
		F_iterator = stored_fractions.find(material->GetSymbol());
		fraction = F_iterator->second;
	}

	//~ std::cout << "\nParticleScatter for input Material : " << mat->GetSymbol() << endl;
	//~ if(aComposite && useComposites)
	//~ std::cout << "ParticleScatter for actual Material : " << RandomElement << endl;
	
	//~ std::cout << "\n" << endl;
	
	// print the updated processes and fractions
	//~ process_i = 0;	
	//~ for(pit = Processes.begin(); pit != Processes.end(); pit++){
		//~ cout << (*pit)->GetProcessType() << "\t sigma = " << (*pit)->sigma << " barns, fraction["<<process_i<<"] = " << fraction[process_i] << endl;
		//~ ++process_i;
	//~ }
	
	// perform the scattering
	
	double r = RandomNG::uniform(0,1);
	
	for(int i = 0; i<fraction.size(); i++)  
	{ 
	    r -= fraction[i]; 
	    if(r<0)
	    {
	        return Processes[i]->Scatter(p, E);
	    }
	}
	
	// OLD method
	//~ double r = RandomNG::uniform(0,1);
	//~ for(int i = 0; i<fraction.size(); i++)  
	//~ { 
	    //~ r -= fraction[i]; 
	    //~ if(r<0)
	    //~ {
	        //~ return Processes[i]->Scatter(p, E);
	    //~ }
	//~ }
	
	cout << " should never get this message : \n\tScatteringModel::ParticleScatter : scattering past r < 0, r = " << r << endl;

	exit(EXIT_FAILURE);
}

void ScatteringModel::DeathReport(PSvector& p, double x, double position, vector<double>& lost){
	double pos = x + position;
	lost.push_back(pos);
}
	
void ScatteringModel::SetScatterType(int st){	
	ScatteringPhysicsModel = st;	
}


void ScatteringModel::ScatterPlot(Particle& p, double z, int turn, string name){
	
	ScatterPlotData* temp = new ScatterPlotData;
	(*temp).ID = p.id();
	(*temp).x = p.x();
	(*temp).xp = p.xp();
	(*temp).y = p.y();
	(*temp).yp = p.yp();
	(*temp).z = z;
	(*temp).turn = turn;	
	(*temp).name = name;
	
	StoredScatterPlotData.push_back(temp);
}

void ScatteringModel::JawImpact(Particle& p, int turn, string name){
	
	JawImpactData* temp = new JawImpactData;
	(*temp).ID = p.id();
	(*temp).x = p.x();
	(*temp).xp = p.xp();
	(*temp).y = p.y();
	(*temp).yp = p.yp();
	(*temp).ct = p.ct();
	(*temp).dp = p.dp();
	(*temp).turn = turn;	
	(*temp).name = name;
	//~ cout << "JawImpact IN: name = " << name << endl;
	
	StoredJawImpactData.push_back(temp);
}

void ScatteringModel::JawInelastic(Particle& p, double z, int turn, string name){
	
	JawInelasticData* temp = new JawInelasticData;
	(*temp).ID = p.id();
	(*temp).x = p.x();
	(*temp).xp = p.xp();
	(*temp).y = p.y();
	(*temp).yp = p.yp();
	(*temp).ct = p.ct();
	(*temp).dp = p.dp();
	(*temp).z = z;
	(*temp).turn = turn;	
	(*temp).name = name;
	//~ cout << "JawImpact IN: name = " << name << endl;
	
	StoredJawInelasticData.push_back(temp);
}

void ScatteringModel::SelectScatter(Particle& p, double z, int turn, string name){
	
	SelectScatterData* temp = new SelectScatterData;
	(*temp).ID = p.id();
	(*temp).x = p.x();
	(*temp).xp = p.xp();
	(*temp).y = p.y();
	(*temp).yp = p.yp();
	(*temp).ct = p.ct();
	(*temp).dp = p.dp();
	(*temp).z = z;
	(*temp).turn = turn;	
	(*temp).name = name;
	(*temp).type = p.type();
	(*temp).theta = atan ( sqrt( p.xp()*p.xp() + p.yp()*p.yp() ) );
	(*temp).mom_t = - (4.9E19)*((*temp).theta*(*temp).theta);
	
	//~ cout << "SelectScatter IN: name = " << name << endl;
	
	StoredSelectScatterData.push_back(temp);
}
	
void ScatteringModel::SetScatterPlot(string name, int single_turn){
	ScatterPlotNames.push_back(name);
	ScatterPlot_on = 1;
}

void ScatteringModel::SetJawImpact(string name, int single_turn){
	JawImpactNames.push_back(name);
	JawImpact_on = 1;
}

void ScatteringModel::SetJawInelastic(string name, int single_turn){
	JawInelasticNames.push_back(name);
	JawInelastic_on = 1;
}

void ScatteringModel::SetSelectScatter(string name, int single_turn){
	SelectScatterNames.push_back(name);
	SelectScatter_on = 1;
}



//~ void ScatteringModel::OutputScatterPlot(std::ostream* os){
void ScatteringModel::OutputScatterPlot(string directory, int seed){
	
	for(vector<string>::iterator name = ScatterPlotNames.begin(); name != ScatterPlotNames.end(); ++name){
		
		std::ostringstream scatter_plot_file;
		if(seed >= 0)
			scatter_plot_file << directory << "scatter_plot_" << (*name) << "_" << seed << ".txt";
		else
			scatter_plot_file << directory << "scatter_plot_" << (*name) << ".txt";
		//~ std::ostringstream scatter_plot_file = directory + "Scatter.txt";
		std::ofstream* os = new std::ofstream(scatter_plot_file.str().c_str());	
		if(!os->good())    {
			std::cerr << "ScatteringModel::OutputScatterPlot: Could not open ScatterPlot file for collimator " << (*name) << std::endl;
			exit(EXIT_FAILURE);
		} 
		
		//~ (*os) << "#\tparticle_id\tx\tx'\ty\ty'\tct\tdpctturn" << endl;
		(*os) << "#\tparticle_id\tz\ty\tturn" << endl;
	
		for(vector <ScatterPlotData*>::iterator its = StoredScatterPlotData.begin(); its != StoredScatterPlotData.end(); ++its)
		{
			if( (*its)->name == (*name) ){
				(*os) << setw(10) << setprecision(10) << left << (*its)->ID;
				(*os) << setw(30) << setprecision(20) << left << (*its)->z;
				(*os) << setw(30)<< setprecision(20) << left << (*its)->x;
				(*os) << setw(30) << setprecision(20) << left << (*its)->y;
				//~ (*os) << setw(10)<< setprecision(20) << left << (*its)->ID;
				//~ (*os) << setw(20)<< setprecision(20) << left << (*its)->xp;
				//~ (*os) << setw(20)<< setprecision(20) << left << (*its)->y;
				//~ (*os) << setw(20)<< setprecision(20) << left << (*its)->yp;
				//~ (*os) << setw(20)<< setprecision(20) << left << (*its)->z;
				(*os) << setw(10)<< setprecision(10) << left << (*its)->turn;
				(*os) << endl;
			}	
		}
	}
	
	StoredScatterPlotData.clear();
}

//~ void ScatteringModel::OutputJawImpact(std::ostream* os){
void ScatteringModel::OutputJawImpact(string directory, int seed){
	
	for(vector<string>::iterator name = JawImpactNames.begin(); name != JawImpactNames.end(); ++name){
		//~ cout << "vector<string>::iterator = " << *name << endl;
		std::ostringstream jaw_impact_file;
		if(seed >= 0)
			jaw_impact_file << directory << "jaw_impact_" << (*name) << "_" << seed << ".txt";
		else
			jaw_impact_file << directory << "jaw_impact_" << (*name) << ".txt";
		ofstream* os = new ofstream(jaw_impact_file.str().c_str());	
		if(!os->good())    {
			std::cerr << "ScatteringModel::OutputJawImpact: Could not open JawImpact file for collimator " << (*name) << std::endl;
			exit(EXIT_FAILURE);
		} 
		
		(*os) << "#\tparticle_id\tx\tx'\ty\ty'\tct\tdp\tturn" << endl;
	
		for(vector <JawImpactData*>::iterator its = StoredJawImpactData.begin(); its != StoredJawImpactData.end(); ++its)
		{
			if( (*its)->name == (*name) ){
				//~ cout << "ColName = " << (*its)->name << endl;
				(*os) << setw(10) << left << setprecision(10) <<  (*its)->ID;
				(*os) << setw(30) << left << setprecision(20) << (*its)->x;
				(*os) << setw(30) << left << setprecision(20) <<  (*its)->xp;
				(*os) << setw(30) << left << setprecision(20) <<  (*its)->y;
				(*os) << setw(30) << left << setprecision(20) <<  (*its)->yp;
				(*os) << setw(30) << left << setprecision(20) << (*its)->ct;
				(*os) << setw(30) << left << setprecision(20) << (*its)->dp;
				(*os) << setw(10) << left << setprecision(10) <<  (*its)->turn;
				(*os) << endl;
			}
		}
	}	
		
	StoredJawImpactData.clear();	
}

void ScatteringModel::OutputJawInelastic(string directory, int seed){
	
	for(vector<string>::iterator name = JawInelasticNames.begin(); name != JawInelasticNames.end(); ++name){
		//~ cout << "vector<string>::iterator = " << *name << endl;
		std::ostringstream jaw_inelastic_file;
		if(seed >= 0)
			jaw_inelastic_file << directory << "jaw_inelastic_" << (*name) << "_" << seed << ".txt";
		else
			jaw_inelastic_file << directory << "jaw_inelastic_" << (*name) << ".txt";
		ofstream* os = new ofstream(jaw_inelastic_file.str().c_str());	
		if(!os->good())    {
			std::cerr << "ScatteringModel::OutputJawInelastic: Could not open JawInelastic file for collimator " << (*name) << std::endl;
			exit(EXIT_FAILURE);
		} 
		
		(*os) << "#\tparticle_id\tx\tx'\ty\ty'\tct\tdp\tz\tturn" << endl;
	
		for(vector <JawInelasticData*>::iterator its = StoredJawInelasticData.begin(); its != StoredJawInelasticData.end(); ++its)
		{
			if( (*its)->name == (*name) ){
				(*os) << setw(10) << left << setprecision(10) <<  (*its)->ID;
				(*os) << setw(30) << left << setprecision(20) << (*its)->x;
				(*os) << setw(30) << left << setprecision(20) <<  (*its)->xp;
				(*os) << setw(30) << left << setprecision(20) <<  (*its)->y;
				(*os) << setw(30) << left << setprecision(20) <<  (*its)->yp;
				(*os) << setw(30) << left << setprecision(20) << (*its)->ct;
				(*os) << setw(30) << left << setprecision(20) << (*its)->dp;
				(*os) << setw(30) << left << setprecision(20) << (*its)->z;
				(*os) << setw(10) << left << setprecision(10) <<  (*its)->turn;
				(*os) << endl;
			}
		}
	}	
		
	StoredJawInelasticData.clear();	
}

void ScatteringModel::OutputSelectScatter(string directory, int seed){
	
	// Iterate over collimators
	for(vector<string>::iterator name = SelectScatterNames.begin(); name != SelectScatterNames.end(); ++name){
		
		// INELASTIC
		std::ostringstream ss_file1;
		ss_file1 << directory << "select_scatter_" << (*name) << "_inelastic_.txt";
		ofstream* os1 = new ofstream(ss_file1.str().c_str());	
		if(!os1->good())    {
			std::cerr << "ScatteringModel::OutputSelectScatter: Could not open inelastic SelectScatter file for collimator " << (*name) << std::endl;
			exit(EXIT_FAILURE);
		} 		
		(*os1) << "#\tparticle_id\tx\tx'\ty\ty'\tct\tdp\tz\ttheta\tt\ttype" << endl;
	
		for(vector <SelectScatterData*>::iterator its = StoredSelectScatterData.begin(); its != StoredSelectScatterData.end(); ++its)
		{
			if( (*its)->name == (*name) && (*its)->type == 1){
				(*os1) << setw(10) << left << setprecision(10) <<  (*its)->ID;
				(*os1) << setw(30) << left << setprecision(20) << (*its)->x;
				(*os1) << setw(30) << left << setprecision(20) <<  (*its)->xp;
				(*os1) << setw(30) << left << setprecision(20) <<  (*its)->y;
				(*os1) << setw(30) << left << setprecision(20) <<  (*its)->yp;
				(*os1) << setw(30) << left << setprecision(20) << (*its)->ct;
				(*os1) << setw(30) << left << setprecision(20) << (*its)->dp;
				(*os1) << setw(30) << left << setprecision(20) << (*its)->z;
				(*os1) << setw(30) << left << setprecision(20) << (*its)->theta;
				(*os1) << setw(30) << left << setprecision(20) << (*its)->mom_t;
				(*os1) << setw(30) << left << setprecision(20) << (*its)->type;
				(*os1) << endl;
			}
		}
		
		// ELASTIC
		std::ostringstream ss_file2;
		ss_file2 << directory << "select_scatter_" << (*name) << "_elastic_.txt";
		ofstream* os2 = new ofstream(ss_file2.str().c_str());	
		if(!os2->good())    {
			std::cerr << "ScatteringModel::OutputSelectScatter: Could not open elastic SelectScatter file for collimator " << (*name) << std::endl;
			exit(EXIT_FAILURE);
		} 		
		(*os2) << "#\tparticle_id\tx\tx'\ty\ty'\tct\tdp\tz\ttheta\tt\ttype" << endl;
	
		for(vector <SelectScatterData*>::iterator its = StoredSelectScatterData.begin(); its != StoredSelectScatterData.end(); ++its)
		{
			if( (*its)->name == (*name) && ( (*its)->type == 2 || (*its)->type == 3 ) ){
				(*os2) << setw(10) << left << setprecision(10) <<  (*its)->ID;
				(*os2) << setw(30) << left << setprecision(20) << (*its)->x;
				(*os2) << setw(30) << left << setprecision(20) <<  (*its)->xp;
				(*os2) << setw(30) << left << setprecision(20) <<  (*its)->y;
				(*os2) << setw(30) << left << setprecision(20) <<  (*its)->yp;
				(*os2) << setw(30) << left << setprecision(20) << (*its)->ct;
				(*os2) << setw(30) << left << setprecision(20) << (*its)->dp;
				(*os2) << setw(30) << left << setprecision(20) << (*its)->z;
				(*os2) << setw(30) << left << setprecision(20) << (*its)->theta;
				(*os2) << setw(30) << left << setprecision(20) << (*its)->mom_t;
				(*os2) << setw(30) << left << setprecision(20) << (*its)->type;
				(*os2) << endl;
			}
		}
		
		// SD
		std::ostringstream ss_file3;
		ss_file3 << directory << "select_scatter_" << (*name) << "_singlediffractive_.txt";
		ofstream* os3 = new ofstream(ss_file3.str().c_str());	
		if(!os3->good())    {
			std::cerr << "ScatteringModel::OutputSelectScatter: Could not open SD SelectScatter file for collimator " << (*name) << std::endl;
			exit(EXIT_FAILURE);
		} 		
		(*os3) << "#\tparticle_id\tx\tx'\ty\ty'\tct\tdp\tz\ttheta\tt\ttype" << endl;
	
		for(vector <SelectScatterData*>::iterator its = StoredSelectScatterData.begin(); its != StoredSelectScatterData.end(); ++its)
		{
			if( (*its)->name == (*name) && (*its)->type == 4){
				(*os3) << setw(10) << left << setprecision(10) <<  (*its)->ID;
				(*os3) << setw(30) << left << setprecision(20) << (*its)->x;
				(*os3) << setw(30) << left << setprecision(20) <<  (*its)->xp;
				(*os3) << setw(30) << left << setprecision(20) <<  (*its)->y;
				(*os3) << setw(30) << left << setprecision(20) <<  (*its)->yp;
				(*os3) << setw(30) << left << setprecision(20) << (*its)->ct;
				(*os3) << setw(30) << left << setprecision(20) << (*its)->dp;
				(*os3) << setw(30) << left << setprecision(20) << (*its)->z;
				(*os3) << setw(30) << left << setprecision(20) << (*its)->theta;
				(*os3) << setw(30) << left << setprecision(20) << (*its)->mom_t;
				(*os3) << setw(30) << left << setprecision(20) << (*its)->type;
				(*os3) << endl;
			}
		}	
	}			
	StoredSelectScatterData.clear();	
}

void ScatteringModel::OutputScatteringProcesses(string directory, int seed){
	
	std::ostringstream sp_file;
	if(seed >= 0)
		sp_file << directory << "ScatteringProcesses_" << seed << ".txt";
	else
		sp_file << directory << "ScatteringProcesses.txt";
	ofstream* os = new ofstream(sp_file.str().c_str());	
	if(!os->good())    {
		std::cerr << "ScatteringModel::OutputScatteringProcesses: Could not open ScatteringProcesses file "<< std::endl;
		exit(EXIT_FAILURE);
	} 
	int process_i = 0;
	string current_element;
	
	// Iterate through each material		
	for(CS_iterator = stored_cross_sections.begin(); CS_iterator != stored_cross_sections.end(); CS_iterator++){
	
		// For each material we have to print the ScatteringProcess type, its sigma, and fraction
		// CS_iterator->second is a pointer to the CS object
		// CS_iterator->first is string that corresponds to the material
		current_element = CS_iterator->first;
		
		// element symbol
		//~ (*os) << "Material:" << current_element_c << endl;
		(*os) << "CS :" << CS_iterator->first << endl;
		
		P_iterator = stored_processes.begin();
		P_iterator = stored_processes.find(current_element);
		if(P_iterator == stored_processes.end()){cout <<"\n\tScatteringModel::OutputScatteringProcesses: did not find stored_process" << endl;}
		Processes = P_iterator->second;
		F_iterator = stored_fractions.find(current_element);
		if(F_iterator == stored_fractions.end()){cout <<"\n\tScatteringModel::OutputScatteringProcesses: did not find stored_fractions" << endl;}
		fraction = F_iterator->second;
		
		
		(*os) << "Process:" << P_iterator->first << endl;
		(*os) << "Fraction:" << F_iterator->first << endl;
		
		
		process_i = 0;
		vector<ScatteringProcess*>::iterator p;
		
		for(p = Processes.begin(); p != Processes.end(); p++){				
			(*os) << setw(10) << left << setprecision(8) << (*p)->GetProcessType();
			(*os) << setw(10) << left << setprecision(8) << "\t\t\tsigma = " ;				
			(*os) << setw(10) << left << setprecision(8) << (*p)->sigma << " barns";
			(*os) << setw(10) << left << setprecision(8) << "\tFraction = ";
			(*os) << setw(10) << left << setprecision(8) << fraction[process_i] << endl;
			++process_i;
		}				
	}			
}

void ScatteringModel::OutputCounter(string directory, int seed){
	
	std::ostringstream sp_file;
	if(seed >= 0)
		sp_file << directory << "CompositeCounter_" << seed << ".txt";
	else
		sp_file << directory << "CompositeCounter.txt";
	ofstream* os = new ofstream(sp_file.str().c_str());	
	if(!os->good())    {
		std::cerr << "ScatteringModel::OutputCounter: Could not open CompositeCounter file "<< std::endl;
		exit(EXIT_FAILURE);
	} 
	for(CC_it = CompCounter.begin(); CC_it != CompCounter.end(); CC_it++){
		
		(*os) << CC_it->first << "\t" << CC_it->second << endl;
	}
}

void ScatteringModel::OutputSelectScatterHistogram(string directory, int n, int nbins, int norm){
	
	for(vector<string>::iterator name = SelectScatterNames.begin(); name != SelectScatterNames.end(); ++name){
		double bob = 5E-6;
		const double bin_min_x = -bob, bin_max_x = bob;
		const double x_bw = (bin_max_x - bin_min_x) / nbins;
		
		const double bin_min_xp = -bob, bin_max_xp = bob;	
		const double xp_bw = (bin_max_xp - bin_min_xp) / nbins;
		
		const double bin_min_y = -bob, bin_max_y = bob;	
		const double y_bw = (bin_max_y - bin_min_y) / nbins;
		
		const double bin_min_yp = -bob, bin_max_yp = bob;		
		const double yp_bw = (bin_max_yp - bin_min_yp) / nbins;
		
		
		double bin_min_dp = 0, bin_max_dp = 2E-5;
		if(n==4){bin_max_dp = 0.15;}
		const double dp_bw = (bin_max_dp - bin_min_dp) / nbins;
		
		const double bin_min_t = -1E9, bin_max_t = 0;
		const double t_bw = (bin_max_t - bin_min_t) / nbins;
		
		const double bin_min_th = 0, bin_max_th = 3E-6;
		const double th_bw = (bin_max_th - bin_min_th) / nbins;
		
		int hist_x[nbins+2] = {0};
		int hist_xp[nbins+2] = {0};
		int hist_y[nbins+2] = {0};
		int hist_yp[nbins+2] = {0};
		int hist_dp[nbins+2] = {0};
		int hist_t[nbins+2] = {0};
		int hist_th[nbins+2] = {0};	
		
		int cut_type = 0;
		
		//~ cout << "vector<string>::iterator = " << *name << endl;
		std::ostringstream select_scatter_file;
		select_scatter_file << directory << "HIST_" << (*name) << "_" << n << ".txt";

		ofstream* os = new ofstream(select_scatter_file.str().c_str());	
		if(!os->good())    {
			std::cerr << "ScatteringModel::OutputSelectScatter: Could not open SelectScatter HIST file for collimator " << (*name) << std::endl;
			exit(EXIT_FAILURE);
		} 
		
		(*os) << "#\tbin_x\tx\tbin_xp\txp\tbin_y\ty\tbin_yp\typ\tbin_ct\tct\tbin_dp\tdp\tbin_theta\ttheta\tbin_t\tt" << endl;
	
		for(vector <SelectScatterData*>::iterator its = StoredSelectScatterData.begin(); its != StoredSelectScatterData.end(); ++its)
		{
			cut_type = (*its)->type;
			// For elastic
			if(n==3){n=2;}
			if ((*its)->type == (2||3)){cut_type = 2;}
			
			if (cut_type == n){
				int bin_x = (((*its)->x - bin_min_x) / (bin_max_x-bin_min_x) * (nbins)) +1; // +1 because bin zero for outliers
				// so handle end bins, by check against x, not bin
				if ((*its)->x < bin_min_x) bin_x = 0;
				if ((*its)->x > bin_max_x) bin_x = nbins+1;
				hist_x[bin_x] += 1;

				int bin_xp = (((*its)->xp - bin_min_xp) / (bin_max_xp-bin_min_xp) * (nbins)) +1; // +1 because bin zero for outliers
				if ((*its)->xp < bin_min_xp) bin_xp = 0;
				if ((*its)->xp > bin_max_xp) bin_xp = nbins+1;
				hist_xp[bin_xp] += 1;

				int bin_y = (((*its)->y - bin_min_y) / (bin_max_y-bin_min_y) * (nbins)) +1; // +1 because bin zero for outliers
				if ((*its)->y < bin_min_y) bin_y = 0;
				if ((*its)->y > bin_max_y) bin_y = nbins+1;
				hist_y[bin_y] += 1;

				int bin_yp = (((*its)->yp - bin_min_yp) / (bin_max_yp-bin_min_yp) * (nbins)) +1; // +1 because bin zero for outliers
				if ((*its)->yp < bin_min_yp) bin_yp = 0;
				if ((*its)->yp > bin_max_yp) bin_yp = nbins+1;
				hist_yp[bin_yp] += 1;

				int bin_dp = ((-(*its)->dp - bin_min_dp) / (bin_max_dp-bin_min_dp) * (nbins)) +1; // +1 because bin zero for outliers
				if (-(*its)->dp < bin_min_dp) bin_dp = 0;
				if (-(*its)->dp > bin_max_dp) bin_dp = nbins+1;
				hist_dp[bin_dp] += 1;

				int bin_th = (((*its)->theta - bin_min_th) / (bin_max_th-bin_min_th) * (nbins)) +1; // +1 because bin zero for outliers
				if ((*its)->theta < bin_min_th) bin_th = 0;
				if ((*its)->theta > bin_max_th) bin_th = nbins+1;
				hist_th[bin_th] += 1;
				
				int bin_t = (((*its)->mom_t - bin_min_t) / (bin_max_t-bin_min_t) * (nbins)) +1; // +1 because bin zero for outliers
				if ((*its)->mom_t < bin_min_t) bin_t = 0;
				if ((*its)->mom_t > bin_max_t) bin_t = nbins+1;
				hist_t[bin_t] += 1;		
			}		
		}
		
		for (size_t i=0; i<nbins+2; i++){
			
			/*** This output should be normalised by the original particle
			* number npart in order to compare the number of lost particles
			* It may also need to be normalised to the bin width */
			
			// Normalised by npart, start bin
			(*os) << bin_min_x + (x_bw*i) << "\t";
			(*os) << (double)hist_x[i]/norm << "\t";
			(*os) << bin_min_xp + (xp_bw*i) << "\t";
			(*os) << (double)hist_xp[i]/norm <<"\t";
			(*os) << bin_min_y + (y_bw*i) << "\t";
			(*os) << (double)hist_y[i]/norm << "\t";
			(*os) << bin_min_yp + (yp_bw*i) << "\t";
			(*os) << (double)hist_yp[i]/norm <<"\t";
			(*os) << bin_min_dp + (dp_bw*i) << "\t";
			(*os) << (double)hist_dp[i]/norm << "\t";
			(*os) << bin_min_th + (th_bw*i) << "\t";
			(*os) << (double)hist_th[i]/norm << "\t";
			(*os) << bin_min_t + (t_bw*i) << "\t";
			(*os) << (double)hist_t[i]/norm << endl;				
		}		
	}
}

