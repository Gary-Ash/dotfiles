#!/usr/bin/env osascript
(*****************************************************************************************
 * HashTable.scrpt 
 *
 * This file contains the implementation of hash table
 *
 * Author.  :  Gary Ash <gary.ash@icloud.com>
 * Created. :  26-Mar-2026. 5:50pm
 * Modified :
 *
 * Copyright © 2026 By Gary Ash All rights reserved.
 ****************************************************************************************)
use AppleScript version "2.4"
use framework "Foundation"
use scripting additions

script HashTable
	property nativeDict : missing value
	
	-- Initialize a new empty hash table
	on init()
		set my nativeDict to current application's NSMutableDictionary's alloc()'s init()
		return me
	end init
	
	-- Add or update a key
	on setVal(theKey, theValue)
		(my nativeDict)'s setValue:theValue forKey:(theKey as string)
	end setVal
	
	-- Retrieve a value
	on getVal(theKey)
		set theResult to (my nativeDict)'s objectForKey:(theKey as string)
		if theResult is missing value then return nil
		return theResult
	end getVal
	
	-- Delete a key
	on deleteKey(theKey)
		(my nativeDict)'s removeObjectForKey:(theKey as string)
	end deleteKey
	
	-- Save to a .plist file
	on saveToFile(hfsPath)
		set posixPath to POSIX path of hfsPath
		return (my nativeDict)'s writeToFile:posixPath atomically:true
	end saveToFile
	
	-- Load from a .plist file
	on loadFromFile(hfsPath)
		set posixPath to POSIX path of hfsPath
		set my nativeDict to current application's NSMutableDictionary's dictionaryWithContentsOfFile:posixPath
		if my nativeDict is missing value then return false
		return true
	end loadFromFile
	
	-- Get all keys as an AppleScript list
	on allKeys()
		return (my nativeDict)'s allKeys() as list
	end allKeys
	
	-- Add this inside the 'script HashTableInstance' block in your library
	on mergeWith(otherTable)
		-- 'otherTable' should be another instance created by this library
		set otherDict to otherTable's nativeDict
		(my nativeDict)'s addEntriesFromDictionary:otherDict
	end mergeWith
end script


