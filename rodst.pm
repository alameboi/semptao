module rodst;

var $n : tuple of atom := atom[];

var $ch : tuple of atom := atom[Ivan, Ekaterina];

var $win1;
var $wy : integer := 20;

rule input
   forall $x: Person( name: $name )
=>
   $n := $n + atom[$name];
end;

rule input1
=>
   var $m1,$m2 : integer;
   $m1 := Menu(400,50," Choose a person", $n, 1 ); 
   $ch[1]:= $n[$m1];
   OutText( $win1, 50, $wy, $ch[1]);
   $wy:=$wy+15;
   $m2 := Menu(400,50," Choose a second person", $n, 1 ); 
   $ch[2]:= $n[$m2];
   OutText( $win1, 50, $wy, $ch[2]);
   $wy:=$wy+30;
end;

rule input2
exist $x: Person( name:$namex ),
      $y: Person( name:$namey )
  when ( $namex = $ch[1] ) & ( $namey = $ch[2] )
=> 
  new rodstv($x, $y);
end;

rule Stop
=>
  activate group();
end;

rule ChildrenOfParents
  forall $x: Person( parents: $par )
  when #$par != 0
=>
  for $i in $par loop
       edit   $i: Person( children:  $i.children + Person{$x} ); 
  end;
end;

rule ParentsOfChildren
  forall $x: Person(  spouse: $spouse, children: $children )
  when (#$children != 0) & ($spouse != ?)
=>
  if #$spouse.children = 0
  then edit   $spouse: Person( children: $children );
  end;
  for $ii in $children loop
      if #$ii.parents != 2
      then edit   $ii: Person( parents: Person{$x, $spouse }); 
      end; 
  end;
end;

/*----------------------------------------------------------------*/

rule MotherFather
exist $rod : rodstv(kto: $x, komu: $y),
      $x: Person( parents: $par )
      when ( #$par != 0 ) & ( $y in $par )
=>
      if $y.sex = male 
      then   
           OutText( $win1, 50, $wy, ToString($y.name)+ " father of "+ ToString($x.name) );
      else 
           OutText( $win1, 50, $wy,ToString($y.name)+ " mother of "+ToString($x.name) );
       end; 
      
      $wy := $wy + 15;

      if $x.sex = male
      then  
           OutText( $win1, 50, $wy, ToString($x.name) + " son of " + ToString($y.name) );
      else  
           OutText( $win1, 50, $wy, ToString($x.name)+ " daughter of " + ToString($y.name) );
      end; 
      $wy := $wy + 30; 
finish
      activate group();
end;


rule BrotherSister
exist $rod : rodstv(kto: $x, komu: $y),
      $x: Person( parents: $par1 ),
      $y: Person( parents: $par2 )
      when ( $par1 != ? ) & ( $par1 = $par2 )
=>
      if $y.sex = male 
      then   
           OutText( $win1, 50, $wy, ToString($y.name)+ " brother of "+ ToString($x.name) );
      else 
           OutText( $win1, 50, $wy,ToString($y.name)+ " sister of "+ToString($x.name) );
       end; 
      
      $wy := $wy + 15;

      if $x.sex = male
      then  
           OutText( $win1, 50, $wy, ToString($x.name) + " brother of " + ToString($y.name) );
      else  
           OutText( $win1, 50, $wy, ToString($x.name)+ " sister of " + ToString($y.name) );
      end; 
      $wy := $wy + 30; 
finish
      activate group();
end;

rule Spouse
  exist $rod : rodstv(kto: $x, komu: $y ),
        $x: Person( spouse: $y )
=>
         if $x.sex = male 
         then   
             OutText( $win1, 50, $wy, ToString($x.name) + " husband of " + ToString($y.name) );
         else 
             OutText( $win1, 50, $wy, ToString($x.name) + " wife of " + ToString($y.name) );
         end; 

         $wy := $wy + 15;   

         if $y.sex = male
         then  
             OutText( $win1, 50, $wy, ToString($y.name) + " husband of " + ToString($x.name) );
         else  
             OutText( $win1, 50, $wy, ToString($y.name) + " wife of " + ToString($x.name) );
         end; 

      $wy := $wy + 30;   
finish
	activate group();
end;

rule Zyat  
exist $rod : rodstv(kto: $x, komu: $y ),
      $x: Person( spouse: $sp ),
      $sp: Person( parents: $par)
      when (#$par != 0) & ($sp != ?) & ( $y in $par )
=>
         if $x.sex = male 
         then   
             OutText( $win1, 50, $wy, ToString($x.name) + "  zyat' (son-in-law) of " + ToString($y.name) );
	 end;

         $wy := $wy + 15;   

         if $y.sex = male
         then  
             OutText( $win1, 50, $wy, ToString($y.name) + "  father-in-law of " + ToString($x.name) );
         else  
             OutText( $win1, 50, $wy, ToString($y.name) + "  mother-in-law of " + ToString($x.name) );
         end; 

      $wy := $wy + 30;   
finish
	activate group();
end;


rule NotRelatives
  exist $rod : rodstv(kto: $x, komu: $y)
=>
  OutText( $win1, 50, $wy, ToString($x.name) + " not relatives with " + ToString($y.name) );
end;




var $rules : group := group( ChildrenOfParents, ParentsOfChildren, input, input1, input2, 
                              MotherFather, BrotherSister,
                              Spouse, Zyat,
			      NotRelatives, Stop );

begin
  new

    @Ivan: Person (  name: Ivan, sex: male ),

    @Ekaterina: Person (  name: Ekaterina,  spouse: @Ivan ),

    @Alexandr: Person (  name: Alexandr ),

    @Anna: Person (  name: Inna, sex: female, spouse: @Alexandr ),

    @Lena: Person (  name: Lena, sex: female ),

    @Misha: Person (  name: Misha, sex: male ),

    @Vasya: Person (  name: Vasya, sex: male ),

    @Valentina: Person (  name: Valentina, sex: female, 
  	                parents: (Person { @Ekaterina , @Ivan  }) ),

    @Andrey: Person (  name: Andrey, sex: male, 
                      spouse: @Valentina, 
        	      children: (Person{ @Lena , @Misha, @Vasya }) ,
        	      parents: Person{ @Alexandr, @Anna } ),

    @Olya: Person (  name: Olya, sex: female ), 
 
    @Dima: Person (  name: Dima, sex: male ), 

    @Sergey: Person (  name: Sergey, sex: male, 
	                parents: Person { @Ekaterina, @Ivan } ),

    @Inna: Person (  name: Inna, sex: female, 
   	                  spouse: @Sergey,
	                  children: Person { @Olya, @Dima } ), 
	
    @Natasha: Person (  name: Natasha, sex: female ),
 
    @Anya: Person (  name: Anya, sex: female ), 
 
    @Lyudmila: Person (  name: Lyudmila, sex: female, 
	              children: Person { @Natasha, @Anya } ,
	              parents: Person { @Alexandr , @Anna} ),

    @Vladimir: Person (  name: Vladimir,
	              spouse: @Lyudmila ), 
 
    @Tamara: Person (  name: Tamara  ), 

    @Lyosha: Person (  name: Lyosha, sex: male ), 

    @Ira: Person (  name: Ira, sex: female ),

    @Pyotr: Person (  name: Pyotr, sex: male, 
 	                spouse: @Tamara, 
	                children: Person { @Lyosha, @Ira },
	                parents: Person { @Alexandr , @Anna } );


   $win1 := MakeWindow(" Relatives ", 0,0,1010,640);  
   TextColor($win1,4);
   call $rules;
   if (Ask(" End of session ", " Close window? "))
   then  CloseWindow($win1);
   end; 
WriteNet();

end.
