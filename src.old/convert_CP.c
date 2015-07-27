/*
This program reads pollen records stored in CalPalyn format and
converts them to a more reasonable but space-intensive database format.

Input (CalPalyn) looks like this:
140.000       1201.0   138.000  10255.00
^depth   taxon^^count  t^^c      t^^c

Output will look like this:
McM	140.0	201	0	0	0	.....	8	0	.....
site	depth	taxon1	taxon2	t3	t4		t13	.....

This version handles 150 taxa.  Unused taxa get a value of zero on every
level, so you might want to change this or delete columns in the resulting
database.

This program was last modified on April 6, 1991 by EE.
*/

#include <stdio.h>
#include <sys/file.h>
#include <strings.h>
#include <ctype.h>
#include <math.h>

#define MAXTAX 150

FILE	*in, *out;

typedef struct _poll_rec Poll_Rec;

struct _poll_rec {
	double	depth;
	double  taxa[150];
	Poll_Rec	*next_poll_rec;
} ;
	
#define Poll_Rec_Nil	(Poll_Rec	*) 0

#define ChasePollRec( p_point , p_chain ) \
	for( p_point = p_chain; p_point != Poll_Rec_Nil; p_point = p_point->next_poll_rec)


main(argc, argv)
int	argc;
char*	argv[];
{
		char	buf[20];
		char	*string,*string_header;
		char	sitename[100];
		double	count;	
		double	depth;
		int	i,taxon,space_count;
		Poll_Rec	*poll_rec,*curr_rec;

		string = (char *) malloc(100*sizeof(char));
		if (argc != 3) {
			fprintf(stderr, "usage: convert_CP infile outfile\n");
			exit(1);
		}

		if ((in = fopen(argv[1], "r")) == NULL) {
			fprintf(stderr, "can't open infile\n");
			exit(1);
		}

		if ((out = fopen(argv[2], "w")) == NULL) {
			fprintf(stderr, "can't open outfile\n");
			exit(1);
		}

		/*begin main program loop*/
		
		printf("conversion complete.\n");
		printf("if you'd like to know how this program works,\n");
		printf("  read the source code in the file ~/src/convert_CP.c .\n");

		string_header = string;	
		poll_rec = Poll_Rec_Nil;
		while (fgets(string,100,in) != NULL) {
			if (isalpha(string[0])) {
				if (poll_rec != Poll_Rec_Nil) {
					print_stuff(poll_rec,sitename);
					poll_rec = Poll_Rec_Nil;	
				}
				strncpy(sitename, string,3);
			} else {
				for (i=0 ; i < 9; i ++ ) {
					buf[i] = string[i];
				}
				buf[10] = '\0';
				depth = atof(buf);
				if (poll_rec == Poll_Rec_Nil) {
					poll_rec=(Poll_Rec *)malloc
						(sizeof(Poll_Rec));
					curr_rec = poll_rec;
					curr_rec->depth = depth;
					curr_rec->next_poll_rec = Poll_Rec_Nil;
				}
				/*first value on line is depth*/
				if (depth != curr_rec->depth) {
					ChasePollRec(curr_rec,poll_rec) {
						if (curr_rec->depth == depth) {
							break;
						} else if (curr_rec->
							next_poll_rec ==
							Poll_Rec_Nil) {
						curr_rec->next_poll_rec=
						(Poll_Rec *)malloc
						(sizeof(Poll_Rec));
						curr_rec = curr_rec->next_poll_rec;
						curr_rec->next_poll_rec = Poll_Rec_Nil;
						curr_rec->depth = depth;
						break;
						}
					}
				}      			
					
				string += 10;
				while (1) {
					for (i=0 ; i < 5; i ++ ) {
						buf[i] = string[i];
						if (buf[i] == '\n') {
							space_count = 5;
							break;		
						}
						if (buf[i] == ' ') {
							space_count++;
						}
					}
					if (space_count == 5) {
						break;
					}
					buf[5] = '\0';
					taxon = atoi(buf);
					string += 5;	
					for (i=0 ; i < 5; i ++ ) {
						buf[i] = string[i];
					}
					buf[5] = '\0';
					count = atof(buf);
					string += 5;
					if ((taxon >0) && (taxon < 151)) {
						curr_rec->taxa[taxon-1] = count;   
					}
				}
			}
			
		string = string_header;
		}
		print_stuff(poll_rec,sitename);
}




print_stuff(poll_rec,sitename)
Poll_Rec	*poll_rec;
char	sitename[];
{
	
	Poll_Rec	*curr_rec;
	int	i;

	fprintf(out,"\n%s\t",sitename);
	ChasePollRec(curr_rec,poll_rec) {
		fprintf(out,"%lf\t",curr_rec->depth);
		for (i = 0; i < 150; i ++ ) {
			fprintf(out,"%lf\t",curr_rec->taxa[i]);
		}
		fprintf(out,"\n%s\t",sitename);
	}
}
		
