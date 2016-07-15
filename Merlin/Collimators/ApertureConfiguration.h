#ifndef _APERTURECONFIGURATION_H_
#define _APERTURECONFIGURATION_H_

#include <vector>
#include <string>
#include <fstream>

#include "AcceleratorModel/AcceleratorModel.h"

class ApertureConfiguration
{
public:

	/**
	* Constructor
	*/
	ApertureConfiguration();

	/**
	* Constructor with an input file to load
	* @param[in] InputFileName The name of the aperture file to load
	*/
	ApertureConfiguration(std::string InputFileName);
	
	/**
	* Constructor with an input file to load
	* @param[in] InputFileName The name of the aperture file to load
	* @param[in] Bool to expect file with no Apertype - all set to RectEllipse by default
	*/
	ApertureConfiguration(std::string InputFileName, bool are);

	/**
	* Load the Aperture settings from an input file.
	* @param[in] InputFileName The name of the aperture file to load
	*/
	void LoadApertureConfiguration(std::string InputFileName);

	/**
	* Dumps the input file back out
	* @param[in] os The name of the stream to output to
	*/
	void OutputApertureList(std::ostream& os);

	/**
	* Configures the 
	* @param[in] Model A pointer to the AcceleratorModel class to add the apertures to
	*/
	void ConfigureElementApertures(AcceleratorModel*);

	/**
	* Set the stream for the collimator settings log.
	* @param [in] os The stream to log the generated aperture to
	*/
	void SetLogFile (ostream& os);

	/**
	* Enable/disable logging
	* @param [in] flag The requested logging state
	*/
	void EnableLogging(bool flag);

	/**
	* The output log file
	*/
	std::ostream* log;

	/**
	* Enable/disable logging
	*/
	bool logFlag;
	
	/**
	* Set all apertures to RectEllipse when no AperType present in input file
	*/
	bool allRectEllipse;

	/**
	* Typedef for access to the enum
	*/
	typedef size_t ApertureClass_t;

	/**
	* See the MAD users guide for how these apertures are defined.
	* (current as of V5.02.07)
	* http://madx.web.cern.ch/madx/releases/last-dev/madxuguide.pdf
	* "Physical Aperture: Aperture definition"
	*
	* Interpolated in this case is where one type joins another - internal usage, not a MAD-X type.
	*/

	typedef enum
	{
		NONE,
		UNKNOWN,
		CIRCLE,			//Supported
		RECTANGLE,		//Supported
		ELLIPSE,		//Supported
		RECTCIRCLE,
		LHCSCREEN,		//Supported as RECTELLIPSE
		RECTELLIPSE,	//Supported
		RACETRACK,
		OCTAGON,
		INTERPOLATED
	} ApertureClass;

	struct ap
	{
		double s;
		double ap1;
		double ap2;
		double ap3;
		double ap4;
		ApertureClass_t ApType;
	};

	/**
	* One aperture entry
	*/
	ap ApertureEntry;

	/**
	* The global list of Aperture entries
	*/
	std::vector<ap> ApertureList;
};

#endif

