function halflife = gethalflife(zzz,aaa,stat,nubase)
% get the halflife of specific isotope in unit second

id1 = find(nubase{:,'zzz'}==zzz);
id2 = find(nubase{:,'aaa'}==aaa);
id3 = find(nubase{:,'state'}==stat);
id = intersect(intersect(id1,id2),id3);
halflife = nubase{id,'halflife'};

end % of function
