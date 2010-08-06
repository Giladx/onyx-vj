

#include "AS3.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>


const int screenWidth  = 230;
const int screenHeight = 230;

int pixels[screenWidth*screenHeight];

double x_;
double y_;
double dx;
double dy;
double time_ = 0;
        //sincos
double sn;
double cn;

AS3_Val allocMem(void* self, AS3_Val args)
{
	int x, y, red, green, blue, width, height, pointer;
	AS3_ArrayValue(args, "IntType, IntType", &width, &height );

    pointer    = 0;
	for(y=0; y<screenHeight; y++)
	{

		for(x=0; x<screenWidth; x++)
		{
		    red   = (int)250;
		    green = (int)200;
		    blue  = (int)20;

            int cols = red << 16 | green << 8 | blue;
			pixels[pointer] = cols;
			pointer++;
		}
	}

    int scale = 1;

    dx = 2.0 / screenWidth  * scale;
    dy = 2.0 / screenHeight * scale;

	return AS3_Ptr( pixels );

}

inline float fastsqrt(float val)  {
        union
        {
                int tmp;
                float val;
        } u;
        u.val = val;
        u.tmp -= 1<<23; /* Remove last bit so 1.0 gives 1.0 */
        /* tmp is now an approximation to logbase2(val) */
        u.tmp = u.tmp >> 1; /* divide by 2 */
        u.tmp += 1<<29; /* add 64 to exponent: (e+127)/2 =(e/2)+63, */
        /* that represents (e/2)-64 but we want e/2 */
        return u.val;
}

inline int shader( double u, double v, double ex, double ey, double ez ) {

    //double a  = time_;
    double d  = 1;
    double n  = time_ * 0.1;
    double Z  = 3; //2 is gasket
    double IZ = 1.0/Z;

    //Start position
    double sx = ex;
    double sy = ey;
    double sz = ez;

    double rx;
    double ry;
    double rz;

    //direction ray
    rx = 1;//u;
    ry = u;//v;
    rz = v;//1;

    //temp position
    double tx = ex;
    double ty = ey;
    double tz = ez;

    double gx = cn * rx + sn * rz;
    double gy = ry;
    double gz = cn * rz - sn * rx;
    rx = gx;    ry = gz;    rz = gy;
    gx = cn * rx + sn * rz;
    gy = ry;
    gz = cn * rz - sn * rx;
    rx = gx; ry = gz; rz = gy;
    double irx = 1.0/rx;
    double iry = 1.0/ry;
    double irz = 1.0/rz;
    int ix;
    int iy;
    int iz;
    int fx;
    int fy;
    int fz;

    int i = 0;

    for(i = 16; i-- && d > 0.0125;) {

        d = d * IZ;

        ix = (int)tx >> 0;
        iy = (int)ty >> 0;
        iz = (int)tz >> 0;
        //fraction;
        tx = (tx - ix) * Z;
        ty = (ty - iy) * Z;
        tz = (tz - iz);
        tz = (tz < 0) ? (1 + tz) : tz;
        tz = tz * Z;

        ix = (int)tx >> 0;
        iy = (int)ty >> 0;
        iz = (int)tz >> 0;

        //integer
        int j =
            ix * ix +
            iy * iy +
            iz * iz;
        j = j & 3;
        if (j >= 2) {
            fx = (rx > 0) ? 1 : 0;
            fy = (ry > 0) ? 1 : 0;
            fz = (rz > 0) ? 1 : 0;

            tx = (fx - (tx - ix)) * irx;
            ty = (fy - (ty - iy)) * iry;
            tz = (fz - (tz - iz)) * irz;

            n = tx;
            n = (ty < n) ? ty : n;
            n = (tz < n) ? tz : n;
            ex = ex + rx * (n * d + 0.001);
            ey = ey + ry * (n * d + 0.001);
            ez = ez + rz * (n * d + 0.001);
            tx = ex;
            ty = ey;
            tz = ez;

            d = 1;
        }
    }

    //fog
    ex = ex - sx;
    ey = ey - sy;
    ez = ez - sz;

    return (int)((1 - exp( -fastsqrt(ex*ex + ey*ey + ez*ez))) * 0xff) >> 0;

}

AS3_Val shootRays(void* self, AS3_Val args) {

    double fsn, fcn, currTime, prevTime, ex, ey, ez;
    AS3_ArrayValue(args, "DoubleType, DoubleType, DoubleType, DoubleType, DoubleType, DoubleType, DoubleType", &fsn, &fcn, &currTime, &prevTime, &ex, &ey, &ez );

    int pointer, x, y;

    sn = fsn;
    cn = fcn;

    y_ = -1.0;
    pointer = 0;

    for(y = 0 ; y < screenHeight; ++y) {

        x_ = -1.0;

        for(x = 0 ; x < screenWidth; ++x) {

            int col = shader(x_, y_, ex, ey, ez);
            pixels[pointer++] = col << 16 & 0x0000FF | col << 8 & 0x0000FF | col;

            x_ = x_ + dx;

        }

        y_ = y_ + dy;

    }

	return AS3_Ptr(pixels);

}





int main()
{

	AS3_Val allocMemMethod  = AS3_Function( NULL, allocMem );
	AS3_Val shootRaysMethod = AS3_Function( NULL, shootRays );
	AS3_Val result = AS3_Object(
		"allocMem: AS3ValType,shootRays: AS3ValType",
		 allocMemMethod, shootRaysMethod
	);
	AS3_Release( allocMemMethod );
	AS3_Release( shootRaysMethod );
	AS3_LibInit( result );

	return 0;
}
