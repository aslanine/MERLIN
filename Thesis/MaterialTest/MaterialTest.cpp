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
    int ncorepart 	= 1E3;						// number of core particles to track
    int npart 		= 1E3;                     	// number of halo particles to track
    int nturns 		= 5;                      // number of turns to track

       
    if (argc >=2){npart = atoi(argv[1]);}

    if (argc >=3){seed = atoi(argv[2]);}

    RandomNG::init(seed);
    
    // Define useful variables
    double beam_energy = 7000.0;
    double energy = beam_energy;
    double beam_charge = 1.1e11;
    double normalized_emittance = 3.5e-6;
    double gamma = beam_energy/PhysicalConstants::ProtonMassMeV/PhysicalUnits::MeV;
	double beta = sqrt(1.0-(1.0/pow(gamma,2)));
	double emittance = normalized_emittance/(gamma*beta);
    cout << " npart = " << npart << ", nturns = " << nturns << ", beam energy = " << beam_energy << endl;
	
	//~ string directory = "/afs/cern.ch/user/h/harafiqu/public/MERLIN";	//lxplus harafiqu
	string directory = "/home/HR/Downloads/MERLIN_HRThesis/MERLIN";					//M11x	
	//~ string directory = "/afs/cern.ch/user/a/avalloni/private/Merlin_all";	//lxplus avalloni
	//~ string directory = "/home/haroon/MERLIN_HRThesis/MERLIN";				//iiaa1
	
	string pn_dir, case_dir, bunch_dir, lattice_dir, hel_dir, dustbin_dir;			
	string core_string =  "Core/";
	string halo_string =  "Halo/";
		
	string input_dir = "/Thesis/data/HELFullBeam/";	
	string output_dir = "/Build/Thesis/outputs/MaterialTest/";
	
	string full_output_dir = (directory+output_dir);
	mkdir(full_output_dir.c_str(), S_IRWXU);	
	bool batch = 1;
	if(batch){

		case_dir = "21Mar16_test/";
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
	
	ScatteringModel* myScatter = new ScatteringModel;
	// 0: ST,    1: ST + Adv. Ionisation,    2: ST + Adv. Elastic,    3: ST + Adv. SD,     4: MERLIN
	if(use_sixtrack_like_scattering){	myScatter->SetScatterType(0);	}
	else{								myScatter->SetScatterType(4);	}
	myScatter->SetCompositesOn();

	cout << "Collimator Aperture" << endl;
	
	// CollimatorAperture constructor contains a material - this is depreciated and can be set to null
	// CollimatorAperture(double w,double h, double t, Material* m, double length, double x_offset_entry=0.0, double y_offset_entry=0.0);	
	//Aperture* ap = new CollimatorAperture(x, y, tilt, material, length, x_offset_entry, y_offset_entry);
	//jaw closed
	Aperture* ap1 = new CollimatorAperture(10.0, 0., 0., NULL, 0.5, 0., 0.);
	
	//Aperture* ap1 = new CollimatorAperture(10.0, 1E-3, 0., 0.5, 0., 0.);
	//Aperture* ap1 = new CollimatorAperture(0., 0., 0., 0.5, 0., 0.);
	//Aperture* ap1 = new OneSidedUnalignedCollimatorAperture(10.0, 0., 0., 0.5, 0., 0.);

	/*
	Aperture* ap = new CollimatorAperture(10.0,0.1E-3,0.,0.1,0.,0.);
	Aperture* apdrift = new CircularAperture(1.);
	*/

	//0.5m coll
	// Collimator constructor:
	// Collimator (const string& id, double len, Material* pp, double P0);
	
	Collimator* coll1=new Collimator("COLL1", 0.1*meter, matter->FindMaterial("Cu"), energy);
	coll1->SetAperture(ap1);
	coll1->SetComponentLatticePosition(0.);

	Collimator* coll2=new Collimator("COLL2", 0.1*meter, matter->FindMaterial("GCOP"), energy);
	coll2->SetAperture(ap1);
	coll2->SetComponentLatticePosition(0.1);
	
	Collimator* coll3=new Collimator("COLL3", 0.1*meter,TEST, energy);
	coll3->SetAperture(ap1);
	coll3->SetComponentLatticePosition(0.2);

	AcceleratorModelConstructor* myaccmodelctor = new AcceleratorModelConstructor();
	myaccmodelctor->NewModel();
	//~ myaccmodelctor->AppendComponent(new Drift("DRIFT1",1.0*meter));
	myaccmodelctor->AppendComponent(coll1);
	myaccmodelctor->AppendComponent(coll2);
	myaccmodelctor->AppendComponent(coll3);
	//myaccmodelctor->AppendComponent(new Drift("DRIFT2",1.0*meter));
	
	AcceleratorModel *myAccModel = myaccmodelctor->GetModel();
	
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
		//this is 0.001 as coll jaw is 0.001, +0.000001 for 1um impact
		//double offset= (1E-3 + 1E-6);
	double offset= 1E-6;
		myBeam.yp0=0.;
		myBeam.xp0=0.;
		myBeam.x0=0.;
		myBeam.y0=offset;

/************
*	BUNCH	*
************/

    int node_particles = npart;
    
    ProtonBunch* myBunch;
    ParticleBunchConstructor* myBunchCtor;

	// pencil distribution
	myBunchCtor = new ParticleBunchConstructor(myBeam, node_particles, HELHaloDistribution);
	
	myBunch = myBunchCtor->ConstructParticleBunch<ProtonBunch>();
    delete myBunchCtor;
   
    myBunch->SetMacroParticleCharge(myBeam.charge);   
    
   if(output_initial_bunch){
	
		ostringstream hbunch_output_file;
		hbunch_output_file << bunch_dir << "initial_bunch.txt";
		ofstream* hbunch_output = new ofstream(hbunch_output_file.str().c_str());
		if(!hbunch_output->good()) { std::cerr << "Could not open initial bunch output" << std::endl; exit(EXIT_FAILURE); }   
		myBunch->Output(*hbunch_output);			
		delete hbunch_output;	   
	}

/************************
*	ParticleTracker		*
************************/

    ParticleTracker* myParticleTracker;

		AcceleratorModel::Beamline beamline1 = myAccModel->GetBeamline();
		
		myParticleTracker = new ParticleTracker(beamline1, myBunch);

		if(symplectic){
			myParticleTracker->SetIntegratorSet(new ParticleTracking::SYMPLECTIC::StdISet());	
		}
		else{	
			myParticleTracker->SetIntegratorSet(new ParticleTracking::TRANSPORT::StdISet());	
		}
	

/****************************
*	Collimation Process		*
****************************/


	cout << "Collimation on" << endl;
	CollimateProtonProcess* myCollimateProcess = new CollimateProtonProcess(2, 4);
	myCollimateProcess->ScatterAtCollimator(true);
		
	LossMapDustbin* myDustbin = new LossMapDustbin;
	myCollimateProcess->SetDustbin(myDustbin);     

	myCollimateProcess->SetScatteringModel(myScatter);
	myCollimateProcess->SetLossThreshold(200.0);
	myCollimateProcess->SetOutputBinSize(0.1);

	myParticleTracker->AddProcess(myCollimateProcess);
		
/********************
 *  TRACKING RUN	*
 *******************/
 
	myParticleTracker->Track(myBunch);
    
/********************
 *  OUTPUT DUSTBIN	*
 *******************/
	if(collimation_on){
		ostringstream hdustbin_file;
		hdustbin_file << (dustbin_dir + "dustbin_losses.txt");	
		ofstream* hdustbin_output = new ofstream(hdustbin_file.str().c_str());	
		if(!hdustbin_output->good()){ std::cerr << "Could not open halo dustbin loss file" << std::endl; exit(EXIT_FAILURE); }   
		myDustbin->Finalise(); 
		myDustbin->Output(hdustbin_output); 
		delete hdustbin_output;
	}
	
/********************
 *  OUTPUT BUNCH	*
 *******************/
	if(output_final_bunch){
		ostringstream hbunch_output_file2;
		hbunch_output_file2 << bunch_dir << "final_bunch.txt";
		ofstream* hbunch_output2 = new ofstream(hbunch_output_file2.str().c_str());
		if(!hbunch_output2->good()){ std::cerr << "Could not open final halo bunch output file" << std::endl; exit(EXIT_FAILURE); }  
		myBunch->Output(*hbunch_output2);
		delete hbunch_output2;

	 }
	 
/************
 *  CLEANUP	*
 ***********/	
	cout << "particles: " << npart << endl;
	cout << "particles remaining: " << myBunch->size() << endl;
	cout << "absorbed: " << npart - myBunch->size() << endl;	
	
	// Cleanup our pointers on the stack for completeness
	delete myBunch;
	delete myAccModel;
	
	// Need to fix destructors for:
	//~ delete myDustbin;
	//~ delete collimator_db;
	//~ delete ap;
	//~ delete myParticleTracker1;
	//~ delete myParticleTracker2;
	//~ delete myParticleTracker3;
	
    return 0;
}
