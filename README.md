# GEMINI-scripts

[![DOI](https://zenodo.org/badge/154507405.svg)](https://zenodo.org/badge/latestdoi/154507405)

Auxiliary scripts for the [GEMINI ionospheric model](https://github.com/gemini3d/gemini-scripts).

## Install

These scripts should be at the same directory "level" as `gemini`, like:

```
/home/username/
   gemini/
   gemini-scripts/
```

Simply `git clone https://github.com/gemini3d/gemini-scripts`

### Requirements

Matlab &ge; R2017b  (Matlab &ge; R2020a recommended for best plots)

## Usage

The scripts are meant to "just work" without fiddling for a particular computer.
From Matlab, run the setup.m to configure all the needed paths for this Matlab session.

```matlab
setup
```

### Top-level scripts

These functions are intended to be run by the end-user or automatically for various purposes.

```matlab
import gemscr.vis
```

* `magcalc`
* `magcalc_single`
* `magcompare`
* `virtual_spacecraft`
