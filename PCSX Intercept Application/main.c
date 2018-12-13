/*
Licensed under the terms of the GNU GENERAL PUBLIC LICENSE
(C) andshrew 2018
See LICENSE in the root directory
https://github.com/andshrew/psclassic-misc/blob/master/LICENSE
*/

#include <stdio.h>
#include <stdarg.h>
#include <string.h>
#include <stdlib.h>
#include <unistd.h>
#include <limits.h>


int main(int argc, char *argv[])
{

	int app_exit;
	char pbp_path[PATH_MAX];

	printf("Starting PS Classic Intercept\r\n");
    printf("Received %i arguments\r\n", argc-1);

	//	Loop through each argument to find -cdfile
	for (int i = 1; i < argc; i++) {
			
		printf("Arg %i: %s\r\n", i, argv[i]);

		// -cdfile found
		if (!strcmp(argv[i], "-cdfile")) {
			
			// The path to the .cue will be in the next argument
			if (i+1 < argc) {

				printf(".cue path: %s\r\n",argv[i+1]);
				printf("Checking for custom routines...\r\n");

				//	If '+' is in the .cue path this is a custom application
				//	extract the command and execute it
				if (strstr(argv[i+1], "+")) {

					char app_path[PATH_MAX];
					strncpy(app_path, argv[i+1], strlen(argv[i+1]));

					char *start = strchr(app_path, '+');
					char *end = strrchr(app_path, '.');
					*end = '\0';
					printf("Custom application found in regional.db - path: %s\r\n", start+1);

					app_exit = system(start + 1);
					printf("Exit code: %i\r\n", app_exit);
					return app_exit;
				}

				//	Check if a launch.txt file exists within this applications directory
				//	If it does read the first line and execute it
				
				char *launch_path="/data/AppData/sony/title/launch.txt";
				if (access(launch_path, F_OK) != -1) {

					printf("Found launch.txt at %s\r\n", launch_path);
					FILE *file;
					char content[PATH_MAX];

					file = fopen(launch_path, "r");
					if (file == NULL) {
						printf("Could not open launch.txt file %s\r\n", launch_path);
					}
					else	
					{
						fgets(content, PATH_MAX, file);
						fclose(file);
						if (content != NULL) {
							printf("Custom application found in launch.txt - path: %s\r\n", content);
							app_exit = system(content);
							return app_exit;
						}
					}
				}

				// If no custom application found check
				// if a PBP file exists in the games directory.. 
				// Otherwise just launch the game as normal.

				printf("Checking if PBP exists...\r\n");                
				//char pbp_path[sizeof(argv[i+1])];
				strncpy(pbp_path, argv[i+1], strlen(argv[i+1]));
				char *temp;
				temp = strrchr(pbp_path, '.');
				*temp = '\0';
				strncat(pbp_path, ".pbp", sizeof(pbp_path));
				printf("pbp_path: %s\r\n", pbp_path);
				printf("Checking if PBP file exists at: %s\r\n", pbp_path);
				if(access(pbp_path, F_OK) != -1) {
					
					printf("A PBP file exists, updating parameter to pass to PCSX\r\n");	
					argv[i+1]=pbp_path;
				}
			}

		}
	}

	// Launch PCSX

	for (int i = 1; i < argc; i++) {
		
		printf("argpre%i %s\r\n", i, argv[i]);
	}

	char *pcsx = "/usr/sony/bin/pcsx.old ";
	char cmd[PATH_MAX];
	
	// Build the launch string
	strncpy(cmd, pcsx, sizeof(cmd));

	for (int i = 1; i < argc; i++) {
		
		strncat(cmd, argv[i], sizeof(cmd));
		if (i+1 < argc) {
			strncat(cmd, " ", sizeof(cmd));
		}
	}
	printf("Executing: %s\r\n", cmd);
	app_exit = system(cmd);
	printf("Exit code: %i\r\n", app_exit);
	return app_exit;
}

