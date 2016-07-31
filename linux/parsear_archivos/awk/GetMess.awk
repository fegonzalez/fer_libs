{
    while (($0!~/^Message name /) && ($0!~/^<End of ADBS/)){
        getline
        if ($0~/^  SOURCE/){ 
            SOURCENAME=gensub (/ /,"","g",substr($0,17, 5))
            SOURCEADDR=substr($0,65, 2)
            SOURCESUBADDR=gensub (/ /,"","g",substr($0,110, 3))
        } 
        if ($0~/^    SINK/){ 
            SINKNAME=gensub (/ /,"","g",substr($0,17, 5))
            SINKSUBADDR=gensub (/ /,"","g",substr($0,110, 3))
        } 


    }


    if ($0!~/^<End of ADBS/) { 

    if (MessageName!=$4) {
       MessageName=$4
    }

    getline
    getline

    while ($0!~/^---+/){
         getline
    }

    getline

    while (($0!~/^____/)&&($0!~/^Message name /)) { 
     
       if ( (substr($0,10, 3)!~/   /) ) {

          if (strtonum(substr($0,5, 4))!=0) WORD = gensub (/ /,"","g",substr($0,5, 4)) 

          MSB  = gensub (/ /,"","g",substr($0,10, 3)) 
          VARIABLE = gensub (/ /,"","g",substr($0,14,37)) 
          DATATYPE = gensub (/ /,"","g",substr($0,52,20)) 

          getline
          if (($0~/^____/)||($0~/^Message name /)){
             printf("\n%s\t%2.2s\t%2.2s\t%s\t%2.2s\t%s\t%s\t%s\t%s\t%s",SOURCENAME,SOURCEADDR,SOURCESUBADDR,SINKNAME, SINKSUBADDR,MessageName,VARIABLE,WORD,MSB,DATATYPE)
             break
          }
            if ( (substr($0,10, 3)~/   /) && (VARIABLE2!~/   / || DATATYPE2!~/   /) && (length ($0)!=0)){
  
                VARIABLE2 = gensub (/ /,"","g",substr($0,14,37))
                DATATYPE2 = gensub (/ /,"","g",substr($0,52,20))
                printf("\n%s\t%2.2s\t%2.2s\t%s\t%2.2s\t%s\t%s%s\t%s\t%s\t%s%s",SOURCENAME,SOURCEADDR,SOURCESUBADDR,SINKNAME, SINKSUBADDR,MessageName,VARIABLE,VARIABLE2,WORD,MSB,DATATYPE,DATATYPE2)
                while ((length ($0)==0)||(substr($0,10, 3)~/   /)) getline

            }else{

                printf("\n%s\t%2.2s\t%2.2s\t%s\t%2.2s\t%s\t%s\t%s\t%s\t%s",SOURCENAME,SOURCEADDR,SOURCESUBADDR,SINKNAME, SINKSUBADDR,MessageName,VARIABLE,WORD,MSB,DATATYPE)
                if ((length ($0)==0)|| (substr($0,10, 3)~/   /)) while ((length ($0)==0)||(substr($0,10, 3)~/   /)) getline                
            }

      
       }else {

           while (length ($0)==0) getline
      }
    }
 }
}
