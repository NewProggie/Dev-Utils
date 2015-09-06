#!/usr/bin/env python
# Copyright (c) 2015, Kai Wolf.
# For the licensing terms see LICENSE file in the root directory. For the
# list of contributors see the AUTHORS file in the same directory

"""
Create files with copyright boilerplate and header include guards.
Usage: tools/boilerplate.py path/to/file.{h,cpp}
"""

from datetime import date
import os
import os.path
import sys

LINES = [
    'Copyright (c) %d, Kai Wolf.' % date.today().year,
    'For the licensing terms see LICENSE file in the root directory. For the',
    'list of contributors see the AUTHORS file in the same directory.'
]

EXTENSIONS_TO_COMMENTS = {
    'h': '//',
    'hpp': '//',
    'cpp': '//',
    'py': '#'
}

def getHeader(filename):
  _, ext = os.path.splitext(filename)
  ext = ext[1:]
  comment = EXTENSIONS_TO_COMMENTS[ext] + ' '
  return '\n'.join([comment + line for line in LINES])


def cppHeader(filename):
  guard = filename.replace('/', '_').replace('.', '_').upper() + '_'
  return '\n'.join([
    '',
    '#ifndef ' + guard,
    '#define ' + guard,
    '',
    '// C system files',
    '// none',
    '',
    '// C++ system files',
    '// none',
    '',
    '// header files of other libraries',
    '// none',
    '',
    '// header files of project libraries',
    '// none',
    '',
    '#endif',
    ''
  ])


def cppImplementation(filename):
  base, _ = os.path.splitext(filename)
  include = '#include "' + base + '.h"'
  return '\n'.join([
    '', include,
    '',
    '// C system files',
    '// none',
    '',
    '// C++ system files',
    '// none',
    '',
    '// header files of other libraries',
    '// none',
    '',
    '// header files of project libraries',
    '// none',
    '',
    ])


def createFile(filename):
  contents = getHeader(filename) + '\n'

  if filename.endswith('.h'):
    contents += cppHeader(filename)
  elif filename.endswith('.cpp'):
    contents += cppImplementation(filename)

  fd = open(filename, 'w')
  fd.write(contents)
  fd.close()


def main():
  files = sys.argv[1:]
  if len(files) < 1:
    print >> sys.stderr, 'Usage: boilerplate.py path/file.h path/file.cpp'
    return 1

  # Perform checks first so that the entire operation is atomic.
  for f in files:
    _, ext = os.path.splitext(f)
    if not ext[1:] in EXTENSIONS_TO_COMMENTS:
      print >> sys.stderr, 'Unknown file type for %s' % f
      return 2

    if os.path.exists(f):
      print >> sys.stderr, 'A file at path %s already exists' % f
      return 2

  for f in files:
    createFile(f)


if __name__ == '__main__':
  sys.exit(main())
