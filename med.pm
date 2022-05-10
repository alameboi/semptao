module med;


rule hypothesis
   forall $x: Desease( name: $name )
=>
   new Diagnosis(des: $x);
    
end;

function deseaseIndicators($d: Desease )
begin
var  $ind: set of Indicator := Indicator {};
     for $i in $d.sympt loop
         $ind := $ind + Indicator{$i};
     end;
     for $i in $d.feel loop
         $ind := $ind + Indicator{$i};
     end;
     for $i in $d.fact loop
         $ind := $ind + Indicator{$i};
     end;
     for $i in $d.acdes loop
         $ind := $ind + Indicator{$i};
     end;

WriteLn("Name: ", $d.name);
     return $ind;
end;

rule diagnosisSet
   forall $x: Diagnosis( des:$d, ind: $ind1 ), $y: Examination( pac: $pac, ind: $ind2, date: $date )
   when # $ind2 <> 0
=>
var $w : integer :=0;
var $m : integer;
var $setind: set of Indicator;
   $setind := deseaseIndicators($d);

   edit $x: Diagnosis( pac: $pac, date: $date);
   
   for $i in $ind2 loop
     for $j in $setind loop
           if $i.name = $j.name
           then 
               $ind1 := $ind1 + string[$i.name];
	       $w := $w + $j.weight * $i.weight;
               edit $x: Diagnosis( weight: $w, ind: $ind1 );
           end;
     end;
   end; 
end;


rule printDiagnosis
   forall $x: Diagnosis( pac: $pac, des: $d ), $pac: Pacient( deseases: $des )
   when $x.weight > 0
=>
   $des := $des + Desease{$d};
   edit $pac: Pacient( deseases: $des );
   WriteLn($x);
end;


rule cureSet
   forall $x: Diagnosis( pac: $pac, des: $d ), $y: Cure( )
   when $x.weight != 0
=>
     for $i in $y.ind loop
         if ($d = $i.des) & #($pac.deseases * $y.contr) = 0
         then 
            WriteLn("Pacient ", $x.pac.last_name, " prescribed ", $y.kind, " ", $y.name, ": ", $i.descr );
         end; 
     end;
end;


rule printExplanations
   forall $x: Diagnosis( des: $d, ind: $ind )
   when ($x.weight != 0 ) & ($ind != ?)
=>
   WriteLn("Desease ", $d.name, " indicators pacient ", $x.pac.last_name, " has :" );
   for $i in $ind loop
     WriteLn( $i );
   end;
end;


rule Stop
=>
  activate group();
end;


var $rules :  group := group( hypothesis, diagnosisSet, printDiagnosis, cureSet, printExplanations, Stop );

begin
new 
   
   @Can : ElemAxcDef 
        ( name: "Ca Deficiency",
          elem: Ca,
	  status: deficiency, 
          sympt: ISymptom { ISymptom ( name: "frequent fractures", weight:2), 
			    ISymptom ( name: "decreased immunity", weight:1), 
			    ISymptom ( name: "poor blood clotting", weight:1), 
                            ISymptom ( name: "high blood pressure", weight:1),
			    ISymptom ( name: "cardiac arrhythmia", weight:1)},
          feel: IFeeling { IFeeling(name: "muscle cramps", weight:1),
			   IFeeling(name: "muscle pain", weight:1),
			   IFeeling(name: "numbness and tingling in the limbs", weight:1),
			   IFeeling(name: "hyperexcitability", weight:1)},
          fact: IFactor { IFactor (name: "brain injury", weight:1),
			  IFactor (name: "excess phosphorus", weight:1),
			  IFactor (name: "vit D deficiency", weight:1),
			  IFactor (name: "pregnancy", weight:1),
			  IFactor (name: "lactation", weight:1),
			  IFactor (name: "use of diuretics", weight:1),
			  IFactor (name: "use of laxatives", weight:1),
			  IFactor (name: "age > 40", weight:1)},
          an: IAnalysis { IAnalysis (name: "microelement analysis of hair", anres: AnalysisResult {AnalysisResult (name:"Ca", value: real(150..220)), AnalysisResult (name: "sed rate", value: 100)})}, 
          acdes: IAccompDesease { IAccompDesease (name: "allergy", weight: 1)} ),

   @Mgn : ElemAxcDef 
        ( name: "Mg deficiency",
          elem: Mg, 
	  status: deficiency,
          sympt: ISymptom { ISymptom ( name: "high blood pressure", weight:2 ), ISymptom ( name: "cardiac arrhythmia", weight:1 ) },
          feel: IFeeling { IFeeling ( name: "cold intolerance", weight:1 ), IFeeling ( name: "irritability", weight:1 ), IFeeling ( name: "fatigue", weight:1)},
          fact: IFactor { IFactor ( name: "insufficient consumption of cereals", weight:1 ), 
			  IFactor ( name: "excessive consumption of carbonated drinks", weight:1 ), 
			  IFactor ( name: "excessive consumption of canned food", weight:1 ),
			  IFactor ( name: "stress", weight:1 ),
			  IFactor ( name: "chronic overexertion", weight:1 ),
			  IFactor ( name: "excessive coffee consumption", weight:1)} ),

   @Fen : ElemAxcDef 
        ( name: "Fe deficiency",
          elem: Fe,
	  status: deficiency,
          sympt: ISymptom { ISymptom ( name: "decreased immunity", weight:2 )},
          feel: IFeeling { IFeeling ( name: "fatigue", weight:1 )},
          fact: IFactor { IFactor ( name: "brain injury", weight:2 ), IFactor ( name: "blood loss", weight:1) },
          acdes: IAccompDesease { IAccompDesease ( name: "anemia", weight:3 ) } ),

   @Sl : Cure ( name: "calcium gluconate", kind: "medicine",
                plan: CurePlan {CurePlan (des: @Can, descr: "2 0.1 mg pills 3 times a day" ), CurePlan (des: @Mgn , descr:"1 0.1 mg pill once a day" ) }),
 
   @S2 : Cure ( name: "calcimag", kind: "medicine",
                plan: CurePlan {CurePlan (des: @Can, descr: "3 0.5 mg pills 2 times a day" ), CurePlan (des: @Mgn , descr: "1 0.1 mg pill once a day" ) },
               	contr: Desease  {@Fen} ),

  @Pac1 : Pacient 
        ( last_name: "Sidorov",	
          first_name: "Dima",
          sex: male,
          birth_date: "27.9.1977"),


   @Ex27_02_2022: Examination
        ( pac: @Pac1,
          ind: Indicator {  Indicator (name: "frequent fractures", weight:1), Indicator (name: "high blood pressure", weight:2), 
                            Indicator (name: "muscle pain", weight:3), Indicator (name: "cold intolerance", weight:5), 
                            Indicator (name: "vit D deficiency", weight:3), Indicator (name: "excessive consumption of carbonated drinks", weight:2),
                            Indicator (name: "stress", weight:3), Indicator (name: "Fe deficiency", weight:4), Indicator (name: "anemia", weight:3) },
          anres: AnalysisResult {AnalysisResult (name: "blood pressure h", value:150), AnalysisResult (name: "blood pressure l", value:100), 
                          	 AnalysisResult (name: "temperature", value:36.7), AnalysisResult (name: "pulse", value:90), AnalysisResult (name: "height", value:182), 
                          	 AnalysisResult (name: "weight", value: 97)}, 
          an: IAnalysis {IAnalysis (name: "general blood analysis", anres: AnalysisResult {AnalysisResult (name: "erythrocytes", value:150),
			 						   		   AnalysisResult (name: "sed rate", value:100)}), 
                         IAnalysis (name: "general urine analysis", anres: AnalysisResult {AnalysisResult (name: "protein", value:150), 
											   AnalysisResult (name: "leukocytes", value:100)})},
          date: "27_02_2022");
 

   call rules;

end.