#include "AcceleratorModel/Apertures/RectEllipseAperture.h"
#include <iostream>
#include <cstdlib>
/*
* Checks if a particle is within a RectEllipseAperture type
* Returns true if the point (x,y,z) is within the aperture.
*/
bool RectEllipseAperture::PointInside (double x, double y, double z) const
{
	/* Particle is NOT inside the eliptical aperture component */
	//if( ((x*x*IEHH2) + (y*y*IEHV2)) > 1){return false;}
	if( (x*x + y*y*HV) > EHH2)
	{
		return false;
	}
	/* Particle is NOT inside the rectangular aperture component */
	else if(std::fabs(x) > RectHalfWidth || std::fabs(y) > RectHalfHeight)
	{
		return false;
	}
	/* Particle is inside both components, and is inside the aperture */
	else
	{
		return true;
	}
}

double RectEllipseAperture::GetRadiusAt (double phi, double z) const
{
	std::cerr << "Not yet implemented: RectEllipseAperture::GetRadius()" << std::endl;
	exit(EXIT_FAILURE);
/*
	const double phi0=atan(hh/hw);
	const double piOverTwo = pi/2.0;

	phi=fmod(phi,piOverTwo)*piOverTwo;

	return phi<phi0 ? hw/cos(phi) : hh/sin(phi);
	double rRectangle = sqrt((rect_x*rect_x) + (rect_y*rect_y));
	//double EllipseAngle = atan2(rect_y,rect_x);

	const double EllipseHalfHorizontal;
	const double EllipseHalfVertical;

	double rr = EllipseHalfHorizontal*EllipseHalfVertical / sqrt(pow(EllipseHalfVertical*cos(phi),2) + pow(EllipseHalfHorizontal*sin(phi),2));
	double ellipse_x = rr*cos(phi);
	double ellipse_y = rr*sin(phi);
	double rEllipse = sqrt((ellipse_x*ellipse_x) + (ellipse_y*ellipse_y));
	if(rEllipse > rRectangle)
	{
		return rEllipse;
	}

	return rRectangle;
*/
}

std::string RectEllipseAperture::GetApertureType() const
{
	return "RECTELLIPSE";
}

void RectEllipseAperture::printout(std::ostream& out) const
{
	out << GetApertureType() << "(" << RectHalfWidth << ", "<< RectHalfHeight << ", "<<
	    EllipseHalfHorizontal << ", "<<EllipseHalfVertical << ")";
}

