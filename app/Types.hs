module Types where
import Control.Applicative (Alternative(..))
type Name=String
type NameFiles=[String]
type ContentFiles=String
data Token=
    Heading Int
    | Text String
    | Space
    | Strong
    | Italic
    | TripleStars 
    | ImageStart
    | LeftBracket
    | RightBracket
    | LeftParen
    | RightParen
    | LeftAngle
    | RightAngle
    | Reference   
    | NewLine
    | BlankLine
  deriving (Show,Eq)
data Block =Head Int [Inline]|Paragraph [Inline] deriving (Show,Eq)
data Inline =PlainText String|StrongText String|EmText String|TupleText String|Img [Inline] String (Maybe String)|Link [Inline] String (Maybe String)|Email String deriving (Show,Eq)
newtype Parser a=Parser {runParser::[Token]->Maybe (a, [Token])}
instance Functor Parser where
  fmap f (Parser p)=Parser $ \tokens->do
    (result,remain)<-p tokens
    return (f result,remain)
instance Applicative Parser where
  pure x=Parser $ \tokens->Just (x,tokens)
  Parser p1 <*> Parser p2=Parser $ \tokens->do
    (f,middle)<-p1 tokens
    (result,remain)<-p2 middle
    return (f result,remain)
-- >>=::Parser a->(a->Parser b)->Parser b    
instance Monad Parser where
  (Parser p)>>=f=Parser $ \tokens->do
    (result,remain)<-p tokens
    runParser (f result) remain
instance Alternative Parser where
  empty=Parser $ \_->Nothing
  (Parser a) <|> (Parser b)=Parser $ \tokens->
    a tokens <|> b tokens
data Error = Syntax Error|Lack
type Html=String 