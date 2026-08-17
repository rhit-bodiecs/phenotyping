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

// Choose what OpenSCAD shows/exports.
part_to_show = "assembly"; // "assembly", "static", "body", "original"
assembly_gap = 85;

// --- User-tunable dimensions ---
tray_outer_w = 120;           // mm, leaves material around 110 mm opening
tray_outer_h = 85;            // mm, leaves material around 75 mm opening
tray_lip_depth = 8;           // gasket/contact depth at rectangular end

// Rectangular opening exposed to the vacuum tray.
tray_open_w = 112;
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
female_transition_side_cutout_inset = 4; // narrows transition cutout along the long dimension after the tray lip

// Static-piece round end tuning. The Shark-shaped sleeve remains for two
// thirds of the original socket depth, then transitions into a round duct.
static_shark_len = shark_socket_depth * 2 / 3;
static_round_transition_len = 18;
static_round_straight_len = 26;
static_round_inner_d = 27.9;
static_round_wall = wall;
static_round_outer_d = static_round_inner_d + 2 * static_round_wall;
static_notch_arc_angle = 5;     // degrees, centered at top: +/- 2.5 degrees
static_notch_center_angle = -90;
static_notch_ramp_len = 3;
static_notch_rise = 1;          // radial rise in mm over static_notch_ramp_len
static_notch_embed = 1.2;       // overlaps the round wall so the notch fuses cleanly
static_notch_w = 3;            // temporary direct-width notch while position is tuned
static_notch_count = 4;
static_relief_slot_count = 4;
static_relief_slot_angle_offset = 45;
static_relief_slot_len = static_round_straight_len / 2;
static_relief_slot_w = 1.2;
static_relief_slot_depth = static_round_wall + 2;

// Female/body-side round end tuning. This starts slightly larger than the
// static male round end and will eventually hold the snap/groove detail.
female_round_clearance = 0.8;
female_round_running_clearance = 1;
female_round_inner_d = static_round_outer_d + female_round_running_clearance;
female_round_wall = wall;
female_round_outer_d = female_round_inner_d + 2 * female_round_wall;
female_round_straight_len = 26;
female_groove_clearance = 0.5;
female_groove_outward_shift = 5;

// Servo axle/drive rod on the female body side. It is coaxial with the
// circular elbow and extends opposite the funnel mouth toward the short edge.
female_servo_axle_d = 4;
female_servo_axle_overlap = 2;
female_servo_axle_extra_len = 25;
// --- Derived ---
body_len = tray_lip_depth + transition_len + shark_socket_depth;
funnel_top_z = tray_lip_depth + transition_len;
shark_nozzle_side_inset = shark_nozzle_side_drop / tan(shark_nozzle_side_angle);
shark_nozzle_bottom_w = shark_nozzle_top_w - 2 * shark_nozzle_side_inset;
shark_nozzle_h = shark_nozzle_side_drop + shark_nozzle_curve_drop;
socket_outer_w = shark_nozzle_top_w + 2*wall;
socket_outer_h = shark_nozzle_h + 2*wall;
socket_center_z = funnel_top_z + socket_outer_h / 2;
socket_axis_y = socket_outer_h * 0.45;
static_round_y0 = socket_axis_y;
static_transition_y0 = static_round_y0 + static_round_straight_len;
static_shark_y0 = static_transition_y0 + static_round_transition_len;
static_total_depth = static_round_straight_len + static_round_transition_len + static_shark_len;
static_notch_y0 = static_round_y0 + 1.5;
static_notch_base_z = socket_center_z + static_round_outer_d / 2 - static_notch_embed;
static_relief_slot_y0 = static_round_y0 - 0.5;
static_relief_slot_base_z = socket_center_z + static_round_inner_d / 2 - 0.5;
female_circle_center_z = funnel_top_z;
female_elbow_y = socket_axis_y + female_round_outer_d / 2;
female_groove_y0 = female_elbow_y + static_notch_y0 - static_round_y0 + female_groove_outward_shift;
female_groove_start_d = female_round_inner_d + female_groove_clearance;
female_groove_peak_d = female_round_inner_d + 2 * static_notch_rise + female_groove_clearance;
female_servo_axle_start_y = -tray_outer_h / 2 - female_servo_axle_extra_len;
female_servo_axle_end_y = female_elbow_y + female_servo_axle_overlap;
female_servo_axle_len = female_servo_axle_end_y - female_servo_axle_start_y;
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

// Makes a circular tube along the same sideways axis as the Shark socket.
module y_circle_tube(len, od, id) {
  rotate([-90, 0, 0])
    difference() {
      cylinder(h = len, d = od);
      translate([0, 0, -0.5])
        cylinder(h = len + 1, d = id);
    }
}

// Makes a circular solid along the sideways socket axis for hulls and cutouts.
module y_circle_solid(len, d) {
  rotate([-90, 0, 0])
    cylinder(h = len, d = d);
}// Makes a circular solid along the vertical funnel axis for hulls and cutouts.
module z_circle_solid(len, d) {
  cylinder(h = len, d = d);
}

// Makes a circular tube along the vertical funnel axis.
module z_circle_tube(len, od, id) {
  difference() {
    cylinder(h = len, d = od);
    translate([0, 0, -0.5])
      cylinder(h = len + 1, d = id);
  }
}

// Makes a partial annular sector in the X/Z plane for localized snap features.
module annular_sector_2d(inner_r, outer_r, angle, center_angle, steps = 4) {
  start = center_angle - angle / 2;
  polygon(concat(
    [for (i = [0:steps])
      let(a = start + angle * i / steps)
        [outer_r * cos(a), outer_r * sin(a)]],
    [for (i = [steps:-1:0])
      let(a = start + angle * i / steps)
        [inner_r * cos(a), inner_r * sin(a)]]
  ));
}

// Extrudes a partial radial sector along the sideways socket axis.
module y_sector(len, inner_d, outer_d, angle, center_angle) {
  rotate([-90, 0, 0])
    linear_extrude(height = len)
      annular_sector_2d(inner_d / 2, outer_d / 2, angle, center_angle);
}

// Makes one top-mounted partial notch before rotation around the tube axis.
module static_partial_notch_raw() {
  hull() {
    translate([-static_notch_w / 2, static_notch_y0, static_notch_base_z])
      cube([static_notch_w, 0.2, static_notch_embed + 0.05]);
    translate([-static_notch_w / 2, static_notch_y0 + static_notch_ramp_len, static_notch_base_z])
      cube([static_notch_w, 0.2, static_notch_embed + static_notch_rise]);
  }
}

// Rotates one partial notch around the male round tube axis.
module static_partial_notch_at(angle) {
  translate([0, 0, socket_center_z])
    rotate([0, angle, 0])
      translate([0, 0, -socket_center_z])
        static_partial_notch_raw();
}

// Makes all male snap notches spaced evenly around the round tube.
module static_partial_notches() {
  for (i = [0:static_notch_count - 1])
    static_partial_notch_at(static_notch_center_angle + i * 360 / static_notch_count);
}

// Makes one lengthwise relief slot cutout before rotation around the tube axis.
module static_relief_slot_raw() {
  translate([-static_relief_slot_w / 2, static_relief_slot_y0, static_relief_slot_base_z])
    cube([static_relief_slot_w, static_relief_slot_len + 1, static_relief_slot_depth]);
}

// Rotates one relief slot around the male round tube axis.
module static_relief_slot_at(angle) {
  translate([0, 0, socket_center_z])
    rotate([0, angle, 0])
      translate([0, 0, -socket_center_z])
        static_relief_slot_raw();
}

// Cuts flexibility slots offset halfway between the snap notches.
module static_relief_slots_cutout() {
  for (i = [0:static_relief_slot_count - 1])
    static_relief_slot_at(static_notch_center_angle + static_relief_slot_angle_offset + i * 360 / static_relief_slot_count);
}

// Makes the new female-side outside taper from the tray mouth to a round end.
module female_transition_outer() {
  hull() {
    translate([0, 0, tray_lip_depth])
      rounded_box(tray_outer_w, tray_outer_h, 0.2, corner_r);
    translate([0, 0, funnel_top_z])
      z_circle_solid(0.2, female_round_outer_d);
  }
}

// Cuts the new female-side airway from the tray opening to the round end.

module female_transition_air_cutout() {
  union() {
    // Preserve the full rectangular tray opening through the contact lip.
    translate([0, 0, -0.5])
      rounded_box(tray_open_w, tray_open_h, tray_lip_depth + 1, corner_r - 1);

    // Past the lip, narrow the cutout along the long dimension so the actual
    // funnel walls at the short ends have more printable material.
    hull() {
      translate([0, 0, tray_lip_depth])
        rounded_box(tray_open_w - 2 * female_transition_side_cutout_inset,
                    tray_open_h,
                    0.2,
                    corner_r - 1);
      translate([0, 0, funnel_top_z + 0.5])
        z_circle_solid(0.2, female_round_inner_d);
    }
  }
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

// Makes the straight hollow circular female socket after the 90-degree elbow.
module female_circle_socket_outer() {
  translate([0, female_elbow_y, socket_center_z])
    y_circle_tube(female_round_straight_len, female_round_outer_d, female_round_inner_d);
}

// Cuts the inside of the straight female socket slightly past its end.
module female_circle_socket_cutout() {
  translate([0, female_elbow_y - 0.5, socket_center_z])
    y_circle_solid(female_round_straight_len + 1, female_round_inner_d);
}
// Cuts a full-circumference internal ramped groove matching the male notch slope.
module female_notch_groove_cutout() {
  hull() {
    translate([0, female_groove_y0, socket_center_z])
      y_circle_solid(0.2, female_groove_start_d);
    translate([0, female_groove_y0 + static_notch_ramp_len, socket_center_z])
      y_circle_solid(0.2, female_groove_peak_d);
  }
}
// Makes the outside circular 90-degree elbow for the female/body side.
module female_circle_elbow_outer() {
  hull() {
    translate([0, 0, female_circle_center_z])
      z_circle_solid(0.2, female_round_outer_d);
    translate([0, female_elbow_y, socket_center_z])
      y_circle_solid(0.2, female_round_outer_d);
  }
}

// Cuts the circular 90-degree elbow airway for the female/body side.
module female_circle_elbow_cutout() {
  hull() {
    translate([0, 0, female_circle_center_z - 0.5])
      z_circle_solid(1.2, female_round_inner_d);
    translate([0, female_elbow_y - 0.5, socket_center_z])
      y_circle_solid(0.2, female_round_inner_d);
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

// Makes the static Shark-side sleeve as a standalone part. The vacuum-facing
// end keeps the Shark nozzle profile, then transitions to a tunable round end.
module static_socket_piece() {
  difference() {
    union() {
      translate([0, static_round_y0, socket_center_z])
        y_circle_tube(static_round_straight_len, static_round_outer_d, static_round_inner_d);
      static_partial_notches();

      hull() {
        translate([0, static_transition_y0, socket_center_z])
          y_circle_solid(0.2, static_round_outer_d);
        translate([0, static_shark_y0, socket_center_z])
          rotate([-90, 0, 0])
            shark_nozzle_profile_box(0.2, wall);
      }

      translate([0, static_shark_y0, socket_center_z])
        rotate([-90, 0, 0])
          shark_nozzle_profile_box(static_shark_len, wall);
    }

    translate([0, static_round_y0 - 0.5, socket_center_z])
      y_circle_solid(static_round_straight_len + 1, static_round_inner_d);
    static_relief_slots_cutout();

    hull() {
      translate([0, static_transition_y0 - 0.5, socket_center_z])
        y_circle_solid(0.2, static_round_inner_d);
      translate([0, static_shark_y0 + 0.5, socket_center_z])
        rotate([-90, 0, 0])
          shark_nozzle_profile_box(0.2, 0);
    }

    translate([0, static_shark_y0 - 0.5, socket_center_z])
      rotate([-90, 0, 0])
        shark_nozzle_profile_box(static_shark_len + 1, 0);
  }
}

// Makes a thinner coaxial servo axle/drive rod on the back side of the elbow.
module female_servo_axle_rod() {
  translate([0, female_servo_axle_start_y, socket_center_z])
    y_circle_solid(female_servo_axle_len, female_servo_axle_d);
}
// Makes the female tray/funnel body after separating off the Shark socket
// sleeve. The body transitions from rectangle to circle, then turns 90 degrees.
module rotating_body_piece() {
  difference() {
    union() {
      translate([0, 0, 0])
        rounded_box(tray_outer_w, tray_outer_h, tray_lip_depth, corner_r);
      female_transition_outer();
      female_circle_elbow_outer();
      female_circle_socket_outer();
      female_servo_axle_rod();
    }

    female_transition_air_cutout();
    female_circle_elbow_cutout();
    female_circle_socket_cutout();
    female_notch_groove_cutout();
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

// Preview/export selector for the separated first-pass model.
if (part_to_show == "static") {
  static_socket_piece();
} else if (part_to_show == "body") {
  rotating_body_piece();
} else if (part_to_show == "original") {
  adapter();
} else {
  static_socket_piece();
  translate([0, -assembly_gap, 0])
    rotating_body_piece();
}































