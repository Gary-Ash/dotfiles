#!/usr/bin/env python3
import sys

for raw in sys.stdin:
    line = raw.strip()
    print(f'"{line}"')
