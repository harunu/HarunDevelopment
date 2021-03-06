#include <stdio.h>

#define SIZE 12

void read_message_lines (char message_line [][80], int size, char file_name[])
{
	FILE *mycfPtr;     /* mycfPtr = message.dat file pointer */
	
	int count = 0;
   /* fopen opens file; exits program if file cannot be opened */ 
   if ( ( mycfPtr = fopen( file_name, "r" ) ) == NULL ) {
      printf( "File could not be opened\n" );
   } /* end if */
   else 
	{ /* read lines */
      printf( "%s\n", "Lines of message" );
	  count++;
      fgets( message_line[count], 80, mycfPtr );

      /* while not end of file */
      while ( !feof( mycfPtr ) ) 
	  { 
         printf( "%s", message_line [count] );
		 count++;
		 fgets( message_line[count], 80, mycfPtr );
		 	} /* end while */

      fclose( mycfPtr ); /* fclose closes the file */
   } /* end else */

} /* function read_message_lines */

int main()
{ 
	char file_name[] = "istanbul_message.dat";
	char mymessage [SIZE][80];
	read_message_lines (mymessage, SIZE, file_name);
   
} /* end main */

  