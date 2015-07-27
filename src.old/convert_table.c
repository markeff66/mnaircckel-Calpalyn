/*
Convert a table of data to Calpalyn-readable format.
First line of the input file  must specify:
	N = number of rows of data,
	F = fields of data not including the sample depth, and
	the taxon numbers associated with fields 1 through F.
The sample depth is the first value on each line.  The values may be
separated by spaces or tab stops.  The program should handle any number
of taxa (F)--just change the value of "#define MAXTAX" if you need more
than (105).  Also, be sure to specify a zero value for all the spaces
with no data--don't just leave blanks in the Excel file!
*/
/*
FYI, you can quickly fill all blank cells with zeros in Excel:
	highlight the portion of the spreadsheet containing data, 
	pull down the "Formula" menu to "Select Special",
	check the box next to "Blanks", then click "OK",
	type "0" and then hit control-enter to fill all the selected boxes.
Manually type a zero (or other value) in the last cell (bottom right) first--
  otherwise Excel won't fill the trailing blank cells in the selection area.
*/
/*
This program was last modified on August 21, 1996 by EE.
*/

#include <stdio.h>
#include <sys/file.h>
#include <strings.h>
#include <ctype.h>
#include <math.h>

#define MAXTAX 105

FILE	*in, *out;

main(argc, argv)
int	argc;
char*	argv[];
{
	int	N,F,ncount,fcount,tcount,taxon[MAXTAX];
	float	depth, value[MAXTAX];	
	char	answer[5];

	if (argc != 3) {
		fprintf(stderr, "usage: convert_table infile outfile\n");
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

	/*opening remarks*/

	printf ("\nDetailed instructions? (y/n)");
        scanf("%s",answer);
        if ((answer[0] == 'y') || (answer[0] == 'Y')) {

		printf ("\nThis program reads a table of taxon counts in which all the values in\n");
		printf ("  a particular column are counts for the same taxon.\n");
		printf ("\nTypically, you created this table with a spreadsheet like Excel on the Mac.\n");
        	printf ("\nThe first line of your input file _must_ conform to these specifications:\n");
        	printf ("  The first value on the line is the number of levels in the table, i.e.\n");
		printf ("        the number of lines in the table not counting the initial line.\n");
		printf ("  The second value on the first line is the number of taxa on each line.\n");
		printf ("  The remaining values on the first line are the taxon numbers.\n");
		printf ("\nThe values in your input file may be separated by tabs or spaces;\n");
		printf ("  just save the file as text from Excel and you'll be OK.\n");
		printf ("\nWith any luck at all, the output file will be CalPalyn-compatible.\n");
		printf ("\nNow run the program again by typing '!!' at the next Unix prompt,\n");
		printf ("  and _don't_ ask for detailed instructions.\n\n");
	exit(1);
	}
	
	/* begin program	*/

	fscanf (in,"%d %d",&N,&F);
	for (fcount = 0; fcount < F; fcount++) {
		fscanf (in,"%d",&taxon[fcount]);
	}
	for (ncount = 0; ncount < N; ncount++) {
		fscanf (in,"%f",&depth);
		if (depth < 10) {
			fprintf (out,"%1.5f   ",depth);
		} else if (depth < 100) {
			fprintf (out,"%2.4f   ",depth);
		} else if (depth < 1000) {
			fprintf (out,"%3.3f   ",depth);
		} else if (depth < 10000) {
			fprintf (out,"%4.2f   ",depth);
		}
		for (tcount = 0; tcount < F; tcount++) {
			/* old version commented out; this line should handle
			   any number of taxa.... */
			/* if ((tcount==6) || (tcount==12) || (tcount==18)) */
			if ((tcount > 0) && ((tcount % 6) == 0)) { 
				if (depth < 10) {
					fprintf (out,"\n%1.5f   ",depth);
				} else if (depth < 100) {
					fprintf (out,"\n%2.4f   ",depth);
				} else if (depth < 1000) {
					fprintf (out,"\n%3.3f   ",depth);
				} else if (depth < 10000) {
					fprintf (out,"\n%4.2f   ",depth);
				}
			}
			fprintf (out,"%5d",taxon[tcount]);
			fscanf (in,"%f",&value[tcount]);
			if (value[tcount] < 10) {
				fprintf (out,"%1.3f",value[tcount]);
			} else if (value[tcount] < 100) {
				fprintf (out,"%2.2f",value[tcount]);
			} else if (value[tcount] < 1000) {
				fprintf (out,"%3.1f",value[tcount]);
			} else if (value[tcount] < 10000) {
				fprintf (out," %4.0f",value[tcount]);
			} else {
				fprintf (out,"%5d",(int)(value[tcount]));
			}
		} /* end tcount loop */

		fprintf (out,"\n");

	} /* end ncount loop */
}

