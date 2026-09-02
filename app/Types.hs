module Types where
type NameFiles=[String]
type ContentFiles=String
data Token=
    HeadingOne
    | Text String
    | Space
    | Strong
    | BlankLine
  deriving (Show)   
type Html=String 