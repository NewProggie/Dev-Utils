#!/usr/bin/env python
# Copyright (c) 2015, Kai Wolf.
# For the licensing terms see LICENSE file in the root directory. For the
# list of contributors see the AUTHORS file in the same directory

"""
This script sorts the includes of the source and header files of the given
directory.
Usage: python sort_includes.py source_file_directory
Example:
    ./sort_includes.py src/ledmanager/
"""

import os.path
import re
import sys

def main(path):
    for subdir, dirs, files in os.walk(path):
        for afile in files:
            filepath = subdir + os.sep + afile

            # aggregate include headers for one file
            if filepath.endswith("cpp") or filepath.endswith("hpp"):
                if not os.path.isfile(filepath):
                    print 'File does not exist.'
                else:
                    with open(filepath) as f:
                        content = f.read().splitlines()
                pattern = '\#include.*\Z'
                includelines = []
                includes_sorted = False

                # do the actual sorting of the include headers
                for index in range(len(content)):
                    if re.match(pattern, content[index]):
                        # sort include headers for each block separately
                        condition = re.match(pattern, content[index])
                        while condition:
                            includelines.append(content[index])
                            content.pop(index)
                            condition = re.match(pattern, content[index])
                        # check if includes have changed
                        old_includes = includelines[:]
                        includelines.sort(key=str.lower)
                        includes_sorted |= (old_includes != includelines)
                        includelines.reverse()
                        for line in includelines:
                            content.insert(index, line)
                        includelines[:] = []
                if includes_sorted:
                    print filepath, "sorted"
                f.close()

                myfile = open(filepath, 'w')

                for line in content:
                    myfile.write(line + "\n")

                myfile.close()

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print "Usage: python sort_includes.py source_file_directory"
        sys.exit()
    path = sys.argv[1]
    main(path)
