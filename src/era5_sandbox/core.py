"""This is a core library for the ERA5 dataset pipeline. It defines"""

# AUTOGENERATED! DO NOT EDIT! File to edit: ../../notes/00_core.ipynb.

# %% auto 0
__all__ = ['describe', 'testAPI', 'main']

# %% ../../notes/00_core.ipynb 3
import os
import cdsapi
import hydra

from omegaconf import DictConfig, OmegaConf
from pyprojroot import here

# %% ../../notes/00_core.ipynb 5
def describe(
    cfg: DictConfig=None,  # Configuration file
    )-> None:
    "Describe the configuration file used by Hydra for the pipeline"
    
    if cfg is None:
        print("No configuration file provided. Generating default configuration file.")
        cfg = OmegaConf.create()
        
    print("This package fetches ERA5 data. The following is the config file used by Hydra for the pipeline:\n")
    print(OmegaConf.to_yaml(cfg))

# %% ../../notes/00_core.ipynb 6
def _expand_path(
        path: str   # Path on user's machine
        )->   str:  # Expanded path
    "Expand the path on the user's machine for cross compatibility"

    # Expand ~ to the user's home directory
    path = os.path.expanduser(path)
    # Expand environment variables
    path = os.path.expandvars(path)
    # Convert to absolute path
    path = os.path.abspath(path)
    return path

# %% ../../notes/00_core.ipynb 7
def _create_directory_structure(
        base_path: str,  # The base directory where the structure will be created
        structure: dict  # A dictionary representing the directory structure
    )->None:
    """
    Recursively creates a directory structure from a dictionary.

    Args:
        base_path (str): The base directory where the structure will be created.
        structure (dict): A dictionary representing the directory structure.
    """
    for folder, substructure in structure.items():
        # Create the current directory
        current_path = os.path.join(base_path, folder)
        os.makedirs(current_path, exist_ok=True)
        
        # Recursively create subdirectories if substructure is a dictionary
        if isinstance(substructure, dict):
            _create_directory_structure(current_path, substructure)

# %% ../../notes/00_core.ipynb 9
def testAPI(
    cfg: DictConfig=None,
    dataset:str="reanalysis-era5-pressure-levels"
    )-> bool:    
    
    # parse config
    testing=cfg.development_mode
    output_path=here("data") / "testing"

    print(OmegaConf.to_yaml(cfg))

    try:
        client = cdsapi.Client()

        # build request
        request = {
            'product_type': ['reanalysis'],
            'variable': ['geopotential'],
            'year': ['2024'],
            'month': ['03'],
            'day': ['01'],
            'time': ['13:00'],
            'pressure_level': ['1000'],
            'data_format': 'grib',
        }

        target = output_path / 'test_download.grib'
        
        print("Testing API connection by downloading a dummy dataset to {}...".format(output_path))

        client.retrieve(dataset, request, target)

        if not testing:
            os.remove(target)
        
        print("API connection test successful.")
        return True

    except Exception as e:
        print("API connection test failed.")
        print("Did you set up your API key with CDS? If not, please visit https://cds.climate.copernicus.eu/how-to-api#install-the-cds-api-client")
        print("Error: {}".format(e))
        return False

# %% ../../notes/00_core.ipynb 13
@hydra.main(version_base=None, config_path="../../conf", config_name="config")
def main(cfg: DictConfig) -> None:

    # Create the directory structure
    _create_directory_structure(here() / "data", cfg.datapaths)

    # test the api
    testAPI(cfg=cfg)

# %% ../../notes/00_core.ipynb 14
#| eval: false
try: from nbdev.imports import IN_NOTEBOOK
except: IN_NOTEBOOK=False

if __name__ == "__main__" and not IN_NOTEBOOK:
    main()
