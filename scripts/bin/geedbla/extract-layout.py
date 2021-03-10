#!/usr/bin/env python3
# -*- coding: utf-8 -*-
# ****************************************************************************************
# extract-layout.py
#
# This script will extract the sub-images of a layered graphics file to a given directory
# and write the layout of those sub-images to a layout.txt file
#
# extract-layout.py <layered graphic file> <output directory/subdirectory>
#
# Author   :  Gary Ash <gary.ash@icloud.com>
# Created  :  14-Jul-2020  3:32pm
# Modified :  14-Jul-2020  3:37pm
#
# Copyright © 2020 By Gee Dbl A All rights reserved.
# ****************************************************************************************

import os
import sys
import wand.image
import wand.exceptions

if len(sys.argv) != 3:
    print("**** Error: Bad command line\n\n%s <layered image file> <directory for output>" % os.path.basename(sys.argv[0]))
    sys.exit(1)

if not os.path.isfile(sys.argv[1]):
    print("**** Error: %s doesn't exit as an image file" % sys.argv[1])
    sys.exit(1)

try:
    with wand.image.Image(filename=sys.argv[1]) as layeredImage:
        numberOfImages = len(layeredImage.sequence)
        if numberOfImages < 2:
            print("**** Error: %s is not a layered graphic file" % sys.argv[1])
            sys.exit(1)

        del layeredImage
        if not os.path.isdir(sys.argv[2]):
            try:
                os.makedirs(sys.argv[2])

            except OSError as e:
                print("**** Error: Unable to create the output directory : %s" % e.strerror)
                sys.exit(1)

        try:
            layoutFileName = sys.argv[2] + "/layout.txt"
            layoutFile = open(layoutFileName, 'w')

            for imageNumber in range(1, numberOfImages):
                singleImageFileName = "%s[%d]" % (sys.argv[1], imageNumber)
                singleImage = wand.image.Image(filename=singleImageFileName)
                print("%s,%d,%d" % (singleImage.artifacts['label'], singleImage.size[0], singleImage.size[1]), file=layoutFile)
                singleImage.save(filename="%s.png" % (sys.argv[2] + "/" + singleImage.artifacts['label']))

            layoutFile.close()

        except OSError as e:
            print("**** Error: Unable to write the layout file : %s" % e.strerror)
            sys.exit(1)

except wand.exceptions.BaseError:
    print("**** Error: Unable to read the image file")
    sys.exit(1)
