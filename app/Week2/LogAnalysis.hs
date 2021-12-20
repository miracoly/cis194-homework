module Week2.LogAnalysis where

import Data.String
import Week2.Log

insert :: LogMessage -> MessageTree -> MessageTree
insert (Unknown _) tree = tree
insert msg Leaf = Node Leaf msg Leaf
insert msg@(LogMessage _ newTime _) (Node left tmsg@(LogMessage _ time _) right)
  | newTime < time = Node (insert msg left) tmsg right
  | otherwise = Node left tmsg (insert msg right)

parse :: String -> [LogMessage]
parse s = parseMessage <$> lines s

parseMessage :: String -> LogMessage
parseMessage m = let wl = words m in
  case wl of
    ("I":ts:mx) -> LogMessage Info (read ts) (unwords mx)
    ("W":ts:mx) -> LogMessage Warning (read ts) (unwords mx)
    ("E":sev:ts:mx) -> LogMessage (Error (read sev)) (read ts) (unwords mx)
    _ -> Unknown $ unwords wl
