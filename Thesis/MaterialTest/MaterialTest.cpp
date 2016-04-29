//Include relevant C++ headers

#include <iostream> // input/output
#include <sstream> // handles string streams
#include <string>
#include <map>
#include <set>
#include <ctime> // used for random seed
#include <sys/stat.h> //to use mkdir

//include relevant MERLIN headers
#include "AcceleratorModel/Construction/AcceleratorModelConstructor.h"
#include "AcceleratorModel/Apertures/CollimatorAperture.h"

#include "BeamDynamics/ParticleTracking/ParticleBunchConstructor.h"
#include "BeamDynamics/ParticleTracking/ParticleTracker.h"
#include "BeamDynamics/ParticleTracking/ParticleBunchTypes.h"
#include "BeamDynamics/ParticleTracking/HollowELensProcess.h"
#include "BeamDynamics/ParticleTracking/Integrators/SymplecticIntegrators.h"

#include "Collimators/CollimateProtonProcess.h"
#include "Collimators/ScatteringProcess.h"
#include "Collimators/ScatteringModel.h"
#include "Collimators/CollimatorDatabase.h"
#include "Collimators/MaterialDatabase.h"
#include "Collimators/ApertureConfiguration.h"
#include "Collimators/Dustbin.h"
#include "Collimators/Material.h"

#include "MADInterface/MADInterface.h"

#include "NumericalUtils/PhysicalUnits.h"
#include "NumericalUtils/PhysicalConstants.h"

#include "Random/RandomNG.h"

#include "RingDynamics/Dispersion.h"

// C++ std namespace, and MERLIN PhysicalUnits namespace

using namespace std;
using namespace PhysicalUnits;

// Main function, this executable can be run with the arguments number_of_particles seed

//e.g. for 1000 particles and a seed of 356: ./test 1000 356
int main(int argc, char* argv[])
{
    int seed = (int)time(NULL);                 // seed for random number generators
    int npart 			= 1;                     	// number of halo particles to track
    int nleft = npart;
       
    if (argc >=2){npart = atoi(argv[1]);}
    if (argc >=3){seed = atoi(argv[2]);}
    
    seed = 13;

    RandomNG::init(seed);
    
    // Define useful variables
    double beam_energy = 7000.0;
    double energy = beam_energy;
    double beam_charge = 1.1e11;
    //~ double normalized_emittance = 3.5e-6;
    //~ double gamma = beam_energy/PhysicalConstants::ProtonMassMeV/PhysicalUnits::MeV;
	//~ double beta = sqrt(1.0-(1.0/pow(gamma,2)));
	//~ double emittance = normalized_emittance/(gamma*beta);
	
	//~ string directory = "/afs/cern.ch/user/h/harafiqu/public/MERLIN";	//lxplus harafiqu
	string directory = "/home/HR/Downloads/MERLIN_HRThesis/MERLIN";					//M11x	
	//~ string directory = "/afs/cern.ch/user/a/avalloni/private/Merlin_all";	//lxplus avalloni
	//~ string directory = "/home/haroon/MERLIN_HRThesis/MERLIN";				//iiaa1
	
	string pn_dir, case_dir, bunch_dir, lattice_dir, hel_dir, dustbin_dir;
		
	string input_dir = "/Thesis/data/HELFullBeam/";	
	string output_dir = "/Build/Thesis/outputs/MaterialTest/";
	
	string full_output_dir = (directory+output_dir);
	mkdir(full_output_dir.c_str(), S_IRWXU);	
	
	bool batch = 1;
	if(batch){

		case_dir = "25_Apr_MoGr/";
		full_output_dir = (directory+output_dir+case_dir);
		mkdir(full_output_dir.c_str(), S_IRWXU);
	}
	
	bool output_initial_bunch 	= 1;
	bool output_final_bunch 	= 1;		
		if (output_initial_bunch || output_final_bunch){
			bunch_dir = (full_output_dir+"Bunch_Distn/"); 	mkdir(bunch_dir.c_str(), S_IRWXU); 
		}		
		
	bool collimation_on 		= 1;
		if(collimation_on){
			dustbin_dir = full_output_dir + "LossMap/"; 	mkdir(dustbin_dir.c_str(), S_IRWXU);		
		}
	bool use_sixtrack_like_scattering = 0;
	bool cut_distn				= 0;
			
	bool cleaning				= 1;
		if(cleaning){
			collimation_on		= 1;
			cut_distn			= 0;	//not needed for helhalo	
			output_initial_bunch= 1;
			output_final_bunch	= 1;
		}
	bool symplectic = 1;
	bool composite = 0;
	
/************************
*	HISTOGRAM STUFF		*
************************/		
	const size_t nbins = 500;
	
	// bin width = bin_max - bin_min / nbin
	const double bin_min_x = -100e-6, bin_max_x = 100e-6;
	const double x_bw = (bin_max_x - bin_min_x) / nbins;
	const double bin_min_xp = -100e-6, bin_max_xp = 100e-6;
	const double xp_bw = (bin_max_xp - bin_min_xp) / nbins;
	const double bin_min_y = -100e-6, bin_max_y = 100e-6;
	const double y_bw = (bin_max_y - bin_min_y) / nbins;
	const double bin_min_yp = -100e-6, bin_max_yp = 100e-6;
	const double yp_bw = (bin_max_yp - bin_min_yp) / nbins;
	const double bin_min_dp = 1e-3, bin_max_dp = 1;
	const double dp_bw = (bin_max_dp - bin_min_dp) / nbins;

	int hist_x[nbins+2] = {0};
	int hist_xp[nbins+2] = {0};
	int hist_y[nbins+2] = {0};
	int hist_yp[nbins+2] = {0};
	int hist_dp[nbins+2] = {0};
	
/************************
*	MATERIALS			*
************************/	
	
	// List of material names
	vector<string> material_names;
	//~ material_names.push_back("Be");
	//~ material_names.push_back("B");
	//~ material_names.push_back("C");
	//~ material_names.push_back("O");
	//~ material_names.push_back("Al");
	//~ material_names.push_back("Fe");
	//~ material_names.push_back("Ni");
	//~ material_names.push_back("Cu");
	//~ material_names.push_back("CD");
	//~ material_names.push_back("Mo");
	//~ material_names.push_back("W");
	//~ material_names.push_back("Pb");
	//~ material_names.push_back("AC150K");
	//~ material_names.push_back("GCOP");
	//~ material_names.push_back("IT180");
	//~ material_names.push_back("Mo2C");
	material_names.push_back("CuCD");
	material_names.push_back("MoGr");

/************************
*	BEAM  SETTINGS	*
************************/
	BeamData myBeam;
		myBeam.charge= 1.31e11;
		myBeam.beta_x = 0.000001;
		myBeam.beta_y = 0.000001;
		myBeam.emit_x = 0.;
		myBeam.emit_y = 0.;
		myBeam.sig_z = 75.5*millimeter;
		myBeam.sig_dp = 0.;
		myBeam.p0 = 7000*GeV;
		myBeam.alpha_x = 0.;
		myBeam.alpha_y = 0.;
	double offset= 0;
		myBeam.yp0=0.;
		myBeam.xp0=0.;
		myBeam.x0=0.;
		myBeam.y0=offset;

/****************************
*	Collimation Process		*
****************************/


	cout << "Collimation on" << endl;
	CollimateProtonProcess* myCollimateProcess = new CollimateProtonProcess(2, 4);
	myCollimateProcess->ScatterAtCollimator(true);
		
	LossMapDustbin* myDustbin = new LossMapDustbin;
	myCollimateProcess->SetDustbin(myDustbin);     

	myCollimateProcess->SetLossThreshold(200.0);
	myCollimateProcess->SetOutputBinSize(0.1);
			
/************************************
*	ACCELERATORMODEL CONSTRUCTION	*
************************************/
	//COLLIMATOR
	
	MaterialDatabase* matter = new MaterialDatabase();
	
	CompositeMaterial* TEST = new CompositeMaterial();
	TEST->SetName("TEST");
	TEST->SetSymbol("Tst");
	TEST->AddMaterialByMassFraction(matter->FindMaterial("Al"),0.2);
	TEST->AddMaterialByMassFraction(matter->FindMaterial("Be"),0.2);
	TEST->AddMaterialByMassFraction(matter->FindMaterial("Cu"),0.2);
	TEST->AddMaterialByMassFraction(matter->FindMaterial("W"),0.2);
	TEST->AddMaterialByMassFraction(matter->FindMaterial("Pb"),0.2);
	TEST->Assemble();

	TEST->SetDensity(18060);
	TEST->SetConductivity(1.77E3);	//Set to the same as Tungsten for now
	TEST->SetSixtrackdEdx(TEST->CalculateSixtrackdEdx());
	TEST->SetRadiationLength(TEST->CalculateRadiationLength());
	TEST->SetMeanExcitationEnergy(TEST->CalculateMeanExcitationEnergy());
	TEST->SetElectronDensity(TEST->CalculateElectronDensity());
	TEST->SetPlasmaEnergy(TEST->CalculatePlasmaEnergy());
	
	cout << "Collimator Aperture" << endl;
	
	// CollimatorAperture constructor contains a material - this is depreciated and can be set to null
	// CollimatorAperture(double w,double h, double t, Material* m, double length, double x_offset_entry=0.0, double y_offset_entry=0.0);	
	//Aperture* ap = new CollimatorAperture(x, y, tilt, material, length, x_offset_entry, y_offset_entry);
	//jaw closed
	Aperture* ap1 = new CollimatorAperture(10.0, 0., 0., NULL, 0.5, 0., 0.);
	double length = 0.5*meter;

	//~ Material* material1 = TEST;
	//~ Material* material2 = matter->FindMaterial("GCOP");
	//~ Material* material3 = matter->FindMaterial("Cu");
	
	
	int ii = 0;
	
	// Iterate for size of material names
	vector<string>::iterator pit;
	for(pit = material_names.begin(); pit != material_names.end(); ++pit){
		cout << "Started loop for material: " << *pit << endl;
		
		// Create a collimator for the given material, set aperture and position
		Collimator* coll = new Collimator(*pit, length, matter->FindMaterial(*pit), energy);
		coll->SetAperture(ap1);
		coll->SetComponentLatticePosition(0.);
		
		// AccModelConstructor etc
		AcceleratorModelConstructor* myaccmodelctor = new AcceleratorModelConstructor();
		myaccmodelctor->NewModel();
		myaccmodelctor->AppendComponent(coll);
		AcceleratorModel *myAccModel = myaccmodelctor->GetModel();		
		
		// Scattering Model
		ScatteringModel* myScatter = new ScatteringModel;
		// 0: ST,    1: ST + Adv. Ionisation,    2: ST + Adv. Elastic,    3: ST + Adv. SD,     4: MERLIN
		if(use_sixtrack_like_scattering){	myScatter->SetScatterType(0);	}
		else{								myScatter->SetScatterType(4);	}
		if(composite){		myScatter->SetComposites(1);}
		else{		myScatter->SetComposites(0);}
		myScatter->SetScatterPlot(*pit);
		myScatter->SetJawImpact(*pit);
		
		// Create bunch
		ProtonBunch* myBunch;
		ParticleBunchConstructor* myBunchCtor;
		myBunchCtor = new ParticleBunchConstructor(myBeam, npart, pencilDistribution);	
		myBunch = myBunchCtor->ConstructParticleBunch<ProtonBunch>();
		
		if(output_initial_bunch){	
			ostringstream initial_bunch_file;
			initial_bunch_file << bunch_dir << "initial_bunch_" << *pit << "_.txt";
			ofstream* bunch_initial = new ofstream(initial_bunch_file.str().c_str());
			if(!bunch_initial->good()) { std::cerr << "Could not open initial bunch output for material"<< *pit << std::endl; exit(EXIT_FAILURE); }   
			myBunch->Output(*bunch_initial);			
			delete bunch_initial;	   
		}
		
		// Create the tracker
		ParticleTracker* myParticleTracker;

		AcceleratorModel::Beamline myBeamline = myAccModel->GetBeamline();
		myParticleTracker = new ParticleTracker(myBeamline, myBunch);
		if(symplectic){	myParticleTracker->SetIntegratorSet(new ParticleTracking::SYMPLECTIC::StdISet());}
		else{			myParticleTracker->SetIntegratorSet(new ParticleTracking::TRANSPORT::StdISet());}
		
		// Add the collimation process
		myCollimateProcess->SetScatteringModel(myScatter);
		myParticleTracker->AddProcess(myCollimateProcess);		
	
		// Track
		myParticleTracker->Track(myBunch);
		
		nleft = myBunch->size();
		cout << "Material 	: " << *pit << endl;
		cout << "Particles 	: " << npart << endl;
		cout << "Absorbed	: " << npart - myBunch->size() << endl;	
		cout << "Remaining 	: " << nleft << endl;
	
		// Output
		//~ myScatter->OutputJawImpact(full_output_dir);
		//~ myScatter->OutputScatterPlot(full_output_dir);	
		myScatter->OutputScatteringProcesses(full_output_dir, ii);
		myScatter->OutputCounter(full_output_dir, ii);
		
		if(output_final_bunch){
			ostringstream fin_output_file;
			fin_output_file << bunch_dir << "final_bunch_" << *pit <<"_.txt";
			ofstream* bunch_final = new ofstream(fin_output_file.str().c_str());
			if(!bunch_final->good()){ std::cerr << "Could not open finalbunch output file for material " << *pit << std::endl; exit(EXIT_FAILURE); }  
			//~ myBunch->Output(*hbunch_output2);
			myBunch->OutputScattered(*bunch_final);
			delete bunch_final;

		 }
		 
		 // Histogramming		 
		if(nleft>1){
			for (PSvectorArray::iterator ip=myBunch->begin(); ip!=myBunch->end(); ip++){

				int bin_x = ((ip->x() - bin_min_x) / (bin_max_x-bin_min_x) * (nbins)) +1; // +1 because bin zero for outliers
				// so handle end bins, by check against x, not bin
				if (ip->x() < bin_min_x) bin_x = 0;
				if (ip->x() > bin_max_x) bin_x = nbins+1;
				hist_x[bin_x] += 1;

				int bin_xp = ((ip->xp() - bin_min_xp) / (bin_max_xp-bin_min_xp) * (nbins)) +1; // +1 because bin zero for outliers
				if (ip->xp() < bin_min_xp) bin_xp = 0;
				if (ip->xp() > bin_max_xp) bin_xp = nbins+1;
				hist_xp[bin_xp] += 1;

				int bin_y = ((ip->y() - bin_min_y) / (bin_max_y-bin_min_y) * (nbins)) +1; // +1 because bin zero for outliers
				if (ip->y() < bin_min_y) bin_y = 0;
				if (ip->y() > bin_max_y) bin_y = nbins+1;
				hist_y[bin_y] += 1;

				int bin_yp = ((ip->yp() - bin_min_yp) / (bin_max_yp-bin_min_yp) * (nbins)) +1; // +1 because bin zero for outliers
				if (ip->yp() < bin_min_yp) bin_yp = 0;
				if (ip->yp() > bin_max_yp) bin_yp = nbins+1;
				hist_yp[bin_yp] += 1;

				int bin_dp = ((-ip->dp() - bin_min_dp) / (bin_max_dp-bin_min_dp) * (nbins)) +1; // +1 because bin zero for outliers
				if (-ip->dp() < bin_min_dp) bin_dp = 0;
				if (-ip->dp() > bin_max_dp) bin_dp = nbins+1;
				hist_dp[bin_dp] += 1;
			}
		}
		
		/*********************************************************************
		**	Output Final Hist
		*********************************************************************/
			ostringstream hist_output_file;
			hist_output_file << bunch_dir << "hist_" << *pit <<"_.txt";
			ofstream* out2 = new ofstream(hist_output_file.str().c_str());
			if(!out2->good()){ std::cerr << "Could not open finalbunch output file for material " << *pit << std::endl; exit(EXIT_FAILURE); }  

			
			if(nleft>1){		
				for (size_t i=0; i<nbins+2; i++){
				
				/*** This output should be normalised by the original particle
				* number npart in order to compare the number of lost particles
				* It may also need to be normalised to the bin width */
				
				// Normalised by bin_width * npart, centre bin			
				//~ (*out2) << bin_min_x + (x_bw/2) + (x_bw*i) << "\t";
				//~ (*out2) << (double)hist_x[i]/(x_bw *npart) << "\t";
				//~ (*out2) << bin_min_xp + (xp_bw/2) + (xp_bw*i) << "\t";
				//~ (*out2) << (double)hist_xp[i]/(xp_bw *npart) <<"\t";
				//~ (*out2) << bin_min_y + (y_bw/2) + (y_bw*i) << "\t";
				//~ (*out2) << (double)hist_y[i]/(y_bw *npart) << "\t";
				//~ (*out2) << bin_min_yp + (yp_bw/2) + (yp_bw*i) << "\t";
				//~ (*out2) << (double)hist_yp[i]/(yp_bw *npart) <<"\t";
				//~ (*out2) << bin_min_dp + (dp_bw/2) + (dp_bw*i) << "\t";
				//~ (*out2) << (double)hist_dp[i]/(dp_bw *npart) << endl;
				
				// Normalised by npart, start bin
				(*out2) << bin_min_x + (x_bw*i) << "\t";
				(*out2) << (double)hist_x[i]/npart << "\t";
				(*out2) << bin_min_xp + (xp_bw*i) << "\t";
				(*out2) << (double)hist_xp[i]/npart <<"\t";
				(*out2) << bin_min_y + (y_bw*i) << "\t";
				(*out2) << (double)hist_y[i]/npart << "\t";
				(*out2) << bin_min_yp + (yp_bw*i) << "\t";
				(*out2) << (double)hist_yp[i]/npart <<"\t";
				(*out2) << bin_min_dp + (dp_bw*i) << "\t";
				(*out2) << (double)hist_dp[i]/npart << endl;
				
				// Normalised by bin_width * nleft, centre bin			
				//~ (*out2) << bin_min_x + (x_bw/2) + (x_bw*i) << "\t";
				//~ (*out2) << (double)hist_x[i]/(x_bw *nleft) << "\t";
				//~ (*out2) << bin_min_xp + (xp_bw/2) + (xp_bw*i) << "\t";
				//~ (*out2) << (double)hist_xp[i]/(xp_bw *nleft) <<"\t";
				//~ (*out2) << bin_min_y + (y_bw/2) + (y_bw*i) << "\t";
				//~ (*out2) << (double)hist_y[i]/(y_bw *nleft) << "\t";
				//~ (*out2) << bin_min_yp + (yp_bw/2) + (yp_bw*i) << "\t";
				//~ (*out2) << (double)hist_yp[i]/(yp_bw *nleft) <<"\t";
				//~ (*out2) << bin_min_dp + (dp_bw/2) + (dp_bw*i) << "\t";
				//~ (*out2) << (double)hist_dp[i]/(dp_bw *nleft) << endl;
				
				// Normalised by bin_width * nleft, start bin		
				//~ (*out2) << bin_min_x + (x_bw*i) << "\t";
				//~ (*out2) << (double)hist_x[i]/(x_bw *nleft) << "\t";
				//~ (*out2) << bin_min_xp + (xp_bw*i) << "\t";
				//~ (*out2) << (double)hist_xp[i]/(xp_bw *nleft) <<"\t";
				//~ (*out2) << bin_min_y + (y_bw*i) << "\t";
				//~ (*out2) << (double)hist_y[i]/(y_bw *nleft) << "\t";
				//~ (*out2) << bin_min_yp + (yp_bw*i) << "\t";
				//~ (*out2) << (double)hist_yp[i]/(yp_bw *nleft) <<"\t";
				//~ (*out2) << bin_min_dp + (dp_bw*i) << "\t";
				//~ (*out2) << (double)hist_dp[i]/(dp_bw *nleft) << endl;
				
				// Normalised by bin_width, start bin		
				//~ (*out2) << bin_min_x + (x_bw*i) << "\t";
				//~ (*out2) << (double)hist_x[i]/(x_bw) << "\t";
				//~ (*out2) << bin_min_xp + (xp_bw*i) << "\t";
				//~ (*out2) << (double)hist_xp[i]/(xp_bw) <<"\t";
				//~ (*out2) << bin_min_y + (y_bw*i) << "\t";
				//~ (*out2) << (double)hist_y[i]/(y_bw) << "\t";
				//~ (*out2) << bin_min_yp + (yp_bw*i) << "\t";
				//~ (*out2) << (double)hist_yp[i]/(yp_bw) <<"\t";
				//~ (*out2) << bin_min_dp + (dp_bw*i) << "\t";
				//~ (*out2) << (double)hist_dp[i]/(dp_bw) << endl;
				
				// Normalised by nleft, start bin		
				//~ (*out2) << bin_min_x + (x_bw*i) << "\t";
				//~ (*out2) << (double)hist_x[i]/(nleft) << "\t";
				//~ (*out2) << bin_min_xp + (xp_bw*i) << "\t";
				//~ (*out2) << (double)hist_xp[i]/(nleft) <<"\t";
				//~ (*out2) << bin_min_y + (y_bw*i) << "\t";
				//~ (*out2) << (double)hist_y[i]/(nleft) << "\t";
				//~ (*out2) << bin_min_yp + (yp_bw*i) << "\t";
				//~ (*out2) << (double)hist_yp[i]/(nleft) <<"\t";
				//~ (*out2) << bin_min_dp + (dp_bw*i) << "\t";
				//~ (*out2) << (double)hist_dp[i]/(dp_bw *nleft) << endl;
				
				// Not normalised, start bin		
				//~ (*out2) << bin_min_x + (x_bw*i) << "\t";
				//~ (*out2) << (double)hist_x[i] << "\t";
				//~ (*out2) << bin_min_xp + (xp_bw*i) << "\t";
				//~ (*out2) << (double)hist_xp[i] <<"\t";
				//~ (*out2) << bin_min_y + (y_bw*i) << "\t";
				//~ (*out2) << (double)hist_y[i] << "\t";
				//~ (*out2) << bin_min_yp + (yp_bw*i) << "\t";
				//~ (*out2) << (double)hist_yp[i] <<"\t";
				//~ (*out2) << bin_min_dp + (dp_bw*i) << "\t";
				//~ (*out2) << (double)hist_dp[i] << endl;
			}				
		}
		cout << "Deleting stuff" << endl;
		//~ delete coll;
		delete myaccmodelctor;
		delete myAccModel;
		delete myBunch;
		delete myBunchCtor;	
		delete myScatter;
		delete out2;
		//~ delete myBeamline;
		
		ii++;		
		cout << "Ended loop for material: " << *pit << endl;
	}
		
    return 0;
}
