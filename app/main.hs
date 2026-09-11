import System.IO
import System.Directory
import System.IO.Error
import Control.Exception
import System.FilePath
import GHC.IO.Encoding
import Control.Monad (forM_)
import Types
import Parser
import Render
import Scan
main=toTry `catch` handler
toTry=do
    setLocaleEncoding utf8
    let inputdir="./input"
    createDirectoryIfMissing True "input"           
    allFiles<-listDirectory inputdir
    let nameFiles=filter (isExtensionOf ".md") allFiles
    if null nameFiles then putStrLn "input里没文件"
    else do
            contentFiles<-mapM (\name->do
                let path=inputdir </> name
                readFile' path 
                ) nameFiles    
            let token=map scanToken contentFiles
            -- print token
            let astToken=map blockParser (map blockCut token)
            -- print astToken
            createDirectoryIfMissing True "output"  
            forM_ (zip nameFiles astToken) $ \(name,ast)->
                htmlRender name ast
            putStrLn "编译完成"
handler::IOError->IO()
handler e
   | isPermissionError e=putStrLn "权限有问题无法读取文件夹及文件"
   | otherwise =ioError e                     
         
    