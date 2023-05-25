
import Foundation
import Combine

class AlbumStickersViewModel: ObservableObject {
    
    private let dataSource: AlbumDataSource
    
    @Published var albumDetails: AlbumModel? = nil
    
    init(dataSource: AlbumDataSource) {
        self.dataSource = dataSource
        Task {
            await getAlbum(id: "album")
        }
    }
    
    func getAlbum(id: String) async {
        self.albumDetails = dataSource.getAlbum(code: id)
    }
}

