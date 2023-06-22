#!/bin/bash
sudo apt update
curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
python3 get-pip.py --user
export PATH=$PATH:/home/sujata/.local/bin
python3 -m pip install --user ansible
python3 -m pip show ansible