#!/usr/bin/env python3

import sys

#OPTIONAL_PYTHONPATH

from easybuild.tools.options import set_up_configuration
from easybuild.framework.easyconfig.tweak import ec_filename_for

def main():
    if len( sys.argv ) != 2:
        print( f"Usage: {sys.argv[0]} <easyconfig.eb>", file=sys.stderr )
        sys.exit( 1 )

    path = sys.argv[1]

    opts, _ = set_up_configuration( silent=True )

    try:
        expected_name = ec_filename_for( path )
        print( expected_name )
    except Exception as err:
        print( f"Error processing {path}: {err}", file=sys.stderr )
        sys.exit( 2 )

if __name__ == "__main__":
    main()
