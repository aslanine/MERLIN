/////////////////////////////////////////////////////////////////////////
//
// Merlin C++ Class Library for Charged Particle Accelerator Simulations
//
// Class library version 3 (2004)
//
// Copyright: see Merlin/copyright.txt
//
// Last CVS revision:
// $Date: 2004/12/13 08:38:51 $
// $Revision: 1.2 $
//
/////////////////////////////////////////////////////////////////////////

#ifndef SimpleApertures_h
#define SimpleApertures_h 1

#include "merlin_config.h"
#include <cmath>
#include "AcceleratorModel/Aperture.h"

#include <string>
#include <iostream>

#ifdef MERLIN_PROFILE
#include "utility/MerlinProfile.h"
#endif

/**
* Represents an aperture with a rectangular cross-section.
* The aperture is assumed symmetric about the axis, and
* extruded along its geometry.
*/
class RectangularAperture : public Aperture
{
public:
	RectangularAperture (double width, double height);

	double GetFullWidth () const;
	double GetFullHeight () const;
	void SetFullWidth (double w);
	void SetFullHeight (double h);

	/**
	* Returns true if the point (x,y,z) is within the
	* aperture. The z coordinate is ignored.
	*/
	virtual bool PointInside (double x, double y, double z) const;

	/**
	* Returns the radius to the aperture at the angle phi. The
	* z coordinate is ignored.
	*/
	virtual double GetRadiusAt (double phi, double z) const;

	virtual std::string GetApertureType() const;
	virtual void printout(std::ostream& out) const;

private:

	double hw;
	double hh;
};

inline std::string RectangularAperture::GetApertureType() const
{
	return "RECTANGULAR";
}

/**
* Represents an aperture with a circular cross-section.
* The aperture is assumed to be extruded along its
* geometry.
*/
class CircularAperture : public Aperture
{
public:
	explicit CircularAperture (double r);

	double GetRadius () const;
	double GetDiameter () const;
	void SetRadius (double r);
	void SetDiameter (double d);

	/**
	* Returns true if the point (x,y,z) is within the
	* aperture. The z coordinate is ignored.
	*/
	virtual bool PointInside (double x, double y, double z) const;

	/**
	* Returns the radius.
	*/
	virtual double GetRadiusAt (double phi, double z) const;

	virtual std::string GetApertureType() const;
	virtual void printout(std::ostream& out) const;
private:

	double r2;
};

inline RectangularAperture::RectangularAperture (double width, double height)
	:hw(fabs(width)/2),hh(fabs(height)/2)
{}

inline double RectangularAperture::GetFullWidth () const
{
	return 2*hw;
}

inline double RectangularAperture::GetFullHeight () const
{
	return 2*hh;
}

inline void RectangularAperture::SetFullWidth (double w)
{
	hw=fabs(w)/2;
}

inline void RectangularAperture::SetFullHeight (double h)
{
	hh=fabs(h)/2;
}

inline bool RectangularAperture::PointInside (double x, double y, double z=0.0) const
{
	return fabs(x)<hw && fabs(y)<hh;
}

inline CircularAperture::CircularAperture (double r)
	: r2(r*r)
{}

inline double CircularAperture::GetRadius () const
{
	return sqrt(r2);
}

inline double CircularAperture::GetDiameter () const
{
	return 2*GetRadius();
}

inline void CircularAperture::SetRadius (double r)
{
	r2=r*r;
}

inline void CircularAperture::SetDiameter (double d)
{
	r2=d*d/4.0;
}

inline bool CircularAperture::PointInside (double x, double y, double z) const
{
	return x*x+y*y<r2;
}

inline std::string CircularAperture::GetApertureType() const
{
	return "CIRCULAR";
}

/**
* Represents an aperture with an elliptical cross-section.
* The aperture is assumed extruded along its geometry.
*/
class EllipticalAperture : public Aperture
{
public:
	EllipticalAperture (double width, double height);

	double GetHalfWidth () const;
	double GetHalfHeight () const;

	/**
	* Returns true if the point (x,y,z) is within the
	* aperture. The z coordinate is ignored.
	*/
	virtual bool PointInside (double x, double y, double z) const;

	/**
	* Returns the radius to the aperture at the angle phi. The
	* z coordinate is ignored.
	*/
	virtual double GetRadiusAt (double phi, double z) const;

	virtual std::string GetApertureType() const;
	virtual void printout(std::ostream& out) const;

private:

	double hw;
	double hh;
	double EHH2;
	double HV;
};

inline EllipticalAperture::EllipticalAperture (double ehh, double ehv)
	: hw(ehh), hh(ehv), EHH2(ehh*ehh), HV((ehh*ehh)/(ehv*ehv))
{}

inline bool EllipticalAperture::PointInside (double x, double y, double z) const
{
	return (x*x + y*y*HV) < EHH2;
}

inline double EllipticalAperture::GetHalfWidth () const
{
	return hw;
}

inline double EllipticalAperture::GetHalfHeight () const
{
	return hh;
}

inline std::string EllipticalAperture::GetApertureType() const
{
	return "ELLIPSE";
}

#endif

