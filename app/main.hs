import System.IO
import System.Directory
import System.FilePath
import GHC.IO.Encoding
import Data.Typeable (typeOf)
import Control.Monad (forM_)
import Types
import Parser
import Render
import Scan
main=do
    setLocaleEncoding utf8
    let inputdir="./input"            
    allFiles<-listDirectory inputdir
    let nameFiles=filter (isExtensionOf ".md") allFiles
    contentFiles<-mapM (\name->do
        let path=inputdir </> name
        readFile' path 
        ) nameFiles
    -- print contentFiles    
    let token=map scanToken contentFiles
    -- print token
    let astToken=map blockParser (map blockCut token)
    -- print astToken   
    forM_ (zip nameFiles astToken) $ \(name,ast)->
        htmlRender name ast
    putStrLn "编译完成"                
         
    