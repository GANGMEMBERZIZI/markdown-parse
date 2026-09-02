module Types where
type nameFiles=[String]
type contentFiles=String
data Token=
    HeadingStart
    | Text String
    | StrongStart
    | StrongEnd
type html=String 