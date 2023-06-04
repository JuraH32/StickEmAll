import Combine

class ExchangeViewModel: ObservableObject {
    
    let dataSource: AlbumDataSource
    
    @Published var exchange: Exchange? = nil
    
    init(dataSource: AlbumDataSource, exchangeCode: String) {
        self.dataSource = dataSource
        getExchange(exchangeCode: exchangeCode)
    }
    
    func getExchange(exchangeCode: String) {
        let exchangeAlbum = AlbumModel(exchangeCode: exchangeCode)
        let albums = dataSource.albums
        
        guard let album = albums.first(where: {exchangeAlbum.code == $0.code.trimmingCharacters(in: .whitespacesAndNewlines)}) else { return }
        var exchangeStickers: [Sticker] = []
        for i in 0...album.stickers.count-1 {
            let stickerAlbum = album.stickers[i].numberCollected
            let stickerExchange = exchangeAlbum.stickers[i].numberCollected
            if (stickerExchange == -1 || (stickerAlbum > 0 && stickerExchange > 0) || (stickerAlbum < 2 && stickerExchange < 2)) {
                continue
            }
            if (stickerAlbum >= 2) {
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
    
    func updateStickers() {
        dataSource.exchangeStickers(forExchange: exchange!)
    }
}
