#include <stdio.h>

FILE	*in;

main (argc,argv)
int	argc;
char	**argv;
{

	int	done = 0,level_done;
	float	level;
	int	taxon[100];
	float	count[100];
	int	i;
	
	if ((in = fopen(argv[1],"a")) == NULL) {
		printf ("error opening file %s\n",argv[1]);
	} 
	if (argc != 2) {
		fprintf(stderr, "usage: enter_data datafile\n");
		exit(1);
	}
 
	
	while (!done) { /* begin level loop	*/
	/* notice that this "done" is never assigned a value--
	   program terminates when "level == -1"		*/
		printf("Enter the level (-1 if done)\n");
		scanf("%f",&level);	
		if ((level > -1.01) && (level < -0.99)) {
			fclose ( in );
			break;
		}
		printf(" Entering data for level %.2f\n",level);
		for (i = 0; i < 100; i++) {
			taxon[i] = 0;
			count[i] = 0.0;
		}	
		printf("Enter the taxon followed by a space (or spaces)\n");
		printf("and then the count followed by <return>.\n");  
		printf("Press 0 <return> when done.\n");  
		level_done = 0;
		i = 0;
		while (!level_done) {
			scanf("%d",&taxon[i]);
			if (taxon[i] == 0) {
				level_done = 1;	
				check_answers(level,taxon,count,i);
				write_to_file(level,taxon,count,i);
			} else if (i == 100) {
				scanf("%f",&count[i]);
				check_answers(level,taxon,count,100);
				write_to_file(level,taxon,count,100); 
				i = 0;
			} else {
				scanf("%f",&count[i]);
				++i;
			}
		}
	}	
}			

write_to_file(level,taxon,count,i)
float	level;
int	*taxon;
float	*count;
int	i;
{
	int	c = 0;
	int	j;
	
	for (c = 0; c < i; c += 5) {
		if (level < 10.0 ) {
			fprintf(in,"%.5f   ",level);	
		} else if (level < 100.0) {
			fprintf(in,"%.4f   ",level);	
		} else if (level < 1000.0) {
			fprintf(in,"%.3f   ",level);	
		} else if (level < 10000.0) {
			fprintf(in,"%.2f   ",level);	
		}

		for (j = 0; j < 5; j++) {
			if (c + j < i) {
				fprintf(in,"%5d",taxon[c+j]);
				if (count[c+j] < 10.0 ) {
					fprintf	(in,"%.3f",count[c+j]);	
				} else if (count[c+j] < 100.0) {
					fprintf(in,"%.2f",count[c+j]);	
				} else if (count[c+j] < 1000.0) {
					fprintf(in,"%.1f",count[c+j]);	
				} else if (count[c+j] < 10000.0) {
					fprintf(in," %.0f",count[c+j]);	
				} else if (count[c+j] < 100000.0) {
					fprintf(in,"%.0f",count[c+j]);	
				} else {
				    printf("value %8.2f for taxon %5d exceeds CalPalyn limit;\n",count[c+j],taxon[c+j]);
				    printf("this count will be entered as 99999.\n");
				    fprintf(in,"99999");
				}
			}
		}
		fprintf(in,"\n");
	}
}

check_answers(level,taxon,count,i)
float	level;
int	*taxon;
float	*count;
int	i;
{

	int	c,done;
	int	j,taxon_to_change;
	char	answer[5];

	printf("Here are your data for level %.2f:\n",level);
	for (c = 0; c < i; c += 20) {
		for (j = 0; j < 20; j ++ ) {
			printf("%d.  taxon: %d, count: %.3f\n",(c+j+1),taxon[c+j],
				count[c+j]);
		}
		printf ("--More-- (hit 0 <return> when ready)\n");
		scanf("%s",answer);
	}	
	printf("Do you want to change any taxa? (y/n)");
	scanf("%s",answer);
	if ((answer[0] == 'y') || (answer[0] == 'Y')) {
		done = 0;
		while (! done) {
			printf("Which number would you like to change?\n");
			printf("0 if you are finished\n");
			scanf("%d",&taxon_to_change);
			if (taxon_to_change == 0) {
				done = 1;
			} else {
				printf("that is taxon %d\n",
					taxon[taxon_to_change - 1]);
				printf("current count: %.3f\n",
					count[taxon_to_change - 1]);
				printf("enter new count\n");
				scanf("%f",&count[taxon_to_change - 1]);
			}
		}
	}
}
				
			
