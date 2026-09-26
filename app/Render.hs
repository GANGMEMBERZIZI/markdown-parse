module Render where     
import Text.Printf
import Types    
import System.FilePath
htmlRender::FilePath->Name->[Block]->IO()
htmlRender path name token=writeFile (path </> replaceExtension name ".html") (htmlStruct name $ tokenTranslate token)
htmlStruct::FilePath->String->Html
htmlStruct name token = printf "<!DOCTYPE html>\n<html lang=\"en\">\n<head>\n<meta charset=\"UTF-8\">\n<meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">\n<title>%s</title>\n</head>\n<body>\n%s\n</body>\n</html>" (dropExtension name) token
tokenTranslate::[Block]->Html
tokenTranslate token=concatMap renderBlock token
renderBlock::Block->Html
renderBlock block=case block of
    Head n inlines -> 
        let innerHtml = concatMap renderInline inlines
        in printf "<h%d>%s</h%d>\n" n innerHtml n       
    Paragraph inlines -> 
        let innerHtml = concatMap renderInline inlines
        in printf "<p>%s</p>\n" innerHtml
renderInline :: Inline -> Html
renderInline inline = case inline of
    PlainText token-> token
    StrongText token-> printf "<strong>%s</strong>" token
    EmText token-> printf "<em>%s</em>" token
    TupleText token-> printf "<strong><em>%s</em></strong>" token
    Img inlineList urlstr titleOpt -> 
        let rawAltText=concatMap imgText inlineList 
        in printf "<img src=\"%s\" alt=\"%s\"%s>" urlstr rawAltText (renderTitle titleOpt)  
    Link inlineList urlstr titleOpt -> 
        let innerHtml = concatMap renderInline inlineList
        in printf "<a href=\"%s\"%s>%s</a>" urlstr (renderTitle titleOpt) innerHtml
    Email str-> 
        let prefix=if '@' `elem` str then "mailto:" else ""
        in printf "<a href=\"%s%s\">%s</a>" prefix str str
renderTitle::Maybe String->String
renderTitle (Just t)=printf " title=\"%s\"" t
renderTitle Nothing= ""
imgText::Inline->String
imgText (PlainText str)=str
imgText (StrongText str)=str
imgText (EmText str)=str
imgText (TupleText str)=str
imgText _= ""                                       