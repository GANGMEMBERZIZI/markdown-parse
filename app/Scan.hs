module Scan where
import Types
singleCharTokens::[(Char,Token)]
singleCharTokens=[(' ',Space),('!',ImageStart),('[',LeftBracket),(']',RightBracket),('(',LeftParen),(')',RightParen),('<',LeftAngle),('>',RightAngle),('"',Reference),('\n',NewLine)]    
scanToken::ContentFiles->[Token]
scanToken []=[]
scanToken ('\n':'\n':rest)=BlankLine:scanToken rest
scanToken ('#':rest)=
    let (target,remain)=span (=='#') ('#':rest)
    in if length target<7 then Heading (length target):scanToken remain
    else Text target:scanToken remain
scanToken ('*':rest)=
    let (target,remain)=span (=='*') ('*':rest)
    in case length target of 
        1->Italic:scanToken remain
        2->Strong:scanToken remain
        3->TripleStars:scanToken remain
        _->Text target:scanToken remain
scanToken str@(c:rest)
    | Just token<-lookup c singleCharTokens=token:scanToken rest
    | otherwise=
        let 
           isNormalChar x=x `notElem` ['#',' ','\n','*','!','[',']','(',')','"','<','>']
           (text,remain)=span isNormalChar str
        in Text text:scanToken remain
    



    


          