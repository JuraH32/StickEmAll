import Combine

class ExchangeViewModel: ObservableObject {
    
    let dataSource: AlbumDataSource
    
    @Published var exchange: Exchange? = nil
    
    init(dataSource: AlbumDataSource, exchangeCode: String) {
        self.dataSource = dataSource
        getExchange(exchangeCode: exchangeCode)
    }
    
    func getExchange(exchangeCode: String) {
        let exchangeStickers = [
            Sticker(number: 1, numberCollected: 1),
            Sticker(number: 4, numberCollected: -1),
            Sticker(number: 7, numberCollected: 1),
            Sticker(number: 9, numberCollected: -1),
            Sticker(number: 15, numberCollected: -1),
            Sticker(number: 22, numberCollected: 1),
            Sticker(number: 38, numberCollected: -1),
            Sticker(number: 39, numberCollected: 1),
            Sticker(number: 51, numberCollected: 1),
            Sticker(number: 52, numberCollected: -1),
            Sticker(number: 64, numberCollected: 1),
            Sticker(number: 66, numberCollected: -1),
            Sticker(number: 74, numberCollected: -1),
            Sticker(number: 79, numberCollected: -1),
            Sticker(number: 90, numberCollected: -1),
            Sticker(number: 100, numberCollected: 1),
        ]
        let code = "123456789"
        let name = "Andrein super album"
        let recieve = exchangeStickers.filter {$0.numberCollected > 0}.map {$0.number}
        let give = exchangeStickers.filter {$0.numberCollected < 0}.map {$0.number}
        exchange = Exchange(code: code, name: name, recieve: recieve, give: give)
    }
    
}
