//: Playground - noun: a place where people can play

import UIKit

struct Token {
    let text: String
    let goldTag: String
}

enum Dataset: String {
    case temp
    case test
    case train
    case valid
}

let tagger = NSLinguisticTagger(tagSchemes: [.nameType], options: 0)
let dataset: Dataset = .test
let url = Bundle.main.url(forResource: dataset.rawValue, withExtension: "txt")!
let content = try! String(contentsOf: url, encoding: .utf8).components(separatedBy: ["\n"])
var output: [String] = []

/// Map ios nlp tags to canonical tags.
extension NSLinguisticTag {
    var canonical: String {
        switch self {
        case .personalName:
            return "PER"
        case .placeName:
            return "LOC"
        case .organizationName:
            return "ORG"
        default:
            return "O"
        }
    }
}

func iob(_ descr: String, _ prevDescr: String) -> String {
    if descr == "O" {
        return "O"
    }
    if descr == prevDescr {
        return "I-\(descr)"
    } else {
        return "B-\(descr)"
    }
}

func handleSentence(s: [Token]) {
    let text = s.map { $0.text }.joined(separator: " ")
    tagger.string = text
    var charIdx = 0
    var prevDescr = "O"
    for tok in s {
        let iosTag = tagger.tag(at: charIdx, unit: .word, scheme: .nameType, tokenRange: nil)
        let iosDescr = iosTag?.canonical ?? "O"
        let outputLine = "\(tok.text) \(tok.goldTag) \(iob(iosDescr, prevDescr))"
        output.append(outputLine)
        charIdx += tok.text.utf16.count + 1  /// Include single space.
        prevDescr = iosDescr
    }
    output.append("")
}

func handleFile(content: [String]) {
    var currSentence: [Token] = []
    for x in content where !x.starts(with: "-DOCSTART-") {
        if x == "" {
            handleSentence(s: currSentence)
            currSentence = []
        } else {
            let objs    = x.split(separator: " ")
            let text    = String(objs[0])
            let goldTag = String(objs[objs.count - 1])
            currSentence.append(Token(text: text, goldTag: goldTag))
        }
    }
}

handleFile(content: content)
let documentDirectoryURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
let outURL = documentDirectoryURL.appendingPathComponent("\(dataset.rawValue).txt")
print(outURL)
try! output.joined(separator: "\n").write(to: outURL, atomically: false, encoding: .utf8)

