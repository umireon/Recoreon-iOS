class RecordedVideoServiceMock: RecordedVideoService {
  private let dateFormatter = {
    let formatter = ISO8601DateFormatter()
    formatter.formatOptions.remove(.withDashSeparatorInDate)
    formatter.formatOptions.remove(.withColonSeparatorInTime)
    formatter.formatOptions.remove(.withTimeZone)
    formatter.timeZone = TimeZone.current
    return formatter
  }()

  override func listRecordedVideoEntries() -> [RecordedVideoEntry] {
    let record01url = Bundle.main.url(forResource: "Record01", withExtension: "mkv")!
    let record01attrs = try? FileManager.default.attributesOfItem(atPath: record01url.path)
    return [
      RecordedVideoEntry(
        url: record01url,
        encodedVideoCollection: EncodedVideoCollection(encodedVideoURLs: [
          .fourTimeSpeedLowQuality: Bundle.main.url(forResource: "Preview01", withExtension: "mp4")!
        ]),
        size: record01attrs?[.size] as? UInt64 ?? 0,
        creationDate: record01attrs?[.creationDate] as? Date ?? Date(timeIntervalSince1970: 0)
      )
    ]
  }

  override func getThumbnailImage(_ recordedVideoURL: URL) -> UIImage {
    let filenameWithoutExt = recordedVideoURL.deletingPathExtension().lastPathComponent
    let thumbnailName = filenameWithoutExt.replacingOccurrences(of: "Record", with: "Thumbnail")
    return UIImage(named: thumbnailName)!
  }

  override func generateThumbnail(_ recordedVideoURL: URL) async {
  }

  override func listRecordedVideoURLs() -> [URL] {
    return [
      Bundle.main.url(forResource: "Record01", withExtension: "mkv")!
    ]
  }

  var finishSucessfully = false

  override func encode(
    preset: EncodingPreset,
    recordedVideoURL: URL,
    progressHandler: @escaping (Double, Double) -> Void
  ) async -> URL? {
    progressHandler(0.3, 1.0)
    sleep(1)
    progressHandler(0.5, 1.0)
    sleep(1)
    progressHandler(0.7, 1.0)
    sleep(1)
    progressHandler(1.1, 1.0)
    finishSucessfully.toggle()
    if finishSucessfully {
      return URL(filePath: "1.mp4")
    } else {
      return nil
    }
  }

  override func publishRecordedVideo(_ recordedVideoURL: URL) -> Bool {
    finishSucessfully.toggle()
    return finishSucessfully
  }
  override func remux(_ recordedVideoURL: URL) async -> URL? {
    sleep(3)
    return Bundle.main.url(forResource: "Preview01", withExtension: "mp4")
  }

  override func getEncodedVideoURL(recordedVideoURL: URL, encodingPreset: EncodingPreset) -> URL? {
    if encodingPreset == .fourTimeSpeedLowQuality {
      return Bundle.main.url(forResource: "Preview01", withExtension: "mp4")
    } else {
      return nil
    }
  }
}
