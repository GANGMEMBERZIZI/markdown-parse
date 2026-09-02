import System.IO
import System.Directory
import System.FilePath
import GHC.IO.Encoding
import Types
import Parser
import Render
import Scan
main=do
    setLocaleEncoding utf8
    let inputdir="./input"
        outputdir="./output"
    allFiles<-listDirectory inputdir
    let nameFiles=filter (isExtensionOf ".md") allFiles
    contentFiles<-mapM (\name->do
        let path=inputdir </> name
        readFile' path 
        ) nameFiles
    let xs=map scanToken contentFiles   
      
         
    