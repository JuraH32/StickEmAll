class CreateAlbumViewModel {
    let dataSource: AlbumDataSource
    
    init(dataSource: AlbumDataSource) {
        self.dataSource = dataSource
    }
    
    func createAlbum(code: String, name: String, numberOfSticker: Int, numberOfStickerPerPack: Int?) {
        let album = numberOfStickerPerPack != nil && numberOfStickerPerPack != 0 ?
            AlbumModel(code: code, name: name, numberOfStickers: numberOfSticker, stickersPerPack: numberOfStickerPerPack!) :
            AlbumModel(code: code, name: name, numberOfStickers: numberOfSticker)
        dataSource.saveAlbum(album: album)
    }
}

