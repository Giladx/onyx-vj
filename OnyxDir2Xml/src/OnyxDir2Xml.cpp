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
#include <iostream>
#include <unistd.h>
#include <stdio.h>
#include <string.h>
#include <dirent.h>

void recurse(char *root, char *query);

void recurse(char *root, char *query)
{
	char tmpA[PATH_MAX+1];
	char tmpB[PATH_MAX+1];
	char tmpC[PATH_MAX+1];
	
	char fileXml[PATH_MAX+1];
	char nquery[PATH_MAX+1]; 	// next query 
	
	char name[] = "\0"; 		// no file extension
		
	strcat(strcpy(fileXml,query),"/files.xml");	
			
	FILE* xml = fopen(fileXml, "w");
	
	fprintf(xml, "<response>\n\t<query path=\"%s/\">\n\t\t\n\t\t<folder name=\"..\" />\n\t\t\n\t\t", query);
		
	strcat(strcat(strcpy(tmpA, root), "/"), query);
	
	DIR* pdir;
	struct dirent* ent;
    struct stat info;
    
    //list dir only
    pdir = opendir(tmpA);
    
    if (pdir != NULL) {
    	
    	readdir(pdir); //skip .
    	readdir(pdir); //skip ..
    	
    	while(ent = readdir(pdir)) {
    		
    		strcpy(tmpB,tmpA);
    		stat(strcat(strcat(tmpA,"/"),ent->d_name), &info);
    		    			
    		if(S_ISDIR(info.st_mode) && strcmp(ent->d_name,"thumbs")) {
    			
    			fprintf(xml, "<folder name=\"%s/\" url=\"%s/%s\" />\n\t\t", ent->d_name, tmpB, ent->d_name);
    			
    			strcpy(nquery,"\0");
    			printf("%s\n", strcat(strcat(strcat(nquery,query),"/"),ent->d_name));
    			
    			strcpy(nquery,"\0");
    			recurse(root, strcat(strcat(strcat(nquery,query),"/"),ent->d_name));
    				    			
    		}
    		
    		strcpy(tmpA,tmpB);
    		
    	}
    	
    	fprintf(xml, "\n\t\t");
    	closedir(pdir);
    }
    
    //list files only
    pdir = opendir(tmpA);
    
    if (pdir != NULL) {

       	readdir(pdir); //skip .
       	readdir(pdir); //skip ..
        	
       	while(ent = readdir(pdir)) {
        		
      		strcpy(tmpB,tmpA);
       		stat(strcat(strcat(tmpA,"/"),ent->d_name), &info);
        		    			
       		if(S_ISREG(info.st_mode) && strcmp(ent->d_name,"files.xml") && strcmp(ent->d_name,"Thumbs.db")) {
       				
       			strncpy( name, ent->d_name, strlen(ent->d_name) - strlen(strpbrk(ent->d_name,".")) );
       			fprintf(xml, "<file name=\"%s\" url=\"%s/%s\" thumb=\"thumbs/%s.png\" />\n\t\t", ent->d_name, tmpB, ent->d_name, name);
       		
       		}
       		strcpy(tmpA,tmpB);
       		strcpy(tmpC,"\0");
       		
        }
        	
        fprintf(xml, "\n\t\t");
        closedir(pdir);
    }
    
    fprintf(xml,"</query>\n</response>");
    fclose(xml);
    
}

int main (/*int argc, char *argv[]*/) {
	
	char root[PATH_MAX+1];
	char query[] = "video"; 
	
	getcwd(root, PATH_MAX+1);
	recurse(root, query);
	
	return EXIT_SUCCESS;
	
}

