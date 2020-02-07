# GEMINI-scripts

[![DOI](https://zenodo.org/badge/154507405.svg)](https://zenodo.org/badge/latestdoi/154507405)

Auxiliary scripts for the [GEMINI ionospheric model](https://github.com/mattzett/gemini-scripts).

## Install

These scripts should be at the same directory "level" as `gemini`, like:

```
/home/username/
   gemini/
   gemini-scripts/
```

Simply `git clone https://github.com/mattzett/gemini-scripts`

### Requirements

either of:

* Matlab &ge; R2007b
* [GNU Octave](https://www.gnu.org/software/octave/) &ge; 4.0

## Usage

The scripts are meant to "just work" without fiddling for a particular computer.
For plot generation, we prioritize recent versions of Matlab, particularly for generating publication quality plots.

### Top-level scripts

These functions are intended to be run by the end-user or automatically for various purposes.

under `vis/`:

* `magcalc`
* `magcalc_single`
* `magcompare`
* `virtual_spacecraft`

## Notes

### GNU Octave

GNU Octave is compatible with most Matlab scripts and generally makes OK plots, particularly with the [Qt graphics toolkit](https://octave.org/doc/v5.1.0/Graphics-Toolkits.html).

If you're having issues, please open a GitHub Issue.
The goal going forward is to use Python instead.
