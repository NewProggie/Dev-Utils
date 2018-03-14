#!/usr/bin/env python

import os
from subprocess import getoutput
from sys import argv, stdout, platform

newline = '\r\n' if os.name == 'nt' else '\n'

W = '\033[0m'  # white (normal)
R = '\033[31m'  # red
B = '\033[36m'  # blue


def term_supports_color():
    supported_platform = platform != 'Pocket PC' and (platform != 'win32' or
                                                      'ANSICON' in os.environ)
    is_a_tty = hasattr(stdout, 'isatty') and stdout.isatty()
    return supported_platform and is_a_tty


def print_svn_info_colored(rev, user, date, message):
    print("*%s changeset:   %s%s" % (R, rev, W))
    print("%s|%s user:        %s" % (B, W, user))
    print("%s|%s date:        %s" % (B, W, date))
    print("%s|%s summary:     %s" % (B, W, message.strip()))
    print("%s|%s" % (B, W))


def print_svn_info(rev, user, date, message):
    print("* changeset:   %s" % rev)
    print("| user:        %s" % user)
    print("| date:        %s" % date)
    print("| summary:     %s" % message.strip())
    print("|")


def main(args):
    num_entries = str(args[0]) if args else '10'
    logdata = getoutput(['svn', 'log', '-l', num_entries])
    for entry in logdata.split('-' * 72):
        parts = entry.split(newline * 2)[0].split('\n\n')
        if len(parts) < 2: continue
        info, message = parts
        rev, user, date, _ = list(map(str.strip, info.split('|')))
        if term_supports_color():
            print_svn_info_colored(rev, user, date, message.strip())
        else:
            print_svn_info(rev, user, date, message.strip())


if __name__ == "__main__":
    main(argv[1:])
