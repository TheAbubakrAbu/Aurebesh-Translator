import SwiftUI

struct LetterData: Identifiable {
    let id = UUID()
    let name: String
    let symbol: String
}

let aurebeshLetters: [LetterData] = [
    LetterData(name: "Aurek", symbol: "A"),
    LetterData(name: "Besh", symbol: "B"),
    LetterData(name: "Cresh", symbol: "C"),
    LetterData(name: "Dorn", symbol: "D"),
    LetterData(name: "Esk", symbol: "E"),
    LetterData(name: "Forn", symbol: "F"),
    LetterData(name: "Grek", symbol: "G"),
    LetterData(name: "Herf", symbol: "H"),
    LetterData(name: "Isk", symbol: "I"),
    LetterData(name: "Jenth", symbol: "J"),
    LetterData(name: "Krill", symbol: "K"),
    LetterData(name: "Leth", symbol: "L"),
    LetterData(name: "Mern", symbol: "M"),
    LetterData(name: "Nern", symbol: "N"),
    LetterData(name: "Osk", symbol: "O"),
    LetterData(name: "Peth", symbol: "P"),
    LetterData(name: "Qek", symbol: "Q"),
    LetterData(name: "Resh", symbol: "R"),
    LetterData(name: "Senth", symbol: "S"),
    LetterData(name: "Trill", symbol: "T"),
    LetterData(name: "Usk", symbol: "U"),
    LetterData(name: "Vev", symbol: "V"),
    LetterData(name: "Wesk", symbol: "W"),
    LetterData(name: "Xesh", symbol: "X"),
    LetterData(name: "Yirt", symbol: "Y"),
    LetterData(name: "Zerek", symbol: "Z"),
]

let digraphLetters: [LetterData] = [
    LetterData(name: "Cherek", symbol: "CH"),
    LetterData(name: "Enth", symbol: "AE"),
    LetterData(name: "Onith", symbol: "EO"),
    LetterData(name: "Krenth", symbol: "KH"),
    LetterData(name: "Nen", symbol: "NG"),
    LetterData(name: "Orenth", symbol: "OO"),
    LetterData(name: "Shen", symbol: "SH"),
    LetterData(name: "Thesh", symbol: "TH"),
]

let numberLetters: [LetterData] = [
    LetterData(name: "One", symbol: "1"),
    LetterData(name: "Two", symbol: "2"),
    LetterData(name: "Three", symbol: "3"),
    LetterData(name: "Four", symbol: "4"),
    LetterData(name: "Five", symbol: "5"),
    LetterData(name: "Six", symbol: "6"),
    LetterData(name: "Seven", symbol: "7"),
    LetterData(name: "Eight", symbol: "8"),
    LetterData(name: "Nine", symbol: "9"),
    LetterData(name: "Zero", symbol: "0"),
]

let specialAlphabetLetters: [LetterData] = [
    LetterData(name: "Dash", symbol: "-"),
    LetterData(name: "Slash", symbol: "/"),
    LetterData(name: "Colon", symbol: ":"),
    LetterData(name: "Semicolon", symbol: ";"),
    LetterData(name: "Left Parenthesis", symbol: "("),
    LetterData(name: "Right Parenthesis", symbol: ")"),
    LetterData(name: "Dollar", symbol: "$"),
    LetterData(name: "Ampersand", symbol: "&"),
    LetterData(name: "At", symbol: "@"),
    LetterData(name: "Double Quote", symbol: "\""),
    LetterData(name: "Period", symbol: "."),
    LetterData(name: "Comma", symbol: ","),
    LetterData(name: "Question Mark", symbol: "?"),
    LetterData(name: "Exclamation Mark", symbol: "!"),
    LetterData(name: "Single Quote", symbol: "'"),
    LetterData(name: "Asterisk", symbol: "*")
]
