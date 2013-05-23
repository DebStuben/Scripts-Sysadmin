#!/usr/bin/python
# -*- coding: utf-8 -*-

import os, glob, sys
import re
import argparse

# Args
parser = argparse.ArgumentParser(description='Multiple rename with regular expression', epilog='Created by Steven Ducastelle on May 23 2013')
parser.add_argument('--filter', '-f', action="store", dest='filter', help="Filter for selecting files", default="*")
parser.add_argument('--pattern', '-p', action="store", dest="pattern", help="Pattern for extraction filenames")
parser.add_argument('--replace', '-r', action="store", dest="replace", help="Replacement for create new filename")
parser.add_argument('-y', action="store_true", dest="prompt", help="When a yes/no prompt would be presented, assume that the user entered 'yes'.", default="False")
parser.add_argument('--show-exemple', '-s', action="store_true", dest="example", help="Dislays an example", default='False')
args = parser.parse_args()


# Show an exmple and quit
if args.example == True:
	print "Usage example :"
	print "You want to rename the txt files starting with 'test' keeping their numbers."
	print "Before : 'test file 001.txt'	=>	After : 'new_filename001.txt'"
	print "For this : renamex.py -f 'test*.txt' -p '^test.*([0-9]{3})\.txt$' -r 'new_filename\1.txt'" 
	sys.exit(0) 


matchs = False		# Boolean indicating if file match the pattern

# Verify if pattern and replace are passed in argument
if (args.pattern is not None) and (args.replace is not None):
	os.chdir('.')	# Place search in actual directory
	
	# Browse the files matching the mask (args.filter)
	for files in glob.glob(args.filter):
		try:
			match = re.match(args.pattern, files)	# Verify pattern
			
			if match:
				newname = re.sub(args.pattern, args.replace, files)	# Create new name from regex
   				print "Match : " + files + "\t => " + newname
   				matchs = True
			else:
				print "Not Match : " + files

		except Exception, e:
			print "Error pattern : " + str(e)
			sys.exit(0)

	# If the files match whit pattern
	if matchs is True:
		# If you want to force the decision
		if args.prompt == True:
			answer = "y"
		else:
			answer = raw_input("Do you want apply this result ? [y/n] : ").lower()	# Ask the user

		if (answer == "y") or (answer == "yes"):
			print "Renaming in progress..."
			for files in glob.glob(args.filter):
				match = re.match(args.pattern, files)
				if match:
					newname = re.sub(args.pattern, args.replace, files)	
					os.rename(files, newname)		# Move file with new filename
			print "Renaming terminated"
		else:
			print 'No renaming'
	else:
		print "The pattern can be applied to any file"