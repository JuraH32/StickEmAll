import Combine

class AlbumPickerViewModel {
    private let dataSource: AlbumDataSource
    
    @Published var albums: [AlbumModel] = []
    
    init(dataSource: AlbumDataSource) {
        self.dataSource = dataSource
        Task {
            await getAlbumsList()
        }
    }
    
    func getAlbumsList() async{
        self.albums = dataSource.getAlbums()
    }
    
}
