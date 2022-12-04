from typing import Optional, List
import osutil

# Standard maven flags
# --batch-mode : do not run in interactive mode
# -V : display version
# -U : force updates of snapshots
# --Dsurefire.useFile=false : display test errors in logs
MAVEN_STD_ARGS = ['mvn', '--batch-mode', '-V', '-U', '-Dsurefirce.useFile=false']


def maven_command(command: str, args: List[str] = None, working_directory: Optional[str] = None):
    cmd = MAVEN_STD_ARGS + [command]
    if args is not None:
        cmd += args

    osutil.execute(cmd, working_directory=working_directory)
