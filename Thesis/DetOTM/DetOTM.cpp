//Include relevant C++ headers

#include <iostream> // input/output
#include <sstream> // handles string streams
#include <string>
#include <map>
#include <set>
#include <ctime> // used for random seed
#include <sys/stat.h> //to use mkdir

//include relevant MERLIN headers
#include "AcceleratorModel/ApertureSurvey.h"
#include "AcceleratorModel/ControlElements/Klystron.h"

#include "BeamDynamics/ParticleTracking/ParticleBunchConstructor.h"
#include "BeamDynamics/ParticleTracking/ParticleTracker.h"
#include "BeamDynamics/ParticleTracking/ParticleBunchTypes.h"
#include "BeamDynamics/ParticleTracking/Integrators/SymplecticIntegrators.h"
#include "BeamDynamics/TrackingSimulation.h"
#include "BeamDynamics/TrackingOutputAV.h"

#include "BeamModel/PSTypes.h"
#include "BeamModel/BeamData.h"
#include "BeamModel/PSmoments.h"

#include "Collimators/CollimatorSurvey.h"
#include "Collimators/CollimateProtonProcess.h"
#include "Collimators/ScatteringProcess.h"
#include "Collimators/ScatteringModel.h"
#include "Collimators/CollimatorDatabase.h"
#include "Collimators/MaterialDatabase.h"
#include "Collimators/ApertureConfiguration.h"
#include "Collimators/Dustbin.h"
#include "Collimators/FlukaLosses.h"

#include "MADInterface/MADInterface.h"

#include "NumericalUtils/PhysicalUnits.h"
#include "NumericalUtils/PhysicalConstants.h"
#include "NumericalUtils/MatrixPrinter.h"
#include "NumericalUtils/MatrixDet.h"

#include "Random/RandomNG.h"

#include "RingDynamics/BetatronTunes.h"
#include "RingDynamics/Dispersion.h"
#include "RingDynamics/LatticeFunctions.h"
#include "RingDynamics/EquilibriumDistribution.h"
#include "RingDynamics/ClosedOrbit.h"
#include "RingDynamics/TransferMatrix.h"


#include "TLAS/LinearAlgebra.h"
#include "TLAS/TLAS.h"

// C++ std namespace, and MERLIN PhysicalUnits namespace

using namespace std;
using namespace PhysicalUnits;
using namespace PhysicalConstants;
using namespace ParticleTracking;
using namespace TLAS;


// Main function, this executable can be run with the arguments number_of_particles seed

//e.g. for 1000 particles and a seed of 356: ./test 1000 356

int main(int argc, char* argv[])
{
    int seed 	= (int)time(NULL);	// seed for random number generators
    int iseed 	= (int)time(NULL);	// seed for random number generators
    int npart 	= 2E3+1;			// number of particles to track
    int nturns 	= 30;				// number of turns to track
	bool DoTwiss = 1;				// run twiss and align to beam envelope etc?
	 
    if (argc >=2){npart = atoi(argv[1]);}
    if (argc >=3){seed = atoi(argv[2]);}

    RandomNG::init(iseed);

    double beam_energy = 7000.0;

    cout << "npart=" << npart << " nturns=" << nturns << " beam energy = " << beam_energy << endl;

	string start_element;
	start_element = "TCP.C6L7.B1";// HORIZONTAL COLLIMATOR (x)

    // Define useful variables
    double beam_charge = 1.1e11;
    double normalized_emittance = 3.5e-6;
    double gamma = beam_energy/PhysicalConstants::ProtonMassMeV/PhysicalUnits::MeV;
	double beta = sqrt(1.0-(1.0/pow(gamma,2)));
	double emittance = normalized_emittance/(gamma*beta);
	
	string directory, input_dir, output_dir, pn_dir, case_dir, bunch_dir, lattice_dir, fluka_dir, dustbin_dir, OTM_dir, Tune_dir;			
	
	//~ string directory = "/afs/cern.ch/user/h/harafiqu/public/MERLIN";	//lxplus harafiqu
	//~ string directory = "/home/haroon/git/Merlin/HR";					//iiaa1	
	directory 	= "/home/HR/Downloads/MERLIN_HRThesis/MERLIN";				//HR MAC
	
	input_dir 	= "/Thesis/data/7TeV_nominal_B1/";
	output_dir 	= "/Build/Thesis/outputs/DetOTM/";

	string batch_directory="08Jun_Test/";
	 
	string full_output_dir = (directory+output_dir);
	mkdir(full_output_dir.c_str(), S_IRWXU);
	full_output_dir = (directory+output_dir+batch_directory);
	mkdir(full_output_dir.c_str(), S_IRWXU);
	fluka_dir = full_output_dir + "Fluka/";    
	mkdir(fluka_dir.c_str(), S_IRWXU); 
	OTM_dir = full_output_dir + "OTM/";    
	mkdir(OTM_dir.c_str(), S_IRWXU); 
	Tune_dir = full_output_dir + "Tune/";    
	mkdir(Tune_dir.c_str(), S_IRWXU); 
	
	bool every_bunch			= 0;		// output whole bunch every turn in a single file
	bool rf_test				= 0;		// Use RF distribution to plot RF bucket
	bool calc_tune				= 0;		// Perform tune calculation
	bool tune_test				= 0;		// Perform tune test
		
		
	bool output_initial_bunch 	= 1;
	bool output_final_bunch 	= 0;
		if (output_initial_bunch || output_final_bunch || every_bunch){
			bunch_dir = (full_output_dir+"Bunch_Distn/"); 	mkdir(bunch_dir.c_str(), S_IRWXU); 		
		}	
	
	bool output_fluka_database 	= 0;
	bool output_twiss			= 0;		
		if(output_twiss){ lattice_dir = (full_output_dir+"LatticeFunctions/"); mkdir(lattice_dir.c_str(), S_IRWXU); }	
	
	bool collimation_on 		= 0;
		if(collimation_on){
			dustbin_dir = full_output_dir + "LossMap/"; 	mkdir(dustbin_dir.c_str(), S_IRWXU);		
		}		
	bool use_sixtrack_like_scattering = 0;
	bool scatterplot			= 0;
	bool jawinelastic			= 0;
	bool jawimpact				= 0;
	
	bool ap_survey				= 0;
	bool coll_survey			= 0;
	bool output_particletracks	= 0;
	
	bool symplectic				= 1;
	bool sixD					= 1;	//0 = No RF, 1 = Rf	
	bool composite				= 1;	//0 = Sixtrack composite, 1=MERLIN composite	
	
	// 0=pure, 1=composite, 2=MoGr 2e, 3=CuCD 2e, 4=MoGr 1e, 5=CuCD 1e.
	int CollMat					= 0;
	
	
/************************************
*	ACCELERATORMODEL CONSTRUCTION	*
************************************/
	cout << "MADInterface" << endl;

	MADInterface* myMADinterface;
		myMADinterface = new MADInterface( directory+input_dir+"Twiss_7TeV_nominal.tfs", beam_energy );
		myMADinterface->SetSingleCellRF(1);
	cout << "MADInterface Done" << endl;

    //myMADinterface->TreatTypeAsDrift("RFCAVITY");
    //~ myMADinterface->TreatTypeAsDrift("SEXTUPOLE");
    //~ myMADinterface->TreatTypeAsDrift("OCTUPOLE");

    myMADinterface->ConstructApertures(false);

    AcceleratorModel* myAccModel = myMADinterface->ConstructModel();    

	std::vector<RFStructure*> RFCavities;
	myAccModel->ExtractTypedElements(RFCavities,"ACS*");
	Klystron* Kly1 = new Klystron("KLY1",RFCavities);
	Kly1->SetVoltage(0.0);
	Kly1->SetPhase(pi/2);                                                                

/************
*	TWISS	*
************/

    int start_element_number = myAccModel->FindElementLatticePosition(start_element.c_str());
    
    cout << "Found start element TCP.C6L7 at element number " << start_element_number << endl;

	LatticeFunctionTable* myTwiss = new LatticeFunctionTable(myAccModel, beam_energy);
	myTwiss->UseDefaultFunctions();
	myTwiss->AddFunction(1,6,3);
    myTwiss->AddFunction(2,6,3);
    myTwiss->AddFunction(3,6,3);
    myTwiss->AddFunction(4,6,3);
    myTwiss->AddFunction(6,6,3);

    double bscale1 = 1e-22;
    
    if(DoTwiss){    
		while(true)
		{
		cout << "start while(true) to scale bend path length" << endl;
			// If we are running a lattice with no RF, the TWISS parameters
			// will not be calculated correctly. This is because some are
			// calculated from using the eigenvalues of the one turn map,
			// which is not complete with RF (i.e. longitudinal motion) 
			// switched off. In order to compensate for this we use the 
			// ScaleBendPath function which calls a RingDeltaT process 
			// and attaches it to the TWISS tracker. RingDeltaT process 
			// adjusts the ct and dp values such that the TWISS may be 
			// calculated and there are no convergence errors
			myTwiss->ScaleBendPathLength(bscale1);
			myTwiss->Calculate();

			// If Beta_x is a number (as opposed to -nan) then we have 
			// calculated the correct TWISS parameters, otherwise the loop
			//  keeps running
			if(!std::isnan(myTwiss->Value(1,1,1,0))) {break;}
			bscale1 *= 2;
			cout << "\n\ttrying bscale = " << bscale1<< endl;
		}
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
	
	if(sixD)
	Kly1->SetVoltage(2.0);

/************************
*	Collimator set up	*
************************/

	cout << "Collimator Setup" << endl;   
   
	MaterialDatabase* myMaterialDatabase = new MaterialDatabase();	
    CollimatorDatabase* collimator_db;
	
	switch(CollMat){
		case 0:	collimator_db = new CollimatorDatabase( directory+input_dir+"Collimator_7TeV_pure.txt", myMaterialDatabase,  true);
		break;
		case 1:	collimator_db = new CollimatorDatabase( directory+input_dir+"Collimator_7TeV_Composite.txt", myMaterialDatabase,  true);
		break;
		case 2:	collimator_db = new CollimatorDatabase( directory+input_dir+"Collimator_7TeV_MoGr_2.txt", myMaterialDatabase,  true);
		break;
		case 3:	collimator_db = new CollimatorDatabase( directory+input_dir+"Collimator_7TeV_CuCD_2.txt", myMaterialDatabase,  true);
		break;
		case 4:	collimator_db = new CollimatorDatabase( directory+input_dir+"Collimator_7TeV_MoGr_1.txt", myMaterialDatabase,  true);
		break;
		case 5:	collimator_db = new CollimatorDatabase( directory+input_dir+"Collimator_7TeV_CuCD_1.txt", myMaterialDatabase,  true);
		break;    
	}
    collimator_db->MatchBeamEnvelope(false);
    collimator_db->EnableJawAlignmentErrors(false);
    //~ collimator_db->UseMiddleJawHalfGap();

    collimator_db->SetJawPositionError(0.0 * nanometer);
    collimator_db->SetJawAngleError(0.0 * microradian);
    collimator_db->SelectImpactFactor(start_element, 1.0e-6);
    
    double impact = 6;
    // Finally we set up the collimator jaws to appropriate sizes
    try{
		if(DoTwiss)
        impact = collimator_db->ConfigureCollimators(myAccModel, emittance, emittance, myTwiss);
		else
        collimator_db->ConfigureCollimators(myAccModel);
    }
	catch(exception& e){ std::cout << "Exception caught: " << e.what() << std::endl; exit(1); }
    if(std::isnan(impact)){ cerr << "Impact is nan" << endl; exit(1); }
    cout << "Impact factor number of sigmas: " << impact << endl;
    
    
    if(output_fluka_database && seed == 1){
		ostringstream fd_output_file;
		fd_output_file << (full_output_dir+"fluka_database.txt");

		ofstream* fd_output = new ofstream(fd_output_file.str().c_str());
		collimator_db->OutputFlukaDatabase(fd_output);
		delete fd_output;
	}
    delete collimator_db;
    
/****************************
*	Aperture Configuration	*
****************************/

	ApertureConfiguration* myApertureConfiguration;
	myApertureConfiguration = new ApertureConfiguration(directory+input_dir+"Aperture_7TeV.tfs",1);     
    	
	//~ ostringstream ap_output_file;
	//~ ap_output_file << full_output_dir << "ApertureConfiguration.log";
	//~ ofstream* ApertureConfigurationLog = new ofstream(ap_output_file.str().c_str());
    //~ myApertureConfiguration->SetLogFile(*ApertureConfigurationLog);
	//~ myApertureConfiguration->EnableLogging(true);
	
    myApertureConfiguration->ConfigureElementApertures(myAccModel);
    delete myApertureConfiguration;
    
	if(ap_survey){
		ApertureSurvey* myApertureSurvey = new ApertureSurvey(myAccModel, full_output_dir, 0.01, 0);
		//~ ApertureSurvey* myApertureSurvey = new ApertureSurvey(myAccModel, full_output_dir, 0, 20);
	}
		
	if(coll_survey){
		CollimatorSurvey* CollSurvey = new CollimatorSurvey(myAccModel, emittance, emittance, myTwiss); 
		ostringstream cs_output_file;
		cs_output_file << full_output_dir << "coll_survey.txt";
		ofstream* cs_output = new ofstream(cs_output_file.str().c_str());
		if(!cs_output->good()) { std::cerr << "Could not open collimator survey output" << std::endl; exit(EXIT_FAILURE); }   
		CollSurvey->Output(cs_output, 100);			
		delete cs_output;
	}

/********************
*	Beam Settings	*
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
    
    // Minimum and maximum sigma for HEL Halo Distribution
    mybeam.min_sig_x = -20;
    mybeam.max_sig_x = 20;
    mybeam.min_sig_y = 0.0;
    mybeam.max_sig_y = 0.0;    
   
    // Dispersion
    mybeam.Dx=myDispersion->Dx;
    mybeam.Dy=myDispersion->Dy;
    mybeam.Dxp=myDispersion->Dxp;
    mybeam.Dyp=myDispersion->Dyp;

    mybeam.emit_x = emittance * meter;
    mybeam.emit_y = emittance * meter;

    //Beam centroid
    mybeam.x0=myTwiss->Value(1,0,0,start_element_number);
    mybeam.xp0=myTwiss->Value(2,0,0,start_element_number);
    mybeam.y0=myTwiss->Value(3,0,0,start_element_number);
    mybeam.yp0=myTwiss->Value(4,0,0,start_element_number);
    mybeam.ct0=myTwiss->Value(5,0,0,start_element_number);

    //~ mybeam.sig_dp = 0.0;
    //~ mybeam.sig_z = 0.0;
    //~ if(rf_test){
		mybeam.sig_z = ((2.51840894498383E-10 * 299792458)) * meter;
	//~ }
    //~ mybeam.sig_dp =  (1.129E-4);

    // X-Y coupling
    mybeam.c_xy=0.0;
    mybeam.c_xyp=0.0;
    mybeam.c_xpy=0.0;
    mybeam.c_xpyp=0.0;

    delete myDispersion;

/************
*	BUNCH	*
************/

    ProtonBunch* myBunch;
    int node_particles = npart;
    ParticleBunchConstructor* myBunchCtor;
    
    if(rf_test){
		//~ myBunchCtor = new ParticleBunchConstructor(mybeam, node_particles, RFDistn);
		myBunchCtor = new ParticleBunchConstructor(mybeam, node_particles, RFDistn2);
	}
	else{
		myBunchCtor = new ParticleBunchConstructor(mybeam, node_particles, tuneTestDistribution);
	}
	
    myBunch = myBunchCtor->ConstructParticleBunch<ProtonBunch>();
    delete myBunchCtor;

    myBunch->SetMacroParticleCharge(mybeam.charge);
    
    if(output_initial_bunch){   
		ostringstream hbunch_output_file;
		hbunch_output_file << bunch_dir << seed  << "_initial_bunch.txt";
		ofstream* hbunch_output = new ofstream(hbunch_output_file.str().c_str());
		if(!hbunch_output->good()) { std::cerr << "Could not open initial bunch output" << std::endl; exit(EXIT_FAILURE); }   
		myBunch->Output(*hbunch_output);			
		delete hbunch_output;	
	} 

/********************
*	One Turn Map	*
********************/
						
	ostringstream otm_output_file;
	otm_output_file << OTM_dir << "OTM.txt";	
	ofstream* otm_output = new ofstream(otm_output_file.str().c_str());	
	
	cout << "\n Calculating Det(OTM) " << endl;

	for(ParticleBunch::iterator tmpart = (myBunch->begin()); tmpart != myBunch->end(); ++tmpart){			

		RealMatrix OTM(6);
		TransferMatrix TM(myAccModel, beam_energy);
		TM.SetDelta(1E-8);
		TM.ScaleBendPathLength(1E-16);
		TM.FindTM(OTM, *tmpart);
		//~ *otm_output << ((*tmpart).x()/0.000266828 ) << "\t" << (Determinant(OTM)-1) << "\t" << (*tmpart).ct() << "\t" << (*tmpart).dp()<< endl;
		*otm_output << ((*tmpart).x()/0.000266828 ) << "\t" << sqrt(pow((Determinant(OTM)-1),2)) << "\t" << (*tmpart).ct() << "\t" << (*tmpart).dp()<< endl;
		//~ *otm_output << sqrt(pow(((*tmpart).x()/0.000266828 ),2)) << "\t" << sqrt(pow((Determinant(OTM)-1),2)) << "\t" << (*tmpart).ct() << "\t" << (*tmpart).dp()<< endl;
		
		
		//~ *otm_output << sqrt(pow(((*tmpart).x()/267E-6 )-h_offset,2)) << "\t" << sqrt(pow((Determinant(OTM)-1),2)) << "\t" << (*tmpart).ct() << "\t" << (*tmpart).dp()<< endl;
		//~ cout << "\n\n\t\tOne Turn Map : " << OTM(0,0) << "\t" << OTM(0,1) << endl;
		//~ cout << "\n\t\tOne Turn Map : " << endl;				
		//~ MatrixForm(OTM, std::cout);				
		//~ cout <<"\n\tparticle sigma_x = " << ((*tmpart).x()/267.067E-6 )-h_offset<<  "\n\t Determinant of OTM = " << (Determinant(OTM)-1) << endl;
	}

/************
*	Tune	*
*************/
	if(calc_tune){		
		
	cout << "\n Calculating Tune " << endl;
			
	double Tunex(0.), Tuney(0.), dTunex(0.), dTuney(0.);
	cout << "\n\tTUNE" << endl;
	
	BetatronTunes* tune = new BetatronTunes(myAccModel, beam_energy);

	//PSvector* tuneparticle = new PSvector(4*0.000302303*seed);
	
	ParticleBunch::iterator tuneparticle = myBunch->begin();
	tuneparticle++;			
		
		tune->FindTunes(*tuneparticle);

		Tunex = tune->GetQx();
		cout << " \n\t\tTunex = " << Tunex << endl;
		Tuney = tune->GetQy();
		cout << " \t\tTuney = " << Tuney << endl;
		dTunex = tune->GetdQx();
		cout << " \t\tdTunex = " << dTunex << endl;
		dTuney = tune ->GetdQy();
		cout << " \t\tdTuney = " << dTuney << endl;
		
		delete tune;
	}
	
	//Output particle sigma
	//~ if(single_particle){
		//~ for(ParticleBunch::iterator tunepart = (myBunch->begin())+1; tunepart != myBunch->end(); ++tunepart){	
			//~ cout << "\n\tparticle sigma_x = " << ((*tunepart).x()/267.067E-6 )-h_offset<< endl;		
		//~ }
	//~ }
	
	if(tune_test){		
		
		cout << "\n Performing Tune Test " << endl;
		
		//Possible number of turns 256 default 1024	2048	4096	8192	16384	32768	65536	131072
		double powertwo = 256;
		
		ostringstream tune_output_file;
		ostringstream alttune_output_file;
		tune_output_file << Tune_dir << "Tune.txt";		
		alttune_output_file << Tune_dir << "Alttune.txt";	
		ofstream* tune_output = new ofstream(tune_output_file.str().c_str());		
		ofstream* alttune_output = new ofstream(alttune_output_file.str().c_str());		
		
			cout << "\n\tTUNE TEST" << endl;

			double start = 0;
			double end = 5;			
			double step = (end - start) / npart;
			double it = start+step;
						
			//Method 1
			double cscale = 1.0E-16;
			double delta = 1.0E-8;
			
			ClosedOrbit co(myAccModel, beam_energy);
			co.SetDelta(delta);
			co.TransverseOnly(true);
			co.ScaleBendPathLength(cscale);
			
			RealMatrix M(6);
			TransferMatrix tm(myAccModel, beam_energy);
			tm.SetDelta(delta);
			tm.ScaleBendPathLength(cscale);
					
			double tm_qx = 0;		
			
			for(ParticleBunch::iterator alttunepart = (myBunch->begin())+1; alttunepart != myBunch->end(); ++alttunepart){			
				co.FindClosedOrbit(*alttunepart);
				tm.FindTM(M,*alttunepart);
				//~ cout << "\n\t Phase Advance 1 = " << M(0,0) << " phase advance 2  = " << M(1,1) << endl;
				tm_qx = acos( (M(0,0) + M(1,1))/2 ) / 2*pi;
				cout << " \n\t\tTunex Alt= " << tm_qx << endl;
				
				*alttune_output << it << "\t" << (*alttunepart).x()/275.02E-6 << "\t" << tm_qx << endl;
				it += step;
			}						
			
			//Method 2		
			
			start = 0;					
			it = start+step;
			
			// Overloaded to include ofstream
			//BetatronTunes* tune = new BetatronTunes(model, energy, tune_output);
			// No ostream			
						
			// Infinite DC HEL
			//~ HollowELensProcess* HELProcess = new HollowELensProcess(2, 1, 1.2, 0.138874007, 2.334948339E4, 2.0);
			//~ HELProcess->SetRadii(0, 999);			
			//~ HELProcess->SetOpMode(DC);
			
			//void BetatronTunes::FindTunes(PSvector& particle, int ntrack, bool diffusion)
			BetatronTunes* tune = new BetatronTunes(myAccModel, beam_energy);
			//~ tune->SetHELProcess(HELProcess);
				
			for(ParticleBunch::iterator tunepart = (myBunch->begin())+1; tunepart != myBunch->end(); ++tunepart){
								
				//FindTunes(particle, n turns, diffusion (n turns *2))
				tune->FindTunes(*tunepart, powertwo, 0);
				*tune_output << it << "\t" << (*tunepart).x()/275.02E-6 << "\t" << tune->GetQx() << endl;
				cout << " \n\t" << it << "\t" << "Tunex = " << tune->GetQx() << endl;
				
				it += step;								
			}			
				
	}

    return 0;
}
