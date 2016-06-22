//Include relevant C++ headers

#include <iostream> // input/output
#include <sstream> // handles string streams
#include <string>
#include <map>
#include <set>
#include <ctime> // used for random seed
#include <sys/stat.h> //to use mkdir
#include <cmath>

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
    int seed = (int)time(NULL);		// seed for random number generators
    int npart 			= 6.4E6;	// number of halo particles to track
    int nleft = npart;
       
    if (argc >=2){npart = atoi(argv[1]);}
    if (argc >=3){seed = atoi(argv[2]);}
    
    seed = 13;

    RandomNG::init(seed);
    
    double beam_energy = 7000.0;
    double energy = beam_energy;
    double beam_charge = 1.1e11;
	
	//~ string directory = "/afs/cern.ch/user/h/harafiqu/public/MERLIN";	//lxplus harafiqu
	string directory = "/home/HR/Downloads/MERLIN_HRThesis/MERLIN";					//M11x	
	//~ string directory = "/afs/cern.ch/user/a/avalloni/private/Merlin_all";	//lxplus avalloni
	//~ string directory = "/home/haroon/MERLIN_HRThesis/MERLIN";				//iiaa1
	
	string pn_dir, case_dir, bunch_dir, dustbin_dir, mat_dir, hist_dir;
		
	string input_dir = "/Thesis/data/HELFullBeam/";	
	string output_dir = "/Build/Thesis/outputs/1cm/";
	
	string full_output_dir = (directory+output_dir);
	mkdir(full_output_dir.c_str(), S_IRWXU);	
	
	bool batch = 1;
	if(batch){
		case_dir = "21JunAll/";
		full_output_dir = (directory+output_dir+case_dir);
		mkdir(full_output_dir.c_str(), S_IRWXU);
		
		case_dir = "MScatter/";
		full_output_dir = (full_output_dir+case_dir);
		mkdir(full_output_dir.c_str(), S_IRWXU);
	}
	
	bool output_initial_bunch 	= 0;
	bool output_final_bunch 	= 1;		
		if (output_initial_bunch || output_final_bunch){
			//~ bunch_dir = (full_output_dir+"Bunch_Distn/"); 	mkdir(bunch_dir.c_str(), S_IRWXU); 
		}		
		
	bool collimation_on 		= 1;
		if(collimation_on){
			//~ dustbin_dir = full_output_dir + "LossMap/"; 	mkdir(dustbin_dir.c_str(), S_IRWXU);		
		}
	bool use_sixtrack_like_scattering = 0;
	bool cut_distn				= 0;

	bool symplectic = 1;
	bool composite	= 1;
	bool hist 		= 1;
	
	bool selectscatter 	= 1;
	bool jawimpact 		= 0;
	bool scatterplot 	= 0;
	bool jawinelastic 	= 0;
	
/************************
*	HISTOGRAM STUFF		*
************************/		
	const size_t nbins = 1000;
	
	// bin width = bin_max - bin_min / nbin
	double bob = 1E-4;
	//~ const double bin_min_x = -100e-6, bin_max_x = 100e-6;
	const double bin_min_x = -(5*bob), bin_max_x = (5*bob);
	const double x_bw = (bin_max_x - bin_min_x) / nbins;
	
	const double bin_min_xp = -1E-6, bin_max_xp = 1E-6;	
	const double xp_bw = (bin_max_xp - bin_min_xp) / nbins;
	
	const double bin_min_y = -(5*bob), bin_max_y = (5*bob);	
	const double y_bw = (bin_max_y - bin_min_y) / nbins;
	
	const double bin_min_yp = -1E-6, bin_max_yp = 1E-6;		
	const double yp_bw = (bin_max_yp - bin_min_yp) / nbins;
	
	const double bin_min_dp = 0, bin_max_dp = 5E-6;
	const double dp_bw = (bin_max_dp - bin_min_dp) / nbins;
	
	const double bin_min_t = -1E10, bin_max_t = 0;
	const double t_bw = (bin_max_t - bin_min_t) / nbins;
	
	const double bin_min_th = 0, bin_max_th = 1E-5;
	const double th_bw = (bin_max_th - bin_min_th) / nbins;

	int hist_x[nbins+2] = {0};
	int hist_xp[nbins+2] = {0};
	int hist_y[nbins+2] = {0};
	int hist_yp[nbins+2] = {0};
	int hist_dp[nbins+2] = {0};
	int hist_t[nbins+2] = {0};
	int hist_th[nbins+2] = {0};
	
	double theta = 0;
	double t = 0;
	
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
	material_names.push_back("AC150K");
	//~ material_names.push_back("Mo2C");
	//~ material_names.push_back("GCOP");
	//~ material_names.push_back("IT180");
	//~ material_names.push_back("CuCD");
	//~ material_names.push_back("MoGr");

/************************
*	BEAM  SETTINGS	*
************************/
	BeamData myBeam;
		myBeam.charge= 1.31e11;
		myBeam.beta_x = 0.000001;
		myBeam.beta_y = 0.000001;
		myBeam.emit_x = 0.;
		myBeam.emit_y = 0.;
		//~ myBeam.sig_z = 75.5*millimeter;
		myBeam.sig_z = 0.;
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
	
	cout << "Collimator Aperture" << endl;
	
	// CollimatorAperture constructor contains a material - this is depreciated and can be set to null
	// CollimatorAperture(double w,double h, double t, Material* m, double length, double x_offset_entry=0.0, double y_offset_entry=0.0);	
	//Aperture* ap = new CollimatorAperture(x, y, tilt, material, length, x_offset_entry, y_offset_entry);
	//jaw closed
	Aperture* ap1 = new CollimatorAperture(10.0, 0., 0., NULL, 0.5, 0., 0.);
	double length = 0.01*meter;
		
	int ii = 0;
	
	// Iterate for size of material names
	vector<string>::iterator pit;
	for(pit = material_names.begin(); pit != material_names.end(); ++pit){
		cout << "Started loop for material: " << *pit << endl;
		
		// Create batch output files for different scatter histograms
		mat_dir = (full_output_dir+(*pit)+"/"); 	 	mkdir(mat_dir.c_str(), S_IRWXU);		
		
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
		
		if(scatterplot) 	{myScatter->SetScatterPlot(*pit);}
		if(jawimpact)		{myScatter->SetJawImpact(*pit);}
		if(jawinelastic)	{myScatter->SetJawInelastic(*pit);}
		if(selectscatter)	{myScatter->SetSelectScatter(*pit);}
		
		// Create bunch
		ProtonBunch* myBunch;
		ParticleBunchConstructor* myBunchCtor;
		myBunchCtor = new ParticleBunchConstructor(myBeam, npart, pencilDistribution);	
		myBunch = myBunchCtor->ConstructParticleBunch<ProtonBunch>();
		
		if(output_initial_bunch){	
			ostringstream initial_bunch_file;
			initial_bunch_file << mat_dir << "initial_bunch_" << *pit << "_.txt";
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
		cout << "\n\n" << endl;
		cout << "\tMaterial 	: " << *pit << endl;
		cout << "\tParticles 	: " << npart << endl;
		cout << "\tAbsorbed	: " << npart - myBunch->size() << endl;	
		cout << "\tRemaining 	: " << nleft << endl;
	
		// Output
		if(jawimpact)		{myScatter->OutputJawImpact(mat_dir);}
		if(jawinelastic)	{myScatter->OutputJawInelastic(mat_dir);}
		if(scatterplot) 	{myScatter->OutputScatterPlot(mat_dir);}
		if(selectscatter) 	{
			if(hist){
				myScatter->OutputSelectScatterHistogram(mat_dir, 1, nbins, 1);
				myScatter->OutputSelectScatterHistogram(mat_dir, 2, nbins, 1);
				myScatter->OutputSelectScatterHistogram(mat_dir, 3, nbins, 1);
				myScatter->OutputSelectScatterHistogram(mat_dir, 4, nbins, 1);
				myScatter->OutputSelectScatterHistogram(mat_dir, 6, nbins, 1);
						}
			myScatter->OutputSelectScatter(mat_dir);
		}
		myScatter->OutputScatteringProcesses(mat_dir, ii);
		myScatter->OutputCounter(mat_dir, ii);
		
		cout << "\tOutput final bunches" << endl;
		if(output_final_bunch){
			ostringstream fin_output_file;
			fin_output_file << mat_dir << "unscattered_final_bunch_" << *pit <<"_.txt";
			ofstream* bunch_final = new ofstream(fin_output_file.str().c_str());
			if(!bunch_final->good()){ std::cerr << "Could not open unscattered final bunch output file for material " << *pit << std::endl; exit(EXIT_FAILURE); }  
			myBunch->OutputScattered(*bunch_final,5);
			delete bunch_final;
			
			//~ ostringstream fin_output_file1;
			//~ fin_output_file1 << mat_dir << "final_bunch_" << *pit <<"_.txt";
			//~ ofstream* bunch_final1 = new ofstream(fin_output_file1.str().c_str());
			//~ if(!bunch_final1->good()){ std::cerr << "Could not open final bunch output file for material " << *pit << std::endl; exit(EXIT_FAILURE); }  
			//~ myBunch->OutputScattered(*bunch_final1);
			//~ delete bunch_final1;
		}
		
		cout << "\tOutput MCS histogram" << endl;
		// MCS Histogramming			
		if(hist){			 	 
			if(nleft>1){
				for (PSvectorArray::iterator ip=myBunch->begin(); ip!=myBunch->end(); ip++){
					
					if (ip->type() == 5){
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
						
						theta = atan ( sqrt( ip->xp()*ip->xp() + ip->yp()*ip->yp() ) );
						t = - (4.9E19)*(theta*theta);
			
						int bin_th = ((theta - bin_min_th) / (bin_max_th-bin_min_th) * (nbins)) +1; // +1 because bin zero for outliers
						if (theta < bin_min_th) bin_th = 0;
						if (theta > bin_max_th) bin_th = nbins+1;
						hist_th[bin_th] += 1;
						
						int bin_t = ((t - bin_min_t) / (bin_max_t-bin_min_t) * (nbins)) +1; // +1 because bin zero for outliers
						if (t < bin_min_t) bin_t = 0;
						if (t > bin_max_t) bin_t = nbins+1;
						hist_t[bin_t] += 1;		
					}
					
				}
			}
			
			/*********************************************************************
			**	Output Final Hist
			*********************************************************************/
				ostringstream hist_output_file;
				hist_output_file << mat_dir << "HIST_" << *pit <<"_5.txt";
				ofstream* out2 = new ofstream(hist_output_file.str().c_str());
				if(!out2->good()){ std::cerr << "Could not open MCS hist output file for material " << *pit << std::endl; exit(EXIT_FAILURE); }  
				
				//~ double norm = npart;
				double norm = 1;
				
				if(nleft>1){		
					for (size_t i=0; i<nbins+2; i++){
					
					/*** This output should be normalised by the original particle
					* number npart in order to compare the number of lost particles
					* It may also need to be normalised to the bin width */
					
					// Normalised by npart, start bin
					(*out2) << bin_min_x + (x_bw*i) << "\t";
					(*out2) << (double)hist_x[i]/norm << "\t";
					(*out2) << bin_min_xp + (xp_bw*i) << "\t";
					(*out2) << (double)hist_xp[i]/norm <<"\t";
					(*out2) << bin_min_y + (y_bw*i) << "\t";
					(*out2) << (double)hist_y[i]/norm << "\t";
					(*out2) << bin_min_yp + (yp_bw*i) << "\t";
					(*out2) << (double)hist_yp[i]/norm <<"\t";
					(*out2) << bin_min_dp + (dp_bw*i) << "\t";
					(*out2) << (double)hist_dp[i]/norm << "\t";
					(*out2) << bin_min_th + (th_bw*i) << "\t";
					(*out2) << (double)hist_th[i]/norm << "\t";
					(*out2) << bin_min_t + (t_bw*i) << "\t";
					(*out2) << (double)hist_t[i]/norm << endl;				
				}
				delete out2;				
			}
		}
		
		cout << "Deleting stuff" << endl;
		//~ delete coll;
		delete myaccmodelctor;
		delete myAccModel;
		delete myBunch;
		delete myBunchCtor;	
		delete myScatter;
		//~ delete out2;
		//~ delete myBeamline;
		
		ii++;		
		cout << "Ended loop for material: " << *pit << endl;
	}
		
    return 0;
}
