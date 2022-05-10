definition med;

type Sex = atom( male, fem ); 

type Symptom = string("frequent fractures","decreased immunity","poor blood clotting","high blood pressure","cardiac arrhythmia");

type Feeling = string("muscle cramps","muscle pain","numbness and tingling in the limbs","hyperexcitability","cold intolerance","irritability","fatigue");

type Factor = string("brain injury","excess phosphorus","vit D deficiency","pregnancy","lactation","use of diuretics","use of laxatives","age > 40",
		     "insufficient consumption of cereals","excessive consumption of carbonated drinks","excessive consumption of canned food",
		     "stress","chronic overexertion","excessive coffee consumption", "blood loss");

type Des = string("allergy", "hypertension", "Fe deficiency", "anemia");

type Analysis = string("general blood analysis", "general urine analysis", "blood sugar test", "lipid spectrum blood test", "microelement analysis of hair");

type Elem = atom( Al, As, Be, Br, Bi, Ca, Cd, Co, Cr, Cu, Fe, Hg, I, K, Mg, Mn, Mo, 
                  Na, Ni, P, Pb, Rb, S, Se, Si, Sr, Ti, V, Zn );


type CureType = string("medicine", "product", "procedure"); 

class AnalysisResult 
   name: string;   
   value: real := real(0..32000);   
end;

class Indicator
  name: string;
  start_date: string;
  duration : string; 
  kind : atom ( objective, subjective );
  weight : integer := 1; 
end;


class ISymptom (Indicator)
  name: Symptom;
end;

class IFeeling(Indicator)
  name: Feeling;
end;

class IFactor (Indicator)
  name: Factor;
end;

class IAccompDesease (Indicator)
  name: Des;
end;

class IAnalysis (Indicator)
  name: Analysis;
  kind: atom := objective;
  anres :  set of AnalysisResult := AnalysisResult {};
end;


class Desease
  name: string;
  sympt: set of ISymptom := ISymptom {};
  feel: set of IFeeling := IFeeling {};
  fact: set of IFactor := IFactor {};
  an: set of IAnalysis := IAnalysis {};
  anres : set of AnalysisResult := AnalysisResult {};
  acdes: set of IAccompDesease := IAccompDesease {}; 
  ind: set of Indicator := Indicator {};
end;

class Pacient
  last_name: string;	
  first_name: string;
  sex: Sex;
  birth_date: string;
  deseases: set of Desease := Desease {};
end;

class Examination
  pac: Pacient;
  ind: set of Indicator := Indicator {};
  an: set of IAnalysis := IAnalysis {};
  anres : set of AnalysisResult := AnalysisResult {};
  date: string;
end;

class Diagnosis
  pac: Pacient;
  des: Desease;
  weight: integer:=0;
  date: string; 
  ind: tuple of string := string[];
end;


class ElemAxcDef (Desease)
  elem: Elem;
  status: atom ( excess, deficiency);
end;

structure CurePlan
   num : integer;
   des : Desease;
   descr: string; 
end;

class Cure
   name: string;
   kind: CureType;
   plan: set of CurePlan := CurePlan {};
   contr: set of Desease := Desease {};  
end;

end.