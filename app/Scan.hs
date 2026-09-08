module Scan where
import Types    
scanToken::ContentFiles->[Token]
scanToken []=[]
scanToken ('\n':'\n':rest)=BlankLine:scanToken rest
scanToken ('*':'*':'*':rest)=TripleStars:scanToken rest 
scanToken ('*':'*':rest)=Strong:scanToken rest
scanToken ('*':rest)=Italic:scanToken rest
scanToken (' ':rest)=Space:scanToken rest
scanToken ('#':'#':'#':'#':'#':'#':rest)=HeadingSix:scanToken rest
scanToken ('#':'#':'#':'#':'#':rest)=HeadingFive:scanToken rest
scanToken ('#':'#':'#':'#':rest)=HeadingFour:scanToken rest
scanToken ('#':'#':'#':rest)=HeadingThree:scanToken rest
scanToken ('#':'#':rest)=HeadingTwo:scanToken rest
scanToken ('#':rest)=HeadingOne:scanToken rest
scanToken ('!':rest)=ImageStart:scanToken rest
scanToken ('[':rest)=LeftBracket:scanToken rest
scanToken (']':rest)=RightBracket:scanToken rest
scanToken ('(':rest)=LeftParen:scanToken rest
scanToken (')':rest)=RightParen:scanToken rest
scanToken ('<':rest)=LeftAngle:scanToken rest
scanToken ('>':rest)=RightAngle:scanToken rest
scanToken ('"':rest)=Reference:scanToken rest
scanToken ('\n':rest)=NewLine:scanToken rest
scanToken str=
    let 
        isNormalChar c = c `notElem` ['#',' ','\n','*','!','[',']','(',')','"','<','>']
        (text,rest)=span isNormalChar str
    in Text text:scanToken rest
    



    


          