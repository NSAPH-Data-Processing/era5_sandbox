import hydra
from omegaconf import OmegaConf
import json

conda: "environment.yaml"

# the workflow configuration file is orchestrated by hydra
# read config with hydra
with hydra.initialize(config_path="conf", version_base=None):
    cfg = hydra.compose(config_name="config", overrides=[])
    print(OmegaConf.to_yaml(cfg))

# confirm API is working

# read list of years
year_cfg = OmegaConf.to_container(cfg.query.year, resolve=True)
month_cfg = OmegaConf.to_container(cfg.query.month, resolve=True)
#day_cfg = OmegaConf.to_container(cfg.query.day, resolve=True)
#time_cfg = OmegaConf.to_container(cfg.query.time, resolve=True)

rule all:
    input:
        expand(f"python era5_sandbox/core.py --year {year} --month {month}", year=year_cfg, month=month_cfg)
