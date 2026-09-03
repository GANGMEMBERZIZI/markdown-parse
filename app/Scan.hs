module Scan where
import Types    
scanToken::ContentFiles->[Token]
scanToken []=[]
scanToken ('\n':'\n':rest)=BlankLine:scanToken rest
scanToken ('*':'*':rest)=Strong:scanToken rest
scanToken (' ':rest)=Space:scanToken rest
scanToken ('#':rest)=HeadingOne:scanToken rest
scanToken ('*':rest)=Text "*":scanToken rest
scanToken ('\n':rest)=Text "\n":scanToken rest
scanToken str=
    let 
        isNormalChar c=c `notElem` ['#', ' ', '\n', '*']
        (text,rest)=span isNormalChar str
    in Text text:scanToken rest    



    


          