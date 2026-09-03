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
    Heading str->"<h1>"++ (concatMap renderInline str) ++ "</h1>\n"
    Paragraph str->"<p>"++ (concatMap renderInline str) ++ "</p>\n"
renderInline::Inline->Html
renderInline str=case str of
    PlainText token->token
    StrongText token->"<strong>"++token++"</strong>"                         