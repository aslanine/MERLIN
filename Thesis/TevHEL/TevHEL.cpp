//Include relevant C++ headers

#include <iostream> // input/output
#include <sstream> // handles string streams
#include <string>
#include <map>
#include <set>
#include <ctime> // used for random seed
#include <sys/stat.h> //to use mkdir

//include relevant MERLIN headers
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
    int npart = 1E4;                            // number of particles to track
    int nturns = 1;                           // number of turns to track
 
    if (argc >=2){npart = atoi(argv[1]);}

    if (argc >=3){seed = atoi(argv[2]);}
    
    seed = 1;

    RandomNG::init(seed);
    
    // Define useful variables
    double beam_energy = 7000.0;
    double beam_charge = 1.1e11;
    double normalized_emittance = 3.5e-6;
    double gamma = beam_energy/PhysicalConstants::ProtonMassMeV/PhysicalUnits::MeV;
	double beta = sqrt(1.0-(1.0/pow(gamma,2)));
	double emittance = normalized_emittance/(gamma*beta);
    cout << " npart = " << npart << ", nturns = " << nturns << ", beam energy = " << beam_energy << endl;
	
	//~ string directory = "/afs/cern.ch/user/h/harafiqu/public/MERLIN";	//lxplus harafiqu
	//~ string directory = "/home/haroon/git/Merlin";				//iiaa1
	string directory = "/home/HR/Downloads/MERLIN_HRThesis/MERLIN";					//M11x	
	//~ string directory = "/afs/cern.ch/user/a/avalloni/private/Merlin_all";	//lxplus avalloni
	
	string pn_dir, case_dir, bunch_dir, lattice_dir, hel_dir;	
	string input_dir = "/Thesis/data/TevHEL/";	
	string output_dir = "/Build/Thesis/outputs/TevHEL/";
	
	string full_output_dir = (directory+output_dir);
	mkdir(full_output_dir.c_str(), S_IRWXU);	
	bool batch = 1;
	if(batch){
		case_dir = "16DecDistn/";
		full_output_dir = (directory+output_dir+case_dir);
		mkdir(full_output_dir.c_str(), S_IRWXU);
	}
	
	bool output_turn_bunch		= 1;		if(output_turn_bunch){	pn_dir = (full_output_dir+"ParticleNo/"); mkdir(pn_dir.c_str(), S_IRWXU); }		
	bool every_bunch			= 1;		// output whole bunch every turn in a single file
	bool output_initial_bunch 	= 1;
	bool output_final_bunch 	= 1;		if (output_initial_bunch || output_final_bunch){ bunch_dir = (full_output_dir+"Bunch_Distn/"); mkdir(bunch_dir.c_str(), S_IRWXU); }		
	bool output_fluka_database 	= 1;
	bool output_twiss			= 1;		if(output_twiss){ lattice_dir = (full_output_dir+"LatticeFunctions/"); mkdir(lattice_dir.c_str(), S_IRWXU); }	
	
	bool hel_on 				= 1; 		// Hollow electron lens process?
	bool LHC_HEL				= 0;		// LHC or Tevatron Hardware
		bool DCon				= 0;
		bool ACon				= 0;		if(ACon){DCon=0;}
		bool Turnskipon			= 0;		if(Turnskipon){ACon=0; DCon=0;}
		bool Diffusiveon		= 1;		if(Diffusiveon){ACon=0; Turnskipon=0; DCon=0;}
		bool output_hel_profile = 0;		if(output_hel_profile){hel_dir = (full_output_dir+"HEL/"); mkdir(hel_dir.c_str(), S_IRWXU);}
		
	bool collimation_on 		= 0;
	bool use_sixtrack_like_scattering = 0;
	bool cut_distn				= 0;
	
	//~ bool round_beams			= 0;		// true = -30m, false = -88.6m
	bool thin					= 1;		// true = use thin HEL instead of thick
	bool symplectic				= 1;
	
	// REMEMBER TO CHANGE DISTRIBUTION SIGMA
	// note that this gives the correct phase advance if we don't use m.apply()
	bool start_at_ip1			= 1;	// True: 3 trackers: IP1->HEL, HEL->TCP, TCP->IP1 
										// False: 3 trackers: TCP->IP1, IP1->HEL, HEL->TCP
										
	bool cleaning				= 0;
		if(cleaning){
			collimation_on		= 1;
			every_bunch			= 0;
			output_turn_bunch	= 1;
			start_at_ip1		= 0;	
			cut_distn			= 0;	//not needed for helhalo	
			output_initial_bunch= 1;
			output_final_bunch	= 1;
		}
		
/************************************
*	ACCELERATORMODEL CONSTRUCTION	*
************************************/
	cout << "MADInterface" << endl;
	MADInterface* myMADinterface;

	if(thin){
			myMADinterface = new MADInterface( directory+input_dir+"twiss.hel.7.0tev.b1.thin.tfs", beam_energy );
	}
	else{
			myMADinterface = new MADInterface( directory+input_dir+"twiss.hel.7.0tev.b1.tfs", beam_energy );
	}
	
    //~ myMADinterface->TreatTypeAsDrift("RFCAVITY");
    //~ myMADinterface->TreatTypeAsDrift("SEXTUPOLE");
    //~ myMADinterface->TreatTypeAsDrift("OCTUPOLE");

    myMADinterface->ConstructApertures(false);

    AcceleratorModel* myAccModel = myMADinterface->ConstructModel();   

/**************
*	TWISS 	  *
**************/
	
	// Primary collimator
	string tcp_element = "TCP.C6L7.B1";    // HORIZONTAL COLLIMATOR (x)
    int tcp_element_number = myAccModel->FindElementLatticePosition(tcp_element.c_str()); 
    
    // Hollow electron lens
	string hel_element = "HEL.B5R4.B1";
	int hel_element_number = myAccModel->FindElementLatticePosition(hel_element.c_str());

    // END of Lattice
    string end_element = "IP1.L1";
	int end_element_number = myAccModel->FindElementLatticePosition(end_element.c_str());
	// START of Lattice
    string ip1_element = "IP1";
	int ip1_element_number = myAccModel->FindElementLatticePosition(ip1_element.c_str());	
    
    int start_element_number;
    if(start_at_ip1){ start_element_number = ip1_element_number;}
	else{ start_element_number = tcp_element_number;}

    cout << "Found start element IP1 at element number " << start_element_number << endl;
    cout << "Found start element HEL at element number " << hel_element_number << endl;
    cout << "Found start element TCP.C6L7 at element number " << tcp_element_number << endl;
    cout << "Found start element END at element number " << end_element_number << endl;
    cout << "Found start element START at element number " << start_element_number << endl;

  LatticeFunctionTable* myTwiss = new LatticeFunctionTable(myAccModel, beam_energy);
    myTwiss->AddFunction(1,6,3);
    myTwiss->AddFunction(2,6,3);
    myTwiss->AddFunction(3,6,3);
    myTwiss->AddFunction(4,6,3);
    myTwiss->AddFunction(6,6,3);

    double bscale1 = 1e-22;    
  
	while(true)
	{
	cout << "start while(true) to scale bend path length" << endl;
		myTwiss->ScaleBendPathLength(bscale1);
		myTwiss->Calculate();

		if(!std::isnan(myTwiss->Value(1,1,1,0))) {break;}
		bscale1 *= 2;
	}
	
	Dispersion* myDispersion = new Dispersion(myAccModel, beam_energy);
    myDispersion->FindDispersion(start_element_number);

	if (output_twiss){
		
		ostringstream twiss_output_file; 
		twiss_output_file << (lattice_dir+"LatticeFunctions.dat");
		ofstream twiss_output(twiss_output_file.str().c_str());
		if(!twiss_output.good()){ std::cerr << "Could not open twiss output file" << std::endl; exit(EXIT_FAILURE); } 
		myTwiss->PrintTable(twiss_output);
		
		ostringstream disp_output_file; 
		disp_output_file << (lattice_dir+"Dispersion.dat");
		ofstream* disp_output = new ofstream(disp_output_file.str().c_str());
		if(!disp_output->good()){ std::cerr << "Could not open dispersion output file" << std::endl; exit(EXIT_FAILURE); } 
		myDispersion->FindRMSDispersion(disp_output);
		delete disp_output;
	}
	
/************************
*	Collimator set up	*
************************/
	cout << "Collimator Setup" << endl;   
   
    MaterialDatabase* myMaterialDatabase = new MaterialDatabase();
    CollimatorDatabase* collimator_db = new CollimatorDatabase( directory+input_dir+"collimator.hel.7.0.sigma", myMaterialDatabase,  true);
   
    collimator_db->MatchBeamEnvelope(true);
    collimator_db->EnableJawAlignmentErrors(false);
    collimator_db->SetJawPositionError(0.0 * nanometer);
    collimator_db->SetJawAngleError(0.0 * microradian);
    
    //LHC v6.503  1 sigma = 267E-6 m
 
	collimator_db->SelectImpactFactor(tcp_element, 1.0e-6);

    double impact = 6;
    
    try{
        impact = collimator_db->ConfigureCollimators(myAccModel, emittance, emittance, myTwiss);
    }
    catch(exception& e){ std::cout << "Exception caught: " << e.what() << std::endl; exit(1); }
    if(std::isnan(impact)){ cerr << "Impact is nan" << endl; exit(1); }
    cout << "Impact factor number of sigmas: " << impact << endl;
    
    if(output_fluka_database){
		ostringstream fd_output_file;
		fd_output_file << (full_output_dir+"fluka_database.txt");

		ofstream* fd_output = new ofstream(fd_output_file.str().c_str());
		collimator_db->OutputFlukaDatabase(fd_output);
		delete fd_output;
	}    
    
    delete collimator_db;
    
// CHECK FOR COLLIMATOR APERTURES	
	vector<Collimator*> TCP;
	int siz = myAccModel->ExtractTypedElements(TCP, tcp_element);

	cout << "\n\t Found " << TCP.size() << " Collimators when extracting" << endl;

	Aperture *ap = (TCP[0])->GetAperture();
	if(!ap){cout << "Could not get tcp ap" << endl;	abort();}
	else{cout << "TCP aperture type = " << ap->GetApertureType() << endl;}

	CollimatorAperture* CollimatorJaw = dynamic_cast<CollimatorAperture*>(ap);
	if(!CollimatorJaw){cout << "Could not cast" << endl;	abort();}
	
/****************************
*	Aperture Configuration	*
****************************/
	ApertureConfiguration* myApertureConfiguration = new ApertureConfiguration(directory+input_dir+"aperture_hel_7TeV.tfs",1);      
    
    myApertureConfiguration->ConfigureElementApertures(myAccModel);
    delete myApertureConfiguration;

/********************
*	BEAM SETTINGS	*
********************/
    BeamData mybeam;

    // Default values for all members of BeamData are 0.0
    // Particles are treated as macro particles - this has no bearing on collimation
    mybeam.charge = beam_charge/npart;
    mybeam.p0 = beam_energy;
    mybeam.beta_x = myTwiss->Value(1,1,1,start_element_number)*meter;
    mybeam.beta_y = myTwiss->Value(3,3,2,start_element_number)*meter;
    mybeam.alpha_x = -myTwiss->Value(1,2,1,start_element_number);
    mybeam.alpha_y = -myTwiss->Value(3,4,2,start_element_number);

    // Dispersion
    mybeam.Dx=myDispersion->Dx;
    mybeam.Dy=myDispersion->Dy;
    mybeam.Dxp=myDispersion->Dxp;
    mybeam.Dyp=myDispersion->Dyp;

    // We set the beam emittance such that the bunch (created from this BeamData object later) will impact upon the primary collimator
    if(start_at_ip1){
		mybeam.emit_x = emittance * meter;
		mybeam.emit_y = emittance * meter;
	}
    else{
		mybeam.emit_x = impact * impact * emittance * meter;
		mybeam.emit_y = impact * impact * emittance * meter;
	}
    impact =1;
    //~ mybeam.emit_y = impact * impact * emittance * meter;
    
    mybeam.sig_z = 0.0;

    //Beam centroid
    mybeam.x0=myTwiss->Value(1,0,0,start_element_number);
    mybeam.xp0=myTwiss->Value(2,0,0,start_element_number);
    mybeam.y0=myTwiss->Value(3,0,0,start_element_number);
    mybeam.yp0=myTwiss->Value(4,0,0,start_element_number);
    mybeam.ct0=myTwiss->Value(5,0,0,start_element_number);

    mybeam.sig_dp = 0.0;

    // X-Y coupling
    mybeam.c_xy=0.0;
    mybeam.c_xyp=0.0;
    mybeam.c_xpy=0.0;
    mybeam.c_xpyp=0.0;
    
    // Minimum and maximum sigma for HEL Halo Distribution
    mybeam.min_sig_x = 4;
    mybeam.max_sig_x = 6;
    mybeam.min_sig_y = 4;
    mybeam.max_sig_y = 6;

    delete myDispersion;

/************
*	BUNCH	*
************/

    ProtonBunch* myBunch;
    int node_particles = npart;

    // horizontalHaloDistribution1 is a halo in xx' plane, zero in yy'
    // horizontalHaloDistribution2 is a halo in xx' plane, gaussian in yy'
    ParticleBunchConstructor* myBunchCtor;
    if(cleaning){
		//~ myBunchCtor = new ParticleBunchConstructor(mybeam, node_particles, horizontalHaloDistribution2);
		myBunchCtor = new ParticleBunchConstructor(mybeam, node_particles, HELHaloDistribution);
	}
    else{
    	//~ myBunchCtor = new ParticleBunchConstructor(mybeam, node_particles, tuneTestDistribution);
    	myBunchCtor = new ParticleBunchConstructor(mybeam, node_particles, HELHaloDistribution);
	}
    
	if(collimation_on && cut_distn){ 
		double h_offset = myTwiss->Value(1,0,0,start_element_number);
		double JawPosition = (CollimatorJaw->GetFullWidth() / 2.0);
		cout << "h_offset: " << h_offset << endl;	
		cout << "Jaw position: " << JawPosition << endl;

		HorizontalHaloParticleBunchFilter* hFilter = new HorizontalHaloParticleBunchFilter();
		//~ double tcpsig = 0.000273539;
		double tcpsig = 0.000266313;
		hFilter->SetHorizontalLimit(4*tcpsig);
		hFilter->SetHorizontalOrbit(h_offset);

		myBunchCtor->SetFilter(hFilter); 
	}
	
	myBunch = myBunchCtor->ConstructParticleBunch<ProtonBunch>();
    delete myBunchCtor;

    myBunch->SetMacroParticleCharge(mybeam.charge);
    
   if(output_initial_bunch){
		ostringstream bunch_output_file;
		bunch_output_file << (bunch_dir + "initial_bunch.txt");
		ofstream* bunch_output = new ofstream(bunch_output_file.str().c_str());
		if(!bunch_output->good()) { std::cerr << "Could not open initial bunch output" << std::endl; exit(EXIT_FAILURE); }   
		myBunch->Output(*bunch_output);			
		delete bunch_output;
	}

/************************
*	ParticleTracker		*
************************/

    ParticleTracker* myParticleTracker1;
    ParticleTracker* myParticleTracker2;
    ParticleTracker* myParticleTracker3;

	if(start_at_ip1){
		AcceleratorModel::Beamline beamline1 = myAccModel->GetBeamline(start_element_number, hel_element_number-1);
		AcceleratorModel::Beamline beamline2 = myAccModel->GetBeamline(hel_element_number, tcp_element_number-1);
		AcceleratorModel::Beamline beamline3 = myAccModel->GetBeamline(tcp_element_number, end_element_number);
		
		myParticleTracker1 = new ParticleTracker(beamline1, myBunch);
		myParticleTracker2 = new ParticleTracker(beamline2, myBunch);
		myParticleTracker3 = new ParticleTracker(beamline3, myBunch);

		if(symplectic){
			myParticleTracker1->SetIntegratorSet(new ParticleTracking::SYMPLECTIC::StdISet());	
			myParticleTracker2->SetIntegratorSet(new ParticleTracking::SYMPLECTIC::StdISet());
			myParticleTracker3->SetIntegratorSet(new ParticleTracking::SYMPLECTIC::StdISet());	
		}
		else{	
			myParticleTracker1->SetIntegratorSet(new ParticleTracking::TRANSPORT::StdISet());	
			myParticleTracker2->SetIntegratorSet(new ParticleTracking::TRANSPORT::StdISet());
			myParticleTracker3->SetIntegratorSet(new ParticleTracking::TRANSPORT::StdISet());	
		}
	}
	else{
		AcceleratorModel::Beamline beamline1 = myAccModel->GetBeamline(tcp_element_number, end_element_number);
		AcceleratorModel::Beamline beamline2 = myAccModel->GetBeamline(ip1_element_number, hel_element_number-1);
		AcceleratorModel::Beamline beamline3 = myAccModel->GetBeamline(hel_element_number, tcp_element_number-1);
		
		myParticleTracker1 = new ParticleTracker(beamline1, myBunch);
		myParticleTracker2 = new ParticleTracker(beamline2, myBunch);
		myParticleTracker3 = new ParticleTracker(beamline3, myBunch);
				
		if(symplectic){
			myParticleTracker1->SetIntegratorSet(new ParticleTracking::SYMPLECTIC::StdISet());	
			myParticleTracker2->SetIntegratorSet(new ParticleTracking::SYMPLECTIC::StdISet());
			myParticleTracker3->SetIntegratorSet(new ParticleTracking::SYMPLECTIC::StdISet());	
		}
		else{	
			myParticleTracker1->SetIntegratorSet(new ParticleTracking::TRANSPORT::StdISet());	
			myParticleTracker2->SetIntegratorSet(new ParticleTracking::TRANSPORT::StdISet());
			myParticleTracker3->SetIntegratorSet(new ParticleTracking::TRANSPORT::StdISet());	
		}
	}

/****************************
*	Collimation Process		*
****************************/
	
	LossMapDustbin* myDustbin = new LossMapDustbin;

	if(collimation_on){
		cout << "Collimation on" << endl;
		CollimateProtonProcess* myCollimateProcess = new CollimateProtonProcess(2, 4);
			
		myCollimateProcess->SetDustbin(myDustbin);       

		//~ myCollimateProcess->ScatterAtCollimator(true);
		myCollimateProcess->ScatterAtCollimator(false);
	   
		ScatteringModel* myScatter = new ScatteringModel;

		// 0: ST,    1: ST + Adv. Ionisation,    2: ST + Adv. Elastic,    3: ST + Adv. SD,     4: MERLIN
		if(use_sixtrack_like_scattering){	myScatter->SetScatterType(0);	}
		else{								myScatter->SetScatterType(4);	}

		myCollimateProcess->SetScatteringModel(myScatter);

		myCollimateProcess->SetLossThreshold(200.0);
		myCollimateProcess->SetOutputBinSize(0.1);
		
		if(start_at_ip1){
			myParticleTracker1->AddProcess(myCollimateProcess);
			myParticleTracker2->AddProcess(myCollimateProcess);
			myParticleTracker3->AddProcess(myCollimateProcess);
		}
		else{
			myParticleTracker1->AddProcess(myCollimateProcess);
			myParticleTracker2->AddProcess(myCollimateProcess);
			myParticleTracker3->AddProcess(myCollimateProcess);
		}
	}
    
/********************
*	HEL Process		*
********************/
	if(hel_on){
		cout << "HEL on" << endl;
				
		// HollowELensProcess (int priority, int mode, double current, double beta_e, double rigidity, double length_e);
		HollowELensProcess* myHELProcess;
		
		if(LHC_HEL){	// LHC: 3m, 10KeV, 5A
			myHELProcess = new HollowELensProcess(3, 1, 5, 0.195, 2.334948339E4, 3.0);
			myHELProcess->SetRadiiSigma(4, 8, myAccModel, emittance, emittance, myTwiss);
			
			// for LHC hardware we need to scale the radial profile
			myHELProcess->SetLHCRadialProfile();
		}
		else{			//Tevatron: 2m, 5KeV, 1.2A
			myHELProcess = new HollowELensProcess(3, 1, 1.2, 0.138874007, 2.334948339E4, 2.0);
			//~ myHELProcess = new HollowELensProcess(3, 1, 1.2, 0.138874007, 2.334948339E4, 3.0);
			myHELProcess->SetRadiiSigma(4, 6.8, myAccModel, emittance, emittance, myTwiss);
		}
				
		myHELProcess->SetRadialProfile();
		//~ myHELProcess->SetPerfectProfile();	
		
		// 1 = opposite to protons (focussing)
		myHELProcess->SetElectronDirection(1);			
		
		if(ACon){
			//Set AC variables
			//HollowELensProcess::SetAC (double tune, double deltatune, double tunevarperstep, double turnsperstep, double multi) 
			//H20
			myHELProcess->SetAC(0.31, .002, 5E-5, 1E3, 2.);
			myHELProcess->SetOpMode(AC);
		}
		else if(DCon){
			myHELProcess->SetOpMode(DC);
		}
		else if(Diffusiveon){	
			myHELProcess->SetOpMode(Diffusive);
		}
		else if(Turnskipon){	
			myHELProcess->SetTurnskip(2);
			myHELProcess->SetOpMode(Turnskip);
		}
		
		if(start_at_ip1){
			myParticleTracker1->AddProcess(myHELProcess);	
			myParticleTracker2->AddProcess(myHELProcess);	
			myParticleTracker3->AddProcess(myHELProcess);	
			//~ cout << "HEL set" << endl;		
		}
		else{			
			myParticleTracker1->AddProcess(myHELProcess);	
			myParticleTracker2->AddProcess(myHELProcess);	
			myParticleTracker3->AddProcess(myHELProcess);	
			//~ cout << "HEL set" << endl;		
		}
		
		// Output HEL profile
		if(output_hel_profile){
			ostringstream hel_output_file;
			hel_output_file << hel_dir << "profile.txt";
			ofstream* hel_os = new ofstream(hel_output_file.str().c_str());
			if(!hel_os->good()){ std::cerr << "Could not open HEL profile file" << std::endl; exit(EXIT_FAILURE); }  
			//~ myHELProcess->OutputProfile(hel_os, 7000, 0, 10);
			myHELProcess->OutputProfile(hel_os, 7000, 0, 14.3);
		}
	}

/*****************************
 *  Other Output Files
 ****************************/
	 // No of particles per turn
	ostringstream particle_no_file;
	particle_no_file << pn_dir<< "No.txt";
	ofstream* particle_no_output = new ofstream(particle_no_file.str().c_str());	
	if(!particle_no_output->good())	{	std::cerr << "Could not open particle_no_output file" << std::endl;	exit(EXIT_FAILURE);	}

	// Total bunch at a given s every turn
	// Output bunch every turn @HEL in one file
	ostringstream bo_file;
	bo_file << bunch_dir << "HEL_bunch.txt";
	
	//truncate (clear) the file first to prevent appending to last run
	ofstream* boclean = new ofstream(bo_file.str().c_str(), ios::trunc);
	ofstream* bo = new ofstream(bo_file.str().c_str(), ios::app);	
	if(!bo->good())	{ std::cerr << "Could not open every bunch HEL output file" << std::endl; exit(EXIT_FAILURE); }
	
	// Output bunch every turn @TCP in one file
	ostringstream bot_file;
	bot_file << bunch_dir << "TCP_bunch.txt";
	
	//truncate (clear) the file first to prevent appending to last run
	ofstream* botclean = new ofstream(bot_file.str().c_str(), ios::trunc);
	ofstream* bot = new ofstream(bot_file.str().c_str(), ios::app);	
	if(!bot->good()){ std::cerr << "Could not open every bunch TCP output file" << std::endl; exit(EXIT_FAILURE); }

		
/********************
 *  TRACKING RUN	*
 *******************/
	if(output_turn_bunch){ (*particle_no_output) << "0\t" << myBunch->size() << endl; }
    
    for (int turn=1; turn<=nturns; turn++)
    {
        cout << "Turn " << turn <<"\tParticle number: " << myBunch->size() << endl;

		if(start_at_ip1){	myParticleTracker1->Track(myBunch);}
		else{				myParticleTracker1->Track(myBunch);
							myParticleTracker2->Track(myBunch);}
							
			if(every_bunch){myBunch->Output(*bo);} //Split the tracker to output at HEL
        
        if(start_at_ip1){	myParticleTracker2->Track(myBunch);}
		else{				myParticleTracker3->Track(myBunch);}	
		
			if(every_bunch){myBunch->Output(*bot);} //Split the tracker to output at TCP
		
		if(start_at_ip1){	myParticleTracker3->Track(myBunch);}	
		
			if(output_turn_bunch){(*particle_no_output) << turn <<"\t" << myBunch->size() << endl;}
			
        if( myBunch->size() <= 1 ) break;
    }
    
/********************
 *  OUTPUT DUSTBIN	*
 *******************/
	if(collimation_on){
		ostringstream dustbin_file;
		dustbin_file << (full_output_dir+"dustbin_losses.txt");	
		ofstream* dustbin_output = new ofstream(dustbin_file.str().c_str());	
		if(!dustbin_output->good()){ std::cerr << "Could not open dustbin loss file" << std::endl; exit(EXIT_FAILURE); }   
		myDustbin->Finalise(); 
		myDustbin->Output(dustbin_output); 
		delete dustbin_output;
	}
	
/********************
 *  OUTPUT BUNCH	*
 *******************/
	if(output_final_bunch){
		ostringstream bunch_output_file2;
		bunch_output_file2 << bunch_dir << "final_bunch.txt";
		ofstream* bunch_output2 = new ofstream(bunch_output_file2.str().c_str());
		if(!bunch_output2->good()){ std::cerr << "Could not open final bunch output file" << std::endl; exit(EXIT_FAILURE); }  
		myBunch->Output(*bunch_output2);
		delete bunch_output2;
	 }
	 
/************
 *  CLEANUP	*
 ***********/	
	cout << "npart: " << npart << endl;
	cout << "left: " << myBunch->size() << endl;
	cout << "absorbed: " << npart - myBunch->size() << endl;

	// Cleanup our pointers on the stack for completeness
	delete myMaterialDatabase;
	delete myBunch;
	delete myTwiss;
	delete myAccModel;
	delete myMADinterface;
	delete CollimatorJaw;
	delete myParticleTracker1;
	delete myParticleTracker2;
	delete myParticleTracker3;
		
	delete bo;
	delete boclean;
	delete bot;
	delete botclean;
	delete particle_no_output;
	
	// Need to fix destructors for:
	//~ delete myDustbin;
	//~ delete collimator_db;
	//~ delete ap;
	
    return 0;
}
