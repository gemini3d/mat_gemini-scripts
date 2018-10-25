# GEMINI-scripts
Auxiliary scripts for the GEMINI ionospheric model.


## Requirements

either of:

* Matlab &ge; R2007b
* GNU Octave &ge; 4.0

## Usage

The scripts are meant to "just work" without fiddling for a particular computer.
In terms of plot formatting, we prioritize recent versions of Matlab, particularly for generating publication quality plots.

### GNU Octave 

GNU Octave is compatible with most Matlab scripts, except those using proprietary Mathworks toolboxes.
Octave generally makes OK plots, particularly with the Qt graphics toolkit.
You can check which Octave graphics toolkit is active by:
```matlab
graphics_toolkit
```
```
ans = qt
```
Qt is the newest and best supported Octave graphics toolkit.
GNUplot is the oldest Octave graphics system and may not be able to make all plots properly.

