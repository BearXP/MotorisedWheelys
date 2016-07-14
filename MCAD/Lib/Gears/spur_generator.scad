// Copyright 2011 Cliff L. Biffle.
// This file is licensed Creative Commons Attribution-ShareAlike 3.0.
// http://creativecommons.org/licenses/by-sa/3.0/

// You can get this file from http://www.thingiverse.com/thing:3575
use <parametric_involute_gear_v5.0.scad>

// Couple handy arithmetic shortcuts
function sqr(n) = pow(n, 2);
function cube(n) = pow(n, 3);

// This was derived as follows:
// In Greg Frost's original script, the outer radius of a spur
// gear can be computed as...
function gear_outer_radius(number_of_teeth, circular_pitch) =
	(sqr(number_of_teeth) * sqr(circular_pitch) + 64800)
		/ (360 * number_of_teeth * circular_pitch);

// We can fit gears to the spacing by working it backwards.
//  spacing = gear_outer_radius(teeth1, cp)
//          + gear_outer_radius(teeth2, cp);
//
// I plugged this into an algebra system, assuming that spacing,
// teeth1, and teeth2 are given.  By solving for circular pitch,
// we get this terrifying equation:
function fit_spur_gears(n1, n2, spacing) =
	(180 * spacing * n1 * n2  +  180
		* sqrt(-(2*n1*cube(n2)-(sqr(spacing)-4)*sqr(n1)*sqr(n2)+2*cube(n1)*n2)))
	/ (n1*sqr(n2) + sqr(n1)*n2);

// Here's an example.
module example_gears() {
	n1 = 25; n2 = 5;
	p = fit_spur_gears(n1, n2, 30);
	// Simple Test:
	gear (circular_pitch=p,
		gear_thickness = 10,
		rim_thickness = 12,
		hub_thickness = 8,
	    number_of_teeth = n1,
		circles=8);
	
	translate([gear_outer_radius(n1, p) + gear_outer_radius(n2, p),0,0])
	gear (circular_pitch=p,
		gear_thickness = 10,
		rim_thickness = 12,
		hub_thickness = 8,
		circles=8,
		number_of_teeth = n2,
		rim_width = 2);
    
    translate([gear_outer_radius(n1, p) + gear_outer_radius(n2, p),0,12])
	gear (circular_pitch=p,
		gear_thickness = 12,
		rim_thickness = 12,
		hub_thickness = 12,
	    number_of_teeth = n1,
		circles=8);
}

module MainGear() {
	p = fit_spur_gears(n1, n2, spacing);
	// Simple Test:
	gear (circular_pitch=p,
		gear_thickness = 8,     // Inside body depth
		rim_thickness = 10,     // Outside teeth depth
        hub_diameter = 5,       // Inside Hub Diameter
        bore_diameter = 5.5,    // Hole Diameter
	    number_of_teeth = n1,
		circles=8);
}

module MiddleGear() {
	p = fit_spur_gears(n1, n2, spacing);
    
	gear (circular_pitch=p,
		gear_thickness = 10,
		rim_thickness = 10,
        bore_diameter = 3,
        hub_diameter = 9,
	    number_of_teeth = n1,
		circles=8,
        rim_width = 1);
    
    translate([0,0,10])
	gear (circular_pitch=p,
		gear_thickness = 10,
		rim_thickness = 10,
		hub_thickness = 5,
        bore_diameter = 3,
		circles=0,
		number_of_teeth = n2,
		rim_width = 2);
}

n2 = 10; spacing = 15;
n1 = 5*n2;

MiddleGear();
//MainGear();