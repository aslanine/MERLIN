#ifndef _COLLIMATOR_SURVEY_H_
#define _COLLIMATOR_SURVEY_H_

#include "AcceleratorModel/AcceleratorModel.h"
#include "AcceleratorModel/Aperture.h"
#include "AcceleratorModel/StdComponent/Collimator.h"

#include "RingDynamics/LatticeFunctions.h"

using namespace std;

class CollimatorSurvey
{
public:

	CollimatorSurvey(AcceleratorModel* model, double emittance_x, double emittance_y, LatticeFunctionTable* twiss);
	
	void Output(std::ostream* os, int no_points);
	
	double ReturnCollimatorHalfGap(string name, int);

protected:

private:

	void SurveyAperture(Aperture* ap, double s, double *aps);

	double em_x;
	double em_y;

	AcceleratorModel* AM;
	LatticeFunctionTable* LFT;
	
};

#endif
