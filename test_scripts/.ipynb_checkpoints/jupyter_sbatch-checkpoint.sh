#!/bin/bash

## User
#SBATCH --account=carney-frankmj-condo
#SBATCH --mail-user=an_vo@brown.edu
#SBATCH --mail-type=ALL

## Machine
#SBATCH --nodes 1
#SBATCH -c 6
#SBATCH --time 04:00:00
#SBATCH --mem-per-cpu 3G
#SBATCH --job-name tunnel
#SBATCH --output /users/avo2/jupyterlogs/jupyter-log-%J.txt

## GPU Config
#SBATCH -p gpu --gres=gpu:1

## get tunneling info
XDG_RUNTIME_DIR=""
ipnport=$(shuf -i8000-9999 -n1)
ipnip=$(hostname -i)

## print tunneling instructions to jupyter-log-{jobid}.txt
echo -e "
    Copy/Paste this in your local terminal to ssh tunnel with remote
    -----------------------------------------------------------------
    ssh -N -L $ipnport:$ipnip:$ipnport $USER@ssh.ccv.brown.edu
    -----------------------------------------------------------------
    Then open a browser on your local machine to the following address
    ------------------------------------------------------------------
    localhost:$ipnport  (prefix w/ https:// if using password)
    ------------------------------------------------------------------
    "
## start an ipcluster instance and launch jupyter server
source /users/avo2/.bashrc
#module load anaconda/3-5.2.0
module load cuda/10.0.130 cudnn/7.4
conda deactivate
conda activate tf_test
jupyter lab --no-browser --port=$ipnport --ip=$ipnip

