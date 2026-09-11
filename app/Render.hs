module Render where
import Text.Printf
import Types    
import System.FilePath
outputdir = "./output/"
htmlRender::Name->[Block]->IO()
htmlRender name token=writeFile (outputdir ++ replaceExtension name ".html") (htmlStruct name $ tokenTranslate token)
htmlStruct::FilePath->String->Html
htmlStruct name token = printf "<!DOCTYPE html>\n<html lang=\"en\">\n<head>\n<meta charset=\"UTF-8\">\n<meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">\n<title>%s</title>\n</head>\n<body>\n%s\n</body>\n</html>" (dropExtension name) token
tokenTranslate::[Block]->Html
tokenTranslate token=concatMap renderBlock token
renderBlock::Block->Html
renderBlock block=case block of
    Heading1 str->"<h1>"++ (concatMap renderInline str) ++ "</h1>\n"
    Heading2 str->"<h2>"++ (concatMap renderInline str) ++ "</h2>\n"
    Heading3 str->"<h3>"++ (concatMap renderInline str) ++ "</h3>\n"
    Heading4 str->"<h4>"++ (concatMap renderInline str) ++ "</h4>\n"
    Heading5 str->"<h5>"++ (concatMap renderInline str) ++ "</h5>\n"
    Heading6 str->"<h6>"++ (concatMap renderInline str) ++ "</h6>\n"
    Paragraph str->"<p>"++ (concatMap renderInline str) ++ "</p>\n"
renderInline::Inline->Html
renderInline str=case str of
    PlainText token->token
    StrongText token->"<strong>"++token++"</strong>"
    EmText token->"<em>"++token++"</em>"
    TupleText token->"<strong>"++"<em>"++token++"</em>"++"</strong>"
    Img altstr urlstr (Just titlestr)->printf "<img src=\"%s\" alt=\"%s\" title=\"%s\">" urlstr altstr titlestr
    Img altstr urlstr Nothing->printf "<img src=\"%s\" alt=\"%s\">" urlstr altstr
    Link namestr urlstr (Just titlestr)->printf "<a href=\"%s\" title=\"%s\">%s</a>" urlstr titlestr namestr
    Link namestr urlstr Nothing->printf "<a href=\"%s\">%s</a>" urlstr namestr
    Email str->if '@' `elem` str then printf "<a href=\"mailto:%s\">%s</a>" str str else printf "<a href=\"%s\">%s</a>" str str                          