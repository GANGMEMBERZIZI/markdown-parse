module Parser where
import Types    
blockCut::[Token]->[[Token]]
blockCut []=[]
blockCut (BlankLine:rest)=blockCut rest
blockCut (HeadingOne:Space:rest)=
   let (xs,remain)=span (/= NewLine) rest
   in (HeadingOne:Space:xs):blockCut (dropNewLine remain)
blockCut (HeadingTwo:Space:rest)=
   let (xs,remain)=span (/=NewLine) rest
   in (HeadingTwo:Space:xs):blockCut (dropNewLine remain)
blockCut (HeadingThree:Space:rest)=
   let (xs,remain)=span (/=NewLine) rest
   in (HeadingThree:Space:xs):blockCut (dropNewLine remain)
blockCut (HeadingFour:Space:rest)=
   let (xs,remain)=span (/=NewLine) rest
   in (HeadingFour:Space:xs):blockCut (dropNewLine remain)
blockCut (HeadingFive:Space:rest)=
   let (xs,remain)=span (/=NewLine) rest
   in (HeadingFive:Space:xs):blockCut (dropNewLine remain)
blockCut (HeadingSix:Space:rest)=
   let (xs,remain)=span (/=NewLine) rest
   in (HeadingSix:Space:xs):blockCut (dropNewLine remain)
blockCut token=
   let (xs,rest)=span (/= BlankLine) token
   in xs:blockCut rest                
dropNewLine::[Token]->[Token]
dropNewLine []=[]
dropNewLine (NewLine:xs)=xs
dropNewLine token=token
blockParser::[[Token]]->[Block]
blockParser token=map parser token
parser::[Token]->Block
parser (HeadingOne:Space:rest)=Heading1 (inlineParser rest)
parser (HeadingTwo:Space:rest)=Heading2 (inlineParser rest)
parser (HeadingThree:Space:rest)=Heading3 (inlineParser rest)
parser (HeadingFour:Space:rest)=Heading4 (inlineParser rest)
parser (HeadingFive:Space:rest)=Heading5 (inlineParser rest)
parser (HeadingSix:Space:rest)=Heading6 (inlineParser rest)
parser token=Paragraph (inlineParser token)
inlineParser::[Token]->[Inline]
inlineParser []=[]
inlineParser (Text str:rest)=PlainText str:inlineParser rest
inlineParser (Italic:rest)=
    let (str,remain) =semanticParser rest
    in EmText str : inlineParser remain
inlineParser (Strong:rest) =
    let (str, remain) = semanticParser rest
    in StrongText str : inlineParser remain
inlineParser (TripleStars:rest)=
    let (str,remain) = semanticParser rest
    in TupleText str:inlineParser remain
inlineParser (ImageStart:LeftBracket:Text altstr:RightBracket:LeftParen:Text urlstr:Space:Reference:rest)=
    let (titlestr,remain)=semanticParser rest
    in Img altstr urlstr (Just titlestr):inlineParser remain
inlineParser (ImageStart:LeftBracket:Text altstr:RightBracket:LeftParen:Text urlstr:RightParen:rest)=
    Img altstr urlstr Nothing:inlineParser rest    
inlineParser (LeftBracket:Text namestr:RightBracket:LeftParen:Text urlstr:Space:Reference:rest)=
    let (titlestr,remain)=semanticParser rest
    in Link namestr urlstr (Just titlestr):inlineParser remain
inlineParser (LeftBracket:Text namestr:RightBracket:LeftParen:Text urlstr:RightParen:rest)=
    Link namestr urlstr Nothing:inlineParser rest    
inlineParser (LeftAngle:Text str:RightAngle:rest)=Email str:inlineParser rest        
inlineParser (Space:rest)=PlainText " ":inlineParser rest
inlineParser (_:rest)=inlineParser rest      
semanticParser::[Token]->(String,[Token])
semanticParser []=("",[])
semanticParser (Strong:rest) =
    ("", rest)
semanticParser (Italic:rest) =
    ("", rest)
semanticParser (TripleStars:rest)=
    ("",rest)
semanticParser (Reference:RightParen:rest)=
    ("",rest)                
semanticParser (Text str:rest) =
    let (content, remain) = semanticParser rest
    in (str ++ content, remain)
semanticParser (Space:rest) =
    let (content, remain) = semanticParser rest
    in (" " ++ content, remain)
semanticParser (NewLine:rest) =
    let (content, remain) = semanticParser rest
    in ("\n" ++ content, remain)
semanticParser (_:rest) =
    semanticParser rest