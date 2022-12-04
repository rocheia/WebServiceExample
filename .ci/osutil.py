from typing import Optional, List
import subprocess


def execute(cls, cmd: List[str], working_directory: Optional[str] = None):
    if working_directory is None:
        process = subprocess.call(cmd, shell=True, capture_output=True, check=True)
    else:
        process = subprocess.call(cmd, shell=True, capture_output=True, check=True, cwd=working_directory)
