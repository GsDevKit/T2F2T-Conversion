# T2F2T-Conversion

[![Build Status](https://travis-ci.org/GsDevKit/T2F2T-Conversion.svg?branch=master)](https://travis-ci.org/GsDevKit/T2F2T-Conversion)

Rowan-based scripts for converting package repositories from Tonel to Filetree and Filetree to Tonel format.

See [man page][1] for additional details.

### Installation
In order to use the **T2F2T-Conversion** scripts, you need to download an extent with rowan installed and a copy of the [GemStone 3.5.0](https://gemtalksystems.com/products/gs64/versions35x/#350) product tree. The `bin/install.sh` script does the install:
```bash
bin/install.sh
```

### Conversion
Run the following scripts from the T2F2T-Conversion project directory:
1. Create the t2f2t meta data file in the target project directory (`t2f2t`):
   ```bash
   bin/t2f2t.sh --create <path-to-target-project-dir> t2f2t src filetree
   ```
2. Prepare the `tonel` package directory for reading by Rowan. `#convention : 'Monticello'` informs Rowan that the packages in this directory will be expected to conform to the Monticello conventions where class category begins with the name of package and the method categories for extension methods begins with `*case-insensitive-package-name`:
   ```bash
   cat - > <path-to-target-project-dir>/<package-directory-path>/.properties << EOF
   {
   	#format : #tonel,
   	#convention : 'Monticello'
   }
   EOF
   ```
3. Copy the packages in the `tonel` package directory to the `filetree` package directory, converting to filetree format:
   ```bash
   bin/t2f2t.sh filetree <path-to-target-project-dir>/t2f2t
   ```
4.  Copy the packages in the `filetree` package directory to the `tonel` package directory, converting to tonel format:
   ```bash
   bin/t2f2t.sh tonel <path-to-target-project-dir>/t2f2t
   ```
   **NOTE**, Pharo uses a different `tonel` package format than Rowan, so converting from `filetree` format to `tonel` format will result in a number of spurious changes, at the moment. The long term plan is that Rowan will support `pharo_tonel` format and `rowan_tonel` format repositories and when that comes to pass, it will be pratical to convert from `filetree` to `tonel`. 


[1]: docs/man.txt
