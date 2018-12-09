/*
Licensed under the terms of the GNU GENERAL PUBLIC LICENSE
(C) andshrew 2018
See LICENSE in the root directory
*/

#include <stdio.h>
#include <stdarg.h>
#include <string.h>
#include <stdlib.h>
#include <unistd.h>

int main(int argc, char *argv[])
{
	int maxlen = 255;
	int app_exit;

	printf("Starting PS Classic Intercept\r\n");
	printf("Received %i arguments\r\n", argc-1);
	
	//	Loop through each argument to find -cdfile
	for (int i = 1; i < argc; i++) {
		
		printf("Arg %i: %s\r\n", i, argv[i]);
		// -cdfile found
		if (!strcmp(argv[i], "-cdfile")) {
		
			printf("Checking for custom routines...\r\n");
			// The path to the .cue will be in the next argument
			if (i+1 < argc) {
			
				printf(".cue path: %s\r\n",argv[i+1]);
				// If Rainbow Six (SLES-01136) launch a custom app
				if (strstr(argv[i+1], "SLES-01136")) {
				
					app_exit = system("/usr/sony/bin/showLogo");
					app_exit = system("/usr/sony/bin/showLogo");
					return 0;
				}
				
				// If no game specific entries exist check
				// if a PBP file exists to launch. Otherwise
				// just launch the game as normal.
				
				printf("Checking if PBP exists\r\n");
				char pbpPath[sizeof(argv[i+1])];
				strncpy(pbpPath, argv[i+1], strlen(argv[i+1]));
				char *temp;
				temp = strrchr(pbpPath, '.');
				*temp = '\0';
				strncat(pbpPath, ".pbp", sizeof(pbpPath));
				printf("Checking if PBP file exists at: %s\r\n", pbpPath);
				if(access(pbpPath, F_OK) != -1) {
					printf("A PBP file exists, updating parameter to pass to PCSX\r\n");
					argv[i+1]=pbpPath;
				}
			}
		}
	}
	
	// Launch PCSX
	char *pcsx = "/usr/sony/bin/pcsx.old ";
	char cmd[maxlen];
	
	// Build the launch string
	strncpy(cmd, pcsx, sizeof(cmd));
	
	for (int i = 1; i < argc; i++) {
	
		strncat(cmd, argv[i], sizeof(cmd));
		if (i+1 < argc) {
			strncat(cmd, " ", sizeof(cmd));
		}
	}
	
	printf("cmd: %s\r\n", cmd);
	app_exit = system(cmd);
	return 0;
}
