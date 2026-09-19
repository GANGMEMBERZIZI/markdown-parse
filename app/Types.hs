module Types where
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
data Inline =PlainText String|StrongText String|EmText String|TupleText String|Img String String (Maybe String)|Link String String (Maybe String)|Email String deriving (Show,Eq)
data Error = Syntax Error|Lack
type Html=String 