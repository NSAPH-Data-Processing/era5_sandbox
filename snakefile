import hydra
import json
from pyprojroot import here
from omegaconf import OmegaConf

conda: "environment.yaml"

# Define paths relative to the project root
data_dir = here("data")

# the workflow configuration file is orchestrated by hydra
# read config with hydra
with hydra.initialize(config_path="conf", version_base=None):
    cfg = hydra.compose(config_name="config", overrides=[])
    print(OmegaConf.to_yaml(cfg))

# read list of variables to parellelize over
years_cfg = OmegaConf.to_container(cfg.query.year, resolve=True)
months_cfg = OmegaConf.to_container(cfg.query.month, resolve=True)
variable_cfg = OmegaConf.to_container(cfg.query.variable, resolve=True)
geographies_cfg = OmegaConf.to_container(cfg.query.geography, resolve=True)

rule all:
    input:
        expand(data_dir / "intermediate/{geography}_environmental_exposure-era5_healthshed_{variable}_{year}_{month}.parquet", 
               geography=geographies_cfg, variable=variable_cfg, year=years_cfg, month=months_cfg)

rule test_api:
    output:
        data_dir / "testing/test_download.grib"
    shell:
        "python src/era5_sandbox/core.py"

rule download_raw_era5:
    output:
        temp(data_dir / "input/{geography}_{year}_{month}.nc")
    shell:
        """
        python src/era5_sandbox/download.py "++query.year={wildcards.year}" "++query.month={wildcards.month}" "++query.geography={wildcards.geography}"
        """

rule spatial_aggregate_raw_era5:
    message:
        "[AGGREGATE] Processing variable '{wildcards.variable}' "
        "for geography '{wildcards.geography}' in {wildcards.year}-{wildcards.month}"
    input:
        data_dir / "input/{geography}_{year}_{month}.nc"
    output:
        data_dir / "intermediate/{geography}_environmental_exposure-era5_healthshed_{variable}_{year}_{month}.parquet"
    params:
        variable="{variable}",
        geography="{geography}"
    script:
        "src/era5_sandbox/aggregate.py"

rule summarize_na_dashboard:
    input:
        rmd = "notes/prototypes/aggregation_visualizer.Rmd",
        downloads = expand(data_dir / "input/{geography}_{year}_{month}.nc", 
                           geography=geographies_cfg, 
                           year=years_cfg, 
                           month=months_cfg)
    output:
        summary = data_dir / "testing/raw_na_summary.csv"
    shell:
        """
        Rscript -e "rmarkdown::render(
            input = '{input.rmd}', 
            params = list(output_path = '{output.summary}'), 
            output_file = tempfile(), 
            quiet = TRUE
        )"
        """