High level feature requirements:

- Midi Input
- Line-in Sound Analysis

Short term:

- holding control while changing a value should change all values for all layers
- Transitions
- ONX files support transitions?
- Prototype a preview Window?
- Layer update should be even slower for performance
- Layers should have flip horizontal / flip vertical

- Figure out a way to handle slow rendering of layers
> - should rendering be changed to event.render?

- Being able to control one layer as the child of another layer

Plugins:

- 3d Text
- BlendMode filter
- Threshold filter

Recent Fixes and Enhancements:

X Play Rate has mouse factor of 6
X Fixed filters to have their name established in the plugin definition rather than in the filter itself
X Should be able to pass in rendering concatenated matrix to IContent
X Overwriting layers copies settings while hold CTRL key
X Change controls to implement IControlObject so the compiler can make use of the traits for performance