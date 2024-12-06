#!/bin/bash
#
# Desc: Hard links and symbolic links
#
# Author: Sabyasachi Mitra
# Date: 12/02/2024
#
# Hard link:
# A file in any Unix-based operating system comprises data block(s) and an inode. 
# The data blocks store the actual file contents. On the other hand, an inode stores 
# file attributes (except the file name) and the disk block locations.
#
# A hard link is just another file that points to the same underlying inode as the original file.
# Thus, it references the same physical file location.
# Even if we later delete the original file, we’ll still be able to access its contents using the created hard link. 
# Effectively, once no hard link points to an inode, the file is considered deleted.
# hard links can be created using ln command
ln filename link-filename
# Limitations:
# 1. We cannot create hard links to a directory.
# 2. hard links cannot cross filesystem boundaries, like between network-mapped disks.
#
# Symbolic links:
# A symbolic or soft link is a new file that just stores the path of the original file and not its contents.
# A soft link won’t work after moving or deleting the original file.
# Unlike hard links, original files and its symbolic link do not share the same inode.
# You can create symbolic links to directories and across file systems
# Symbolic links can be created using:
ln -s source-file-name link-name
#
# Relative and Absolute Symbolic Links:












