import PureLayout

struct AlbumModel: Codable {
    let code: String
    let name: String
    var numberOfStickers: Int
    var stickers: [Sticker]
    var stickersPerPack: Int?
    
    var numberOfCollectedStickers: Int {
        return stickers.filter {$0.numberCollected > 0}.count
    }
    
    var expectedNumberOfPacks: Float? {
        guard let stickersPerPack = stickersPerPack else { return nil }
        //TODO: Add formula
        return 0
    }
    
    var exchangeCode: String {
        var exchangeString = ""
        guard let numCode = Int64(code) else { return ""}
        let numCodeHex = String(numCode, radix: 16)
        if (numCodeHex.count < 11) {
            for _ in 1...(11-numCodeHex.count) {
                exchangeString += "0"
            }
        }
        exchangeString += numCodeHex
        var character = 0
        for i in 0...numberOfStickers-1 {
            if (i % 2 == 0 && i != 0) {
                exchangeString += String(character, radix: 16)
                character = 0
            }
            let shift = 2 * (i % 2)
            let sticker = stickers[i]
            if (sticker.numberCollected == 1) {
                character += (8 >> shift)
            } else if sticker.numberCollected > 1 {
                character += (12 >> shift)
            }
        }
        exchangeString += String(character, radix: 16)
        return exchangeString
    }
    
    init(code: String, name: String, numberOfStickers: Int, stickersPerPack: Int, stickers: [Sticker]) {
        self.code = code
        self.name = name
        self.numberOfStickers = numberOfStickers
        self.stickers = stickers
        self.stickersPerPack = stickersPerPack
    }
    
    init(code: String, name: String, numberOfStickers: Int, stickersPerPack: Int) {
        self.code = code
        self.name = name
        self.numberOfStickers = numberOfStickers
        self.stickersPerPack = stickersPerPack
        var stickers: [Sticker] = []
        for i in 0...numberOfStickers-1 {
            stickers.append(Sticker(number: i+1, numberCollected: 0))
        }
        self.stickers = stickers
    }
    
    init(code: String, name: String, numberOfStickers: Int) {
        self.code = code
        self.name = name
        self.numberOfStickers = numberOfStickers
        self.stickersPerPack = nil
        var stickers: [Sticker] = []
        for i in 1...numberOfStickers {
            stickers.append(Sticker(number: i, numberCollected: 0))
        }
        self.stickers = stickers
    }
    
    init(exchangeCode: String) {
        let codeHex = exchangeCode.prefix(11)
        let decimalCode = Int64(codeHex, radix: 16)
        var code = ""
        let codeString = String(describing: decimalCode!)
        if 11 - codeString.count > 0 {
            for _ in 1...(11 - codeString.count) {
                code += "0"
            }
        }
        code += codeString
        self.code = code
        self.name = "Exchange album"
        self.stickersPerPack = nil
        var stickers: [Sticker] = []
        for i in 11...exchangeCode.count-1 {
            let index = (i - 11) * 2 + 1
            guard let num = Int(exchangeCode[i], radix: 16) else {
                stickers.append(Sticker(number: index, numberCollected: -1))
                stickers.append(Sticker(number: index + 1, numberCollected: -1))
                continue
            }
            let count1 = (num & 8) > 0 ? 2 : ((num & 4) > 0 ? 1 : 0)
            let count2 = (num & 2) > 0 ? 2 : ((num & 1) > 0 ? 1 : 0)
            stickers.append(Sticker(number: index, numberCollected: count1))
            stickers.append(Sticker(number: index + 1, numberCollected: count2))
        }
        self.stickers = stickers
        self.numberOfStickers = stickers.count
    }
    
}

struct Sticker: Codable {
    let number: Int
    var numberCollected: Int
}

struct Exchange {
    let code: String
    let name: String
    var recieve: [Int]
    var give: [Int]
}
