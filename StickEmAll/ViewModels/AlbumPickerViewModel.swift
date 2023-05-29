import Combine

class AlbumPickerViewModel: ObservableObject {
    private let dataSource: AlbumDataSource
    
    @Published var albums: [AlbumModel] = []
    
    init(dataSource: AlbumDataSource) {
        self.dataSource = dataSource
        Task {
            await getAlbumsList()
        }
    }
    
    func getAlbumsList() async{
        dataSource.getAlbums()
        self.albums = dataSource.albums
    }
    
}
