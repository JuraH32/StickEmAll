class AlbumDataSource {
    func getAlbums() -> [AlbumModel] {
        return [
            AlbumModel(
                code: "312342",
                name: "Album 1",
                color: .magenta,
                numberOfStickers: 4,
                stickersPerPack: 5,
                stickers: [
                    Sticker(number: 1, numberCollected: 3),
                    Sticker(number: 2, numberCollected: 0),
                    Sticker(number: 3, numberCollected: 4),
                    Sticker(number: 4, numberCollected: 0)
                ]
            ),
            AlbumModel(
                code: "123456",
                name: "Album 2",
                color: .green,
                numberOfStickers: 3,
                stickersPerPack: 1,
                stickers: [
                    Sticker(number: 1, numberCollected: 1),
                    Sticker(number: 2, numberCollected: 1),
                    Sticker(number: 3, numberCollected: 2),
                ]
            ),
            AlbumModel(
                code: "231465",
                name: "Životinjsko carstvo",
                color: .yellow,
                numberOfStickers: 120,
                stickersPerPack: 1
            )
        ]
    }
    
    func getAlbum(code: String) -> AlbumModel {
        return AlbumModel(
            code: code,
            name: "Album",
            color: .magenta,
            numberOfStickers: 50,
            stickersPerPack: 5,
            stickers: [
                Sticker(number: 1, numberCollected: 1),
                Sticker(number: 2, numberCollected: 0),
                Sticker(number: 3, numberCollected: 1),
                Sticker(number: 4, numberCollected: 2),
                Sticker(number: 5, numberCollected: 2),
                Sticker(number: 6, numberCollected: 1),
                Sticker(number: 7, numberCollected: 0),
                Sticker(number: 8, numberCollected: 2),
                Sticker(number: 9, numberCollected: 0),
                Sticker(number: 10, numberCollected: 2),
                Sticker(number: 11, numberCollected: 1),
                Sticker(number: 12, numberCollected: 0),
                Sticker(number: 13, numberCollected: 0),
                Sticker(number: 14, numberCollected: 1),
                Sticker(number: 15, numberCollected: 2),
                Sticker(number: 16, numberCollected: 1),
                Sticker(number: 17, numberCollected: 2),
                Sticker(number: 18, numberCollected: 0),
                Sticker(number: 19, numberCollected: 0),
                Sticker(number: 20, numberCollected: 1),
                Sticker(number: 21, numberCollected: 0),
                Sticker(number: 22, numberCollected: 0),
                Sticker(number: 23, numberCollected: 2),
                Sticker(number: 24, numberCollected: 1),
                Sticker(number: 25, numberCollected: 1),
                Sticker(number: 26, numberCollected: 1),
                Sticker(number: 27, numberCollected: 0),
                Sticker(number: 28, numberCollected: 2),
                Sticker(number: 29, numberCollected: 0),
                Sticker(number: 30, numberCollected: 1),
                Sticker(number: 31, numberCollected: 2),
                Sticker(number: 32, numberCollected: 2),
                Sticker(number: 33, numberCollected: 1),
                Sticker(number: 34, numberCollected: 0),
                Sticker(number: 35, numberCollected: 1),
                Sticker(number: 36, numberCollected: 2),
                Sticker(number: 37, numberCollected: 1),
                Sticker(number: 38, numberCollected: 0),
                Sticker(number: 39, numberCollected: 2),
                Sticker(number: 40, numberCollected: 1),
                Sticker(number: 41, numberCollected: 1),
                Sticker(number: 42, numberCollected: 2),
                Sticker(number: 43, numberCollected: 2),
                Sticker(number: 44, numberCollected: 0),
                Sticker(number: 45, numberCollected: 2),
                Sticker(number: 46, numberCollected: 0),
                Sticker(number: 47, numberCollected: 1),
                Sticker(number: 48, numberCollected: 0),
                Sticker(number: 49, numberCollected: 1),
                Sticker(number: 50, numberCollected: 2)
            ]

        )
    }
}
