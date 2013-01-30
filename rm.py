import os
import shutil
import sys
from os.path import join, exists

visited = []
def delete_file():
    for path, dirs, files in os.walk(".", topdown=True):
        if path not in visited: 
            # delete xcuserdata
            for di in dirs:
                cmd_a = "git rm -rf " + join(path, 'xcuserdata')
                print cmd_a
                os.system(cmd_a)
            # copy images html and js files                    
            for fi in files:
            	cmd_b = "git rm " + join(path, '.DS_Store')
                print cmd_b
                os.system(cmd_b)
            visited.append(path)
delete_file()