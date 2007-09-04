//============================================================================
// Name        : OnyxDir2Xml.cpp
// Author      : Stefano Cottafavi
// Description : Automatic library file builder for Onyx
//============================================================================

/* 
 * Copyright (c) 2003-2007, www.onyx-vj.com
 * All rights reserved.	
 * 
 * Redistribution and use in source and binary forms, with or without modification,
 * are permitted provided that the following conditions are met:
 * 
 * -  Redistributions of source code must retain the above copyright notice, this 
 *    list of conditions and the following disclaimer.
 * 
 * -  Redistributions in binary form must reproduce the above copyright notice, 
 *    this list of conditions and the following disclaimer in the documentation 
 *    and/or other materials provided with the distribution.
 * 
 * -  Neither the name of the www.onyx-vj.com nor the names of its contributors 
 *    may be used to endorse or promote products derived from this software without 
 *    specific prior written permission.
 * 
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND 
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED 
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. 
 * IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, 
 * INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
 * NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
 * PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, 
 * WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
 * POSSIBILITY OF SUCH DAMAGE.
 * 
 */

#include <sys/stat.h>
#include <unistd.h>
#include <stdio.h>
#include <string.h>
#include <dirent.h>

// file copy
#include <iostream>
#include <fstream>
#include <string>

using namespace std;

void recurse(string root, string query);

void recurse(string root, string query)
{
	
	string tmp = root+"/"+query+"/files.xml";
	
	string fileXml;
	string name;
	string nameNoExt;

	bool hasThumbDir 	= false;	//check for thumbs dir
	
	DIR* pdir;
	struct dirent* ent;
	struct stat info;
	struct stat thumb;   
	
	fstream xml;
	
	///start here
	fclose( fopen(tmp.c_str(), "w"));
	xml.open(tmp.c_str(), fstream::in | fstream::out);
	xml << "<response>\n\t<query path=\""+query+"/\">\n\t\t\n\t\t<folder name=\"..\" />\n\t\t\n\t\t";	
		
    //list dir only
	tmp = root+"/"+query;
    pdir = opendir(tmp.c_str());
    
    if (pdir != NULL) {
    	
    	readdir(pdir); //skip .
    	readdir(pdir); //skip ..
    	
    	while(ent = readdir(pdir)) {
    		
    		name = ent->d_name;
    		tmp = root+"/"+query+"/"+name; 
    		
    		stat(tmp.c_str(), &info);
    		    			
    		if(S_ISDIR(info.st_mode) && name!="thumbs") {
    			
    			xml << "<folder name=\""+name+"/\" url=\""+tmp+"\" />\n\t\t";
    			
    			recurse(root, query+"/"+name);
    				    			
    		} else if (S_ISDIR(info.st_mode) && name=="thumbs") {
    	
    			hasThumbDir = true;
    			
    		}
    		    		
    	}
    	
    	//create "thumbs" dir
    	if(!hasThumbDir) {
    		
    		tmp = root+"/"+query+"/thumbs";
    		mkdir(tmp.c_str());
    		
    		hasThumbDir = false;
    	
    	}
    	
    	xml << "\n\t\t";
    	closedir(pdir);
    }
    
    //list files only
    tmp = root+"/"+query;
    pdir = opendir(tmp.c_str());
    
    if (pdir != NULL) {

       	readdir(pdir); //skip .
       	readdir(pdir); //skip ..
        	
       	while(ent = readdir(pdir)) {
        		
       		name = ent->d_name;
       		nameNoExt = name.substr(0,name.find_last_of("."));
       		
       		tmp = root+"/"+query+"/"+name;
       		
       		stat(tmp.c_str(), &info);
        		    			
       		if(S_ISREG(info.st_mode) && name!="files.xml" && name!="Thumbs.db") {
       			
       			xml << "<file name=\""+name+"\" url=\""+query+"/"+name+"\" thumb=\"thumbs/"+nameNoExt+".png\" />\n\t\t";
       		
       			//create .png thumb if not exists (unknown,yellow-black content)
       			tmp = root+"/"+query+"/thumbs/"+nameNoExt+".png";
       			       			
       			if(stat(tmp.c_str(), &thumb) == -1) {
       				
       				//create file
       				fclose(fopen(tmp.c_str(),"w"));
       				
       				string tmp2 = root+"/unknown.png";
       				
       				fstream src, dst;
       				src.open(tmp2.c_str(), fstream::in | fstream::binary);
       				dst.open(tmp.c_str(), fstream::out | fstream::binary);
       				
       				dst << src.rdbuf();
       				
       				src.close();
       				dst.close();
       				
       			}
       		}
       		
        }
        	
        xml << "\n\t\t";
        closedir(pdir);
    }
    
    xml << "</query>\n</response>";
    xml.close();
    
}

int main (/*int argc, char *argv[]*/) {
	
	char path[PATH_MAX+1];
	 
	string root 	= getcwd(path, PATH_MAX+1);
	string query	= "video";
	
	recurse(root, query);
	
	return EXIT_SUCCESS;
	
}

