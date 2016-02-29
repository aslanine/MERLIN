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
    int ncorepart 	= 1E3;						// number of core particles to track
    int npart 		= 1E4;                     	// number of halo particles to track
    int nturns 		= 1E4;                      // number of turns to track

       
    if (argc >=2){npart = atoi(argv[1]);}

    if (argc >=3){seed = atoi(argv[2]);}

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
	string directory = "/home/haroon/MERLIN_HRThesis/MERLIN";				//iiaa1
	//~ string directory = "/home/HR/Downloads/MERLIN_HRThesis/MERLIN";					//M11x	
	//~ string directory = "/afs/cern.ch/user/a/avalloni/private/Merlin_all";	//lxplus avalloni
	
	string pn_dir, case_dir, bunch_dir, lattice_dir, hel_dir, cbunch_dir, hbunch_dir, hpn_dir, cpn_dir, dustbin_dir, hdustbin_dir, cdustbin_dir;			
	string core_string =  "Core/";
	string halo_string =  "Halo/";
		
	string input_dir = "/Thesis/data/HELFullBeam/";	
	string output_dir = "/Build/Thesis/outputs/HELFullBeam/";
	
	string full_output_dir = (directory+output_dir);
	mkdir(full_output_dir.c_str(), S_IRWXU);	
	bool batch = 1;
	if(batch){

		case_dir = "24Feb_MADInterface_out_test/";
		full_output_dir = (directory+output_dir+case_dir);
		mkdir(full_output_dir.c_str(), S_IRWXU);
	}
	
	bool output_turn_bunch		= 1;		
		if(output_turn_bunch){			
			pn_dir = (full_output_dir+"ParticleNo/"); 		mkdir(pn_dir.c_str(), S_IRWXU); 
			cpn_dir = pn_dir + core_string;					mkdir(cpn_dir.c_str(), S_IRWXU);
			hpn_dir = pn_dir + halo_string;					mkdir(hpn_dir.c_str(), S_IRWXU);
		}	
	bool every_bunch			= 1;		// output whole bunch every turn in a single file
	bool output_initial_bunch 	= 1;
	bool output_final_bunch 	= 1;		
		if (output_initial_bunch || output_final_bunch || every_bunch){
			bunch_dir = (full_output_dir+"Bunch_Distn/"); 	mkdir(bunch_dir.c_str(), S_IRWXU); 
			cbunch_dir = bunch_dir + core_string;			mkdir(cbunch_dir.c_str(), S_IRWXU);
			hbunch_dir = bunch_dir + halo_string;			mkdir(hbunch_dir.c_str(), S_IRWXU);
		}		
	
	bool output_fluka_database 	= 1;
	bool output_twiss			= 1;		if(output_twiss){ lattice_dir = (full_output_dir+"LatticeFunctions/"); mkdir(lattice_dir.c_str(), S_IRWXU); }	
	

	bool hel_on 				= 1; 		// Hollow electron lens process?
	bool elliptical_HEL			= 1;		// Use elliptical operation

		bool DCon				= 1;
		bool ACon				= 0;		if(ACon){DCon=0;}
		bool Turnskipon			= 0;		if(Turnskipon){ACon=0; DCon=0;}
		bool Diffusiveon		= 0;		if(Diffusiveon){ACon=0; Turnskipon=0; DCon=0;}
		bool output_hel_profile = 1;		if(output_hel_profile){hel_dir = (full_output_dir+"HEL/"); mkdir(hel_dir.c_str(), S_IRWXU);}
		
	bool collimation_on 		= 1;
		if(collimation_on){
			dustbin_dir = full_output_dir + "LossMap/"; 	mkdir(dustbin_dir.c_str(), S_IRWXU);
			cdustbin_dir = dustbin_dir + core_string; 	mkdir(cdustbin_dir.c_str(), S_IRWXU);
			hdustbin_dir = dustbin_dir + halo_string; 	mkdir(hdustbin_dir.c_str(), S_IRWXU);			
		}
	bool use_sixtrack_like_scattering = 0;
	bool cut_distn				= 0;
	
	bool round_beams			= 0;		// true = -30m, false = -88.6m

	// REMEMBER TO CHANGE DISTRIBUTION SIGMA
	// note that this gives the correct phase advance if we don't use m.apply()
	bool start_at_ip1			= 0;	// True: 3 trackers: IP1->HEL, HEL->TCP, TCP->IP1 
										// False: 3 trackers:  HEL->TCP, TCP->IP1, IP1->HEL
										// // False: 3 trackers: TCP->IP1, IP1->HEL, HEL->TCP NOT IN USE
										
	bool cleaning				= 1;
		if(cleaning){
			collimation_on		= 1;
			every_bunch			= 0;
			output_turn_bunch	= 1;
			start_at_ip1		= 0;	
			cut_distn			= 0;	//not needed for helhalo	
			output_initial_bunch= 1;
			output_final_bunch	= 1;
		}
		
	//ALWAYS TRUE
	bool thin					= 1;		// true = use thin HEL instead of thick
	bool symplectic				= 1;
	bool collision				= 1;
		
/************************************
*	ACCELERATORMODEL CONSTRUCTION	*
************************************/
	cout << "MADInterface" << endl;
	MADInterface* myMADinterface;

	if(thin){
		if(round_beams)	{
			if(collision){
				myMADinterface = new MADInterface( directory+input_dir+"HL1.2.1_Collision_nonflat_-30m_thin_RF.tfs", beam_energy );	//HL v1.2 nonflat collision 
			}
			else{
				myMADinterface = new MADInterface( directory+input_dir+"HL_v1.2.1_-30m_thinHEL_RF.tfs", beam_energy );				//new HL v1.2
			//~ myMADinterface = new MADInterface( directory+input_dir+"HLv1.2.0_C+S_RF_-30mHEL.tfs", beam_energy );				//old HL v1.2
			}
		}
		else{
			if(collision){
				myMADinterface = new MADInterface( directory+input_dir+"HL1.2.1_Collision_nonflat_-88.6m_thin_RF.tfs", beam_energy );//HL v1.2 nonflat collision 
			}
			else{
				myMADinterface = new MADInterface( directory+input_dir+"HL_v1.2.1_-88.6m_thinHEL_RF.tfs", beam_energy );
			}
		}
	}
	else{
		if(round_beams)
			myMADinterface = new MADInterface( directory+input_dir+"HL_v1.2.1_C+S_RF_-30mHEL.tfs", beam_energy );					//new HL v1.2
			//~ myMADinterface = new MADInterface( directory+input_dir+"HLv1.2.0_C+S_RF_-30mHEL.tfs", beam_energy );				//old HL v1.2
		else
			myMADinterface = new MADInterface( directory+input_dir+"HL_v1.2.1_C+S_RF_-90mHEL.tfs", beam_energy );
	}
	
    myMADinterface->TreatTypeAsDrift("RFCAVITY");
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
	int hel_element_number = 0;
	string hel_element;
    if(thin){
		if(round_beams){
			hel_element = "HEL-30m";
			hel_element_number = myAccModel->FindElementLatticePosition(hel_element.c_str());
		}
		else{
			hel_element = "HEL-88.6m";
			hel_element_number = myAccModel->FindElementLatticePosition(hel_element.c_str());
		}
	}
	else{
		if(round_beams){
			hel_element = "HEL_-30.B5L4.B1";
			hel_element_number = myAccModel->FindElementLatticePosition(hel_element.c_str());
		}
		else{
			hel_element = "HEL_-90.A5L4.B1";
			hel_element_number = myAccModel->FindElementLatticePosition(hel_element.c_str());
		}
	}
    // END of Lattice
    string end_element = "IP1.L1";
	int end_element_number = myAccModel->FindElementLatticePosition(end_element.c_str());
	// START of Lattice
    string ip1_element = "IP1";
	int ip1_element_number = myAccModel->FindElementLatticePosition(ip1_element.c_str());	
    
    int start_element_number;
    if(start_at_ip1){ start_element_number = ip1_element_number;}
	else{ start_element_number = hel_element_number;}

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
    myTwiss->AddFunction(0,0,1);
    myTwiss->AddFunction(0,0,2);
    myTwiss->AddFunction(0,0,3);

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
    CollimatorDatabase* collimator_db = new CollimatorDatabase( directory+input_dir+"HL_v1.2.1_collDB.txt", myMaterialDatabase,  true);
   
    collimator_db->MatchBeamEnvelope(true);
    collimator_db->EnableJawAlignmentErrors(false);
    collimator_db->SetJawPositionError(0.0 * nanometer);
    collimator_db->SetJawAngleError(0.0 * microradian);
    
    // HLv1.2  -0.1 sigma = -2.73539E-5
    // HLv1.2  -0.2 sigma = -5.328E-5
    // HLv1.2  -0.3 sigma = -7.992E-5
    // HLv1.2  -1.2 sigma = -3.196E-4
    // HLv1.2  -0.7 sigma = -1.8648E-4
    
    collimator_db->SelectImpactFactor(tcp_element, -2.66313E-5);     
	//~ collimator_db->SelectImpactFactor(tcp_element, 1.0e-6);

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
	ApertureConfiguration* myApertureConfiguration = new ApertureConfiguration(directory+input_dir+"HL_v1.2.1_Aperture.tfs",1);      
    
    myApertureConfiguration->ConfigureElementApertures(myAccModel);
    delete myApertureConfiguration;

/************************
*	BEAM HALO SETTINGS	*
************************/
    BeamData myHaloBeam;

    // Default values for all members of BeamData are 0.0
    // Particles are treated as macro particles - this has no bearing on collimation
    myHaloBeam.charge = beam_charge/npart;
    myHaloBeam.p0 = beam_energy;
    myHaloBeam.beta_x = myTwiss->Value(1,1,1,start_element_number)*meter;
    myHaloBeam.beta_y = myTwiss->Value(3,3,2,start_element_number)*meter;
    myHaloBeam.alpha_x = -myTwiss->Value(1,2,1,start_element_number);
    myHaloBeam.alpha_y = -myTwiss->Value(3,4,2,start_element_number);

    // Dispersion
    myHaloBeam.Dx=myDispersion->Dx;
    myHaloBeam.Dy=myDispersion->Dy;
    myHaloBeam.Dxp=myDispersion->Dxp;
    myHaloBeam.Dyp=myDispersion->Dyp;

    // We set the beam emittance such that the bunch (created from this BeamData object later) will impact upon the primary collimator
    if(start_at_ip1){
		myHaloBeam.emit_x = emittance * meter;
		myHaloBeam.emit_y = emittance * meter;
	}
    else{
		myHaloBeam.emit_x = emittance * meter;
		myHaloBeam.emit_y = emittance * meter;
		//~ myHaloBeam.emit_x = impact * impact * emittance * meter;
		//~ myHaloBeam.emit_y = impact * impact * emittance * meter;
	}
    impact =1;
    //~ myHaloBeam.emit_y = impact * impact * emittance * meter;

    //Beam centroid
    myHaloBeam.x0=myTwiss->Value(1,0,0,start_element_number);
    myHaloBeam.xp0=myTwiss->Value(2,0,0,start_element_number);
    myHaloBeam.y0=myTwiss->Value(3,0,0,start_element_number);
    myHaloBeam.yp0=myTwiss->Value(4,0,0,start_element_number);
    myHaloBeam.ct0=myTwiss->Value(5,0,0,start_element_number);

    myHaloBeam.sig_dp = 0.0;
    myHaloBeam.sig_z = 0.0;

    // X-Y coupling
    myHaloBeam.c_xy=0.0;
    myHaloBeam.c_xyp=0.0;
    myHaloBeam.c_xpy=0.0;
    myHaloBeam.c_xpyp=0.0;
    
    // Minimum and maximum sigma for HEL Halo Distribution
    myHaloBeam.min_sig_x = 4;
    myHaloBeam.max_sig_x = 5.8;
    myHaloBeam.min_sig_y = 4;
    myHaloBeam.max_sig_y = 5.8;
 
 /***********************
*	BEAM CORE SETTINGS	*
************************/   
    
    BeamData myCoreBeam;
    
    // Default values for all members of BeamData are 0.0
    // Particles are treated as macro particles - this has no bearing on collimation
    myCoreBeam.charge = beam_charge/ncorepart;
    myCoreBeam.p0 = beam_energy;
    myCoreBeam.beta_x = myTwiss->Value(1,1,1,start_element_number)*meter;
    myCoreBeam.beta_y = myTwiss->Value(3,3,2,start_element_number)*meter;
    myCoreBeam.alpha_x = -myTwiss->Value(1,2,1,start_element_number);
    myCoreBeam.alpha_y = -myTwiss->Value(3,4,2,start_element_number);

    // Dispersion
    myCoreBeam.Dx=myDispersion->Dx;
    myCoreBeam.Dy=myDispersion->Dy;
    myCoreBeam.Dxp=myDispersion->Dxp;
    myCoreBeam.Dyp=myDispersion->Dyp;

    // We set the beam emittance such that the bunch (created from this BeamData object later) will impact upon the primary collimator
    if(start_at_ip1){
		myCoreBeam.emit_x = emittance * meter;
		myCoreBeam.emit_y = emittance * meter;
	}
    else{
		myCoreBeam.emit_x = emittance * meter;
		myCoreBeam.emit_y = emittance * meter;
		//~ myCoreBeam.emit_x = impact * impact * emittance * meter;
		//~ myCoreBeam.emit_y = impact * impact * emittance * meter;
	}
    impact =1;
    //~ myHaloBeam.emit_y = impact * impact * emittance * meter;
    

    //Beam centroid
    myCoreBeam.x0=myTwiss->Value(1,0,0,start_element_number);
    myCoreBeam.xp0=myTwiss->Value(2,0,0,start_element_number);
    myCoreBeam.y0=myTwiss->Value(3,0,0,start_element_number);
    myCoreBeam.yp0=myTwiss->Value(4,0,0,start_element_number);
    myCoreBeam.ct0=myTwiss->Value(5,0,0,start_element_number);

    myCoreBeam.sig_dp = 0.0;
    myCoreBeam.sig_z = 0.0;

    // X-Y coupling
    myCoreBeam.c_xy=0.0;
    myCoreBeam.c_xyp=0.0;
    myCoreBeam.c_xpy=0.0;
    myCoreBeam.c_xpyp=0.0;
    
    // Minimum and maximum sigma for HEL Halo Distribution
    myCoreBeam.min_sig_x = 0;
    myCoreBeam.max_sig_x = 4;
    myCoreBeam.min_sig_y = 0;
    myCoreBeam.max_sig_y = 4;
    
    delete myDispersion;

/************
*	BUNCH	*
************/

    int node_particles = npart;
    int core_particles = ncorepart;
    
    ProtonBunch* myHaloBunch;
    ProtonBunch* myCoreBunch;
    ParticleBunchConstructor* myHaloBunchCtor;
    ParticleBunchConstructor* myCoreBunchCtor;

    // horizontalHaloDistribution1 is a halo in xx' plane, zero in yy'
    // horizontalHaloDistribution2 is a halo in xx' plane, gaussian in yy'
    if(cleaning){
		//~ myHaloBunchCtor = new ParticleBunchConstructor(myHaloBeam, node_particles, horizontalHaloDistribution2);
		myHaloBunchCtor = new ParticleBunchConstructor(myHaloBeam, node_particles, HELHaloDistribution);
		myCoreBunchCtor = new ParticleBunchConstructor(myCoreBeam, core_particles, HELHaloDistribution);
	}
    else{
    	//~ myHaloBunchCtor = new ParticleBunchConstructor(myHaloBeam, node_particles, tuneTestDistribution);
    	//~ myCoreBunchCtor = new ParticleBunchConstructor(myCoreBeam, core_particles, tuneTestDistribution);
		myHaloBunchCtor = new ParticleBunchConstructor(myHaloBeam, node_particles, HELHaloDistribution);
		myCoreBunchCtor = new ParticleBunchConstructor(myCoreBeam, core_particles, HELHaloDistribution);
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

		myHaloBunchCtor->SetFilter(hFilter); 
	}
	
	myHaloBunch = myHaloBunchCtor->ConstructParticleBunch<ProtonBunch>();
    delete myHaloBunchCtor;
    
	myCoreBunch = myCoreBunchCtor->ConstructParticleBunch<ProtonBunch>();
    delete myCoreBunchCtor;

    myHaloBunch->SetMacroParticleCharge(myHaloBeam.charge);
    myCoreBunch->SetMacroParticleCharge(myCoreBeam.charge);    
    
   if(output_initial_bunch){
	
		ostringstream hbunch_output_file;
		hbunch_output_file << hbunch_dir << "initial_bunch.txt";
		ofstream* hbunch_output = new ofstream(hbunch_output_file.str().c_str());
		if(!hbunch_output->good()) { std::cerr << "Could not open initial halo bunch output" << std::endl; exit(EXIT_FAILURE); }   
		myHaloBunch->Output(*hbunch_output);			
		delete hbunch_output;	   

		ostringstream cbunch_output_file;
		cbunch_output_file << cbunch_dir << "initial_bunch.txt";
		ofstream* cbunch_output = new ofstream(cbunch_output_file.str().c_str());
		if(!cbunch_output->good()) { std::cerr << "Could not open initial core bunch output" << std::endl; exit(EXIT_FAILURE); }   
		myCoreBunch->Output(*cbunch_output);			
		delete cbunch_output;	
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
		
		myParticleTracker1 = new ParticleTracker(beamline1, myHaloBunch);
		myParticleTracker2 = new ParticleTracker(beamline2, myHaloBunch);
		myParticleTracker3 = new ParticleTracker(beamline3, myHaloBunch);

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
		AcceleratorModel::Beamline beamline1 = myAccModel->GetBeamline(hel_element_number, tcp_element_number-1);
		AcceleratorModel::Beamline beamline2 = myAccModel->GetBeamline(tcp_element_number, end_element_number);
		AcceleratorModel::Beamline beamline3 = myAccModel->GetBeamline(ip1_element_number, hel_element_number-1);
		
		myParticleTracker1 = new ParticleTracker(beamline1, myHaloBunch);
		myParticleTracker2 = new ParticleTracker(beamline2, myHaloBunch);
		myParticleTracker3 = new ParticleTracker(beamline3, myHaloBunch);
				
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
	
	LossMapDustbin* myHaloDustbin = new LossMapDustbin;
	LossMapDustbin* myCoreDustbin = new LossMapDustbin;

	if(collimation_on){
		cout << "Collimation on" << endl;
		CollimateProtonProcess* myCollimateProcess = new CollimateProtonProcess(2, 4);
			
		myCollimateProcess->SetDustbin(myHaloDustbin);       
		myCollimateProcess->SetDustbin(myCoreDustbin);       

		myCollimateProcess->ScatterAtCollimator(true);
	   
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
		HollowELensProcess* myHELProcess = new HollowELensProcess(3, 1, 5, 0.195, 2.334948339E4, 3.0);			// LHC: 3m, 10KeV, 5A
				
		// 1 = opposite to protons (focussing)
		myHELProcess->SetElectronDirection(1);
				
		// radial (measured) or perfect profile
		myHELProcess->SetRadialProfile();
		//~ myHELProcess->SetPerfectProfile();
		
		// for LHC hardware we need to scale the radial profile
		myHELProcess->SetLHCRadialProfile();
		
		// centre the HEL on the closed orbit
		myHELProcess->SetRadiiSigma(4, 8, myAccModel, emittance, emittance, myTwiss, 7000);			
		
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
		
		if(elliptical_HEL){
			myHELProcess->SetEllipticalMatching(1);
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
			
			ostringstream hel_footprint_file;
			hel_footprint_file << hel_dir << "footprint.txt";
			ofstream* helf_os = new ofstream(hel_footprint_file.str().c_str());
			if(!helf_os->good()){ std::cerr << "Could not open HEL footprint file" << std::endl; exit(EXIT_FAILURE); }  
			myHELProcess->OutputFootprint(helf_os, 1E4);			
		}
	}

/*****************************
 *  Other Output Files
 ****************************/
	 // No of particles per turn
	ostringstream hparticle_no_file;
	hparticle_no_file << hpn_dir << "No.txt";
	ofstream* hparticle_no_output = new ofstream(hparticle_no_file.str().c_str());	
	if(!hparticle_no_output->good())	{	std::cerr << "Could not open halo particle_no_output file" << std::endl;	exit(EXIT_FAILURE);	}
	
	ostringstream cparticle_no_file;
	cparticle_no_file << cpn_dir << "No.txt";
	ofstream* cparticle_no_output = new ofstream(cparticle_no_file.str().c_str());	
	if(!cparticle_no_output->good())	{	std::cerr << "Could not open core particle_no_output file" << std::endl;	exit(EXIT_FAILURE);	}

	// Total bunch at a given s every turn
	// Output bunch every turn @HEL in one file
	ostringstream cbo_file;
	cbo_file << cbunch_dir << "HEL_bunch.txt";
	ostringstream hbo_file;
	hbo_file << hbunch_dir << "HEL_bunch.txt";
	
	//truncate (clear) the file first to prevent appending to last run
	ofstream* cboclean = new ofstream(cbo_file.str().c_str(), ios::trunc);
	ofstream* hboclean = new ofstream(hbo_file.str().c_str(), ios::trunc);	
	ofstream* cbo = new ofstream(cbo_file.str().c_str(), ios::app);	
	ofstream* hbo = new ofstream(hbo_file.str().c_str(), ios::app);	
	if(!cbo->good())	{ std::cerr << "Could not open every bunch HEL core output file" << std::endl; exit(EXIT_FAILURE); }
	if(!hbo->good())	{ std::cerr << "Could not open every bunch HEL halo output file" << std::endl; exit(EXIT_FAILURE); }
	
	// Output bunch every turn @TCP in one file
	ostringstream cbot_file;
	cbot_file << cbunch_dir << "TCP_bunch.txt";
	ostringstream hbot_file;
	hbot_file << hbunch_dir << "TCP_bunch.txt";
	
	//truncate (clear) the file first to prevent appending to last run
	ofstream* cbotclean = new ofstream(cbot_file.str().c_str(), ios::trunc);
	ofstream* hbotclean = new ofstream(hbot_file.str().c_str(), ios::trunc);
	ofstream* cbot = new ofstream(cbot_file.str().c_str(), ios::app);	
	ofstream* hbot = new ofstream(hbot_file.str().c_str(), ios::app);	
	if(!cbot->good()){ std::cerr << "Could not open every bunch TCP core output file" << std::endl; exit(EXIT_FAILURE); }
	if(!hbot->good()){ std::cerr << "Could not open every bunch TCP halo output file" << std::endl; exit(EXIT_FAILURE); }

		
/********************
 *  TRACKING RUN	*
 *******************/
	if(output_turn_bunch){ 	(*hparticle_no_output) << "0\t" << myHaloBunch->size() << endl; 
							(*cparticle_no_output) << "0\t" << myCoreBunch->size() << endl; }
    
    for (int turn=1; turn<=nturns; turn++)
    {
        cout << "Turn " << turn <<"\tHalo particle number: " << myHaloBunch->size() << endl;
        cout << "Turn " << turn <<"\tCore particle number: " << myCoreBunch->size() << endl;

		if(start_at_ip1){	myParticleTracker1->Track(myHaloBunch); myParticleTracker1->Track(myCoreBunch);}
							
			if(every_bunch){myHaloBunch->Output(*hbo); myCoreBunch->Output(*cbo);} //Split the tracker to output at HEL
        
        if(start_at_ip1){	myParticleTracker2->Track(myHaloBunch); myParticleTracker2->Track(myCoreBunch);}
		else{				myParticleTracker1->Track(myHaloBunch); myParticleTracker1->Track(myCoreBunch);}	
		
			if(every_bunch){myHaloBunch->Output(*hbot); myCoreBunch->Output(*cbot);} //Split the tracker to output at TCP
		
		if(start_at_ip1){	myParticleTracker3->Track(myHaloBunch); myParticleTracker3->Track(myCoreBunch);}	
		else{				myParticleTracker2->Track(myHaloBunch); myParticleTracker2->Track(myCoreBunch);
							myParticleTracker3->Track(myHaloBunch); myParticleTracker3->Track(myCoreBunch);}
		
			if(output_turn_bunch){	(*hparticle_no_output) << turn <<"\t" << myHaloBunch->size() << endl; 	
									(*cparticle_no_output) << turn <<"\t" << myCoreBunch->size() << endl;}
			
        if( myHaloBunch->size() <= 1 ) break;
    }
    
/********************
 *  OUTPUT DUSTBIN	*
 *******************/
	if(collimation_on){
		ostringstream hdustbin_file;
		hdustbin_file << (hdustbin_dir + "dustbin_losses.txt");	
		ofstream* hdustbin_output = new ofstream(hdustbin_file.str().c_str());	
		if(!hdustbin_output->good()){ std::cerr << "Could not open halo dustbin loss file" << std::endl; exit(EXIT_FAILURE); }   
		myHaloDustbin->Finalise(); 
		myHaloDustbin->Output(hdustbin_output); 
		delete hdustbin_output;
		
		ostringstream cdustbin_file;
		cdustbin_file << (cdustbin_dir + "dustbin_losses.txt");	
		ofstream* cdustbin_output = new ofstream(cdustbin_file.str().c_str());	
		if(!cdustbin_output->good()){ std::cerr << "Could not open core dustbin loss file" << std::endl; exit(EXIT_FAILURE); }   
		myCoreDustbin->Finalise(); 
		myCoreDustbin->Output(cdustbin_output); 
		delete cdustbin_output;
	}
	
/********************
 *  OUTPUT BUNCH	*
 *******************/
	if(output_final_bunch){
		ostringstream hbunch_output_file2;
		hbunch_output_file2 << hbunch_dir << "final_bunch.txt";
		ofstream* hbunch_output2 = new ofstream(hbunch_output_file2.str().c_str());
		if(!hbunch_output2->good()){ std::cerr << "Could not open final halo bunch output file" << std::endl; exit(EXIT_FAILURE); }  
		myHaloBunch->Output(*hbunch_output2);
		delete hbunch_output2;
		
		ostringstream cbunch_output_file2;
		cbunch_output_file2 << cbunch_dir << "final_bunch.txt";
		ofstream* cbunch_output2 = new ofstream(cbunch_output_file2.str().c_str());
		if(!cbunch_output2->good()){ std::cerr << "Could not open final core bunch output file" << std::endl; exit(EXIT_FAILURE); }  
		myHaloBunch->Output(*cbunch_output2);
		delete cbunch_output2;
	 }
	 
/************
 *  CLEANUP	*
 ***********/	
	cout << "Halo particles: " << npart << endl;
	cout << "Halo particles remaining: " << myHaloBunch->size() << endl;
	cout << "Halo absorbed: " << npart - myHaloBunch->size() << endl;	
	
	cout << "Core particles: " << ncorepart << endl;
	cout << "Core particles remaining: " << myCoreBunch->size() << endl;
	cout << "Core absorbed: " << ncorepart - myCoreBunch->size() << endl;

	// Cleanup our pointers on the stack for completeness
	delete myMaterialDatabase;
	delete myHaloBunch;
	delete myCoreBunch;
	delete myTwiss;
	delete myAccModel;
	delete myMADinterface;
	delete CollimatorJaw;
		
	delete hbo;
	delete cbo;
	delete hboclean;
	delete cboclean;
	delete hbot;
	delete cbot;
	delete hbotclean;
	delete cbotclean;
	delete cparticle_no_output;
	delete hparticle_no_output;
	
	// Need to fix destructors for:
	//~ delete myDustbin;
	//~ delete collimator_db;
	//~ delete ap;
	//~ delete myParticleTracker1;
	//~ delete myParticleTracker2;
	//~ delete myParticleTracker3;
	
    return 0;
}
