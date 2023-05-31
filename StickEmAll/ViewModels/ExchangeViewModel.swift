import Combine

class ExchangeViewModel: ObservableObject {
    
    let dataSource: AlbumDataSource
    
    @Published var exchange: Exchange? = nil
    
    init(dataSource: AlbumDataSource, exchangeCode: String, album: AlbumModel) {
        self.dataSource = dataSource
        getExchange(exchangeCode: exchangeCode, album: album)
    }
    
    func getExchange(exchangeCode: String, album: AlbumModel) {
        //Testing exchange code for album with code 3856021222580
        //exchangeCode = "381ccc674b4ecc00c3c00001110100000000E000000000000C000000300000000010000000000000E000000000400000000000000000003”
        let exchangeAlbum = AlbumModel(exchangeCode: exchangeCode)
        guard exchangeAlbum.code == album.code else { return }
        var exchangeStickers: [Sticker] = []
        for i in 0...album.stickers.count {
            let stickerAlbum = album.stickers[i].numberCollected
            let stickerExchange = exchangeAlbum.stickers[i].numberCollected
            if (stickerExchange == -1 || (stickerAlbum > 0 && stickerExchange > 0) || (stickerAlbum < 2 && stickerExchange < 2)) {
                continue
            }
            if (stickerAlbum == 2) {
                exchangeStickers.append(Sticker(number: i+1, numberCollected: -1))
            } else {
                exchangeStickers.append(Sticker(number: i+1, numberCollected: 1))
            }
        }
        let code = album.code
        let name = album.name
        let recieve = exchangeStickers.filter {$0.numberCollected > 0}.map {$0.number}
        let give = exchangeStickers.filter {$0.numberCollected < 0}.map {$0.number}
        exchange = Exchange(code: code, name: name, recieve: recieve, give: give)
    }
    
}
