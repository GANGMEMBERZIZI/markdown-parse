module Parser where
import Types    
blockCut::[Token]->[[Token]]
blockCut []=[]
blockCut (BlankLine:rest)=blockCut rest
blockCut token=    
   let (xs,rest)=span process token
   in xs : blockCut rest
   where process=(/=BlankLine)
blockParser::[[Token]]->[Block]
blockParser token=map parser token
parser::[Token]->Block
parser (HeadingOne:Space:rest)=Heading (inlineParser rest)
parser token=Paragraph (inlineParser token)
inlineParser::[Token]->[Inline]
inlineParser []=[]
inlineParser (Text str:rest)=PlainText str:inlineParser rest
inlineParser (Strong:Text str:Strong:rest)=StrongText str:inlineParser rest
inlineParser (Space:rest)=PlainText " ":inlineParser rest
inlineParser (_:rest)=inlineParser rest         