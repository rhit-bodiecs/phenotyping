# Sorghum Seed Phenotyping Automation

This repository contains prototype code and hardware design files for improving a sorghum seed phenotyping imaging pipeline.

The motivation for the project is to reduce the manual bottleneck in preparing seed samples for imaging. The current workflow requires opening a labeled packet, pouring approximately 100 seeds onto an imaging tray, manually spreading them so seeds do not touch, taking an image for downstream segmentation, and returning the seeds to the packet. Because the segmentation step expects separated seeds and is not being modified here, the hardware goal is to make seed spacing and collection faster and more repeatable.


## Demo Video

A short demo of the current prototype is available here:

[Seed phenotyping automation prototype demo](https://youtu.be/DYeSpMTDBck)

## Project Concept

The current prototype explores a vacuum-assisted positioning system:

- A perforated imaging surface biases seeds toward individual hole locations.
- A Shark WV201 handheld vacuum provides suction through a custom adapter.
- A rocking or tilting mechanism can move loose seeds around until they settle into available holes.
- After positioning, uncaptured seeds can be dumped into a collection chute while captured seeds remain held by vacuum.
- The system is being designed as modular 3D-printable parts so pieces can be tested and revised independently.

## Repository Layout

```text
.
├── 3d_models/
│   ├── seed_case_print_v1/
│   └── shark_wv201_adapter/
├── ImageProcessing/
├── nucleo-servo/
├── Time_Data.xlsx
└── README.md
```

## 3D Models

The `3d_models/` folder contains OpenSCAD source files and exported STL files from the current hardware prototype work.

### `3d_models/seed_case_print_v1/`

Separated printable parts for the modular seed imaging case and collection frame:

- `top_plate.scad` / `top_plate.stl`
- `front_wall.scad` / `front_wall.stl`
- `back_wall.scad` / `back_wall.stl`
- `left_side_wall.scad` / `left_side_wall.stl`
- `right_side_wall.scad` / `right_side_wall.stl`
- `bottom_collector_frame.scad` / `bottom_collector_frame.stl`

These parts are intended to slide together using tab-and-slot features. The bottom collector frame includes the seed collection funnel/chute and receiver grooves for the wall pieces.

### `3d_models/shark_wv201_adapter/`

Adapter prototypes for connecting the seed tray/funnel system to a Shark WV201 handheld vacuum:

- rectangular adapter prototype
- nozzle fit-test model
- rotating adapter starting model
- separated static and moving rotating-adapter pieces

These files preserve the iterative vacuum-interface work used to test nozzle fit, suction transfer, and the rotating joint concept.

## Firmware / Electronics

The `nucleo-servo/` folder is intended for embedded control work, including servo-based motion experiments. The planned control flow is:

1. Press a button to start the sequence.
2. Turn on vacuum.
3. Rock or tilt the plate to encourage seeds to settle into holes.
4. Rotate/tilt to dump uncaptured seeds into the collector.
5. Return to flat for imaging.

Future work may add camera triggering and automatic image transfer, but the current hardware/control focus is on seed positioning and mechanical automation.

## Image Processing

The `ImageProcessing/` folder contains image-processing work related to extracting phenotype data from seed images. The mechanical prototype is designed around the constraint that the segmentation step works best when seeds are separated and not touching.

## Ignored Local Artifacts

The repository ignores:

- `Figures/`
- `Phenotyping_Automation_Project.pptx`

These files are useful locally for documentation and presentation work but are excluded from version control.


## Bill of Materials

Prototype electronics and hardware links:

| Item | Link |
| --- | --- |
| BOM item 1 | [Amazon ASIN B01I8XLEM8](https://www.amazon.com/dp/B01I8XLEM8) |
| BOM item 2 | [Amazon ASIN B07HNTKSZT](https://www.amazon.com/dp/B07HNTKSZT) |
| BOM item 3 | [Amazon ASIN B08BCBZ632](https://www.amazon.com/dp/B08BCBZ632) |
| BOM item 4 | [Amazon ASIN B01ERP6WL4](https://www.amazon.com/dp/B01ERP6WL4) |


## Next Steps

- Reprint the top plate with a slightly wider/longer tray cutout so the rotating tray has enough clearance. The current printed plate is slightly too small length-wise for smooth tray rotation.
- Revise the funnel/rotating adapter model to include a printed tab at the end of the dowel/axle for connecting to the servo motor tab. The current prototype uses superglue, a loose plastic tab, and a rubber band linkage; integrating this tab directly into the printed model should make the servo linkage more reliable and repeatable.

## Current Prototype Status

The current print-ready mechanical checkpoint is `3d_models/seed_case_print_v1/`. The parts are separated for modular printing and iterative fit testing. The design is still experimental, especially the tab/slot tolerances, collector geometry, and future servo mounting/alignment.

## Tools

Primary tools used so far:

- OpenSCAD for parametric CAD
- STL exports for 3D printing
- Shark WV201 vacuum for suction testing
- STM32/Nucleo-style development target for planned servo control experiments



