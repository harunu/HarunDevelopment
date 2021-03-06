int binary_search (int list[], int left, int right, int find)
   {
   int subset = -1, mid;
   if (left <= right)      //search list while there are values to be searched
     {
     mid = (int) ((left + right) / 2);     //obtain the integer middle of the list
     if (find == list[mid])                //if the value searched for is in list[mid]
       subset = mid;                       //set subset equal to mid
     else if (find>list[mid])            //test to see if the value searching 
       {                                   //for is greater than list[mid]
       left = mid + 1;                     //set the left var to 1 more than the middle
       subset = binary_search(list, left, right, find);    ///////recursion call to search
       }
     else //if value is not greater than nor equal to list[mid] it must be less than list[mid]
       {
       right = mid - 1;                    //set the right var to 1 less than the middle
       subset = binary_search(list, left, right, find);   ///////recursion call to search
       }
     }
   return (subset);  //pass back the index of the value in the list (-1 if not in list)
   } 