module Types where
type Name=String
type NameFiles=[String]
type ContentFiles=String
data Token=
    HeadingOne
    | Text String
    | Space
    | Strong
    | BlankLine
  deriving (Show,Eq)
data Block =Heading [Inline]|Paragraph [Inline] deriving (Show,Eq)
data Inline =PlainText String|StrongText String deriving (Show,Eq)
data Error = Syntax Error|Lack
type Html=String 