#!/bin/bash

# Copyright 2023 David Chin
#
# This file is part of alphafold_singularity.
#
# alphafold_singularity is free software: you can redistribute it and/or
# modify it under the terms of the GNU General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# alphafold_singularity is distributed in the hope that it will be
# useful, but WITHOUT ANY WARRANTY; without even the implied warranty
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
# General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with alphafold_singularity. If not, see <https://www.gnu.org/licenses/>.

#SBATCH --job-name=alphafold
#SBATCH --output=job_%j_%x.out
#SBATCH --partition=gpu
#SBATCH --time=2:00:00
#SBATCH --gres=gpu:1
#SBATCH --cpus-per-gpu=12
#SBATCH --mem-per-gpu=36G
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=abc@bio.aau.dk

pip3 install -r requirements.txt

ALPHAFOLD_DATABASE_DIR="/databases/alphafold"
output_dir=output

if [ -d "$output_dir" ]
then
    echo "The directory ${output_dir} already exists, refusing to overwrite. Please backup or delete the folder and restart."
    exit 1
else
    mkdir -p "$output_dir"
fi

# Run AlphaFold; default is to use GPUs
python3 /shared_software/biocloud-software/alphafold_singularity/run_singularity.py \
    --use_gpu \
    --output_dir=$output_dir \
    --data_dir=${ALPHAFOLD_DATABASE_DIR} \
    --fasta_paths=T1050.fasta \
    --max_template_date=2020-05-14 \
    --model_preset=monomer \
    --db_preset=reduced_dbs