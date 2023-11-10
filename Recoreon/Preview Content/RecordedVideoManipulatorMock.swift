class RecordedVideoManipulatorMock: RecordedVideoManipulator {
  private let dateFormatter = {
    let formatter = ISO8601DateFormatter()
    formatter.formatOptions.remove(.withDashSeparatorInDate)
    formatter.formatOptions.remove(.withColonSeparatorInTime)
    formatter.formatOptions.remove(.withTimeZone)
    formatter.timeZone = TimeZone.current
    return formatter
  }()

  override func listRecordedVideoURLs() -> [URL] {
    return [
      Bundle.main.url(forResource: "Record01", withExtension: "mkv")!
    ]
  }

  override func listVideoEntries() -> [RecordedVideoEntry] {
    let uiImage = UIImage(named: "Thumbnail01")!

    return (0..<30).map {
      let date = Date(timeIntervalSince1970: TimeInterval($0))
      let filename = "Recoreon" + dateFormatter.string(from: date) + ".mkv"
      let path = "/Documents/Records/" + filename
      return RecordedVideoEntry(url: URL(fileURLWithPath: path), uiImage: uiImage)
    }
  }

  var finishSucessfully = false

  override func encode(
    preset: EncodingPreset,
    recordedVideoURL: URL, progressHandler: @escaping (Double, Double) -> Void
  ) async -> URL? {
    progressHandler(0.3, 1.0)
    sleep(1)
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
}
