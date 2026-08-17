/*
  Shark WV201 nozzle fit-test ring

  This is a low-material test part using the same nozzle-opening profile as
  the current full adapter. Print this first to check whether the shaped
  opening slips onto the actual Shark vacuum attachment point.
*/

$fn = 64;

// --- Shark nozzle profile copied from current adapter ---
shark_nozzle_top_w = 51.4;          // mm
shark_nozzle_side_drop = 10.5;      // mm
shark_nozzle_side_angle = 80;     // degrees from top edge; 90 = vertical sides
shark_nozzle_top_curve_rise = 1.2;// mm, slight downward bow at top center
shark_nozzle_curve_drop = 6.7;    // mm
shark_nozzle_wall = 1.8;            // mm wall thickness
shark_nozzle_corner_r = 1.5;      // mm, rounds sharp corners on nozzle profile

// --- Fit-test dimensions ---
test_depth = 10.2;                  // mm, short sleeve for quick printing
lead_in_depth = 2;                // mm, chamfered mouth to help it start
lead_in_clearance = 0.7;          // mm, extra clearance at the entry face

// --- Derived ---
shark_nozzle_side_inset = shark_nozzle_side_drop / tan(shark_nozzle_side_angle);
shark_nozzle_bottom_w = shark_nozzle_top_w - 2 * shark_nozzle_side_inset;
shark_nozzle_h = shark_nozzle_side_drop + shark_nozzle_curve_drop;

// Makes the base 2D Shark nozzle profile. The top bows slightly downward, the
// sides lean slightly inward, and the bottom is a tunable smooth curve.
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

// Offsets the base profile so the outer ring gets uniform wall thickness.
module shark_nozzle_profile_2d(extra = 0) {
  if (extra == 0) {
    shark_nozzle_base_profile_2d();
  } else {
    offset(delta = extra)
      shark_nozzle_base_profile_2d();
  }
}

// Low-material sleeve: a short hollow profile with a slight lead-in.
module fit_test_ring() {
  difference() {
    linear_extrude(height = test_depth)
      shark_nozzle_profile_2d(shark_nozzle_wall);

    translate([0, 0, -0.5])
      linear_extrude(height = test_depth + 1)
        shark_nozzle_profile_2d(0);

    translate([0, 0, -0.5])
      linear_extrude(height = lead_in_depth + 0.5)
        shark_nozzle_profile_2d(lead_in_clearance);
  }
}

fit_test_ring();


