## Parameterized Rugged Case for OpenSCAD

This project is a fully parametric rugged-style case designed in OpenSCAD.
You can generate a complete assembly for preview, or export individual printable parts such as:

- base
- top
- latches
- handle
- seal
- hinge screw
- latch screw

The model is driven by variables in the OpenSCAD Customizer, so you can tune dimensions, wall thickness, latch geometry, hinge fit, and seal behavior for your own use case and printer tolerances.

## Preview

### Full Assembly

![Assembly view](images/assembly_view.png)

### Individual Parts

![Base part](images/base.png)
![Top part](images/top.png)
![Handle part](images/handle.png)
![Seal part](images/seal.png)

## Quick Start

1. Open `case.scad` in OpenSCAD.
2. Open the Customizer panel.
3. Set dimensions and feature values to suit your build.
4. Choose what to generate with the `run` selector:
	- `assembly` for a full preview
	- `base`, `top`, `latches`, `handle`, `seal`, `hinge_screw`, or `latch_screw` for exportable parts
5. Render (`F6`) and export to STL or 3MF.

## Notes

- The model is intended to be edited parametrically, not by direct mesh editing.
- Fit-critical values (clearances, hole diameters, seal undersizing) may need tuning for different printers and materials.

## Support

If you like the design, you are welcome to buy me a coffee:

<a href="https://buymeacoffee.com/amead77"><img src="images/bmc-button.png" alt="Buy Me a Coffee" width="50%" /></a>

## Licence

CC – Attribution – Non-Commercial (CC BY-NC): Users can remix and build upon your model, but only for non-commercial purposes. Credit must be provided.