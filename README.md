# ERA5 Exposure Aggregation Pipeline

This repository contains a pipeline for aggregating ERA5 environmental exposures data to a 0.1 degree grid. The pipeline is designed to be run on FASRC. We developed
this pipeline using `nbdev`, which means that we can create modules and scripts from notebooks.
Hence, all of the documentation for how the pipeline was developed and validated is
available in `notes/index.ipynb` and the associated notebooks.

## How to Review a PR

To review a PR on this repository, follow these steps:

0. Obtain an API key for the ERA5 datastore from [here](https://cds.climate.copernicus.eu/how-to-api)

1. Clone this repository to your workspace on FASRC

2. Install the package with `pip`

3. Run the `core` module to test your API key and setup the data
directory structure

`python src/era5_sandbox/core.py`

4. Symlink your local data directory to the original work
`ln -s [YOUR WORKING DIRECTORY]/data /n/dominici_lab/lab/data_processing/csph-era5_sandbox/data`

5. Dry run by removing a file from data `snakemake --dry-run`

6. Run the pipeline `sbatch snakemake.sbatch`