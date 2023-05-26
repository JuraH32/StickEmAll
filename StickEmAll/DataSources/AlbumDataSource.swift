import Foundation

class AlbumDataSource {
    var documentsDirectory: URL?
    var albums: [AlbumModel] = []
    
    init() {
        setDocumentDirectory()
        getAlbums()
    }
    
    func setDocumentDirectory() {
        let fileManager = FileManager.default
        do {
            let documentsDirectory = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            self.documentsDirectory = documentsDirectory
            
            let fileURL = documentsDirectory.appendingPathComponent("albums.json")
            
            if !FileManager.default.fileExists(atPath: fileURL.path) {
                let defaultContent = Data("[]".utf8)
                    FileManager.default.createFile(atPath: fileURL.path, contents: defaultContent, attributes: nil)
            }
        } catch {
            print("Error getting documents directory: \(error)")
            self.documentsDirectory = nil
        }
    }
    
    func getAlbums() {
        if !albums.isEmpty {
            return
        }
        guard let fileURL = documentsDirectory?.appendingPathComponent("albums.json") else {
            print("Invalid file URL")
            return
        }
        print("Fetching albums...")
        do {
            let data = try Data(contentsOf: fileURL)
            let decoder = JSONDecoder()
            let albums = try decoder.decode([AlbumModel].self, from: data)
            print(albums)
            self.albums = albums
        } catch {
            print("Failed to load albums: \(error)")
        }
    }
    
    func saveAlbum(album: AlbumModel) {
        guard let fileURL = documentsDirectory?.appendingPathComponent("albums.json") else {
                print("Invalid file URL")
                return
        }
        
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            getAlbums()
            albums.append(album)
            let encodedData = try encoder.encode(albums)
            try encodedData.write(to: fileURL)
            print("Saved album")
        } catch {
            print("Failed to save albums: \(error)")
        }
    }
    
    func changeStickers(changedStickers: [Sticker], albumCode: String) {
        if let index = albums.firstIndex(where: {$0.code == albumCode}) {
            for sticker in changedStickers {
                albums[index].stickers[sticker.number - 1].numberCollected += sticker.numberCollected
            }
        } else {
            print("No album found with code: " + albumCode)
        }
        
    }
    
    func getAlbum(code: String) -> AlbumModel? {
        getAlbums()
        if let album = albums.first(where: {$0.code == code}) {
            return album
        } else {
            print("No album found with code: " + code)
            return nil
        }
    }
}
