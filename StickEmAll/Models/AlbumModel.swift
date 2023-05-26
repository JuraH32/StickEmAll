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
        for i in 0...numberOfStickers-1 {
            stickers.append(Sticker(number: i+1, numberCollected: 0))
        }
        self.stickers = stickers
    }
    
}

struct Sticker: Codable {
    let number: Int
    var numberCollected: Int
}
