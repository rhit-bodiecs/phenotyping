/*
  Shark WV201 rectangular vacuum adapter

  Purpose:
    Slip-on adapter that converts the handheld Shark Wandvac-style nozzle
    into a gasket-friendly rectangular mouth for a vacuum tray/plenum.

  Tray mouth:
    2.5 in x 4.5 in nominal outside footprint.

  How to tune:
    Measure the outside width/height of the Shark nozzle where this part
    should slip on. Set shark_socket_outer_w and shark_socket_outer_h to those
    dimensions plus about 0.4-0.8 mm clearance for FDM printing.
*/

$fn = 64;

inch = 25.4;

// --- User-tunable dimensions ---
tray_outer_w = 120;           // mm, leaves material around 110 mm opening
tray_outer_h = 85;            // mm, leaves material around 75 mm opening
tray_lip_depth = 8;           // gasket/contact depth at rectangular end

// Rectangular opening exposed to the vacuum tray.
tray_open_w = 110;
tray_open_h = 75;

// Measure your Shark nozzle OD and tune these.
shark_nozzle_top_w = 51.4;      // mm, straight top edge
shark_nozzle_side_drop = 10.5;  // mm, straight side segment height
shark_nozzle_side_angle = 80; // degrees from top edge; 90 = vertical sides
shark_nozzle_top_curve_rise = 1.2; // mm, slight upward crown on top edge
shark_nozzle_curve_drop = 6.7;  // mm, sets outside top-center to bottom-center height near 20 mm
shark_nozzle_wall = 1.8;        // mm wall thickness around Shark nozzle
shark_nozzle_corner_r = 1.5;  // mm, rounds sharp corners on nozzle profile
shark_socket_depth = 70;

// Minimum size of the air passage through the Shark-side bend. These are kept
// for fallback rectangular clearances; the main throat now uses the larger
// custom nozzle profile to avoid choking the transition.
shark_air_w = 42;
shark_air_h = 15;

wall = shark_nozzle_wall;
transition_len = 18;
corner_r = 5;
socket_corner_r = 4;
gasket_groove_depth = 1.2;
gasket_groove_width = 3.2;
transition_cutout_margin = 1.5; // keeps widened throat from breaking through corners

// --- Derived ---
body_len = tray_lip_depth + transition_len + shark_socket_depth;
funnel_top_z = tray_lip_depth + transition_len;
shark_nozzle_side_inset = shark_nozzle_side_drop / tan(shark_nozzle_side_angle);
shark_nozzle_bottom_w = shark_nozzle_top_w - 2 * shark_nozzle_side_inset;
shark_nozzle_h = shark_nozzle_side_drop + shark_nozzle_curve_drop;
socket_outer_w = shark_nozzle_top_w + 2*wall;
socket_outer_h = shark_nozzle_h + 2*wall;
socket_center_z = funnel_top_z + socket_outer_h / 2;

// Makes a 2D rounded rectangle profile used by the extruded boxes below.
module rounded_rect_2d(w, h, r) {
  offset(r = r)
    square([w - 2*r, h - 2*r], center = true);
}

// Turns a rounded rectangle profile into a 3D rounded rectangular prism.
module rounded_box(w, h, d, r) {
  linear_extrude(height = d)
    rounded_rect_2d(w, h, r);
}

// Makes the base 2D Shark nozzle profile. The top is straight, the sides lean
// slightly inward, and the bottom is a tunable smooth curve.
module shark_nozzle_base_profile_2d() {
  top_w = shark_nozzle_top_w;
  bottom_w = shark_nozzle_bottom_w;
  h = shark_nozzle_h;
  curve_drop = shark_nozzle_curve_drop;
  curve_y = curve_drop;
  top_y = h;
  y_shift = h / 2;
  steps = 18;

  lower_right = [bottom_w/2, curve_y - y_shift];
  lower_left = [-bottom_w/2, curve_y - y_shift];

  top_points = [
    for (i = [0:steps])
      let(
        t = i / steps,
        x = -top_w/2 + t * top_w,
        y = top_y - shark_nozzle_top_curve_rise * (1 - pow(x / (top_w/2), 2)) - y_shift
      )
      [x, y]
  ];

  curve_points = [
    for (i = [0:steps])
      let(
        t = i / steps,
        x = bottom_w/2 - t * bottom_w,
        y = curve_drop * pow(x / (bottom_w/2), 2) - y_shift
      )
      [x, y]
  ];

  offset(r = shark_nozzle_corner_r)
    offset(delta = -shark_nozzle_corner_r)
      polygon(concat(top_points, [lower_right], curve_points, [lower_left]));
}

// Makes the custom 2D Shark nozzle profile, optionally expanded outward by a
// true offset so top, bottom, and sides all get wall thickness.
module shark_nozzle_profile_2d(extra = 0) {
  if (extra == 0) {
    shark_nozzle_base_profile_2d();
  } else {
    offset(delta = extra)
      shark_nozzle_base_profile_2d();
  }
}

// Extrudes the custom Shark nozzle profile along the adapter/socket axis.
module shark_nozzle_profile_box(d, extra = 0) {
  linear_extrude(height = d)
    shark_nozzle_profile_2d(extra);
}

// Makes the outside tapered funnel from the large tray mouth down to the
// smaller Shark socket body.
module transition_outer() {
  hull() {
    translate([0, 0, tray_lip_depth])
      rounded_box(tray_outer_w, tray_outer_h, 0.2, corner_r);
    translate([0, 0, tray_lip_depth + transition_len])
      rounded_box(socket_outer_w, socket_outer_h, 0.2, socket_corner_r + wall);
  }
}

// Cuts the internal tapered air passage through the adapter, connecting the
// tray opening to the smaller Shark-side air opening.
module transition_air_cutout(extra = 0) {
  hull() {
    translate([0, 0, -0.5])
      rounded_box(tray_open_w + extra, tray_open_h + extra, tray_lip_depth + 1, corner_r - 1);
    translate([0, 0, tray_lip_depth + transition_len + 0.5])
      shark_nozzle_profile_box(0.2, extra - transition_cutout_margin);
  }
}

// Cuts a shallow rectangular groove into the tray-contact face so foam tape or
// a soft gasket can sit slightly recessed and seal against the vacuum tray.
module gasket_groove_cutout() {
  difference() {
    translate([0, 0, -0.2])
      rounded_box(tray_outer_w - 8, tray_outer_h - 8, gasket_groove_depth + 0.4, corner_r);
    translate([0, 0, -0.4])
      rounded_box(tray_outer_w - 8 - 2*gasket_groove_width,
                  tray_outer_h - 8 - 2*gasket_groove_width,
                  gasket_groove_depth + 0.8,
                  max(1, corner_r - gasket_groove_width));
  }
}

// Makes the outside 90-degree elbow that bends the narrow end of the funnel
// into the sideways Shark socket.
module shark_socket_elbow_outer() {
  hull() {
    translate([0, 0, funnel_top_z])
      shark_nozzle_profile_box(0.2, wall);
    translate([0, socket_outer_h * 0.45, socket_center_z])
      rotate([-90, 0, 0])
        shark_nozzle_profile_box(0.2, wall);
  }
}

// Cuts the internal 90-degree elbow passage connecting the vertical funnel to
// the sideways Shark socket air passage.
module shark_socket_elbow_cutout() {
  hull() {
    translate([0, 0, funnel_top_z - 0.5])
      shark_nozzle_profile_box(1.2, -transition_cutout_margin);
    translate([0, socket_outer_h * 0.45, socket_center_z])
      rotate([-90, 0, 0])
        shark_nozzle_profile_box(0.2, 0);
  }
}

// Makes the outside sleeve/body that slips over the Shark vacuum nozzle. This
// sleeve now exits sideways, parallel to the short edges of the tray mouth.
module shark_socket_outer() {
  translate([0, socket_outer_h * 0.45, socket_center_z])
    rotate([-90, 0, 0])
      shark_nozzle_profile_box(shark_socket_depth, wall);
}

// Cuts the hollow socket pocket where the Shark nozzle inserts.
module shark_socket_cutout() {
  translate([0, socket_outer_h * 0.45 - 0.5, socket_center_z])
    rotate([-90, 0, 0])
      shark_nozzle_profile_box(shark_socket_depth + 1, 0);
}

// Cuts two side holes for optional set screws to clamp the adapter onto the
// Shark nozzle after the slip fit is tuned.
module set_screw_holes() {
  screw_y = socket_outer_h * 0.45 + shark_socket_depth * 0.55;
  for (x = [-1, 1]) {
    translate([x * (shark_nozzle_top_w/2 + wall + 0.2), screw_y, socket_center_z])
      rotate([0, 90, 0])
        cylinder(h = wall + 2, d = 3.2, center = true);
  }
}

// Combines all solid features, then subtracts the air passage, socket pocket,
// gasket groove, and set-screw holes to make the final printable adapter.
module adapter() {
  difference() {
    union() {
      translate([0, 0, 0])
        rounded_box(tray_outer_w, tray_outer_h, tray_lip_depth, corner_r);
      transition_outer();
      shark_socket_elbow_outer();
      shark_socket_outer();
    }

    transition_air_cutout(0);
    shark_socket_elbow_cutout();
    shark_socket_cutout();
  }
}

adapter();


