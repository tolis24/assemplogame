/* package whatever; // don't place package name! *///https://ideone.com/h9t1lK

import java.util.*;
import java.lang.*;
import java.io.*;

/* Name of the class has to be "Main" only if the class is public. */
class Ideone
{
	public static void main (String[] args) throws java.lang.Exception
	{
		int ch,i;
		i=1;
		System.out.print (i+"    :    ");
		i++;
		 
		while ((ch = System.in.read ()) != -1){
			if (ch=='\n'){
		 	  System.out.print (";\n"+i+"    :    ");
		 	  i++;
			}
			else{
				System.out.print ((char) ch);
			}
		}
		System.out.print (';');
	}
}