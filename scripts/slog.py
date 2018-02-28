#!/usr/bin/env python

import os
from subprocess import getoutput
from sys import argv

newline = '\r\n' if os.name == 'nt' else '\n'

W = '\033[0m'  # white (normal)
R = '\033[31m'  # red
B = '\033[36m'  # blue


def main(args):
    num_entries = str(args[0]) if args else '10'
    logdata = getoutput(['svn', 'log', '-l', num_entries])
    for entry in logdata.split('-' * 72):
        parts = entry.split(newline * 2)[0].split('\n\n')
        if len(parts) < 2: continue
        info, message = parts
        rev, user, date, _ = list(map(str.strip, info.split('|')))
        print("*%s changeset:   %s%s" % (R, rev, W))
        print("%s|%s user:        %s" % (B, W, user))
        print("%s|%s date:        %s" % (B, W, date))
        print("%s|%s summary:     %s" % (B, W, message.strip()))
        print("%s|%s" % (B, W))


if __name__ == "__main__":
    main(argv[1:])
