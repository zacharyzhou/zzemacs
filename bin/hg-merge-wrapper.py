#!/usr/bin/env python

### parameter desc
##$base $local $other $output

import os
import sys
import platform

def hg_merge(a, b, c, d):
    merge_select = []
    sysstr = platform.system()
    if sysstr == "Windows":
        zztools_home = os.environ.get('ZZNIX_HOME') + "/home/zhoujd/zztools"
        merge_tool = [
            ["sh emacs-merge.sh", a, b, c, d],
            [zztools_home + "/perforce/p4merge", a, b, c, d], 
            [zztools_home + "/bcompare/bcompare", a, b, c, d],
        ]

        merge_select = merge_tool[2]
    elif sysstr == "Linux":
        zztools_home = os.environ.get('HOME') + "/zztools"
        merge_tool = [
            ["sh emacs-merge.sh", a, b, c, d],
            [zztools_home + "/p4v/bin/p4merge", a, b, c, d], 
            [zztools_home + "/bcompare/bin/bcompare", a, b, c, d],
            [zztools_home + "/meld/bin/meld", a, b, d],
        ]

        merge_select = merge_tool[3]
    else:
        merge_select = ["sh emacs-merge.sh", a, b, c, d]

    return " ".join(merge_select)

if __name__ == "__main__":
    if len(sys.argv) < 4:
        print "Using example: %s <base> <local> <other> <output>" % sys.argv[0]
        sys.exit(1)

    os.system(hg_merge(sys.argv[1], sys.argv[2], sys.argv[3], sys.argv[4]))
