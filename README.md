# GEMINI-scripts
Auxiliary scripts for the [GEMINI ionospheric model](https://github.com/mattzett/gemini-scripts).


## Install

These scripts should be at the same directory "level" as `gemini`.
E.g.:

```
/home/username/
   gemini/
   gemini-scripts/
```
direc='./';
Simply `git clone https://github.com/mattzett/gemini-scripts`

### Requirements

either of:

* Matlab &ge; R2007b
* [GNU Octave](https://www.gnu.org/software/octave/) &ge; 4.0


## Usage

The scripts are meant to "just work" without fiddling for a particular computer.
In terms of plot formatting, we prioritize recent versions of Matlab, particularly for generating publication quality plots.

### Top-level scripts

These functions are intended to be run by the end-user or automatically for various purposes.


under `vis/`:

* `magcalc`
* `magcalc_single`
* `magcompare`
* `virtual_spacecraft`

## Notes

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

