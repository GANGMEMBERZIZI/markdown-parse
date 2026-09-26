module Parser where
import Types
import Control.Applicative    
satisfy::(Token->Bool)->Parser Token
satisfy judge=Parser $ \tokens->case tokens of
    []->Nothing
    (t:remain)->if judge t then Just (t,remain) else Nothing
matchToken::Token->Parser Token
matchToken expected=satisfy (== expected)
skip::Parser ()
skip=do
    _<-matchToken NewLine <|> matchToken BlankLine
    return () 
parseTextString::Parser String
parseTextString=do
    t<-satisfy (\tok->case tok of 
        Text _ ->True
        _->False)
    let (Text str)=t
    return str
parseTitle::Parser String
parseTitle=do
    _<-matchToken Space
    _<-matchToken Reference
    titlestr<-parseTextString
    _<-matchToken Reference
    return titlestr    
parseStrong::Parser Inline
parseStrong=do
    _<-matchToken Strong
    str<-parseTextString    
    _<-matchToken Strong
    return (StrongText str)
parseEmph::Parser Inline
parseEmph=do
    _<-matchToken Italic
    str<-parseTextString
    _<-matchToken Italic
    return (EmText str)
parseTuple::Parser Inline
parseTuple=do
    _<-matchToken TripleStars
    str<-parseTextString
    _<-matchToken TripleStars
    return (TupleText str)
parseText::Parser Inline
parseText=do
    str<-parseTextString
    return (PlainText str)
parseEmail::Parser Inline                      
parseEmail=do
    _<-matchToken LeftAngle
    str<-parseTextString
    _<-matchToken RightAngle 
    return (Email str)
parseLinkOrImg::Parser Inline     
parseLinkOrImg=do
    isImg<-optional (matchToken ImageStart)
    _<-matchToken LeftBracket
    content<-many parseInline
    _<-matchToken RightBracket
    _<-matchToken LeftParen
    url<-parseTextString
    title<-optional parseTitle
    _<-matchToken RightParen
    case isImg of 
        Just _ ->return (Img content url title)
        Nothing ->return (Link content url title)
parseInline :: Parser Inline
parseInline = parseTuple <|> parseStrong <|> parseEmph <|> parseEmail <|> parseLinkOrImg <|> parseText   
parseHeading::Parser Block
parseHeading=do
    hToken<-satisfy (\tok->case tok of 
        Heading _ ->True
        _->False)
    let (Heading level)=hToken    
    _<-matchToken Space
    inlines<-some parseInline
    _<-many skip
    return (Head level inlines)
parsePara::Parser Block
parsePara=do
    inlines<-some parseInline
    _<-many skip
    return (Paragraph inlines)
parseToken::Parser [Block]
parseToken=many (parseHeading <|> parsePara)
runAST::[Token]->[Block]
runAST tokens=case runParser parseToken tokens of
    Just (ast,_)->ast
    Nothing->[]  




