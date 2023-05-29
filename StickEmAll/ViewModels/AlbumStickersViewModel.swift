
import Foundation
import Combine

class AlbumStickersViewModel: ObservableObject {
    
    private let dataSource: AlbumDataSource
    private let albumCode: String
    
    @Published var albumDetails: AlbumModel? = nil
    
    init(dataSource: AlbumDataSource, albumCode: String) {
        self.dataSource = dataSource
        self.albumCode = albumCode
        Task {
            await getAlbum()
        }
    }
    
    func getAlbum() async {
        self.albumDetails = dataSource.getAlbum(code: albumCode)
    }
    
    func changeStickers(stickers: [Sticker]) {
        let changedStickers = stickers.filter {$0.numberCollected != 0}
        var album = albumDetails
        changedStickers.forEach{album?.stickers[$0.number-1].numberCollected += $0.numberCollected}
        albumDetails = album
        dataSource.changeStickers(changedStickers: changedStickers, albumCode: albumCode)
    }
}

