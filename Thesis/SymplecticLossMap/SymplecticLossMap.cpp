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
#include "AcceleratorModel/ApertureSurvey.h"

#include "BeamDynamics/ParticleTracking/ParticleBunchConstructor.h"
#include "BeamDynamics/ParticleTracking/ParticleTracker.h"
#include "BeamDynamics/ParticleTracking/ParticleBunchTypes.h"
#include "BeamDynamics/ParticleTracking/Integrators/SymplecticIntegrators.h"
#include "BeamDynamics/TrackingSimulation.h"
#include "BeamDynamics/TrackingOutputASCII.h"
#include "BeamDynamics/TrackingOutputAV.h"

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

using namespace std;
using namespace PhysicalUnits;

int main(int argc, char* argv[])
{
    int seed 			= (int)time(NULL);    	// seed for random number generators
    int npart 			= 1E4;                	// number of particles to track
    int nturns 			= 200;                 	// number of turns to track
	
	bool DoTwiss 		= 1;					// run twiss and align to beam envelope etc?
	bool beam1 			= 1;					// beam 1 or 2
	bool hard_edge 		= 0;					// if true, scattering is off in collimation
	bool output_fluka_database = 1;				// FLUKA database of collimators
	bool symplectic		= 0;					// SYMPLECTIC or TRANSPORT tracking
	bool collimation	= 1;
	
	 
    if (argc >=2){npart = atoi(argv[1]);}

    if (argc >=3){seed = atoi(argv[2]);}

	seed=1;
    RandomNG::init(seed);

    double beam_energy = 6500.0;

    cout << "npart=" << npart << " nturns=" << nturns << " beam energy = " << beam_energy << endl;

	string start_element;
	if(beam1)
	    start_element = "TCP.C6L7.B1";    // HORIZONTAL COLLIMATOR (x)
	else	
	    start_element = "TCP.C6R7.B2";    // HORIZONTAL COLLIMATOR (x)

    double beam_charge = 1.1e11;
    double normalized_emittance = 3.5e-6;
    double gamma = beam_energy/PhysicalConstants::ProtonMassMeV/PhysicalUnits::MeV;
	double beta = sqrt(1.0-(1.0/pow(gamma,2)));
	double emittance = normalized_emittance/(gamma*beta);

	//~ string directory = "/afs/cern.ch/user/h/harafiqu/public/MERLIN";					//lxplus harafiqu
	//~ string directory = "/home/haroon/git/Merlin/HR";									//iiaa1
	string directory = "/home/HR/Downloads/MERLIN_HRThesis/MERLIN";							//M11x	
	//~ string directory = "/afs/cern.ch/work/a/avalloni/private/MerlinforFluka/MERLIN";	//lxplus avalloni
	
	string input_dir = "/Thesis/data/AV/";
	
	//~ string output_dir = "/test2/UserSim/outputs/HL/";
	string output_dir = "/Build/Thesis/outputs/SymplecticLossMap/";
	string batch_directory="LossMapDustbinTest/";

	string full_output_dir = (directory+output_dir);
	mkdir(full_output_dir.c_str(), S_IRWXU);
	full_output_dir = (directory+output_dir+batch_directory);
	mkdir(full_output_dir.c_str(), S_IRWXU);
	
///////////////////////////////////
// ACCELERATORMODEL CONSTRUCTION //
///////////////////////////////////
	cout << "MADInterface" << endl;
	
	MADInterface* myMADinterface;
    if(beam1)
		myMADinterface = new MADInterface( directory+input_dir+"Twiss_6p5TeV.tfs", beam_energy );
    else
		myMADinterface = new MADInterface( directory+input_dir+"Twiss_6p5TeV_flat_top_beam2.tfs", beam_energy );
	cout << "MADInterface Done" << endl;

    //~ myMADinterface->TreatTypeAsDrift("RFCAVITY");
    //~ myMADinterface->TreatTypeAsDrift("SEXTUPOLE");
    //~ myMADinterface->TreatTypeAsDrift("OCTUPOLE");

    myMADinterface->ConstructApertures(false);
    AcceleratorModel* myAccModel = myMADinterface->ConstructModel();    

///////////
// TWISS //
///////////

    int start_element_number_test = myAccModel->FindElementLatticePosition(start_element.c_str());    
    cout << "Found start element TCP.C6L7 at element number " << start_element_number_test << endl;

    LatticeFunctionTable* myTwiss = new LatticeFunctionTable(myAccModel, beam_energy);
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
			myTwiss->ScaleBendPathLength(bscale1);
			myTwiss->Calculate();

			if(!std::isnan(myTwiss->Value(1,1,1,0))) {break;}
			bscale1 *= 2;
			cout << "\n\ttrying bscale = " << bscale1<< endl;
		}
	}
	
	ostringstream twiss_output_file; 
    twiss_output_file << (directory+output_dir+"LatticeFunctions.dat");
    ofstream twiss_output(twiss_output_file.str().c_str());
	myTwiss->PrintTable(twiss_output);
	
///////////////////////
// Collimator set up //
///////////////////////
	cout << "Collimator Setup" << endl;   
    MaterialDatabase* myMaterialDatabase = new MaterialDatabase();
    
    CollimatorDatabase* collimator_db;
    if(beam1)
		collimator_db = new CollimatorDatabase( directory+input_dir+"Collimator_6p5TeV.txt", myMaterialDatabase,  true);
    else
		collimator_db = new CollimatorDatabase( directory+input_dir+"Collimator_6p5TeV_flat_top_beam2.txt", myMaterialDatabase,  true);
   
    collimator_db->MatchBeamEnvelope(true);
    collimator_db->EnableJawAlignmentErrors(false);

    collimator_db->SetJawPositionError(0.0 * nanometer);
    collimator_db->SetJawAngleError(0.0 * microradian);

    collimator_db->SelectImpactFactor(start_element, 1.0e-6);

    double impact = 6;
    
    try{
		if(DoTwiss)
        impact = collimator_db->ConfigureCollimators(myAccModel, emittance, emittance, myTwiss);
		else
        collimator_db->ConfigureCollimators(myAccModel);
    }
    catch(exception& e){
        std::cout << "Exception caught: " << e.what() << std::endl;
        exit(1);
    }
    if(std::isnan(impact)){
        cerr << "Impact is nan" << endl;
        exit(1);
    }
    cout << "Impact factor number of sigmas: " << impact << endl;
     
    //~ if(output_fluka_database && seed == 1){
    if(output_fluka_database){
		ostringstream fd_output_file;
		fd_output_file << (full_output_dir+"fluka_database.txt");

		ofstream* fd_output = new ofstream(fd_output_file.str().c_str());
		collimator_db->OutputFlukaDatabase(fd_output);
		delete fd_output;
	}
    delete collimator_db;
    
//CHECK FOR COLLIMATOR APERTURES	
	vector<Collimator*> TCP;
	int siz = myAccModel->ExtractTypedElements(TCP, start_element);

	cout << "\n\t Found " << TCP.size() << " Collimators when extracting" << endl;

	Aperture *ap = (TCP[0])->GetAperture();
	if(!ap){cout << "Could not get tcp ap" << endl;	abort();}
	else{cout << "TCP aperture type = " << ap->GetApertureType() << endl;}

	CollimatorAperture* CollimatorJaw = dynamic_cast<CollimatorAperture*>(ap);
	if(!CollimatorJaw){cout << "Could not cast" << endl;	abort();}

////////////////////////////
// Aperture Configuration //
////////////////////////////

    ApertureConfiguration* myApertureConfiguration;
    if(beam1) 
		myApertureConfiguration = new ApertureConfiguration(directory+input_dir+"Aperture_6p5TeV.tfs",1);   
    else   
		myApertureConfiguration = new ApertureConfiguration(directory+input_dir+"Aperture_6p5TeV_beam2.tfs",1);      
    
    myApertureConfiguration->ConfigureElementApertures(myAccModel);
    delete myApertureConfiguration;

//ApertureSurvey

	//~ if(seed == 1)
	// 5 points per element
	//~ ApertureSurvey* myApertureSurvey = new ApertureSurvey(myAccModel, full_output_dir, 0.1, 5);
	// every 10cm
	//~ ApertureSurvey* myApertureSurvey = new ApertureSurvey(myAccModel, full_output_dir, 0.1);
	// exact s every 10cm
	ApertureSurvey* myApertureSurvey = new ApertureSurvey(myAccModel, full_output_dir, true, 0.1);


///////////////////
// BEAM SETTINGS //
///////////////////

    Dispersion* myDispersion = new Dispersion(myAccModel, beam_energy);
    int start_element_number = myAccModel->FindElementLatticePosition(start_element.c_str());
    myDispersion->FindDispersion(start_element_number);

    BeamData mybeam;

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
    mybeam.emit_x = impact * impact * emittance * meter;
    impact =1;
    mybeam.emit_y = impact * impact * emittance * meter;
    mybeam.sig_z = 0.0;

    // Beam centroid
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

    delete myDispersion;

///////////
// BUNCH //
///////////

	ProtonBunch* myBunch;
    int node_particles = npart;

    // horizontalHaloDistribution1 is a halo in xx' plane, zero in yy'
    // horizontalHaloDistribution2 is a halo in xx' plane, gaussian in yy'
    ParticleBunchConstructor* myBunchCtor = new ParticleBunchConstructor(mybeam, node_particles, horizontalHaloDistribution2);
    //~ ParticleBunchConstructor* myBunchCtor = new ParticleBunchConstructor(mybeam, node_particles, SymplecticHorizontalHaloDistribution2);

    myBunch = myBunchCtor->ConstructParticleBunch<ProtonBunch>();
    delete myBunchCtor;

    myBunch->SetMacroParticleCharge(mybeam.charge);

/////////////////////
// ParticleTracker //
/////////////////////

	AcceleratorModel::RingIterator beamline = myAccModel->GetRing(start_element_number);
    ParticleTracker* myParticleTracker = new ParticleTracker(beamline, myBunch);
    if(symplectic){ myParticleTracker->SetIntegratorSet(new ParticleTracking::SYMPLECTIC::StdISet());}
    else{ myParticleTracker->SetIntegratorSet(new ParticleTracking::TRANSPORT::StdISet());}

// TRACK OUTPUT	
	ostringstream alessias_sstream;
	alessias_sstream << full_output_dir << "Tracking_output_file" << npart << "_" << seed << ".txt";	
	string alessias_file = alessias_sstream.str().c_str();	

	TrackingOutputAV* myTrackingOutputAV = new TrackingOutputAV(alessias_file);
	myTrackingOutputAV->SetSRange(19000, 27000);
	//~ myTrackingOutputAV->SetTurn(1);
	myTrackingOutputAV->SetTurnRange(1,1);	
	myTrackingOutputAV->SuppressUnscattered(0);	
	myParticleTracker->SetOutput(myTrackingOutputAV);

/////////////////////////
// Collimation Process //
/////////////////////////
  
    CollimateProtonProcess* myCollimateProcess =new CollimateProtonProcess(2, 4);
    
	LossMapDustbin* myLossMapDustbin = new LossMapDustbin;
	myCollimateProcess->SetDustbin(myLossMapDustbin);   
		
	FlukaDustbin* myFlukaDustbin = new FlukaDustbin;
	//~ myCollimateProcess->SetDustbin(myFlukaDustbin);      

	if (hard_edge){myCollimateProcess->ScatterAtCollimator(false);}
	else{ myCollimateProcess->ScatterAtCollimator(true);}

   
    // We must assign a ScatteringModel to the CollimateProtonProcess, this will allow us to choose the type of scattering that will be used
    ScatteringModel* myScatter = new ScatteringModel;
    if(beam1){
		myScatter->SetScatterPlot("TCP.C6L7.B1");
		myScatter->SetJawImpact("TCP.C6L7.B1");
		//~ myScatter->SetScatterPlot("TCP.B6L7.B1");
		//~ myScatter->SetJawImpact("TCP.D6L7.B1");
	}
	else{
		myScatter->SetScatterPlot("TCP.C6R7.B2");
		myScatter->SetJawImpact("TCP.C6R7.B2");
		//~ myScatter->SetScatterPlot("TCP.B6R7.B2");
		//~ myScatter->SetJawImpact("TCP.D6R7.B2");	
	}

    // MERLIN contains various ScatteringProcesses; namely the following
    // Rutherford, Elastic pn, Elastic pN, Single Diffractive, and Inelastic
    // Each of these have a MERLIN and SixTrack like version (except the inelastic)
    // As well as this there are 2 types of ionisation; simple (SixTrack like), and advanced
    // There exist 5 pre-defined set ups which may be used:
    // 0: ST,    1: ST + Adv. Ionisation,    2: ST + Adv. Elastic,    3: ST + Adv. SD,     4: MERLIN
    // Where ST = SixTrack like, Adv. = Advanced, SD = Single Diffractive, and MERLIN includes all advanced scattering

    bool use_sixtrack_like_scattering = 0;
    if(use_sixtrack_like_scattering){
        myScatter->SetScatterType(0);
    }
    else{
        myScatter->SetScatterType(4);
    }

    myCollimateProcess->SetScatteringModel(myScatter);

	myCollimateProcess->SetLossThreshold(200.0);

	myCollimateProcess->SetOutputBinSize(0.1);
	
	if(collimation){myParticleTracker->AddProcess(myCollimateProcess);}

//////////////////
// TRACKING RUN //
//////////////////

    // Now all we have to do is create a loop for the number of turns and use the Track() function to perform tracking   
    for (int turn=1; turn<=nturns; turn++)
    {
        cout << "Turn " << turn <<"\tParticle number: " << myBunch->size() << endl;

        myParticleTracker->Track(myBunch);
        
        if( myBunch->size() <= 1 ) break;
    }
	
	/*********************************************************************
	**	Output Jaw Impact
	*********************************************************************/
	myScatter->OutputJawImpact(full_output_dir, seed);
	myScatter->OutputScatterPlot(full_output_dir, seed);	

	/*********************************************************************
	** OUTPUT FLUKA LOSSES 
	*********************************************************************/
	ostringstream fluka_dustbin_file;
	fluka_dustbin_file << full_output_dir<<std::string("fluka_losses_")<< npart << "_" << seed << std::string(".txt");	   
	  
	ofstream* fluka_dustbin_output = new ofstream(fluka_dustbin_file.str().c_str());	
	if(!fluka_dustbin_output->good())    {
        std::cerr << "Could not open dustbin loss file" << std::endl;
        exit(EXIT_FAILURE);
    }   
	
	myFlukaDustbin->Finalise(); 
	myFlukaDustbin->Output(fluka_dustbin_output); 
    
   /*********************************************************************
	** OUTPUT LOSSMAP  
	*********************************************************************/
	ostringstream dustbin_file;
	dustbin_file << full_output_dir<<"Dustbin_losses_"<< npart << "_" << seed << std::string(".txt");	
	ofstream* dustbin_output = new ofstream(dustbin_file.str().c_str());	
	if(!dustbin_output->good())    {
        std::cerr << "Could not open dustbin loss file" << std::endl;
        exit(EXIT_FAILURE);
    }   
	
	myLossMapDustbin->Finalise(); 
	myLossMapDustbin->Output(dustbin_output); 
   
    // These lines tell us how many particles we tracked, how many survived, and how many were lost
    cout << "npart: " << npart << endl;
    cout << "left: " << myBunch->size() << endl;
    cout << "absorbed: " << npart - myBunch->size() << endl;

    // Cleanup our pointers on the stack for completeness
    delete myMaterialDatabase;
    delete myBunch;
    delete myTwiss;
    delete myAccModel;
    delete myMADinterface;

    return 0;
}
