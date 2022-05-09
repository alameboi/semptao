definition rodst;

type Sex = atom( male, female );

class Person;

class Person
  name:		atom;
  sex:		Sex;
  spouse:	Person;
  children:	set of Person := Person{};      
  parents: 	set of Person := Person{};
constraints
  p_sex: sex != spouse.sex;
  p_spouse: spouse.spouse = $;
  p_children: children = spouse.children;
end;

relation rodstv ( kto: Person; komu: Person)
sym;
end;

end.