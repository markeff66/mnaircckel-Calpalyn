/*
	This program reads a CalPalyn .data file, then prompts the user for
pairs of depths and dates, separated by one or more spaces (" "),
starting at the top and working down.
	For reasonable results, the user must arbitrarily specify a date
for the _lowest_ sample in the core.
	Dates must be sequential; reversals will cause this program to crash.
For the time being, dates _must_ be entered in years B.P.  One problem:
right now, 1991, is actually -41 yr. B.P.--but if you use that as your
uppermost sample, you'll get a weird numbering scheme on the y-axis.
	Just deal with it as best you can....
*/

/*
This program was last modified on June 5, 1991 by EE.
*/

#include <stdio.h>
#include <sys/file.h>
#include <strings.h>
#include <ctype.h>
#include <math.h>

FILE	*in, *out;

main(argc, argv)
int	argc;
char*	argv[];
{
	char	answer[5];
	char	whole_line[100];
	char	depth_value[10];
	float	depth[50];
	float	age[50];
	double	ydepth;
	float	yage;	
	int	c,i,ages_entered;

	if (argc != 3) {
		fprintf(stderr, "usage: depth_to_age infile outfile\n");
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

	printf ("Detailed instructions? (y/n)");
        scanf("%s",answer);
        if ((answer[0] == 'y') || (answer[0] == 'Y')) {

		printf ("\n");
		printf ("This program reads a CalPalyn .data file and converts its y-axis from\n");
		printf ("  depth to age, putting output in a new file.\n");
		printf ("\n");
		printf ("You enter pairs of depths and dates, separated by one or more spaces\n");
		printf ("  starting at the top and working down.\n");
		printf ("\n");
        	printf ("You _must_ specify a date for the top and bottom of the core.\n");
        	printf ("  Dates must be sequential; reversals will cause this program to crash.\n");
		printf ("\n");
		printf ("Enter the depth for the _center_ of each C14 date, but for ash layers,\n");
		printf ("  you may enter the depth of the top and bottom of the layer,\n");
		printf ("  each with the same age.  This treats the deposition of a thick\n");
		printf ("  ash layer as an instantaneous event.\n");
		printf ("\n");
		printf ("For the time being, dates _must_ be entered in years B.P.  One problem:\n");
		printf ("  right now, 1991, is actually -41 yr. B.P.--but if you use that as your\n");
		printf ("  uppermost sample, you'll get a weird numbering scheme on the y-axis.\n");
        	printf ("  Just deal with it as best you can....\n");
		printf ("\n");
		printf ("Enter both dates and ages as positive numbers, except as noted for 1950-1991.\n");
		printf ("\n");
        	printf ("You are limited to 50 pairs of depths and dates--hope that's enough!\n");
		printf ("\n");
	}
	
        /* begin enter dates loop     */

        printf("Enter the depth followed by a space (or spaces)\n");
        printf("  and then the age followed by <return>.\n");
        printf("Enter -1 <return> when done.\n");

        ages_entered = 0;
        i = 0;
        while (!ages_entered) {
                scanf("%f",&depth[i]);
                if (depth[i] < 0) {
                        ages_entered = 1;
                        check_answers(depth,age,i);
                } else if (i == 50) {
                        scanf("%f",&age[i]);
                        check_answers(depth,age,50);
                        i = 0;
                } else {
                        scanf("%f",&age[i]);
                        ++i;
                }
	}

	/*begin read and rewrite data file loop*/
/*
	the first value on each line of data file is depth
 	convert that depth to age, write it to outfile
	then dump the rest of the line into the proper position
*/
	while (fgets(whole_line,100,in) != NULL) {

		if (sscanf(whole_line,"%s",depth_value) != NULL) {

			ydepth = atof(depth_value);

			agecalc(ydepth,depth,age,yage);

			for (c=11; c < (strlen(whole_line)); c++) {
				fputc(whole_line[c],out);
			}
		/*	fprintf(out,"\n");	*/
		}
	}
}

check_answers(depth,age,i)
float   *depth;
float	*age;
int     i;
{

        int     c,done;
        int     j,depth_to_change,age_to_change;
        char    answer[5];

        printf("Here are your paired depths and ages:\n");
	j = 0;
	while (j < i) {
                printf("depth: %5.1f, age: %5.1f\n",depth[j],age[j]);
		++j;
        }        
        printf("Do you want to change any depths? (y/n)");
        scanf("%s",answer);
        if ((answer[0] == 'y') || (answer[0] == 'Y')) {
                done = 0;
                while (! done) {
                        printf("Which entry would you like to change?\n");
			printf("(first, second, third, etc.)\n");
                        printf("0 if you are finished\n");
                        scanf("%d",&depth_to_change);
                        if (depth_to_change == 0) {
                                done = 1;
                        } else {
                                printf("current depth: %5.1f\n",
                                        depth[depth_to_change - 1]);
                                printf("enter new depth\n");
                                scanf("%f",&depth[depth_to_change - 1]);
                        }
                }
        }
        printf("Do you want to change any ages? (y/n)");
        scanf("%s",answer);
        if ((answer[0] == 'y') || (answer[0] == 'Y')) {
                done = 0;
                while (! done) {
                        printf("Which entry would you like to change?\n");
			printf("(first, second, third, etc.)\n");
                        printf("0 if you are finished\n");
                        scanf("%d",&age_to_change);
                        if (age_to_change == 0) {
                                done = 1;
                        } else {
                                printf("current age: %5.1f\n",
                                        age[age_to_change - 1]);
                                printf("enter new age\n");
                                scanf("%f",&age[age_to_change - 1]);
                        }
                }
        }
}

agecalc(ydepth,depth,age,yage)

double	ydepth;
float	depth[50];
float	age[50];
float	yage;
{
	int 	j;

	j = 0;
	while (ydepth > depth[j]) {
		++j;
		if ((j == 50) || ((j > 1) && (depth[j-1] < 0.0001))) {
			printf("crash! data file sample below lowest date\n");
			exit(1);
		}
	}

	if (j == 0) {
		yage = age[j];
	} else if (depth[j] == depth[j-1]) {
			printf("crash! repeated depth in input\n");
			exit(1);
	} else if (age[j] == age[j-1]) {
		yage = age[j];
	} else {
/*
		yage = (age[j-1] + 
			((ydepth/(depth[j]-depth[j-1]))*(age[j]-age[j-1])) );
*/
		yage = (age[j-1] + 
			(((ydepth-depth[j-1])/(depth[j]-depth[j-1])) *
				(age[j]-age[j-1])) );
	}

	fprintf(out,"%8.1f   ",yage);

}

