/*
  Seed imaging system case with experimental collector

  Starting point:
    A simple rectangular base plate for the vacuum/rocking seed imaging system.
*/

$fn = 48;

// Choose what OpenSCAD shows/exports.
part_to_show = "assembly"; // "assembly", "plate", "front", "back", "left_side", "right_side", "sides", "collector", "lower_frame", "bottom"

// Base plate dimensions.
plate_w = 210;      // mm
plate_h = 180;      // mm
plate_thick = 2;    // mm
corner_r = 2;       // mm, just enough to remove sharp corners
wall_slot_clearance = 0.3; // mm extra slot size for sliding wall parts into plate

// Cutout matching the outer tray footprint of the moving funnel adapter.
funnel_cutout_w = 124;       // mm, long side plus clearance for rotation
funnel_cutout_h = 87;        // mm, short side plus clearance for rotation
funnel_front_gap = 20;       // mm from front long edge of plate to cutout
funnel_cutout_r = 2;         // mm, slight radius to avoid sharp internal corners
funnel_cutout_y = -plate_h/2 + funnel_front_gap + funnel_cutout_h/2;

// Front wall for the vacuum adapter interface, hanging down from the top plate.
front_wall_offset_from_cutout = 12; // mm from front edge of cutout toward plate front
front_wall_extra_w = 10;            // mm extension beyond each cutout side
front_wall_w = funnel_cutout_w + 2 * front_wall_extra_w;
front_wall_h = 101.25;              // mm, bottom is 72 mm below front circle center
front_wall_thick = 2;               // mm
front_wall_y = funnel_cutout_y - funnel_cutout_h/2 - front_wall_offset_from_cutout - front_wall_thick;
back_wall_offset_from_cutout = 10;  // mm from back edge of cutout toward plate back
back_wall_y = funnel_cutout_y + funnel_cutout_h/2 + back_wall_offset_from_cutout;
side_wall_thick = front_wall_thick;
side_wall_y = front_wall_y;
side_wall_depth = back_wall_y + front_wall_thick - front_wall_y;

// Circular opening in the front wall for the static funnel-system spout.
static_spout_outer_d = 31.5;       // mm, current static male spout OD
front_wall_spout_clearance = 1;    // mm extra diameter clearance
front_wall_spout_cutout_d = static_spout_outer_d + front_wall_spout_clearance;
front_wall_spout_top_drop = 15;    // mm below top surface of plate
front_wall_spout_center_z = plate_thick - front_wall_spout_top_drop - front_wall_spout_cutout_d/2;
front_wall_tab_margin = 10;      // mm material around circular spout tab
front_wall_tab_x = -front_wall_spout_cutout_d/2 - front_wall_tab_margin;
front_wall_tab_w = front_wall_spout_cutout_d + 2 * front_wall_tab_margin;
front_back_wall_bottom_clearance = 10; // mm below circular cutout bottom
front_back_wall_bottom_z = front_wall_spout_center_z - front_wall_spout_cutout_d/2 - front_back_wall_bottom_clearance;
front_back_wall_h = -front_back_wall_bottom_z;

// Rectangular opening in the back wall, aligned with the spout opening height.
back_wall_rect_cutout_w = 40;   // mm, long horizontal edge
back_wall_rect_cutout_h = 20;   // mm, vertical edge
back_wall_rect_cutout_x_shift = -11; // mm, left shift from spout center
back_wall_notch_size = 7;       // mm square notch centered on right edge
back_wall_notch_overlap = 0.5;  // mm overlap to avoid a zero-width seam
back_wall_tab_margin = 10;      // mm material around motor cutout tab
back_wall_cutout_min_x = back_wall_rect_cutout_x_shift - back_wall_rect_cutout_w/2;
back_wall_cutout_max_x = back_wall_rect_cutout_x_shift + back_wall_rect_cutout_w/2 + back_wall_notch_size;
back_wall_tab_x = back_wall_cutout_min_x - back_wall_tab_margin;
back_wall_tab_w = back_wall_cutout_max_x - back_wall_cutout_min_x + 2 * back_wall_tab_margin;
back_wall_servo_pad_thick = 4;    // mm extra thickness behind servo mount area
back_wall_servo_pad_margin = 6;   // mm material around the motor rectangle cutout
// Experimental lower collector dimensions.
total_system_h = 190;              // mm, target total height from top of plate to floor
floor_z = plate_thick - total_system_h;
upper_wall_bottom_z = -front_wall_h;
collector_drop_h = upper_wall_bottom_z - floor_z;
collector_wall = 2;                // mm wall thickness for chute/outlet
collector_outlet_od = 30;          // mm outer diameter for seed packet interface
collector_outlet_id = collector_outlet_od - 2 * collector_wall;
collector_outlet_len = 24;         // mm, angled tube length; shorter leaves room for the funnel slope
collector_neck_overlap = 8;        // mm overlap into throat so the angled neck and funnel connect solidly
collector_outlet_angle = 135;      // degrees; cylinder axis points 45 degrees down toward the front
collector_floor_clearance = 35;    // mm from floor to lowest outside edge of outlet mouth
collector_outlet_end_z = floor_z + collector_floor_clearance + collector_outlet_od/2;
collector_outlet_start_z = collector_outlet_end_z - collector_outlet_len * cos(collector_outlet_angle);
collector_outlet_start_y = front_wall_y + 28;
collector_outlet_end_y = collector_outlet_start_y - collector_outlet_len * sin(collector_outlet_angle);
collector_top_margin = 3;          // mm inset from inside wall span
collector_post = 8;                // mm square lower frame corner posts
collector_base_rail_h = 8;         // mm height of bottom rails
collector_base_rail_thick = 6;     // mm thickness of bottom rails
collector_lip_h = 4;               // mm thick top lip tying collector mouth into lower posts
collector_lip_overlap_up = 1;      // mm overlap into upper walls for preview/alignment before adding slots
bottom_wall_notch_depth = 6;       // mm deep receiver notch for side walls in the bottom piece
side_wall_h = front_wall_h + bottom_wall_notch_depth; // mm side walls extend into bottom notches
side_wall_top_tab_inset = 4;      // mm shorter at each end to make a shoulder stop under the top plate
front_back_wall_top_tab_inset = 4; // mm shorter at each end for front/back top plate shoulder stops
tray_boundary_wall_thick = 6;     // mm, wider than 2 mm front/back walls for future notches
tray_boundary_wall_h = 6;         // mm small raised boundary at front/back tray edges
tray_boundary_wall_x_margin = 4;  // mm extra length beyond matching front/back wall pieces
tray_boundary_wall_side_inset = side_wall_thick/2 + collector_post/2; // mm keeps rails clear of side walls
front_back_diag_frame_w = 8;      // mm width of trapezoid-frame brace bands
front_back_diag_wall_overlap = 1; // mm overlap so brace merges cleanly into front/back wall
front_back_diag_inner_base_inset = 22; // mm larger values make the inner triangle less obtuse
front_back_diag_end_inset = 14;   // mm keeps brace feet shy of side-wall/funnel corners
front_back_diag_tab_w = 12;       // mm width of rectangular feet that seat in tray-wall notches
front_back_diag_tab_h = tray_boundary_wall_h; // mm foot height matching the tray wall height
front_back_diag_notch_clearance = wall_slot_clearance; // mm extra room around brace feet

// Makes a 2D rounded rectangle profile.
module rounded_rect_2d(w, h, r) {
  offset(r = r)
    square([w - 2*r, h - 2*r], center = true);
}

// Makes the main rectangular base plate with lightly rounded corners.
module base_plate() {
  linear_extrude(height = plate_thick)
    rounded_rect_2d(plate_w, plate_h, corner_r);
}

// Cuts the moving funnel adapter tray footprint through the plate. The long
// side of the cutout runs parallel to the long side of the plate.
module funnel_tray_cutout() {
  translate([0, funnel_cutout_y, -0.5])
    linear_extrude(height = plate_thick + 1)
      rounded_rect_2d(funnel_cutout_w, funnel_cutout_h, funnel_cutout_r);
}

// Cuts the round spout opening through the front wall.
module front_wall_spout_cutout() {
  translate([0, front_wall_y + front_wall_thick/2, front_wall_spout_center_z])
    rotate([90, 0, 0])
      cylinder(h = front_wall_thick + 1, d = front_wall_spout_cutout_d, center = true);
}


// Makes a trapezoid-shaped wall extension with a triangular center opening.
// The two lower rectangular feet seat into matching notches in the tray wall.
module front_back_trapezoid_brace_at(wall_x, wall_w, y, y_thick) {
  top_left = wall_x;
  top_right = wall_x + wall_w;
  foot_left_center = -front_wall_w/2 + front_back_diag_end_inset;
  foot_right_center = front_wall_w/2 - front_back_diag_end_inset;
  foot_left_outer = foot_left_center - front_back_diag_tab_w/2;
  foot_left_inner = foot_left_center + front_back_diag_tab_w/2;
  foot_right_inner = foot_right_center - front_back_diag_tab_w/2;
  foot_right_outer = foot_right_center + front_back_diag_tab_w/2;
  z_top = front_back_wall_bottom_z + front_back_diag_wall_overlap;
  z_bottom = upper_wall_bottom_z;
  z_foot_top = upper_wall_bottom_z + front_back_diag_tab_h;

  translate([0, y + y_thick, 0])
    rotate([90, 0, 0])
      linear_extrude(height = y_thick)
        polygon(points = [
          [top_left, z_top],
          [top_right, z_top],
          [foot_right_outer, z_foot_top],
          [foot_right_outer, z_bottom],
          [foot_left_outer, z_bottom],
          [foot_left_outer, z_foot_top]
        ]);
}
// Makes the front vertical wall below the plate.
module front_wall() {
  front_wall_top_tab_x = front_wall_tab_x + front_back_wall_top_tab_inset;
  front_wall_top_tab_w = front_wall_tab_w - 2 * front_back_wall_top_tab_inset;

  difference() {
    union() {
      translate([front_wall_tab_x, front_wall_y, front_back_wall_bottom_z])
        cube([front_wall_tab_w, front_wall_thick, front_back_wall_h], center = false);
      translate([front_wall_top_tab_x, front_wall_y, 0])
        cube([front_wall_top_tab_w, front_wall_thick, plate_thick], center = false);
      front_back_trapezoid_brace_at(front_wall_tab_x, front_wall_tab_w, front_wall_y, front_wall_thick);
    }
    front_wall_spout_cutout();
  }
}

// Cuts the rectangular opening through the back wall.
module back_wall_rect_cutout() {
  union() {
    translate([back_wall_rect_cutout_x_shift - back_wall_rect_cutout_w/2,
               back_wall_y - 0.5,
               front_wall_spout_center_z - back_wall_rect_cutout_h/2])
      cube([back_wall_rect_cutout_w, front_wall_thick + back_wall_servo_pad_thick + 1, back_wall_rect_cutout_h], center = false);

    translate([back_wall_rect_cutout_x_shift + back_wall_rect_cutout_w/2 - back_wall_notch_overlap,
               back_wall_y - 0.5,
               front_wall_spout_center_z - back_wall_notch_size/2])
      cube([back_wall_notch_size + back_wall_notch_overlap, front_wall_thick + back_wall_servo_pad_thick + 1, back_wall_notch_size], center = false);
  }
}


// Adds localized thickness behind the motor cutout for servo mounting screws.
module back_wall_servo_mount_pad() {
  pad_x = back_wall_tab_x;
  pad_w = back_wall_tab_w;
  pad_z = front_wall_spout_center_z - back_wall_rect_cutout_h/2 - back_wall_servo_pad_margin;
  pad_h = back_wall_rect_cutout_h + 2 * back_wall_servo_pad_margin;

  translate([pad_x, back_wall_y + front_wall_thick, pad_z])
    cube([pad_w, back_wall_servo_pad_thick, pad_h], center = false);
}
// Makes the back vertical wall below the plate, mirrored from the front wall.
module back_wall() {
  back_wall_top_tab_x = back_wall_tab_x + front_back_wall_top_tab_inset;
  back_wall_top_tab_w = back_wall_tab_w - 2 * front_back_wall_top_tab_inset;

  difference() {
    union() {
      translate([back_wall_tab_x, back_wall_y, front_back_wall_bottom_z])
        cube([back_wall_tab_w, front_wall_thick, front_back_wall_h], center = false);
      translate([back_wall_top_tab_x, back_wall_y, 0])
        cube([back_wall_top_tab_w, front_wall_thick, plate_thick], center = false);
      front_back_trapezoid_brace_at(back_wall_tab_x, back_wall_tab_w, back_wall_y, front_wall_thick);
      back_wall_servo_mount_pad();
    }
    back_wall_rect_cutout();
  }
}

// Makes side walls that connect the front and back walls while preserving
// the 144 mm interior span between their inside faces.
module side_wall(side) {
  x = side < 0 ? -front_wall_w/2 - side_wall_thick : front_wall_w/2;
  tab_y = side_wall_y + side_wall_top_tab_inset;
  tab_depth = side_wall_depth - 2 * side_wall_top_tab_inset;

  union() {
    translate([x, side_wall_y, -side_wall_h])
      cube([side_wall_thick, side_wall_depth, side_wall_h], center = false);

    translate([x, tab_y, 0])
      cube([side_wall_thick, tab_depth, plate_thick], center = false);
  }
}

module side_walls() {
  side_wall(-1);
  side_wall(1);
}
// Makes a very thin rectangular face used as the open mouth of the collector chute.
module collector_top_patch(w, d, z) {
  translate([-w/2, side_wall_y + collector_top_margin, z])
    cube([w, d, 0.4], center = false);
}

// Makes a very thin circular face used as the lower throat of the collector chute.
module collector_circle_patch(d, y, z) {
  translate([0, y, z])
    cylinder(h = 0.4, d = d, center = true);
}


// Adds a broad lip at the top of the collector so the funnel clearly rests on the lower posts
// and closes the gap to the original side wall pieces.
module collector_top_lip_outer() {
  lip_x = -front_wall_w/2 - side_wall_thick/2 - collector_post/2;
  lip_y = side_wall_y;
  lip_w = front_wall_w + side_wall_thick + collector_post;
  lip_d = side_wall_depth;

  translate([lip_x, lip_y, upper_wall_bottom_z - collector_lip_h])
    cube([lip_w, lip_d, collector_lip_h + collector_lip_overlap_up], center = false);
}

// Keeps the collector lip open so seeds can drop into the funnel.
module collector_top_lip_void() {
  opening_w = front_wall_w - 2 * collector_wall;
  opening_d = side_wall_depth - 2 * collector_wall;

  translate([-opening_w/2,
             side_wall_y + collector_wall,
             upper_wall_bottom_z - collector_lip_h - 0.5])
    cube([opening_w, opening_d, collector_lip_h + 3], center = false);
}
// Outer solid rectangular-to-round collector funnel.
module collector_chute_outer() {
  top_w_outer = front_wall_w - 2 * collector_top_margin;
  top_d_outer = side_wall_depth - 2 * collector_top_margin;

  hull() {
    collector_top_patch(top_w_outer, top_d_outer, upper_wall_bottom_z - 0.4);
    collector_circle_patch(collector_outlet_od + 2 * collector_wall, collector_outlet_start_y, collector_outlet_start_z);
  }
}

// Continuous inner void for the rectangular-to-round collector funnel.
module collector_chute_void() {
  top_w_outer = front_wall_w - 2 * collector_top_margin;
  top_d_outer = side_wall_depth - 2 * collector_top_margin;
  top_w_inner = top_w_outer - 2 * collector_wall;
  top_d_inner = top_d_outer - 2 * collector_wall;

  hull() {
    collector_top_patch(top_w_inner, top_d_inner, upper_wall_bottom_z + 1.5);
    collector_circle_patch(collector_outlet_id, collector_outlet_start_y, collector_outlet_start_z);
  }
}


// Adds material only behind the circular throat to close the rear-side gap.
// The shared inner void is subtracted later, so this reinforces the wall without blocking flow.
module collector_rear_throat_seal_outer() {
  seal_d = collector_outlet_od + 2 * collector_wall;
  seal_h = 8;

  intersection() {
    translate([0, collector_outlet_start_y, collector_outlet_start_z - seal_h/2])
      cylinder(h = seal_h, d = seal_d, center = false);

    translate([-seal_d/2,
               collector_outlet_start_y,
               collector_outlet_start_z - seal_h/2])
      cube([seal_d, seal_d/2 + collector_wall, seal_h], center = false);
  }
}
// Outer solid for the tilted outlet neck that the seed packet can wrap around.
module collector_outlet_neck_outer() {
  translate([0,
             collector_outlet_start_y + collector_neck_overlap * sin(collector_outlet_angle),
             collector_outlet_start_z - collector_neck_overlap * cos(collector_outlet_angle)])
    rotate([collector_outlet_angle, 0, 0])
      cylinder(h = collector_outlet_len + collector_neck_overlap, d = collector_outlet_od, center = false);
}

// Continuous inner void through the tilted outlet neck.
module collector_outlet_neck_void() {
  translate([0,
             collector_outlet_start_y + collector_neck_overlap * sin(collector_outlet_angle),
             collector_outlet_start_z - collector_neck_overlap * cos(collector_outlet_angle)])
    rotate([collector_outlet_angle, 0, 0])
      translate([0, 0, -0.5])
        cylinder(h = collector_outlet_len + collector_neck_overlap + 1, d = collector_outlet_id, center = false);
}


// Adds small front/back boundary walls on the collector tray lip.
// These are wider than the front/back wall thickness so future receiver notches
// can leave material on both sides of the descending wall extensions.
module collector_tray_boundary_walls_outer() {
  edge_x = -front_wall_w/2 - side_wall_thick/2 - collector_post/2 + tray_boundary_wall_side_inset;
  edge_w = front_wall_w + side_wall_thick + collector_post - 2 * tray_boundary_wall_side_inset;
  z0 = upper_wall_bottom_z;

  translate([edge_x,
             front_wall_y + front_wall_thick/2 - tray_boundary_wall_thick/2,
             z0])
    cube([edge_w, tray_boundary_wall_thick, tray_boundary_wall_h], center = false);

  translate([edge_x,
             back_wall_y + front_wall_thick/2 - tray_boundary_wall_thick/2,
             z0])
    cube([edge_w, tray_boundary_wall_thick, tray_boundary_wall_h], center = false);
}
// Makes the internal seed collector as one continuous hollow funnel and angled neck.
module collector_funnel() {
  difference() {
    union() {
      collector_top_lip_outer();
      collector_tray_boundary_walls_outer();
      collector_chute_outer();
      collector_rear_throat_seal_outer();
      collector_outlet_neck_outer();
    }

    union() {
      collector_chute_void();
      collector_outlet_neck_void();
    }
  }
}

// Adds a light lower frame so the final assembly reaches 190 mm without
// relying on the funnel shell as the only support.
module lower_frame() {
  x_left = -front_wall_w/2 - side_wall_thick/2 - collector_post/2;
  x_right = front_wall_w/2 + side_wall_thick/2 - collector_post/2;
  y_front = side_wall_y;
  y_back = side_wall_y + side_wall_depth - collector_post;

  union() {
    for (x = [x_left, x_right])
      for (y = [y_front, y_back])
        translate([x, y, floor_z])
          cube([collector_post, collector_post, collector_drop_h], center = false);

    translate([x_left, y_back, floor_z])
      cube([x_right + collector_post - x_left, collector_base_rail_thick, collector_base_rail_h], center = false);

    for (x = [x_left, x_right])
      translate([x, y_front, floor_z])
        cube([collector_post, side_wall_depth, collector_base_rail_h], center = false);
  }
}



// Cuts receiver notches into the top of the bottom module for the two side walls.
module bottom_side_wall_notches() {
  c = wall_slot_clearance;
  z0 = upper_wall_bottom_z - bottom_wall_notch_depth;
  h = bottom_wall_notch_depth + collector_lip_overlap_up + 1;

  translate([-front_wall_w/2 - side_wall_thick - c/2,
             side_wall_y - c/2,
             z0])
    cube([side_wall_thick + c, side_wall_depth + c, h], center = false);

  translate([front_wall_w/2 - c/2,
             side_wall_y - c/2,
             z0])
    cube([side_wall_thick + c, side_wall_depth + c, h], center = false);
}

// Cuts one long receiver groove in each tray rail for the front/back brace base.
module front_back_brace_foot_notches() {
  c = front_back_diag_notch_clearance;
  groove_w = front_wall_w - 2 * front_back_diag_end_inset + front_back_diag_tab_w + c;
  groove_y = front_wall_thick + c;
  groove_h = front_back_diag_tab_h + c;
  wall_ys = [front_wall_y, back_wall_y];

  for (y = wall_ys)
    translate([-groove_w/2,
               y - c/2,
               upper_wall_bottom_z - c/2])
      cube([groove_w, groove_y, groove_h], center = false);
}
// Makes the new lower modular piece: collector funnel plus its support frame.
// The original side walls remain separate modules so we can add slide-fit features next.
module bottom_piece() {
  difference() {
    union() {
      collector_funnel();
      lower_frame();
    }
    bottom_side_wall_notches();
    front_back_brace_foot_notches();
  }
}
// Cuts slots through the top plate matching the top footprint of each wall/tab.
module wall_slot_cutouts() {
  c = wall_slot_clearance;

  translate([front_wall_tab_x + front_back_wall_top_tab_inset - c/2, front_wall_y - c/2, -0.5])
    cube([front_wall_tab_w - 2 * front_back_wall_top_tab_inset + c, front_wall_thick + c, plate_thick + 1], center = false);

  translate([back_wall_tab_x + front_back_wall_top_tab_inset - c/2, back_wall_y - c/2, -0.5])
    cube([back_wall_tab_w - 2 * front_back_wall_top_tab_inset + c, front_wall_thick + c, plate_thick + 1], center = false);

  translate([-front_wall_w/2 - side_wall_thick - c/2,
             side_wall_y + side_wall_top_tab_inset - c/2,
             -0.5])
    cube([side_wall_thick + c,
          side_wall_depth - 2 * side_wall_top_tab_inset + c,
          plate_thick + 1], center = false);

  translate([front_wall_w/2 - c/2,
             side_wall_y + side_wall_top_tab_inset - c/2,
             -0.5])
    cube([side_wall_thick + c,
          side_wall_depth - 2 * side_wall_top_tab_inset + c,
          plate_thick + 1], center = false);
}
module case_plate() {
  difference() {
    base_plate();
    funnel_tray_cutout();
    wall_slot_cutouts();
  }
}

module case_assembly() {
  union() {
    case_plate();
    front_wall();
    back_wall();
    side_walls();
    bottom_piece();
  }
}

if (part_to_show == "plate") {
  case_plate();
} else if (part_to_show == "front") {
  front_wall();
} else if (part_to_show == "back") {
  back_wall();
} else if (part_to_show == "left_side") {
  side_wall(-1);
} else if (part_to_show == "right_side") {
  side_wall(1);
} else if (part_to_show == "sides") {
  side_walls();
} else if (part_to_show == "collector") {
  collector_funnel();
} else if (part_to_show == "lower_frame") {
  lower_frame();
} else if (part_to_show == "bottom") {
  bottom_piece();
} else {
  case_assembly();
}













































