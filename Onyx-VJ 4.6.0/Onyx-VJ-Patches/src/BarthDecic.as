/*http://paulbourke.net/geometry/barthdecic/

#declare a = 1;              // Change as a sqrt(value)
#declare p = (sqrt(5)+1)/2;  // Golden section phi
#declare p4 = 3*p+2;         // p4 = pow(phi,4);
#declare r = 2;              // r = 1.9 for perfect cutoff // (Doctor John)

isosurface {
	function {
		8 * (x*x - p4*y*y) * (y*y - p4*z*z) * (z*z - p4*x*x) *                              
			(x*x*x*x + y*y*y*y + z*z*z*z - 2*x*x*y*y - 2*x*x*z*z - 2*y*y*z*z) +                                 
			a * (3 + 5*p) * pow((x*x + y*y + z*z - a),2) *               
			pow((x*x + y*y + z*z - (2-p)*a),2)
	}
	contained_by {
		sphere { <0,0,0>, r }
	}
	threshold 0
	max_gradient 25060 // (Doctor John)
	open
	texture { T_Silver_5C }
}*/