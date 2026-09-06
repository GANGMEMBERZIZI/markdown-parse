module Render where
import Types    
import System.FilePath
outputdir = "./output/"
htmlRender::Name->[Block]->IO()
htmlRender name token=writeFile (outputdir ++ replaceExtension name ".html") (tokenTranslate token)
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