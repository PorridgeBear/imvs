# iMolecular Visualisation System - iMVS

iMVS is a simple molecular visualisation system (app) for viewing proteins in 3D. 

The project is a primarily hobbiest approach to learning Apple Swift rather than a serious molecular viewing tool.

It is a reimplementation of my 1999 dissertation software Java3D Molecular Visualisation System (JMVS), also intended to learn and demonstrate Java3D rather than be a serious molecular tool.

It is built for iOS using Apple's Swift language. It uses SceneKit

It has been updated for swift 4.2 by BinarySoftware

# Use of iMVS sources

iMVS is released under [the MIT Licence](http://opensource.org/licenses/MIT).

My hopes in open sourcing this code are

* To contribute to the growing body of Swift source in the wild to help others learn.
* To find those who would like to contribute to the roadmap for iMVS, ideally improving it, thereby enabling me to learn from others.

# Roadmap

The immediate plans for iMVS are as follows:

* __General__. Much needs to be done polishing the UI, providing tickers when molecule bonds are being computed, providing a better display/colour mode switching UI.
* __Display modes__. Currently working on Cartoons mode starting with ribbons for alpha helices and beta sheets. 
* __Colour modes__. CPK and amino modes are already done. Need to add temperature.
* __Networking__. Rather than provide a limited list of PDB molecule files in the app, reach out to the PDB web services.
* __Performance__. Specifically in the realm of bonding, I have used my own "point cloud" implementation that is a lot faster than linear atom to atom testing but this could be improved still further, possibly using Octree/KD-tree type implementation
* __Persistence__. Come up with ways to save PDB files from the web services. Perhaps also persist/cache computed bond data to speed subsequent loads of a molecule.

# Thanks

* [RasMol](http://rasmol.org/) sources were often used in the implementation of JMVS and have been useful again for elements of iMVS.
* [WikiPedia](http://wikipedia.org/) for molecular/chemistry knowledge.
* My other half continues to support me with some trickier mathematical problems
