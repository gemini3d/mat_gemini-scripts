# GEMINI-scripts

[![DOI](https://zenodo.org/badge/154507405.svg)](https://zenodo.org/badge/latestdoi/154507405)

This repository contains auxiliary scripts for the [GEMINI ionospheric model](https://github.com/gemini3d/gemini-scripts).  It is distinct from the [mat_gemini repository](https://github.com/gemini3d/mat_gemini) which contains polished, tested, and functioning script for handling output data from GEMINI.  Instead this repository is a sandbox for experimental/developing capabilities for input preparation for GEMINI and for processing output data.

## Install

These scripts should be at the same directory "level" as `gemini`, like:

```
/home/username/
   gemini3d/
   mat_gemini-scripts/
```

Simply `git clone https://github.com/gemini3d/mat_gemini-scripts`

### Requirements

Matlab &ge; R2019b  (Matlab &ge; R2020a recommended for better plots)

## Usage

The intention is eventually for these scripts to "just work" without fiddling for a particular computer.
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
