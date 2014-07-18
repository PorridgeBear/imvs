// PDB loading

import Foundation

func isRecordTypeEqualTo(to:String, line:String) -> Bool {
    
    return line.substringToIndex(6).stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()) == to
}

let line = "MODEL FOO"
isRecordTypeEqualTo("MODEL", line)

func getDataForColumnsInLine(line:String, from:Int, to:Int) -> String {
    let tmp = line.substringFromIndex(from - 1)
    return tmp.substringToIndex(to - from + 1)
}

getDataForColumnsInLine(line, 2, 3)

